from textwrap import dedent
import sys
import os

saxonJarPath = input(dedent("""Enter the path to the Saxon .jar file you'll use to perform this transformation,
starting at your terminal's home directory (your path will start with '~/'):
"""))

os.system(f"java -cp {saxonJarPath} net.sf.saxon.Transform -s:../../sinopia_maps.xml -xsl:stylesheets/_storage_to_rdfxml.xsl")

# I'd like to provide more information than this...
    # for example, output log
    # or provide errors, etc.

# This should only print if it has actually been completed
print("Storage instance to RDF/XML XSLT transformation complete...")
