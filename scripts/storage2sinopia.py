from textwrap import dedent

def check_directory():
    print(dedent("""Confirm that you are running this script from a terminal open at the following location:
        [...]/sinopia_maps/scripts/
    """))
    check = input(dedent("""Is this the location where the terminal is open?
        Enter 'Y' or 'N':
    """))
    if check == 'Y':
        pass
    elif check == 'N':
        sys.exit(dedent("""Open a terminal at the following location and run this script again:
            [...]/sinopia_maps/scripts/
        """))
    else:
        sys.exit("Be sure to enter either 'Y' or 'N' (omit single quotes).")

check_directory()

"""propSets to RDF/XML"""

import storage2rdfxml

"""Convert RDF/XML to JSON-LD"""

import rdfxml2json

"""Edit JSON-LD for upload to Sinopia"""

import edit_json

"""Post edited JSON-LD to Sinopia"""

# import json_to_sinopia
