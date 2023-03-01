import os
from textwrap import dedent
import lxml.etree as ET
import rdflib
import json
from datetime import datetime
import requests
import sys

""" PRELIMINARIES """

print(dedent("""Please confirm:
1) Terminal is open in the sinopia_maps top-level directory
2) Saxon processor .jar file is located in the user's home (~) directory"""))
confirm = input("OK to proceed? (Yes or No):\n> ")
if confirm.lower() == "yes":
    pass
else:
    exit(0)

saxon_dir_prompt = dedent("""Enter the name of the directory in your home folder where your Saxon HE .jar file is stored
For example: 'saxon', 'saxon11', etc.
> """)
saxon_dir = input(saxon_dir_prompt)

saxon_version_prompt = dedent("""Enter your Saxon HE version number (this will be in the .jar file name)
For example: '11.1', '11.4', etc.
> """)
saxon_version = input(saxon_version_prompt)

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
    
user_prompt = "Enter your username for the Sinopia environment you will load RTs to\n> "
user = input(user_prompt)

jwt_prompt = "Enter a Java web token for the Sinopia environment you will load RTs to\n> "
jwt = input(jwt_prompt)

proceed_prompt = dedent("""Ready to output, publish, and load RTs? (Yes or No)
> """)
proceed = input(proceed_prompt)
if proceed.lower() == "yes":
    pass
else:
    exit(0)

""" OUTPUT RDF RESOURCE TEMPLATES """

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

""" FIX REPEATING PROPERTY IRIS """

def locate_RTs():
    sinopia_maps_repo = os.listdir()
    RT_list = []
    for file in sinopia_maps_repo:
        if file[0:10] == "UWSINOPIA_" and file[-4:] == ".rdf":
            RT_list.append(file)
    return RT_list

def property_template_test(rdf_RDF, rdf_Description, prop_URI, locked_in_propURI_list):
	comment_it_out = True
	current_node_ID = rdf_Description.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}nodeID']
	theoretical_prop_node_ID = prop_URI.strip('http://')
	theoretical_prop_node_ID = theoretical_prop_node_ID.replace('.', '')
	# no need to process object and datatype props any longer
	# theoretical_prop_node_ID = theoretical_prop_node_ID.replace('object', '')
	# theoretical_prop_node_ID = theoretical_prop_node_ID.replace('datatype', '')
	theoretical_prop_node_ID = theoretical_prop_node_ID.replace('/', '') + "_define"

	if current_node_ID == theoretical_prop_node_ID:
		"""This is THE property template for this property; keep it in"""
		comment_it_out = False
	else:
		"""See if there is a different property template for this property"""
		look_for_PT_list = rdf_RDF.findall('{http://www.w3.org/1999/02/22-rdf-syntax-ns#}Description[@{http://www.w3.org/1999/02/22-rdf-syntax-ns#}nodeID="' + theoretical_prop_node_ID + '"]')
		if len(look_for_PT_list) == 0:
			"""There is no property template for this property, so it can remain as a subproperty where it is"""
			comment_it_out = False

	"""Make sure this URI isn't a repeat from a previous PT"""
	if comment_it_out == False and prop_URI in locked_in_propURI_list:
		comment_it_out = True

	return comment_it_out

