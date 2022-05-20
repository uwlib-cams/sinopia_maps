<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    exclude-result-prefixes="xs"
    version="3.0">
    
    <xsl:include href="001_04_define_all_pts.xsl"/>

    <!-- *****create ordering bnodes***** -->
    <xsl:template name="create_ordering">
        <!-- add institution -->
        <xsl:param name="resource"/>
        <xsl:param name="format"/>
        <xsl:param name="user"/>
        <xsl:param name="sorted_property"/>
        <!-- create the 'ordering' bnode for each PT -->
        <xsl:for-each select="$sorted_property">
            <xsl:variable name="current_position" select="position()"/>
            <!-- create bnode to order PTs with first, rest -->
            <rdf:Description rdf:nodeID="{concat(uwmaps:prop_iri/@iri => 
                translate('/.#', '') => substring-after('http:'), '_order')}">
                <rdf:first rdf:nodeID="{concat(uwmaps:prop_iri/@iri => 
                    translate('/.#', '') => substring-after('http:'), '_define')}"/>
                <xsl:choose>
                    <xsl:when test="position() != last()">
                        <rdf:rest rdf:nodeID="{concat($sorted_property[position() = $current_position + 1]/uwmaps:prop_iri/@iri => 
                            translate('/.#', '') => substring-after('http:'), '_order')}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdf:rest rdf:resource="http://www.w3.org/1999/02/22-rdf-syntax-ns#nil"/>
                    </xsl:otherwise>
                </xsl:choose>
            </rdf:Description>
            <xsl:call-template name="define_all_pts">
                <!-- add institution -->
                <xsl:with-param name="resource" select="$resource"/>
                <xsl:with-param name="format" select="$format"/>
                <xsl:with-param name="user" select="$user"/>
                <xsl:with-param name="prop" select="."/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
