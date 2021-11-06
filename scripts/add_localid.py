from CommentedTreeBuilder import CommentedTreeBuilder
from sys import argv
import xml.etree.ElementTree as ET

"""Set variables for input and output files"""
script, map_storage_filepath = argv # filepath from command line

"""Parser to preserve comments"""
parser = ET.XMLParser(target=CommentedTreeBuilder())

"""Open Element Tree"""
tree = ET.parse(map_storage_filepath, parser)
root = tree.getroot()
ns = {'mapstor': 'https://uwlib-cams.github.io/map_storage/'} # establish namespace

"""Add local id to implementation sets"""
for prop in root.findall('.//*[@localid_prop]', ns): # loop through all properties
	prop_num = prop.attrib['localid_prop']
	prop_num = prop_num.split('/')[-1] # get property number from local id
	id_num = 1
	for implementation_set in prop.findall('.//mapstor:implementationSet', ns): # loop through all implementation sets within each property
		localid = f'is_{prop_num}_{id_num:03}'
		implementation_set.set('localid_implementationSet', localid) # set local id as value for attribute localid_implementationSet
		id_num += 1
tree.write(map_storage_filepath) # write results to output file

"""Remove name Element Tree adds to default prefix"""
# element tree replaces default prefix with ns0: # remove all instances of this
original = open(map_storage_filepath, "rt")
find_and_replace = original.read()
find_and_replace = find_and_replace.replace("ns0:", "")
find_and_replace = find_and_replace.replace(":ns0", "")
original.close()
new = open(map_storage_filepath, "wt")
new.write(find_and_replace)
new.close()
