from datetime import datetime
import json
import os
import rdflib
from rdflib import *
import requests
from textwrap import dedent

###

# get list of RTs - must be in sinopia_maps/py 
def locate_RTs():
	sinopia_maps_repo = os.listdir('..')
	RT_list = []
	for file in sinopia_maps_repo:
		#if file is a UWSINOPIA resource of type rdf, add to list
		if file[0:14] == "UWSINOPIA_WAU_" and file[-4:] == ".rdf":
				RT_list.append(file)
	#return list of RTs
	return RT_list

#ensures referenced RTs are uploaded before RTs that reference them
def sort_list(RT_list): 
	is_referenced_by = {}
	references = {}

	for RT in RT_list:
		RT = RT[0:-4]
		RT = RT.replace('_', ':') 
		# declare arrays 
		is_referenced_by[RT] = []
		references[RT] = []

	for RT in RT_list:
		g = Graph()
		g.parse(RT, format='xml') #i think this works? 
		
		RT_id = RT[0:-4].replace('_', ':') #rename to match sinopia format

		for s, p, o in g: #for subject, predicate, object in graph
			if p == URIRef("http://sinopia.io/vocabulary/hasResourceTemplateId"):
				referenced_rt = "{}".format(o)
				if RT_id not in is_referenced_by[referenced_rt]:
					is_referenced_by[referenced_rt].append(RT_id)
				if referenced_rt not in references[RT_id]:
					references[RT_id].append(referenced_rt)
	
	upload_order = {"first_group": [], "second_group": [], "last_group": []}
	# first_group = is referenced by other RTs, does not reference any RTs itself
	# second_group = is referenced by other RTs, does reference other RTs
	# last_group = is not referenced by other RTs

	for RT in RT_list:
		RT_id = RT[0:-4].replace('_', ':')
		referenced_by = is_referenced_by[RT_id]
		if len(referenced_by) == 0:
			# not referenced by other RTs
			upload_order["last_group"].append(RT)
		else:
			references_list = references[RT_id]
			if len(references_list) == 0:
				# does not reference other RTs
				upload_order["first_group"].append(RT)
			else:
				# does reference other RTs
				upload_order["second_group"].append(RT)

	return upload_order #return order as dict with keys first_group, second_group, last_groupu

# mcm104 NOTE: currently, second_group is empty; if second_group later is NOT empty, 
# 	i.e. there are RTs that are referenced by others AND reference RTs themselves, 
# 	the RTs in this group may need to be ordered more narrowly; 
# 	leaving for now as it is not currently an issue

def format_json(username, uri, json_file):
	with open(json_file, 'r') as RT:
		original_data = json.load(RT)
		currentTime = datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%S.%f')[:-3] + 'Z'
		RT_id = uri.split('/')[-1]
		sinopia_format = json.dumps({"data": original_data, "user": username, "group": "washington", "editGroups": [], "templateId": "sinopia:template:resource", "types": [ "http://sinopia.io/vocabulary/ResourceTemplate" ], "bfAdminMetadataRefs": [], "sinopiaLocalAdminMetadataForRefs": [], "bfItemRefs": [], "bfInstanceRefs": [], "bfWorkRefs": [], "id": RT_id, "uri": uri, "timestamp": currentTime})

	with open(json_file, 'w') as RT:
		RT.write(sinopia_format)

def intro():
	print(dedent(f"""
		LOADING RESOURCE TEMPLATES TO SINOPIA
		{'=' * 40}
		"""))

# get jwt
def prompt_jwt():
	jwt = input("Enter JWT here:\n> ")
	prompt_platform(jwt)

# get platform
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
	prompt_resources(jwt, sinopia_platform)

# get resources
def prompt_resources(jwt, platform):
	resources = input("Ready to upload all RTs?\n'YES'/'NO'\n> ")
	if resources.lower() != 'yes':
		quit()
	else:
		# get RTs and upload
		RT_list = locate_RTs()
		upload_list(jwt, platform, RT_list)

def upload_list(jwt, platform, RT_list):
	user = input("Enter Sinopia user name here:\n> ")
	
	#sort RT_list using dict
	sorted_dict = sort_list(RT_list)
	#put sorted RTs from dict into an array 
	sorted_RT_list = list(sorted_dict.values())[0]

	print(sorted_RT_list)

	for RT in sorted_RT_list:
		g = Graph()
		g.parse(RT, format='xml')
		
		for s, p, o in g: #for subject, predicate, object in graph 
			if isinstance(s, rdflib.term.URIRef) == True:
				if s[0:31] == "https://api.development.sinopia" or s[0:25] == "https://api.stage.sinopia" or s[0:19] == "https://api.sinopia":
					RT_id = s.split('/')[-1]
					new_URI = f"https://api.{platform}sinopia.io/resource/{RT_id}"
					g.remove((s, p, o))
					g.add((URIRef(new_URI), p, o))
		g.serialize(f"../{RT.split('.')[0]}.json", format='json-ld')
		format_json(user, new_URI, f"../{RT.split('.')[0]}.json")

		open_RT = open(f"../{RT.split('.')[0]}.json")
		
		data = open_RT.read()

		headers = {"Authorization": f"Bearer {jwt}", "Content-Type": "application/json"}
		post_to_sinopia = requests.post(new_URI, data=data.encode('utf-8'), headers=headers)
		status_code = post_to_sinopia.status_code
		if status_code == 409:
			# conflict; something already exists at this URI, so put (i.e. overwrite) instead of post
			overwrite_in_sinopia = requests.put(new_URI, data=data.encode('utf-8'), headers=headers)
			print(f"{RT}: {overwrite_in_sinopia.status_code}")
		else:
			print(f"{RT}: {status_code}")

###

intro()
prompt_jwt()

# https://www.rfc-editor.org/rfc/rfc9110.html#name-overview-of-status-codes
# 2xx SUCCESSFUL
	# 200 = OK, request has succeeded
	# 201 = Created, request has been fulfilled and has resulted in one or more new resources being created
	# 204 = No Content success (deleted)
# 4xx CLIENT ERROR
	# 400 = Bad Request
	# 401 = Unauthorized
	# 404 = Not Found
