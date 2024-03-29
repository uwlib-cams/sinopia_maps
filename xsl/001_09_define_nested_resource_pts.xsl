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
    
    <!-- output nested resource PT attributes -->
    <xsl:template name="define_nested_resource_pts">
        <xsl:param name="institution"/>
        <xsl:param name="resource"/>
        <xsl:param name="format"/>
        <xsl:param name="user"/>
        <xsl:param name="prop"/>
        <xsl:variable name="node_ID" as="xs:string">
            <xsl:choose>
                <xsl:when test="substring-before($prop/uwmaps:prop_iri/@iri, '//') = 'https:'">
                    <xsl:copy-of select="concat($prop/uwmaps:prop_iri/@iri => 
                        translate('/.#', '') => substring-after('https:'),
                        '_resource_attributes')"/>
                </xsl:when>
                <xsl:when test="substring-before($prop/uwmaps:prop_iri/@iri, '//') = 'http:'">
                    <xsl:copy-of select="concat($prop/uwmaps:prop_iri/@iri => 
                        translate('/.#', '') => substring-after('http:'),
                        '_resource_attributes')"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <rdf:Description
            rdf:nodeID="{$node_ID}">
            <!-- hard-code rdf:type for this node sinopia:ResourcePropertyTemplate -->
            <rdf:type rdf:resource="http://sinopia.io/vocabulary/ResourcePropertyTemplate"/>
            <xsl:for-each select="
                $prop/uwmaps:sinopia/uwsinopia:implementation_set
                [uwsinopia:institution = $institution]
                [uwsinopia:resource = $resource]
                [uwsinopia:format = $format]
                [uwsinopia:user = $user]
                /uwsinopia:nested_resource_pt/uwsinopia:rt_id">
                <sinopia:hasResourceTemplateId rdf:resource="{.}"/>
            </xsl:for-each>
        </rdf:Description>
    </xsl:template>
    
</xsl:stylesheet>