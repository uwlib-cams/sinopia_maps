from textwrap import dedent
import os

# java command components
jar = "~/saxon11/saxon-he-11.1.jar"
xsl = "xsl/001_01_storage_to_rdfxml.xsl"

def intro():
    print(dedent(f"""
    BUILDING RESOURCE TEMPLATES FROM prop_set INSTANCE DATA
    {'=' * 55}\n"""))

# only including testing options right now
def transform(jar, xsl, test, platform):
    confirm1 = input("\nCONFIRM THAT BASH IS RUNNING IN sinopia_maps DIRECTORY: (y/n)\n")
    if confirm1.lower() == 'y':
        pass
    elif confirm1.lower() == 'n':
        print("Quitting...")
        exit(0)
    else:
        print("Unexpected input! Goodbye")
        exit(0)
    print("\nCONFIRM TRANSFORMATION WITH FOLLOWING OPTIONS:")
    # hard-coding
    print("RT IDs will begin with 'TEST:'")
    print("Output RT IRIs will be configured for loading to Sinopia DEVELOPMENT")
    confirm2 = input("OK? (Y/N)\n")
    if confirm2.lower() == 'y':
        print("\nTransforming...\n")
        pass
    elif confirm2.lower() == 'n':
        print("\nQuitting...")
        exit(0)
    else:
        print("\nUnexpected input! Goodbye")
        exit(0)
    os.system(f"java -cp {jar} net.sf.saxon.Transform -s:{xsl} -xsl:{xsl} test={test} platform={platform}")

# only allowing for output of 'TEST' RTs to dev right now
def prompt(jar, xsl):
    intro()
    options = input("Output for TESTING or PRODUCTION? ('testing'/'production')\n")
    if options.lower() == 'testing':
        test = 'TEST:'
        platform = 'development.'
        transform(jar, xsl, test, platform)
    elif options.lower() == 'production':
        print("Not outputting templates for production yet")
        exit(0)

# still to do is re-serialize in a serialization that can be loaded to sinopia
# could be interesting to look at this... 
    # will I go into the directory after this to grab rdf/xml, 
    # or is there some way to pipe the transformation output directly to rdflib?

prompt(jar, xsl)