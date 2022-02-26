<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:maps="https://uwlib-cams.github.io/map_storage/"
    xmlns:bmrxml="https://briesenberg07.github.io/xml_stack/"
    exclude-result-prefixes="xs"
    version="3.0">
    
    <xsl:template name="multiple_property_iris">
        <xsl:param name="prop"/>
        <!-- determine whether the prop is RDA or some other -->
        <!-- start by getting the prop iri and label for the prop element -->
        <!-- then get either all subprops, or get selected iris and labels -->
        <xsl:choose>
            <!-- for RDA PTs -->
            <xsl:when test="starts-with($prop/maps:prop_iri/@iri, 'http://rdaregistry.info')">
                <xsl:choose>
                    <xsl:when test="$prop/maps:sinopia/maps:implementation_set"></xsl:when>
                </xsl:choose>
            </xsl:when>
            <!-- for other-ontology PTs (TO DO) -->
            <xsl:otherwise>
                <xsl:text>ERROR: MULTIPLE-PROPERTY FUNCTIONALITY CANNOT YET HANDLE NON-RDA ONTOLOGIES</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>