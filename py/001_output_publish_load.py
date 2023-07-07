# This program is designed to output RDF/XML, JSON-LD, and HTML serializations of Resource Templates
# and upload these RTs to a Sinopia environment
# for details see https://github.com/uwlib-cams/sinopia_maps/wiki/manage_03_output_publish_load
# last updated: 4/14/2023

import os
from textwrap import dedent
import lxml.etree as ET
import rdflib
from rdflib import *
import json
from datetime import datetime
import requests
import sys

# PRELIMINARIES - ensure everything is set up

# terminal must be open in sinopia_maps top level and saxon should be in home directory
print(dedent("""Please confirm:
1) Terminal is open in the sinopia_maps top-level directory
2) Saxon processor .jar file is located in the user's home (~) directory
3) You have a valid Java Web Token handy for the Sinopia environment you wish to load templates to"""))
confirm = input("OK to proceed? (Yes or No):\n> ")
if confirm.lower() == "yes":
    pass
else:
    exit(0)

# get location and version of saxon folder
saxon_dir_prompt = dedent("""Enter the name of the directory in your home folder where your Saxon HE .jar file is stored
For example: 'saxon', 'saxon11', etc.
> """)
saxon_dir = input(saxon_dir_prompt)

saxon_version_prompt = dedent("""Enter your Saxon HE version number (this will be in the .jar file name)
For example: '11.1', '11.4', etc.
> """)
saxon_version = input(saxon_version_prompt)

# get desired sinopia platform for upload
sinopia_platform = ""
platform_prompt = dedent("""Load to which Sinopia environment?
Development, Stage, or Production?\n[1] Development\n[2] Stage\n[3] Production\n> """)
platform = input(platform_prompt)
if platform == "1":
    sinopia_platform = "development."
elif platform == "2":
    sinopia_platform = "stage."
elif platform == "3":
    sinopia_platform = ""
else:
    print("Platform not recognized.")
    exit(0)

# get sinopia username    
user_prompt = "Enter your username for the Sinopia environment you will load RTs to\n> "
user = input(user_prompt)

# get jwt for upload
jwt_prompt = "Enter a Java web token for the Sinopia environment you will load RTs to\n> "
jwt = input(jwt_prompt)

proceed_prompt = dedent("""Ready to output, publish, and load RTs? (Yes or No)
> """)
proceed = input(proceed_prompt)
if proceed.lower() == "yes":
    pass
else:
    exit(0)

# OUTPUT RDF RESOURCE TEMPLATES

# run stylesheet to output rdf/xml
RDF_RT_stylesheet = "xsl/001_01_storage_to_rdfxml.xsl"
os_command = f"""java -cp ~/{saxon_dir}/saxon-he-{saxon_version}.jar 
net.sf.saxon.Transform -t 
-s:{RDF_RT_stylesheet} 
-xsl:{RDF_RT_stylesheet}"""
os_command = os_command.replace('\n', '')
os.system(os_command)

print(dedent(f"""{'=' * 20}
OUTPUT RDF/XML RESOURCE TEMPLATES
{'=' * 20}"""))

# FIX REPEATING PROPERTY IRIS AND LABELS

# function returns list of resource templates 
def locate_RTs():
    sinopia_maps_repo = os.listdir()
    RT_list = []
    for file in sinopia_maps_repo:
        if file[0:10] == "UWSINOPIA_" and file[-4:] == ".rdf":
            RT_list.append(file)
    return RT_list

# function determines if there are multiple instances of a property within a property template 
def property_template_test(rdf_root, rdf_description, prop_URI, used_propUri_list, pt_used_propUri_list):
	comment_it_out = True
	delete = False 
	action = [True, False]
	
	current_node_id = rdf_description.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}nodeID']
	theoretical_prop_node_id = prop_URI.strip('http://')
	theoretical_prop_node_id = theoretical_prop_node_id.replace('.', '')
	theoretical_prop_node_id = theoretical_prop_node_id.replace('/', '') + "_define"

	if current_node_id == theoretical_prop_node_id:
		# This is THE property template for this property; keep it in
		# This means that the prop_URI is the URI for the property it is a child of 
		comment_it_out = False
	else:
		# See if there is a different property template for this property
		look_for_PT_list = rdf_root.findall('{http://www.w3.org/1999/02/22-rdf-syntax-ns#}Description[@{http://www.w3.org/1999/02/22-rdf-syntax-ns#}nodeID="' + theoretical_prop_node_id + '"]')
		if len(look_for_PT_list) == 0:
			# There is no property template for this property, so it can remain as a subproperty where it is
			comment_it_out = False
	if prop_URI in pt_used_propUri_list:
		#This means this prop_URI has already been handled once in this property template - either kept or commented out 
		delete = True
	# Make sure this URI isn't a repeat from a previous PT 
	if comment_it_out == False and prop_URI in used_propUri_list:
		comment_it_out = True
	
	action = [comment_it_out, delete]
	return action 

