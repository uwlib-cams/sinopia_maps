import lxml.etree as ET

def sort_alphabetical(file):
	parser = ET.XMLParser(remove_blank_text=True)
	tree = ET.parse(file, parser)	
	rdf_root = tree.getroot()

	def get_label(uri):
		label = ""
		for rdf_description in rdf_root:
			# only one subelement means it is an rdfs:label
			# if label contains agent, this prop needs to be removed from multiprop instances
			if (len(rdf_description.getchildren()) == 1) and rdf_description.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}about'] == uri:
				for subelement in rdf_description:
					label = subelement.text
		return label	

	for rdf_description in rdf_root:
		propuri_count = 0
		# count hasPropertyUri elements
		for subelement in rdf_description:
				if subelement.tag == '{http://sinopia.io/vocabulary/}hasPropertyUri':
					propuri_count = propuri_count + 1

		# more than one hasPropertyUri elements -> multiprop, sort sub-properties (ignoring initial 'is' and 'has')
		if propuri_count > 1:
			labels_uris = {}
			for subelement in rdf_description:
				if subelement.tag == '{http://sinopia.io/vocabulary/}hasPropertyUri':
					uri = subelement.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource']
					
					
					label = get_label(uri)
					# if there is a space in the label (there always is), ignore the first word
					# set as keyword to sort by 
					if " " in label: 
						keyword = label.split(" ", 1)[1]
					else:
						keyword = label
					labels_uris[keyword] = uri

					rdf_description.remove(subelement)

			# sort and re-add to rdf_description
			for i in sorted(labels_uris.keys()):
				# print(i + ": " + labels_uris[i])
				subelem = ET.Element('{http://sinopia.io/vocabulary/}hasPropertyUri')
				subelem.set('{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource', labels_uris[i])
				# next = rdf_description.getnext()
				# if '{http://www.w3.org/1999/02/22-rdf-syntax-ns#}nodeID' in next.attrib:
				# 	next.addnext(elem)
				rdf_description.append(subelem)
				
	ET.indent(tree, space="   ", level=0)
	tree.write(file, xml_declaration=True, encoding="UTF-8", pretty_print = True)
    