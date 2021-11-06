import os
from rdflib import *

"""Create list of RDF/XML RTs"""
# add all files to list
RDFXML_RT_list = os.listdir('..')

# remove files that are not RDF/XML RTs
remove_list = []
for file in RDFXML_RT_list:
    if "_RT_" not in file:
        remove_list.append(file)
    elif ".xml" not in file:
        remove_list.append(file)
for file in remove_list:
    RDFXML_RT_list.remove(file)

"""Reserialize RTs"""

for file in RDFXML_RT_list:
    g = Graph()
    g.load(f'file:../{file}', format='xml')
    json_filepath = file.split('.')[0] + '.json'
    g.serialize(destination=f'file:../{json_filepath}', format='json-ld')
