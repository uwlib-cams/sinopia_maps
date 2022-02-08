import json
import os
from rdflib import *
import time



"""Create list of JSON-LD RTs"""
# add all RDF RTs to list
JSONLD_RT_list = os.listdir('../docs/rdf/')

"""Edit JSON-LD"""
def edit_json(file):
    with open(f'../docs/rdf/{file}', 'r') as original_data_file:
        original_data = json.load(original_data_file)
        currentTime = time.strftime("%Y-%m-%dT%H:%M:%S")
        RT_id = file.split('.')[0]
        RT_id = RT_id.replace('_', ':')
        # to do - get desired sinopia environment in storage2sinopia
        RT_iri = f"https://api.development.sinopia.io/resource/{RT_id}"
        everything = {
            "data": original_data,
            # to do - get username in storage2sinopia?
                # BUT this must be a username registered at the chosen sinopia environment I suppose??
            "user": "ries07uwdev",
            "group": "washington",
            "templateId": "sinopia:template:resource",
            "types": ["http://sinopia.io/vocabulary/ResourceTemplate"],
            "bfAdminMetadataRefs": [],
            "bfItemRefs": [],
            "bfInstanceRefs": [],
            "bfWorkRefs": [],
            "id": RT_id,
            "uri": RT_iri,
            "timestamp": currentTime
        }
        sinopia_format = json.dumps(everything)

    with open(f'../docs/rdf/{file}', 'w') as output_file:
        output_file.write(sinopia_format)

for file in JSONLD_RT_list:
    if file.endswith(".json"):
        edit_json(file)

print("Sinopia-required RT admin metadata added...")
