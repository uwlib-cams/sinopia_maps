import lxml.etree as ET
import os

###

def locate_RTs():
	# filepath would change if moving to run from repo top-level
	sinopia_maps_repo = os.listdir('..')
	RT_list = []
	for file in sinopia_maps_repo:
		if (file[0:17] == "UWSINOPIA_WAU_rda") and file[-4:] == ".rdf":
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

	tree.write(file, xml_declaration=True, encoding="UTF-8")

###

RT_list = locate_RTs()

for RT in RT_list:
	fix_multi_props(f'../{RT}')
