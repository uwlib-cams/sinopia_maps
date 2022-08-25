import lxml.etree as ET
import os
from rdflib import *
import re

###

def all_datatype_object_properties():
	datatype_prop_list = []
	object_prop_list = []

	xml_list = [
		'https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/w.xml',
		'https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/e.xml',
		'https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/m.xml',
		'https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/i.xml',
		'https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/a.xml',
		'https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/n.xml',
		'https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/p.xml',
		'https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/t.xml',
		'https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/x.xml'
	]

	for canon_url in xml_list:
		# datatype
		entity_initial = re.search('\D\.xml', canon_url).group()[0]
		datatype_url = canon_url.strip(f'{entity_initial}.xml')
		datatype_url = f"{datatype_url}{entity_initial}/datatype.xml"
		g = Graph()
		g.load(datatype_url, format='xml')
		for s, p, o in g:
			prop_uri = "{}".format(s)
			if prop_uri not in datatype_prop_list:
				datatype_prop_list.append(prop_uri)

		# object
		object_url = canon_url.strip(f'{entity_initial}.xml')
		object_url = f"{object_url}{entity_initial}/object.xml"
		g = Graph()
		g.load(object_url, format='xml')
		for s, p, o in g:
			prop_uri = "{}".format(s)
			if prop_uri not in object_prop_list:
				object_prop_list.append(prop_uri)

	return datatype_prop_list, object_prop_list

list_tuple = all_datatype_object_properties()
datatype_prop_list = list_tuple[0]
object_prop_list = list_tuple[1]

def locate_RTs():
	sinopia_maps_repo = os.listdir('..')
	RT_list = []
	for file in sinopia_maps_repo:
		if (file[0:17] == "UWSINOPIA_WAU_rda" or file[0:22] == "TEST_UWSINOPIA_WAU_rda") and file[-4:] == ".rdf":
			RT_list.append(file)

	return RT_list

def replace_uri(rdf_RDF, prop_type):
	sinopia_hasPropertyUri_list = rdf_Description.findall('{http://sinopia.io/vocabulary/}hasPropertyUri')

	for sinopia_hasPropertyUri in sinopia_hasPropertyUri_list:
		prop_iri = sinopia_hasPropertyUri.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource']
		prop_num = prop_iri.split('/')[-1]
		prop_stem = prop_iri.strip(prop_num)
		if prop_type == "object":
			prop_stem = prop_stem + 'object/'
			prop_iri = prop_stem + prop_num
			if prop_iri in object_prop_list:
				sinopia_hasPropertyUri.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource'] = prop_iri
		elif prop_type == "datatype":
			prop_stem = prop_stem + 'datatype/'
			prop_iri = prop_stem + prop_num
			if prop_iri in datatype_prop_list:
				sinopia_hasPropertyUri.attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource'] = prop_iri

	return rdf_RDF

###

RT_list = locate_RTs()

for RT in RT_list:
	tree = ET.parse(f'../{RT}')

	rdf_RDF = tree.getroot()

	for rdf_Description in rdf_RDF:
		sinopia_hasPropertyType_list = rdf_Description.findall('{http://sinopia.io/vocabulary/}hasPropertyType')
		if len(sinopia_hasPropertyType_list) > 0:
			property_type = sinopia_hasPropertyType_list[0].attrib['{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource']
			if property_type == 'http://sinopia.io/vocabulary/propertyType/uri':
				"""URI or lookup"""
				if len(rdf_Description.findall('{http://sinopia.io/vocabulary/}hasLookupAttributes')) == 0:
					"""URI"""
					rdf_RDF = replace_uri(rdf_RDF, "object")
			elif property_type == 'http://sinopia.io/vocabulary/propertyType/resource':
				"""Nested resource"""
				rdf_RDF = replace_uri(rdf_RDF, "object")
			elif property_type == 'http://sinopia.io/vocabulary/propertyType/literal':
				"""Literal"""
				rdf_RDF = replace_uri(rdf_RDF, "datatype")

	tree.write(f'../{RT}', xml_declaration=True, encoding="UTF-8")
