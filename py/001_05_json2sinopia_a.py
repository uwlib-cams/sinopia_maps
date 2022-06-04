from textwrap import dedent
import os
import requests

def getEnvironment():
    se = input(dedent("""
            Which Sinopia platform will you load the RT(s) to?
            Enter 'Production', 'Stage', or 'Development':
        """))
    if se == 'Production' or 'Stage' or 'Development':
        pass
    # below is not the correct way to make the script loop back to input
    else:
        getEnvironment()

getEnvironment()

"""

JSONLD_RT_list = os.listdir('../docs/rdf/')

environments = {
    "Production": "production",
    "Stage": "stage",
    "Development": "development"
}

 print(f"Copy/paste a Java Web Token for Sinopia {se} below.")
 jwt = input("> ")

 for file in JSONLD_RT_list:
     if file.endswith(".json"):
         # I don't understand the syntax below
         headers = {"Authorization": f"Bearer {jwt}", "Content-Type": "application/json"}

         open_file = open(f"../docs/rdf/{file}")
         data = open_file.read()

         file_id = file.replace("_", ":")
         # need to review split
         file_id = file_id.split(".")[0]
         file
"""
