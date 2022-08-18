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
    
    <!-- var: authority config data as xml -->
    <xsl:variable name="authorities_xml" select="fn:json-to-xml(document('../xml/authorityConfig.xml')/data)"/>
    
    <!-- output uri or lookup > lookup PT attributes -->
    <xsl:template name="define_lookup_pts">
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
                        '_lookup_attributes')"></xsl:copy-of>
                </xsl:when>
                <xsl:when test="substring-before($prop/uwmaps:prop_iri/@iri, '//') = 'http:'">
                    <xsl:copy-of select="concat($prop/uwmaps:prop_iri/@iri => 
                        translate('/.#', '') => substring-after('http:'),
                        '_lookup_attributes')"></xsl:copy-of>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <rdf:Description
            rdf:nodeID="{$node_ID}">
            <!-- hard-code rdf:type for this node sinopia:LookupPropertyTemplate-->
            <rdf:type rdf:resource="http://sinopia.io/vocabulary/LookupPropertyTemplate"/>
            <!-- TO DO BELOW -->
            <xsl:for-each select="
                $prop/uwmaps:sinopia/uwsinopia:implementation_set
                [uwsinopia:institution = $institution]
                [uwsinopia:resource = $resource]
                [uwsinopia:format = $format]
                [uwsinopia:user = $user]
                /uwsinopia:lookup_pt/uwsinopia:authorities/uwsinopia:authority_urn">
                <xsl:variable name="label" select="."/>
                <sinopia:hasAuthority rdf:resource="{$authorities_xml/fn:array/fn:map[fn:string[@key = 'label'] = $label]/fn:string[@key = 'uri']}"/>
            </xsl:for-each>
            <!-- output default IRI value if applicable -->
            <xsl:if test="$prop/uwmaps:sinopia/uwsinopia:implementation_set
                [uwsinopia:institution = $institution]
                [uwsinopia:resource = $resource]
                [uwsinopia:format = $format]
                [uwsinopia:user = $user]
                /uwsinopia:lookup_pt/uwsinopia:lookup_default_iri/@iri">
                <sinopia:hasDefault rdf:resource="{$prop/uwmaps:sinopia/uwsinopia:implementation_set
                    [uwsinopia:institution = $institution]
                    [uwsinopia:resource = $resource]
                    [uwsinopia:format = $format]
                    [uwsinopia:user = $user]
                    /uwsinopia:lookup_pt/uwsinopia:lookup_default_iri/@iri}"/>
            </xsl:if>
        </rdf:Description>
        <!-- output label for default IRI value if applicable -->
        <xsl:if test="$prop/uwmaps:sinopia/uwsinopia:implementation_set
            [uwsinopia:institution = $institution]
            [uwsinopia:resource = $resource]
            [uwsinopia:format = $format]
            [uwsinopia:user = $user]
            /uwsinopia:lookup_pt/uwsinopia:lookup_default_iri_label">
            <rdf:Description rdf:about="{$prop/uwmaps:sinopia/uwsinopia:implementation_set
                [uwsinopia:institution = $institution]
                [uwsinopia:resource = $resource]
                [uwsinopia:format = $format]
                [uwsinopia:user = $user]
                /uwsinopia:lookup_pt/uwsinopia:lookup_default_iri/@iri}">
                <rdfs:label xml:lang="{$prop/uwmaps:sinopia/uwsinopia:implementation_set
                    [uwsinopia:institution = $institution]
                    [uwsinopia:resource = $resource]
                    [uwsinopia:format = $format]
                    [uwsinopia:user = $user]
                    /uwsinopia:lookup_pt/uwsinopia:lookup_default_iri_label/@xml:lang}">
                    <xsl:value-of select="$prop/uwmaps:sinopia/uwsinopia:implementation_set
                        [uwsinopia:institution = $institution]
                        [uwsinopia:resource = $resource]
                        [uwsinopia:format = $format]
                        [uwsinopia:user = $user]
                        /uwsinopia:lookup_pt/uwsinopia:lookup_default_iri_label"/>
                </rdfs:label>
            </rdf:Description>
        </xsl:if>
        <!-- map_storage doesn't allow for assigning labels to authority URNs, so no URN label output -->
    </xsl:template>
    
</xsl:stylesheet>