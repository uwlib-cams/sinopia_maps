from textwrap import dedent
import os

# java command components
jar = "~/saxon11/saxon-he-11.1.jar"
xsl = "xsl/001_01_storage_to_rdfxml.xsl"

def intro():
    print(dedent(f"""
        BUILDING RESOURCE TEMPLATES FROM prop_set INSTANCE DATA
        {'=' * 55}
        """))

def transform(jar, xsl, test, platform):
    os.system(f"java -cp {jar} net.sf.saxon.Transform -s:{xsl} -xsl:{xsl} test={test} platform={platform}")

# only allowing for output of 'TEST' RTs to dev right now
def prompt(jar, xsl):
    intro()
    confirm1 = input("CONFIRM THAT BASH IS RUNNING IN sinopia_maps DIRECTORY: (y/n)\n")
    if confirm1.lower() == 'y':
        pass
    elif confirm1.lower() == 'n':
        print("Quitting...")
        exit(0)
    else:
        print("Unexpected input! Goodbye")
        exit(0)
    options = input("Output for TESTING or PRODUCTION? ('testing'/'production')\n")
    if options.lower() == 'testing':
        test = 'TEST:'
        platform = 'development.'
        print("\nCONFIRM TRANSFORMATION WITH FOLLOWING OPTIONS:")
        print("RT IDs will begin with 'TEST:'")
        print("Output RT IRIs will be configured for loading to Sinopia DEVELOPMENT")
        confirm2 = input("OK? (Y/N)\n")
        if confirm2.lower() == 'y':
            print("\nTransforming...\n")
            transform(jar, xsl, test, platform)
        elif confirm2.lower() == 'n':
            print("\nQuitting...")
            exit(0)
        else:
            print("Unexpected input! Goodbye")
            exit(0)
    elif options.lower() == 'production':
        test = ''
        platform = ''
        print("\nCONFIRM TRANSFORMATION WITH FOLLOWING OPTIONS:")
        print("Output RT IRIs will be configured for loading to Sinopia PRODUCTION")
        confirm3 = input("OK? (Y/N)\n")
        if confirm3.lower() == 'y':
            print("\nTransforming...\n")
            transform(jar, xsl, test, platform)
        elif confirm3.lower() == 'n':
            print("\nQuitting...")
            exit(0)
        else:
            print("Unexpected input! Goodbye")
            exit(0)
    else:
        print("\nUnexpected input! Goodbye")
        exit(0)

# still to do is re-serialize in a serialization that can be loaded to sinopia
# could be interesting to look at this... 
    # will I go into the directory after this to grab rdf/xml, 
    # or is there some way to pipe the transformation output directly to rdflib?

prompt(jar, xsl)