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
        <xsl:param name="institution"/>
        <xsl:param name="resource"/>
        <xsl:param name="format"/>
        <xsl:param name="user"/>
        <xsl:param name="sorted_property"/>
        <!-- create the 'ordering' bnode for each PT -->
        <xsl:for-each select="$sorted_property">
            <xsl:variable name="current_position" select="position()"/>
            <xsl:variable name="order_node_ID" as="xs:string">
                <xsl:choose>
                    <xsl:when test="substring-before(uwmaps:prop_iri/@iri, '//') = 'https:'">
                        <xsl:copy-of select="concat(uwmaps:prop_iri/@iri => 
                            translate('/.#', '') => substring-after('https:'), '_order')"></xsl:copy-of>
                    </xsl:when>
                    <xsl:when test="substring-before(uwmaps:prop_iri/@iri, '//') = 'http:'">
                        <xsl:copy-of select="concat(uwmaps:prop_iri/@iri => 
                            translate('/.#', '') => substring-after('http:'), '_order')"></xsl:copy-of>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="first_node_ID" as="xs:string">
                <xsl:choose>
                    <xsl:when test="substring-before(uwmaps:prop_iri/@iri, '//') = 'https:'">
                        <xsl:copy-of select="concat(uwmaps:prop_iri/@iri => 
                            translate('/.#', '') => substring-after('https:'), '_define')"></xsl:copy-of>
                    </xsl:when>
                    <xsl:when test="substring-before(uwmaps:prop_iri/@iri, '//') = 'http:'">
                        <xsl:copy-of select="concat(uwmaps:prop_iri/@iri => 
                            translate('/.#', '') => substring-after('http:'), '_define')"></xsl:copy-of>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <!-- create bnode to order PTs with first, rest -->
            <rdf:Description rdf:nodeID="{$order_node_ID}">
                <rdf:first rdf:nodeID="{$first_node_ID}"/>
                <xsl:choose>
                    <xsl:when test="position() != last()">
                        <xsl:variable name="rest_node_ID" as="xs:string">
                            <xsl:choose>
                                <xsl:when test="substring-before($sorted_property[position() = $current_position + 1]/uwmaps:prop_iri/@iri, '//') = 'https:'">
                                    <xsl:copy-of select="concat($sorted_property[position() = $current_position + 1]/uwmaps:prop_iri/@iri => 
                                        translate('/.#', '') => substring-after('https:'), '_order')"></xsl:copy-of>
                                </xsl:when>
                                <xsl:when test="substring-before($sorted_property[position() = $current_position + 1]/uwmaps:prop_iri/@iri, '//') = 'http:'">
                                    <xsl:copy-of select="concat($sorted_property[position() = $current_position + 1]/uwmaps:prop_iri/@iri => 
                                        translate('/.#', '') => substring-after('http:'), '_order')"></xsl:copy-of>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        <rdf:rest rdf:nodeID="{$rest_node_ID}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdf:rest rdf:resource="http://www.w3.org/1999/02/22-rdf-syntax-ns#nil"/>
                    </xsl:otherwise>
                </xsl:choose>
            </rdf:Description>
            <xsl:call-template name="define_all_pts">
                <xsl:with-param name="institution" select="$institution"/>
                <xsl:with-param name="resource" select="$resource"/>
                <xsl:with-param name="format" select="$format"/>
                <xsl:with-param name="user" select="$user"/>
                <xsl:with-param name="prop" select="."/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
