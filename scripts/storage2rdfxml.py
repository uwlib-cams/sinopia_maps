import sys
import os
"""
I'll run checkDir here for testing individual .py scripts
Move to storage2sinopia.py following testing
"""

def check_directory():
    print("""
    Confirm that you are running this script from a terminal open at the following location:
    [...]/sinopia_maps/scripts/
    """)
    check = input("""
    Is this the location where the terminal is open?
    Enter 'Y' or 'N': """)
    if check == 'Y':
        pass
    elif check == 'N':
        sys.exit("""
        Open a terminal at the following location and run this script again:
        [...]/sinopia_maps/scripts/
        """)
    else:
        sys.exit("Be sure to enter either 'Y' or 'N' (omit single quotes).")

check_directory()

saxonJarPath = input("""
Enter the path to the Saxon .jar file you'll use to perform this transformation,
starting at your terminal's home directory (your path will start with '~/'):
""")

os.system(f"java -cp {saxonJarPath} net.sf.saxon.Transform -s:storage_to_rdfxml.xsl -xsl:storage_to_rdfxml.xsl")
