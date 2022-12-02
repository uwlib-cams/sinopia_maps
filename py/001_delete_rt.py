from textwrap import dedent
import requests

def intro():
	print(dedent(f"""
		DELETING RESOURCES FROM SINOPIA
		{'=' * 35}
		"""))

def prompt_jwt():
	jwt = input("Enter JWT here:\n> ")
	prompt_platform(jwt)
	
def prompt_platform(jwt):
	sinopia_platform = input("Delete from Development, Stage, or Production?\n[1] Development\n[2] Stage\n[3] Production\n> ")
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

def prompt_resources(jwt, platform):
	resources = input("Delete a single resource or a list?\n'single' or 'list'\n> ")
	if resources == 'single':
		resource_id = input("Enter resource ID here:\n> ")
		delete_single(jwt, platform, resource_id)
	elif resources == 'list':
		resource_ids = input("Input filepath to resource ID text file\n> ")
		delete_list(jwt, platform, resource_ids)

def delete_single(jwt, platform, resource_id):
	headers = {"Authorization": f"Bearer {jwt}", "Content-Type": "application/json"}
	delete_from_sinopia = requests.delete(f"https://api.{platform}sinopia.io/resource/{resource_id}", headers = headers)
	print(delete_from_sinopia.status_code)

def delete_list(jwt, platform, resource_list):
# TO DO for delete_list:
	# strip URI base from list entries (it's easier to just copy IRIs than select and copy just IDs/slugs)
	to_delete = open(resource_list, 'r')
	to_delete = to_delete.read().split('\n')
	for resource in to_delete:
		if resource != '':
			headers = {"Authorization": f"Bearer {jwt}", "Content-Type": "application/json"}
			delete_from_sinopia = requests.delete(f"https://api.{platform}sinopia.io/resource/{resource}", headers = headers)
			print(delete_from_sinopia.status_code)
		else:
			pass

intro()
prompt_jwt()

# 204 = deleted
# 401 = Unauthorized
# 404 = Not found
