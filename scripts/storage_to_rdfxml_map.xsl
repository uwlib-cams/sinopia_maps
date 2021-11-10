<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mapstor="https://uwlib-cams.github.io/map_storage/"
    xmlns:uwlsinopia="https://uwlib-cams.github.io/uwl_sinopia_maps/"
    xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    exclude-result-prefixes="xs" version="3.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:include href="storage_to_rdfxml_map_templates.xsl"/>

    <xsl:template match="/">
        <!-- to do change href to output for production -->
        <xsl:for-each select="document('../uwl_sinopia_maps.xml')/uwlsinopia:maps/uwlsinopia:rt">
            <xsl:call-template name="start_rdf_map">
                <!-- to do: propSet param will not work as is for using multiple prop sets -->
                <xsl:with-param name="propSet" select="uwlsinopia:propSet"/>
                <xsl:with-param name="resource" select="uwlsinopia:resource"/>
                <xsl:with-param name="format" select="uwlsinopia:format"/>
                <xsl:with-param name="user" select="uwlsinopia:user"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="start_rdf_map">
        <!-- params -->
        <xsl:param name="propSet"/>
        <xsl:param name="resource"/>
        <xsl:param name="format"/>
        <xsl:param name="user"/>
        <!-- to do remove 'TEST' in rt_id to output for production -->
        <xsl:param name="rt_id" select="concat('TEST:WAU:', $resource, ':', $format, ':', $user)"/>

        <xsl:result-document href="../tests/{translate($rt_id, ':', '_')}.rdf">
            <rdf:RDF>
                <rdf:Description
                    rdf:about="{concat('https://api.development.sinopia.io/resource/', $rt_id)}">
                    <rdf:type rdf:resource="http://sinopia.io/vocabulary/ResourceTemplate"/>
                    <sinopia:hasResourceTemplate>sinopia:template:resource</sinopia:hasResourceTemplate>
                    <sinopia:hasResourceId>
                        <xsl:value-of select="$rt_id"/>
                    </sinopia:hasResourceId>
                    <xsl:call-template name="rtHasClass">
                        <xsl:with-param name="resource" select="$resource"/>
                    </xsl:call-template>
                    <rdfs:label>
                        <xsl:value-of select="translate($rt_id, ':', '_')"/>
                    </rdfs:label>
                    <sinopia:hasAuthor>
                        <xsl:value-of select="uwlsinopia:author"/>
                    </sinopia:hasAuthor>
                    <sinopia:hasDate>
                        <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
                    </sinopia:hasDate>
                    <!-- pick up here -->
                    <sinopia:hasPropertyTemplate/>
                </rdf:Description>
            </rdf:RDF>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
