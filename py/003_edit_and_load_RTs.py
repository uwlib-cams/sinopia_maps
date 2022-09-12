"""Step 1: Run XSLT transformation"""
import os

os.system('java -cp ~/saxon11/saxon-he-11.1.jar net.sf.saxon.Transform -t -s:../xsl/001_01_storage_to_rdfxml.xsl -xsl:../xsl/001_01_storage_to_rdfxml.xsl')
os.system('mv UWSINOPIA_WAU_rda* ../')

"""Step 2: Convert canonical IRIs to object/datatype IRIs"""
import functions.replace_canonical_props

"""Step 3: Fix multiple prop IRIs"""
import functions.fix_multi_props

"""Step 4: Load RTs to Sinopia"""
import functions.batch_load_RTs
