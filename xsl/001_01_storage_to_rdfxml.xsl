<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="xs" version="3.0">

    <xsl:output method="xml" indent="yes"/>
    
    <xsl:param name="oxygenPath"/>

    <xsl:include href="001_02_rt_metadata.xsl"/>
    <xsl:include href="001_03_create_ordering.xsl"/>

    <xsl:template match="/">
        <xsl:for-each
            select="document('../xml/sinopia_maps.xml')/uwsinopia:sinopia_maps/uwsinopia:rts/uwsinopia:rt">
            <!-- vars -->
            <xsl:variable name="institution" select="uwsinopia:institution"/>
            <xsl:variable name="resource" select="uwsinopia:resource"/>
            <xsl:variable name="format" select="uwsinopia:format"/>
            <xsl:variable name="user" select="uwsinopia:user"/>
            <!-- colons for RT ID, underscores for RT filename, spaces for RT label -->
            <xsl:variable name="rt_id" select="
                concat('UWSINOPIA:', $institution, ':', $resource, ':', $format, ':', $user)"/>
            <xsl:variable name="sorted_properties" as="node()*">
                <xsl:for-each select="
                    (: [!] CAUTION local path to prop_set instances, using local data :)
                        collection('../../map_storage/?select=*.xml')/
                        uwmaps:prop_set/uwmaps:prop
                        [uwmaps:sinopia/uwsinopia:implementation_set
                        [uwsinopia:institution = $institution]
                        [uwsinopia:resource = $resource]
                        [uwsinopia:format = $format]
                        [uwsinopia:user = $user]]">
                    <xsl:sort select="
                            uwmaps:sinopia/uwsinopia:implementation_set
                            [uwsinopia:institution = $institution]
                            [uwsinopia:resource = $resource]
                            [uwsinopia:format = $format]
                            [uwsinopia:user = $user]
                            /uwsinopia:form_order"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:variable>
            <!-- colons for RT ID, underscores for RT filename, spaces for RT label -->
            <xsl:result-document href="{concat($oxygenPath, translate($rt_id, ':', '_'))}.rdf">
                <rdf:RDF>
                    <xsl:call-template name="rt_metadata">
                        <xsl:with-param name="suppressible" select="uwsinopia:suppressible"/>
                        <xsl:with-param name="optional_classes">
                            <xsl:for-each select="uwsinopia:optional_class">
                                <optional_class>
                                    <xsl:value-of select="."/>
                                </optional_class>
                            </xsl:for-each>
                        </xsl:with-param>
                        <xsl:with-param name="institution" select="$institution"/>
                        <xsl:with-param name="resource" select="$resource"/>
                        <xsl:with-param name="format" select="$format"/>
                        <xsl:with-param name="user" select="$user"/>
                        <xsl:with-param name="rt_id" select="$rt_id"/>
                        <xsl:with-param name="sorted_properties" select="$sorted_properties"/>
                    </xsl:call-template>
                    <xsl:call-template name="create_ordering">
                        <xsl:with-param name="institution" select="$institution"/>
                        <xsl:with-param name="resource" select="$resource"/>
                        <xsl:with-param name="format" select="$format"/>
                        <xsl:with-param name="user" select="$user"/>
                        <xsl:with-param name="sorted_property" select="$sorted_properties"/>
                    </xsl:call-template>
                </rdf:RDF>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
