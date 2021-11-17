<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:mapstor="https://uwlib-cams.github.io/map_storage/"
    xmlns:bmrxml="https://briesenberg07.github.io/xml_stack/"
    exclude-result-prefixes="xs"
    version="3.0">
    
    <!-- function(s) -->
    <!-- there must be a better way to reuse a function than copying and renaming here -->
    <xsl:function name="bmrxml:rda_iri_slug_02">
        <xsl:param name="path_to_iri"/>
        <xsl:value-of select="translate(substring-after($path_to_iri, 'Elements/'), '/', '_')"/>
    </xsl:function>
        
    <xsl:template name="rtHasClass">
        <xsl:param name="resource"/>
        <!-- Take choices here from schema definition for xs:simpleType mapid_resource_attr -->
        <xsl:choose>
            <xsl:when test="$resource = 'rdacWork'">
                <sinopia:hasClass rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
            </xsl:when>
            <xsl:when test="$resource = 'rdacExpression'">
                <sinopia:hasClass rdf:resource="http://rdaregistry.info/Elements/c/C10006"/>
            </xsl:when>
            <xsl:when test="$resource = 'rdacManifestation'">
                <sinopia:hasClass rdf:resource="http://rdaregistry.info/Elements/c/C10007"/>
            </xsl:when>
            <!-- No sin:hasClass triple in RT may result in error (prevent loading) -->
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    
    <!-- rough draft but looks good so far yay -->
    <xsl:template name="property_templates">
        <xsl:param name="sorted_property"/>
        <xsl:for-each select="$sorted_property">
            <xsl:variable name="current_position" select="position()"/>
            <rdf:Description rdf:nodeID="{concat(bmrxml:rda_iri_slug_02(mapstor:prop_iri/@iri),
                '_order')}">
                <rdf:first rdf:nodeID="{concat(bmrxml:rda_iri_slug_02(mapstor:prop_iri/@iri),
                    '_define')}"/>
                <xsl:choose>
                    <xsl:when test="position() != last()">
                        <rdf:rest rdf:nodeID="{concat(bmrxml:rda_iri_slug_02($sorted_property[position() = $current_position + 1]/mapstor:prop_iri/@iri),
                            '_order')}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdf:rest rdf:resource="http://www.w3.org/1999/02/22-rdf-syntax-ns#nil"/>
                    </xsl:otherwise>
                </xsl:choose>
            </rdf:Description>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>