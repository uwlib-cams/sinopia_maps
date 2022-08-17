import lxml.etree as ET

###

def create_comment(comment_info_tuple):
	comment_label = comment_info_tuple[1]
	comment = ET.Comment(f"USE PT FOR {comment_label}")

	return comment

def fix_multi_props(file):
	hasPropertyUri_list = []
	duplicates = []

	tree = ET.parse(file)

	rdf_RDF = tree.getroot()

	for rdf_Description in rdf_RDF:
		sinopia_hasPropertyUri_list = rdf_Description.findall('{http://sinopia.io/vocabulary/}hasPropertyUri')
		if len(sinopia_hasPropertyUri_list) > 0:
			for sinopia_hasPropertyUri in sinopia_hasPropertyUri_list:
				prop_URI = sinopia_hasPropertyUri.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource']
				"""Check if a property has its own property template AND is listed as a subproperty elsewhere"""
				comment_it_out = property_template_test(rdf_RDF, rdf_Description, prop_URI)
				if comment_it_out == True:
					"""There is a PT for this property, but this isn't it; comment it out"""
					# remove original triple
					rdf_Description.remove(sinopia_hasPropertyUri)

					# generate text of comment
					comment_info_tuple = get_comment_info(rdf_RDF, rdf_Description, prop_URI)
					comment = create_comment(comment_info_tuple)

					# generate location of comment within rdf:Description
					comment_index = comment_info_tuple[0]

					# insert comment at given location
					rdf_Description.insert(comment_index, comment)
				else:
					"""There is not a PT for this property OR this is THE PT for this property"""
					if prop_URI in hasPropertyUri_list:
						# remove original triple
						rdf_Description.remove(sinopia_hasPropertyUri)

						# generate text of comment
						comment_info_tuple = get_comment_info(rdf_RDF, rdf_Description, prop_URI)
						comment = create_comment(comment_info_tuple)

						# generate location of comment within rdf:Description
						comment_index = comment_info_tuple[0]

						# insert comment at given location
						rdf_Description.insert(comment_index, comment)
					else:
						hasPropertyUri_list.append(prop_URI)

	tree.write('test.rdf', xml_declaration=True, encoding="UTF-8")

def property_template_test(rdf_RDF, rdf_Description, prop_URI):
	comment_it_out = True

	current_node_ID = rdf_Description.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}nodeID']
	theoretical_prop_node_ID = prop_URI.strip('http://')
	theoretical_prop_node_ID = theoretical_prop_node_ID.replace('.', '')
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

	return comment_it_out

def get_comment_info(rdf_RDF, rdf_Description, prop_URI):
	index_ID = {}
	index_num = 0
	for element in rdf_Description:
		if isinstance(element.tag, str) == True:
			if '{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource' in element.attrib.keys():
				tag_text_tuple = (element.tag, element.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource'])
			elif element.text != None:
				tag_text_tuple = (element.tag, element.text)
			index_ID[tag_text_tuple] = index_num
		index_num += 1

	match_key = ('{http://sinopia.io/vocabulary/}hasPropertyUri', prop_URI)
	try:
		comment_index = index_ID[match_key]
	except:
		print(f"match key: {match_key}")
		for key in index_ID.keys():
			print(key)
		input()

	for rdf_Desc in rdf_RDF:
		if '{http://www.w3.org/1999/02/22-rdf-syntax-ns#}about' in rdf_Desc.attrib.keys():
			if rdf_Desc.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}about'] == prop_URI:
				label_object = rdf_Desc.findall('{http://www.w3.org/2000/01/rdf-schema#}label')
				prop_label = label_object[0].text

	return comment_index, prop_label

fix_multi_props('../UWSINOPIA_WAU_rdaWork_monograph_CAMS.rdf')

# missing <?xml version="1.0" encoding="UTF-8"?>
