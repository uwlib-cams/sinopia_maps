<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:sin="http://sinopia.io/vocabulary/"
    xmlns:mapstor="https://uwlib-cams.github.io/map_storage/"
    exclude-result-prefixes="xs"
    version="3.0">
        
    <xsl:template name="rtHasClass">
        <xsl:param name="mapid_resource"/>
        <!-- Take choices here from schema definition for xs:simpleType mapid_resource_attr -->
        <xsl:choose>
            <xsl:when test="$mapid_resource = 'Work'">
                <sin:hasClass rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
            </xsl:when>
            <xsl:when test="$mapid_resource = 'Expression'">
                <sin:hasClass rdf:resource="http://rdaregistry.info/Elements/c/C10006"/>
            </xsl:when>
            <xsl:when test="$mapid_resource = 'Manifestation'">
                <sin:hasClass rdf:resource="http://rdaregistry.info/Elements/c/C10007"/>
            </xsl:when>
            <!-- No sin:hasClass triple in RT may result in error (prevent loading) -->
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="rtHasAuthor">
        <xsl:param name="mapid_user"/>
        <!-- Take choices here from schema definition for xs:simpleType mapid_user_attr
            Attribute default RTs to ...someone [need to decide who]
            Attribute custom user RTs to that user -->
        <xsl:choose>
            <xsl:when test="$mapid_user = 'default'">
                <!-- BMR: Are we supposed to use email addresses as sinopia:hasAuthor values? 
                    I forgot about this -->
                <sin:hasAuthor>  
                    <xsl:text>ries07@uw.edu</xsl:text>
                </sin:hasAuthor>
            </xsl:when>
            <xsl:when test="$mapid_user = 'ries07'">
                <sin:hasAuthor>  
                    <xsl:text>ries07@uw.edu</xsl:text>
                </sin:hasAuthor>
            </xsl:when>
            <xsl:when test="$mapid_user = 'mcm104'">
                <sin:hasAuthor>  
                    <xsl:text>mcm104@uw.edu</xsl:text>
                </sin:hasAuthor>
            </xsl:when>
            <!-- No sin:hasAuthor triple in RT may result in error (prevent loading) -->
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="ptHasAttributes">
        <xsl:param name="sinopia_prop_attributes"/>
        <xsl:if test="$sinopia_prop_attributes/mapstor:required/@value='true'">
            <sin:hasPropertyAttribute rdf:resource="http://sinopia.io/vocabulary/propertyAttribute/required"/>
        </xsl:if>
        <xsl:if test="$sinopia_prop_attributes/mapstor:repeatable/@value='true'">
            <sin:hasPropertyAttribute rdf:resource="http://sinopia.io/vocabulary/propertyAttribute/repeatable"/>
        </xsl:if>
        <xsl:if test="$sinopia_prop_attributes/mapstor:ordered/@value='true'">
            <sin:hasPropertyAttribute rdf:resource="http://sinopia.io/vocabulary/propertyAttribute/ordered"/>
        </xsl:if>
    </xsl:template>
    
    <!-- BMR: Below were used previously but are not currently in use -->
    
    <xsl:template name="classLabel">
        <xsl:param name="resource"/>
        <!-- Take choices here from schema definition for xs:simpleType mapid_resource_attr -->
        <xsl:choose>
            <xsl:when test="$resource = 'Work'">
                <rdf:Description rdf:about="http://rdaregistry.info/Elements/c/C10001">
                    <rdfs:label>work</rdfs:label>
                </rdf:Description>
            </xsl:when>
            <xsl:when test="$resource = 'Expression'">
                <rdf:Description rdf:about="http://rdaregistry.info/Elements/c/C10006">
                    <rdfs:label>work</rdfs:label>
                </rdf:Description>
            </xsl:when>
            <xsl:when test="$resource = 'Manifestation'">
                <rdf:Description rdf:about="http://rdaregistry.info/Elements/c/C10007">
                    <rdfs:label>work</rdfs:label>
                </rdf:Description>
            </xsl:when>
            <!-- Will lack of an rdfs:label triple for the resource class corresponding to the RT result in an error (prevent loading)? -->
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="propLabel">
        <xsl:param name="iri"/>
        <xsl:param name="label"/>
    <rdf:Description rdf:about="{$iri}">
        <rdfs:label>
            <xsl:value-of select="$label"/>
        </rdfs:label>
    </rdf:Description>
    </xsl:template>
</xsl:stylesheet>