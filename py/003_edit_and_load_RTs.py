"""Step 1: Run XSLT transformation"""
import os

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
	os.system('java -cp ~/saxon11/saxon-he-11.1.jar net.sf.saxon.Transform -t -s:../xsl/001_01_storage_to_rdfxml.xsl -xsl:../xsl/001_01_storage_to_rdfxml.xsl test="TEST:"')

	# Move to top-level folder
	os.system('mv TEST_UWSINOPIA_WAU_rda* ../')
elif resources == 2:
	# Non-test RTs
	os.system('java -cp ~/saxon11/saxon-he-11.1.jar net.sf.saxon.Transform -t -s:../xsl/001_01_storage_to_rdfxml.xsl -xsl:../xsl/001_01_storage_to_rdfxml.xsl')

	# Move to top-level folder
	os.system('mv UWSINOPIA_WAU_rda* ../')
else:
	# Both
	os.system('java -cp ~/saxon11/saxon-he-11.1.jar net.sf.saxon.Transform -t -s:../xsl/001_01_storage_to_rdfxml.xsl -xsl:../xsl/001_01_storage_to_rdfxml.xsl test="TEST:"')
	os.system('java -cp ~/saxon11/saxon-he-11.1.jar net.sf.saxon.Transform -t -s:../xsl/001_01_storage_to_rdfxml.xsl -xsl:../xsl/001_01_storage_to_rdfxml.xsl')

	# Move to top-level folder
	os.system('mv TEST_UWSINOPIA_WAU_rda* ../')
	os.system('mv UWSINOPIA_WAU_rda* ../')

"""Step 2: Convert canonical IRIs to object/datatype IRIs"""
import functions.replace_canonical_props

"""Step 3: Fix multiple prop IRIs"""
import functions.fix_multi_props

"""Step 4: Load RTs to Sinopia"""
import functions.batch_load_RTs
