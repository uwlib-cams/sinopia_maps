import os
from textwrap import dedent

"""Step 0: A couple of caveats"""
caveats = 'yes'
print(dedent("""Please note:
1) The terminal should be open in the sinopia_maps/py directory when running this script
2) The script assumes that Saxon HE is located in the user's home directory"""))
caveats_okay = input("OK to proceed? (yes or no): ")
if caveats_okay.lower() == 'yes':
	pass
else:
	exit(0)

"""Step 1: Run XSLT transformation"""
saxon_dir_prompt = dedent("""Enter the name of the directory in which the Saxon HE .jar file is stored
For example: 'saxon', 'saxon11', etc.
> """)
saxon_dir = input(saxon_dir_prompt)

saxon_version_prompt = dedent("""
Enter the Saxon HE version number you'll use for the transformation
For example: '11.1', '11.4', etc.
> """)
saxon_version = input(saxon_version_prompt)

def prompt_resources():
	resources = input("Update test resource templates?\n[1] Update test RTs only\n[2] Update non-test RTs only\n[3] Update all RTs\n> ")
	acceptable_responses = ["1", "2", "3"]
	if resources not in acceptable_responses:
		print("Input not recognized.")
		quit()

	return resources

resources = prompt_resources()

if resources == 1:
	# Test RTs
	os.system(f'java -cp ~/saxon11/saxon-he-{saxon_version}.jar net.sf.saxon.Transform -t -s:../xsl/001_01_storage_to_rdfxml.xsl -xsl:../xsl/001_01_storage_to_rdfxml.xsl test="TEST:"')

	# Move to top-level folder
	os.system('mv TEST_UWSINOPIA_WAU_rda* ../')
elif resources == 2:
	# Non-test RTs
	os.system(f'java -cp ~/saxon11/saxon-he-{saxon_version}.jar net.sf.saxon.Transform -t -s:../xsl/001_01_storage_to_rdfxml.xsl -xsl:../xsl/001_01_storage_to_rdfxml.xsl')

	# Move to top-level folder
	os.system('mv UWSINOPIA_WAU_rda* ../')
else:
	# Both
	os.system(f'java -cp ~/saxon11/saxon-he-{saxon_version}.jar net.sf.saxon.Transform -t -s:../xsl/001_01_storage_to_rdfxml.xsl -xsl:../xsl/001_01_storage_to_rdfxml.xsl test="TEST:"')
	os.system(f'java -cp ~/saxon11/saxon-he-{saxon_version}.jar net.sf.saxon.Transform -t -s:../xsl/001_01_storage_to_rdfxml.xsl -xsl:../xsl/001_01_storage_to_rdfxml.xsl')

	# Move to top-level folder
	os.system('mv TEST_UWSINOPIA_WAU_rda* ../')
	os.system('mv UWSINOPIA_WAU_rda* ../')

"""Step 2: Convert canonical IRIs to object/datatype IRIs"""
import functions.replace_canonical_props

"""Step 3: Fix multiple prop IRIs"""
import functions.fix_multi_props

"""Step 4: Load RTs to Sinopia"""
import functions.batch_load_RTs
