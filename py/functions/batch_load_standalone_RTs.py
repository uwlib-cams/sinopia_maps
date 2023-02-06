from datetime import datetime
import json
import os
import rdflib
from rdflib import * 
import requests
from textwrap import dedent

###
# SUMMARY
# Function to load all RTs present at the top-level of sinopia_maps
# [!] Only usable for RTs without any nested-resource property templates
# Assuming...
    # 1) nested-resource property templates in Sinopia create bnodes and
    # 2) bnodes are not well-formed RDA/RDF
# ... no RTs with nested-property PTs will require loading (for RDA RTs)
### 

def format_json(user, uri, json_file):
	with open(json_file, 'r') as RT:
		original_data = json.load(RT)
		current_time = datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%S.%f')[:-3] + 'Z'
		RT_id = uri.split('/')[-1]
		sinopia_format = json.dumps({"data": original_data, "user": user, "group": "washington", "editGroups": [], "templateId": "sinopia:template:resource", "types": [ "http://sinopia.io/vocabulary/ResourceTemplate" ], "bfAdminMetadataRefs": [], "sinopiaLocalAdminMetadataForRefs": [], "bfItemRefs": [], "bfInstanceRefs": [], "bfWorkRefs": [], "id": RT_id, "uri": uri, "timestamp": current_time})
	
    # here's where the Sinopia admin metadata gets written to the json-ld in the repo
    # I'd like to save just the JSON-LD template with no Sinopia admin metadata
	"""
    with open(json_file, 'w') as RT:
        RT.write(sinopia_format)
	"""
	# so skip RT.write and just use sinopia_format to load



def load(sinopia_platform, user, jwt, RT_list):
    for RT in RT_list:
	    g = Graph()
	    g.parse(RT, format = 'xml')
	    
	    for s, p, o in g:
		    if isinstance(s, rdflib.term.URIRef) == True:
			    if s[0:19] == "https://api.sinopia":
                    RT_id = s.split('/')[-1]
                    new_URI = f"https://api.{sinopia_platform}sinopia.io/resource/{RT_id}"
                    g.remove((s, p, o))
                    g.add((URIRef(new_URI), p, o))
        
        # filepath needs to change if running from repo top level
        g.serialize(f"../{RT.split('.')[0]}.json", format='json-ld')
        # filepath needs to change if running from repo top level
        # TESTING
        # format_json(user, new_URI, f"../{RT.split('.')[0]}.json")

def intro():
	print(dedent(f"""
	    LOADING RESOURCE TEMPLATES TO SINOPIA
	    {'=' * 40}
		"""))

def prompt_platform(jwt): 
	sinopia_platform = input("Load to Development, Stage, or Production?\n[1] Development\n[2] Stage\n[3] Production\n> ")
	if sinopia_platform == "1":
	    sinopia_platform = "development."
	elif sinopia_platform == "2":
	    sinopia_platform = "stage."
	elif sinopia_platform == "3":
		sinopia_platform = ""
	else:
		print("Platform not recognized.")
		quit()
	return sinopia_platform

def prompt_username():
	user = input("Enter Sinopia user name here:\n> ")
	return user

def prompt_jwt():
	jwt = input("Enter JWT here:\n> ")
	return jwt

def locate_RTs():
    # filepath would need to change if running from repo top level
    repo_top_level = os.listdir('..')
    RT_list = []
    for file in repo_top_level:
        if file[0:10] == "UWSINOPIA_" and file[-4:] == ".rdf":
            RT_list.append(file)
	return RT_list


intro()
prompt_platform()
prompt_username
prompt_jwt()
load(sinopia_platform, user, jwt, RT_list)
