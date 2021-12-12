# Run XSLT
import os
os.system("java -cp ~/ries/saxon/saxon-he-10.3.jar net.sf.saxon.Transform -t -s:build_update_test002.xsl -xsl:build_update_test002.xsl")
# OK

# TO-DO:
    # Save output as log file
    # (...much more)
