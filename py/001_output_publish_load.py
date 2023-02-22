import os
from textwrap import dedent
import lxml.etree as ET
import rdflib

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

proceed_prompt = dedent("""Ready to output, publish, and load RTs? (Yes or No)
> """)
proceed = input(proceed_prompt)
if proceed.lower() == "yes":
    pass
else:
    exit(0)

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
	prepped_RTs[RT] = ""


for RT in RT_list:
    g = rdflib.Graph()
    g.parse(RT, format = 'xml')
    g.serialize(f"{RT.split('.')[0] + '.jsonld'}", format = 'json-ld') # write 'plain' (no sinopia admin metadata) RTs to top-level as json-ld
    for s, p, o in g:
	    if isinstance(s, rdflib.term.URIRef) == True:
		   	if s[0:19] == "https://api.sinopia":




# save RT ID as var
# save json-ld as var
# wrap as object with Sinopia admin metadata



# losing it here - still to do:
    # Alter the RT IRIs if for Stage or Dev
        # MCM used rdflib in a way i can't quite follow
    # Wrap RT as object with Sinopia admin metadata:
        # { 
        #   "data": prepped_iri_rt ,
        #   "user": user ,
        #   "group": "washington" ,
        #   "editGroups": [] ,
        #   "templateId": "sinopia:template:resource" ,
        #   "types": [ "http://sinopia.io/vocabulary/ResourceTemplate" ] ,
        #   "bfAdminMetadataRefs": [] ,
        #   "sinopiaLocalAdminMetadataForRefs": [] ,
        #   "bfItemRefs": [] ,
        #   "bfInstanceRefs": [] ,
        #   "bfWorkRefs": [] ,
        #   "id": RT_id ,
        #   "uri": uri ,
        #   "timestamp": currentTime
        # } 
    # Load (each) RT to selected platform
    # Get a status code



