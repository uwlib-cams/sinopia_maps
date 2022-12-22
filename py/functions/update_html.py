import lxml.etree as ET
import os
import subprocess 

###

def get_xslt():
	if os.path.exists('../xsl/004_01_create_human_readable_RTs.xsl'):
		xslt_file = ('../xsl/004_01_create_human_readable_RTs.xsl')
		print(xslt_file)
		return(xslt_file)
	else:
		print('failed to find 004_01_create_human_readable_RTs.xsl')
		quit()

def transform(saxon_dir, saxon_version, xsl_file):
	os.system(f'java -cp ~/{saxon_dir}/saxon-he-{saxon_version}.jar net.sf.saxon.Transform -t -s:{xsl_file} -xsl:{xsl_file}')

def update_html(saxon_dir, saxon_version):
	xsl_file = get_xslt()
	transform(saxon_dir, saxon_version, xsl_file)
		