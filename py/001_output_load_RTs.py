import os
from functions.update_html import *
from textwrap import dedent

"""Confirm directories"""
print(dedent("""Please confirm:
	1) The terminal must be open in the sinopia_maps/py directory when running this script
	2) The Saxon processor .jar file must be located in the user's home directory (~)"""))
confirm = input("OK to proceed? (yes or no): ")
if confirm.lower() == 'yes':
	pass
else:
	exit(0)

"""Setup and run XSLT transformation"""
saxon_dir_prompt = dedent("""Enter the name of the directory in which the Saxon HE .jar file is stored
For example: 'saxon', 'saxon11', etc.
> """)
saxon_dir = input(saxon_dir_prompt)

saxon_version_prompt = dedent("""
Enter the Saxon HE version number you'll use for the transformation
For example: '11.1', '11.4', etc.
> """)
saxon_version = input(saxon_version_prompt)

def prompt_proceed():
	proceed = input("Ready to update and load all RTs?\n'YES'/'NO'\n> ")
	if proceed.lower() != 'yes':
		quit()

prompt_proceed()

# filepaths would change if changing to run from repo top-level
os.system(f'java -cp ~/{saxon_dir}/saxon-he-{saxon_version}.jar net.sf.saxon.Transform -t -s:../xsl/001_01_storage_to_rdfxml.xsl -xsl:../xsl/001_01_storage_to_rdfxml.xsl')

# Move to top-level folder (might be unnecessary if changing to run from repo top-level)
os.system('mv UWSINOPIA_WAU_rda* ../')

"""Eliminate repeating property IRIs"""
import functions.fix_multi_props

""" update html"""
update_html(saxon_dir, saxon_version)

"""Load RTs to selected Sinopia environment"""
import py.functions.batch_load_nested_RTs
