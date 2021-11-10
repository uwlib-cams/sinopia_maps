<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:mapstor="https://uwlib-cams.github.io/map_storage/"
    exclude-result-prefixes="xs"
    version="3.0">
        
    <xsl:template name="rtHasClass">
        <xsl:param name="resource"/>
        <!-- Take choices here from schema definition for xs:simpleType mapid_resource_attr -->
        <xsl:choose>
            <xsl:when test="$resource = 'rda_Work'">
                <sinopia:hasClass rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
            </xsl:when>
            <xsl:when test="$resource = 'rda_Expression'">
                <sinopia:hasClass rdf:resource="http://rdaregistry.info/Elements/c/C10006"/>
            </xsl:when>
            <xsl:when test="$resource = 'rda_Manifestation'">
                <sinopia:hasClass rdf:resource="http://rdaregistry.info/Elements/c/C10007"/>
            </xsl:when>
            <!-- No sin:hasClass triple in RT may result in error (prevent loading) -->
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>