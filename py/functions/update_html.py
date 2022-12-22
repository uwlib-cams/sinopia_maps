# this program contains functions used to transform sinopia_maps.xml
# using 004_01_create_human_readable_RTs.xsl
# to generate html files of RTs 

import lxml.etree as ET
import os
import subprocess 

###

def get_xsl():
	# ensure xslt file exists, else quit program
	if os.path.exists('../xsl/004_01_create_human_readable_RTs.xsl'):
		xslt_file = ('../xsl/004_01_create_human_readable_RTs.xsl')
		print(xslt_file)
		return(xslt_file)
	else:
		print('failed to find 004_01_create_human_readable_RTs.xsl')
		quit()

def transform(saxon_dir, saxon_version, xsl_file):
	#transform xml file using xslt through saxon 
	os.system(f'java -cp ~/{saxon_dir}/saxon-he-{saxon_version}.jar net.sf.saxon.Transform -t -s:{xsl_file} -xsl:{xsl_file}')

def update_html(saxon_dir, saxon_version):
	xsl_file = get_xsl()
	transform(saxon_dir, saxon_version, xsl_file)
		