def fix_multi_props(file):
	locked_in_propURI_list = []
	tree = ET.parse(file)
	rdf_RDF = tree.getroot()

	for rdf_Description in rdf_RDF:
		# Determine if rdf:Description contains multiple instances of sinopia:hasPropertyUri
		sinopia_hasPropertyUri_list = rdf_Description.findall('{http://sinopia.io/vocabulary/}hasPropertyUri')
		if len(sinopia_hasPropertyUri_list) > 1:
			# Get index number for each subelement of rdf:Description
			rdf_Description_dict = {}
			index_num = 0
			for subelement in rdf_Description:
				rdf_Description_dict[index_num] = (subelement.tag, subelement.attrib)
				index_num += 1

			for subelement in rdf_Description:
				if subelement.tag == '{http://sinopia.io/vocabulary/}hasPropertyUri':
					comment_it_out = property_template_test(rdf_RDF, rdf_Description, subelement.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource'], locked_in_propURI_list)
					if comment_it_out == True:
						for index_num in rdf_Description_dict:
							tpl = rdf_Description_dict[index_num]
							if tpl[0] == '{http://sinopia.io/vocabulary/}hasPropertyUri':
								if tpl[1]['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource'] == subelement.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource']:
									comment_index = index_num
						rdf_Description.remove(subelement)\
						# would like to add newline following commented prop IRI
						rdf_Description.insert(comment_index, ET.Comment(subelement.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource']))
					else:
						if subelement.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource'] not in locked_in_propURI_list:
							locked_in_propURI_list.append(subelement.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource'])

		elif len(sinopia_hasPropertyUri_list) == 1:
			for hasPropertyUri in sinopia_hasPropertyUri_list:
				if hasPropertyUri.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource'] not in locked_in_propURI_list:
					locked_in_propURI_list.append(hasPropertyUri.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource'])

	tree.write(file, xml_declaration=True, encoding="UTF-8", pretty_print = True) # TEST pretty_print
	
RT_list = locate_RTs()
for RT in RT_list:
    fix_multi_props(f'{RT}')

print(dedent(f"""{'=' * 20}
COMMENTED OUT REPEATING PROPERTY IRIS IN RESOURCE TEMPLATES
{'=' * 20}"""))

""" OUTPUT HTML RESOURCE TEMPLATES """

HTML_RT_stylesheet = "xsl/004_01_storage_to_html.xsl"
os_command = f"""java -cp ~/{saxon_dir}/saxon-he-{saxon_version}.jar 
net.sf.saxon.Transform -t 
-s:{HTML_RT_stylesheet} 
-xsl:{HTML_RT_stylesheet}"""
os_command = os_command.replace('\n', '')
os.system(os_command)

print(dedent(f"""{'=' * 20}
OUTPUT HTML RESOURCE TEMPLATES
{'=' * 20}"""))

""" SERIALIZE JSON, (ADD SINOPIA ADMIN METADATA, LOAD TO A SINOPIA PLATFORM) """

prepped_RTs = {}

for RT in RT_list:
    # print(RT)
    g = rdflib.Graph()
    g.parse(RT, format = 'xml')
    # write 'plain' (no sinopia admin metadata) RTs to top-level as json-ld
    g.serialize(f"{RT.split('.')[0] + '.jsonld'}", format = 'json-ld') 
    
    # edit RT IRI for loading
    for s, p, o in g:
        if isinstance(s, rdflib.term.URIRef) == True:
            if s[0:19] == "https://api.sinopia":
                RT_id = s.split('/')[-1]
                new_IRI = f"https://api.{sinopia_platform}sinopia.io/resource/{RT_id}" # pass this to format_json as iri
                g.remove((s, p, o))
                g.add((rdflib.URIRef(new_IRI), p, o))
    prepped_RTs[new_IRI] = RT

def format_json(user, iri, json_file):
    with open(f"{json_file.split('.')[0] + '.jsonld'}", 'r') as RT:
        original_data = json.load(RT)
        currentTime = datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%S.%f')[:-3] + 'Z'
        RT_id = iri.split('/')[-1]
        return json.dumps({"data": original_data, "user": user, "group": "washington", "editGroups": [], "templateId": "sinopia:template:resource", "types": [ "http://sinopia.io/vocabulary/ResourceTemplate" ], "bfAdminMetadataRefs": [], "sinopiaLocalAdminMetadataForRefs": [], "bfItemRefs": [], "bfInstanceRefs": [], "bfWorkRefs": [], "id": RT_id, "uri": iri, "timestamp": currentTime})

for RT in prepped_RTs:
    # 'wrap' RT with Sinopia admin metadata
    prepped_RTs[RT] = format_json(user, RT, prepped_RTs[RT])
    # loading
    headers = {"Authorization": f"Bearer {jwt}", "Content-Type": "application/json"}
    post_to_sinopia = requests.post(RT, data = prepped_RTs[RT].encode('utf-8'), headers=headers)
    status_code = post_to_sinopia.status_code
    if status_code == 409:
        # conflict; something already exists at this URI, so put (i.e. overwrite) instead of post
        overwrite_in_sinopia = requests.put(RT, data = prepped_RTs[RT].encode('utf-8'), headers=headers)
        print(f"{RT}: {overwrite_in_sinopia.status_code}")
    else:
        print(f"{RT}: {status_code}")

# https://www.rfc-editor.org/rfc/rfc9110.html#name-overview-of-status-codes
# 2xx SUCCESSFUL
	# 200 = OK, request has succeeded
	# 201 = Created, request has been fulfilled and has resulted in one or more new resources being created
	# 204 = No Content success (deleted)
# 4xx CLIENT ERROR
	# 400 = Bad Request
	# 401 = Unauthorized
	# 404 = Not Found
