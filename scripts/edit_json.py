import json
import os
from rdflib import *
import time

"""Create list of JSON-LD RTs"""
# add all files to list
JSONLD_RT_list = os.listdir('..')

# remove files that are not RDF/XML RTs
remove_list = []
for file in JSONLD_RT_list:
    if "_RT_" not in file:
        remove_list.append(file)
    elif ".json" not in file:
        remove_list.append(file)
for file in remove_list:
    JSONLD_RT_list.remove(file)

"""Edit JSON-LD"""
def edit_json(file):
    with open(f'../{file}', 'r') as original_data_file:
        original_data = json.load(original_data_file)
        currentTime = time.strftime("%Y-%m-%dT%H:%M:%S")
        RT_id = file.split('.')[0]
        RT_id = RT_id.replace('_', ':')
        RT_iri = f"https://api.stage.sinopia.io/resource/{RT_id}"
        sinopia_format = json.dumps({"data": original_data, "user": "mcm104", "group": "washington", "templateId": "sinopia:template:resource", "types": ["http://sinopia.io/vocabulary/ResourceTemplate"], "bfAdminMetadataRefs": [], "bfItemRefs": [], "bfInstanceRefs": [], "bfWorkRefs": [], "id": RT_id, "uri": RT_iri, "timestamp": currentTime})

    with open(f'../{file}', 'w') as output_file:
        output_file.write(sinopia_format)

for file in JSONLD_RT_list:
    edit_json(file)