# this function removes repeated hasPropertyUri instances, commenting out or deleting unnecessary repeats 
def fix_multi_props(file):
	# list of propUri's that already appear in RT
	used_propUri_list = []
	tree = ET.parse(file)
	rdf_root = tree.getroot()

	for rdf_description in rdf_root:
		# Determine if rdf:Description contains multiple instances of sinopia:hasPropertyUri
		hasPropertyUri_list = rdf_description.findall('{http://sinopia.io/vocabulary/}hasPropertyUri')
		# list of propUri's that already appear in property 
		pt_used_propUri_list = [] 

		if len(hasPropertyUri_list) > 1:
			# index each subelement of rdf:Description and store in dictionary 
			rdf_description_dict = {}
			index_num = 0
			for subelement in rdf_description:
				rdf_description_dict[index_num] = (subelement.tag, subelement.attrib)
				index_num += 1

			# determine if property is a repeat 
			for subelement in rdf_description:
				if subelement.tag == '{http://sinopia.io/vocabulary/}hasPropertyUri':
					# determine if propUri should be kept, commented out, or deleted 
					action = property_template_test(rdf_root, rdf_description, subelement.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource'], used_propUri_list, pt_used_propUri_list)
					
					# add URI to list of URIs in this property template 
					if subelement.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource'] not in pt_used_propUri_list:	
							pt_used_propUri_list.append(subelement.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource'])
					
					# check if delete is true 
					if action[1] == True:
						# delete uri
						rdf_description.remove(subelement)
					
					# check if comment is true 
					if action[0] == True and action[1] == False:
						# get correct index for inserting comment 
						for index_num in rdf_description_dict:
							test = rdf_description_dict[index_num]
							if test[0] == '{http://sinopia.io/vocabulary/}hasPropertyUri':
								if test[1]['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource'] == subelement.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource']:
									comment_index = index_num
						# comment out property 
						rdf_description.remove(subelement)
						rdf_description.insert(comment_index, ET.Comment(subelement.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource']))
						# add new line under comment 
						ET.indent(rdf_root)

					else:
						# if not a repeat, add to used_propUri_list for reference 
						if subelement.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource'] not in used_propUri_list:
							used_propUri_list.append(subelement.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource'])
		
		# only one hasPropertyUri in rdf_Description means this is THE uri for the property 
		elif len(hasPropertyUri_list) == 1:
			for hasPropertyUri in hasPropertyUri_list:
				if hasPropertyUri.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource'] not in used_propUri_list:
					used_propUri_list.append(hasPropertyUri.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource'])

	tree.write(file, xml_declaration=True, encoding="UTF-8", pretty_print = True)
	
# function to delete duplicate triples 
def fix_duplicate_triples(file):
	locked_in_label_list = []
	tree = ET.parse(file)
	rdf_root = tree.getroot()

	for rdf_description in rdf_root: 
		to_remove = False
		#get label from property template 
		sinopia_hasLabel_list = rdf_description.findall('{http://www.w3.org/2000/01/rdf-schema#}label')
		#if label is the only child of pt and label is already in list,
		# then this is a duplicate - remove property template 
		if len(rdf_description.getchildren()) == 1:
			for label in rdf_description:
				if label.text in locked_in_label_list:
					to_remove = True
				else:
					locked_in_label_list.append(label.text)
			if to_remove == True:
				rdf_root.remove(rdf_description)

	tree.write(file, xml_declaration=True, encoding="UTF-8", pretty_print = True)

# this function removes any agent subproperties in multiprops that are not person, corporate body, or family props
def filter_agents(file):
	propuri_count = 0; 	
	tree = ET.parse(file)
	rdf_root = tree.getroot()

	def check_uri(uri):
		agent_prop = False
		for rdf_description in rdf_root:
			# only one subelement means it is an rdfs:label
			# if label contains agent, this prop needs to be removed from multiprop instances
			if (len(rdf_description.getchildren()) == 1) and rdf_description.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}about'] == uri:
				for subelement in rdf_description:
					if 'agent' in subelement.text: 
						rdf_root.remove(rdf_description)
						agent_prop = True
		return agent_prop	

	for rdf_description in rdf_root:
		# count hasPropertyUri elements
		for subelement in rdf_description:
				if subelement.tag == '{http://sinopia.io/vocabulary/}hasPropertyUri':
					propuri_count = propuri_count + 1

		# more than one hasPropertyUri elements -> multiprop
		# remove agent subprops
		if propuri_count > 1:
			for subelement in rdf_description:
				if subelement.tag == '{http://sinopia.io/vocabulary/}hasPropertyUri':
					uri = subelement.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource']
					agent_prop = check_uri(uri)
					if agent_prop == True:
						rdf_description.remove(subelement)
		
	tree.write(file, xml_declaration=True, encoding="UTF-8", pretty_print = True)

RT_list = locate_RTs()
for RT in RT_list:
    fix_multi_props(f'{RT}')
    fix_duplicate_triples(f'{RT}')
    filter_agents(f'{RT}')
    

print(dedent(f"""{'=' * 20}
COMMENTED OUT REPEATING PROPERTY IRIS AND LABELS IN RESOURCE TEMPLATES
{'=' * 20}"""))


	
# OUTPUT HTML RESOURCE TEMPLATES 

# run stylesheet to output HTML
HTML_RT_stylesheet = "xsl/004_01_prop_set_to_html.xsl"
os_command = f"""java -cp ~/{saxon_dir}/saxon-he-{saxon_version}.jar 
net.sf.saxon.Transform -t 
-s:{HTML_RT_stylesheet} 
-xsl:{HTML_RT_stylesheet}"""
os_command = os_command.replace('\n', '')
os.system(os_command)

print(dedent(f"""{'=' * 20}
OUTPUT HTML RESOURCE TEMPLATES
{'=' * 20}"""))

# SERIALIZE JSON, (ADD SINOPIA ADMIN METADATA, LOAD TO A SINOPIA PLATFORM) 

prepped_RTs = {}

for RT in RT_list:
    g = rdflib.Graph()
    g.parse(RT, format = 'xml')
    
    # edit RT IRI for loading
    for s, p, o in g:
        if isinstance(s, rdflib.term.URIRef) == True:
			# update iri to match sinopia platform selected by user
            if s[0:19] == "https://api.sinopia":
                RT_id = s.split('/')[-1]
                # pass this to format_json as iri
                new_IRI = f"https://api.{sinopia_platform}sinopia.io/resource/{RT_id}" 
                g.remove((s, p, o))
                g.add((rdflib.URIRef(new_IRI), p, o))
                
    # write 'plain' (no sinopia admin metadata) RTs to top-level as json-ld
    g.serialize(f"{RT.split('.')[0] + '.jsonld'}", format = 'json-ld')
     
    # prepped RTs dictionary contains resource templates as values with the RTs' IRIs as keys 
    prepped_RTs[new_IRI] = RT

# function to correctly format json for upload to sinopia and return as string 
def format_json(user, IRI, json_file):
    with open(f"{json_file.split('.')[0] + '.jsonld'}", 'r') as RT_file:
        original_data = json.load(RT_file)
        currentTime = datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%S.%f')[:-3] + 'Z'
        RT_id = IRI.split('/')[-1]
        return json.dumps({"data": original_data, "user": user, "group": "washington", "editGroups": [], "templateId": "sinopia:template:resource", "types": [ "http://sinopia.io/vocabulary/ResourceTemplate" ], "bfAdminMetadataRefs": [], "sinopiaLocalAdminMetadataForRefs": [], "bfItemRefs": [], "bfInstanceRefs": [], "bfWorkRefs": [], "id": RT_id, "uri": IRI, "timestamp": currentTime})

for RT_IRI in prepped_RTs:
    # for each resource template 'wrap' RT content with Sinopia admin metadata and return to prepped_RTs as value in dict
	prepped_RTs[RT_IRI] = format_json(user, RT_IRI, prepped_RTs[RT_IRI])
    #data for upload is this formatted json 
	data = prepped_RTs[RT_IRI]
    
    # post to sinopia environment and get status code
	headers = {"Authorization": f"Bearer {jwt}", "Content-Type": "application/json"}
	post_to_sinopia = requests.post(RT_IRI, data = data.encode('utf-8'), headers=headers)
	status_code = post_to_sinopia.status_code
	if status_code == 409:
        # conflict; something already exists at this URI, so put (i.e. overwrite) instead of post
		overwrite_in_sinopia = requests.put(RT_IRI, data = data.encode('utf-8'), headers=headers)
		print(f"{RT_IRI}: {overwrite_in_sinopia.status_code}")
	else:
		print(f"{RT_IRI}: {status_code}")

# https://www.rfc-editor.org/rfc/rfc9110.html#name-overview-of-status-codes
# 2xx SUCCESSFUL
	# 200 = OK, request has succeeded
	# 201 = Created, request has been fulfilled and has resulted in one or more new resources being created
	# 204 = No Content success (deleted)
# 4xx CLIENT ERROR
	# 400 = Bad Request
	# 401 = Unauthorized
	# 404 = Not Found
