from os import listdir
from rdflib import Graph

"""Create list of RDF/XML RTs"""
# add all files to list
RDFXML_RT_list = listdir('../docs/rdf/')

"""Reserialize RTs"""
for file in RDFXML_RT_list:
    if file.endswith(".rdf"):
        g = Graph()
        g.load(f'../docs/rdf/{file}', format='xml')
        json_filename = file.split('.')[0] + '.json'
        g.serialize(destination = f'../docs/rdf/{json_filename}', format='json-ld')

print("JSON-LD serialization complete...")
