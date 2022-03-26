<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    xmlns:bmrxml="https://briesenberg07.github.io/xml_stack/" 
    exclude-result-prefixes="xs"
    version="3.0">

    <xsl:output method="xml" indent="yes"/>

    <xsl:include href="001rt_metadata.xsl"/>
    <xsl:include href="001create_ordering.xsl"/>

    <xsl:template match="/">
        <xsl:for-each
            select="document('../xml/sinopia_maps.xml')/uwsinopia:sinopia_maps/uwsinopia:rts/uwsinopia:rt">
            <!-- vars -->
            <!-- to do account for multiple prop_sets output to RT, see also $sorted_properties below -->
            <xsl:variable name="prop_set" select="uwsinopia:prop_set"/>
            <xsl:variable name="resource" select="uwsinopia:resource"/>
            <xsl:variable name="format" select="uwsinopia:format"/>
            <xsl:variable name="user" select="uwsinopia:user"/>
            <!-- to do remove 'TEST' in rt_id to output for production -->
            <xsl:variable name="rt_id" select="
                    concat('TEST:WAU:',
                    format-date(current-date(), '[Y0001]-[M01]-[D01]'), ':',
                    $resource, ':', $format, ':', $user)"/>
            <xsl:variable name="sorted_properties" as="node()*">
                <xsl:for-each select="
                        (: [!] doc XPath is for using TEST prop_sets :)
                        document(concat('../../map_storage/test_prop_set_', $prop_set, '.xml'))/
                        uwmaps:prop_set/uwmaps:prop
                        [uwmaps:sinopia/uwsinopia:implementation_set
                        [uwsinopia:resource = $resource]
                        [uwsinopia:format = $format]
                        [uwsinopia:user = $user]]">
                    <xsl:sort select="
                            uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:form_order"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:variable>

            <!-- to do change result-document path for production -->
            <!-- RT NAMING CONVENTIONS: colons for RT ID, underscores for RT filename, spaces for RT label -->
            <xsl:result-document href="../{translate($rt_id, ':', '_')}.rdf">
                <rdf:RDF>
                    <xsl:call-template name="rt_metadata">
                        <xsl:with-param name="resource" select="$resource"/>
                        <xsl:with-param name="suppressible" select="uwsinopia:suppressible"/>
                        <xsl:with-param name="optional_classes">
                            <xsl:for-each select="uwsinopia:optional_class">
                                <optional_class>
                                    <xsl:value-of select="."/>
                                </optional_class>
                            </xsl:for-each>
                        </xsl:with-param>
                        <xsl:with-param name="format" select="$format"/>
                        <xsl:with-param name="user" select="$user"/>
                        <xsl:with-param name="rt_id" select="$rt_id"/>
                        <xsl:with-param name="sorted_properties" select="$sorted_properties"/>
                    </xsl:call-template>
                    <xsl:call-template name="create_ordering">
                        <xsl:with-param name="sorted_property" select="$sorted_properties"/>
                    </xsl:call-template>
                </rdf:RDF>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
