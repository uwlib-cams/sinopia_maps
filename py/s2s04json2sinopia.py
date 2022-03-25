import os
import requests

"""Create list of JSON-LD RTs"""
# add all files to list
JSONLD_RT_list = os.listdir('../docs/rdf/')

# remove files that are not JSON-LD RTs
remove_list = []
for file in JSONLD_RT_list:
    if "_RT_" not in file:
        remove_list.append(file)
    elif ".json" not in file:
        remove_list.append(file)
for file in remove_list:
    JSONLD_RT_list.remove(file)

"""Post to Sinopia"""
# get JWT from user input
print("Copy and paste a Java Web Token for Sinopia-Stage below.")
jwt = input("> ")

for file in JSONLD_RT_list:
    # establish headers
    headers = {"Authorization": f"Bearer {jwt}", "Content-Type": "application/json"}

    # read JSON-LD from file
    open_file = open(f'../docs/rdf/{file}')
    data = open_file.read()

    # create RT ID and URI
    file_id = file.replace('_', ':')
    file_id = file_id.split('.')[0]
    file_uri = f"https://api.stage.sinopia.io/resource/{file_id}"
    print(file_uri) # remove

    # post to Sinopia
    post_to_sinopia = requests.post(file_uri, data=data.encode('utf-8'), headers = headers)

    # check for errors
    if post_to_sinopia.status_code != requests.codes.ok:
        error_code = post_to_sinopia.status_code
        if error_code == 201: # created, not actually an error
            print("Success!")
        elif error_code == 401: # unauthorized
            print("\nFailed: Java Web Token no longer valid.")
        elif error_code == 409: # conflict
            print("\nFailed: IRI is not unique. Putting instead...")
            post_to_sinopia_2 = requests.put(file_uri, data=data.encode('utf-8'), headers = headers)
            if post_to_sinopia_2.status_code != requests.codes.ok:
                error_code = post_to_sinopia_2.status_code
                if error_code != 201:
                    print(f"Failed: {error_code}")
                else:
                    print("Success!")
            else:
                print("Success!")
        else:
            print(f"Failed: {error_code}")
    else:
        print("Success!")
