<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template name="add_comments" match="//rdf:Description">
        <xsl:param name="nodeID"/>
        <xsl:apply-templates select="/rdf:RDF/rdf:Description//comment()">
            <xsl:with-param name="nodeID" select="$nodeID"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="/rdf:RDF/rdf:Description//comment()">
        <xsl:param name="nodeID"/>
        <xsl:if test="../@rdf:nodeID = $nodeID">
            <xsl:variable name="prop_URI" select="."/>
            <xsl:variable name="entity">
                <xsl:variable name="remove_prop_ID" select="substring-before($prop_URI, '/P')"/>
                <xsl:value-of select="substring-after($remove_prop_ID, 'http://rdaregistry.info/Elements/')"/>
            </xsl:variable>
            <xsl:variable name="rdaRegistry_xml" 
                select="concat('http://www.rdaregistry.info/xml/Elements/', $entity, '.xml')"/>
            <xsl:variable name="prop_label" 
                select="document($rdaRegistry_xml)/rdf:RDF/rdf:Description[@rdf:about=$prop_URI]/rdfs:label[@xml:lang='en']"/>
            <xsl:variable name="seeProp">
                <!-- TO DO
                    remove processing for datatype + object properties -->
                <xsl:choose>
                    <xsl:when test="/rdf:RDF/rdf:Description[sinopia:hasPropertyUri/@rdf:resource = $prop_URI]/rdfs:label">
                        <xsl:value-of select="/rdf:RDF/rdf:Description[sinopia:hasPropertyUri/@rdf:resource = $prop_URI]/rdfs:label"/>
                    </xsl:when>
                    <xsl:when test="/rdf:RDF/rdf:Description[sinopia:hasPropertyUri/@rdf:resource = replace($prop_URI, 'object/', '')]/rdfs:label">
                        <xsl:value-of select="/rdf:RDF/rdf:Description[sinopia:hasPropertyUri/@rdf:resource = replace($prop_URI, 'object/', '')]/rdfs:label"/>
                    </xsl:when>
                    <xsl:when test="/rdf:RDF/rdf:Description[sinopia:hasPropertyUri/@rdf:resource = replace($prop_URI, 'datatype/', '')]/rdfs:label">
                        <xsl:value-of select="/rdf:RDF/rdf:Description[sinopia:hasPropertyUri/@rdf:resource = replace($prop_URI, 'datatype/', '')]/rdfs:label"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <!-- TO DO
            implement localid_implementation_set as id -->
            <xsl:variable name="seeProp_id" select="replace($seeProp, ' ', '')"/>
            <li>
                <i>For "<xsl:value-of select="$prop_label"/>", see "<a href="#{$seeProp_id}">
                    <xsl:value-of select="$seeProp"/></a>".</i>
            </li>
        </xsl:if>
    </xsl:template>
   
</xsl:stylesheet>