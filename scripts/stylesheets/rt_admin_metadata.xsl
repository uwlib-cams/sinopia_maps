<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:maps="https://uwlib-cams.github.io/map_storage/"
    xmlns:uwlsinopia="https://uwlib-cams.github.io/sinopia_maps/"
    xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:bmrxml="https://briesenberg07.github.io/xml_stack/" 
    exclude-result-prefixes="xs"
    version="3.0">
    
    <!-- there must be a better way to reuse a function than copying and renaming in included stylesheet? -->
    <xsl:function name="bmrxml:rda_iri_slug">
        <xsl:param name="path_to_iri"/>
        <xsl:value-of select="translate(substring-after($path_to_iri, 'Elements/'), '/', '_')"/>
    </xsl:function>
    
    <!-- *****admin metadata for the RT is output from this template***** -->
    <xsl:template name="rt_admin_metadata">
        <xsl:param name="propSet"/>
        <xsl:param name="resource"/>
        <xsl:param name="suppressible"/>
        <xsl:param name="format"/>
        <xsl:param name="user"/>
        <xsl:param name="rt_id"/>
        <xsl:param name="sorted_properties"/>
        <rdf:Description
            rdf:about="{concat('https://api.development.sinopia.io/resource/', $rt_id)}">
            <!-- to do output remark in RT description -->
            <rdf:type rdf:resource="http://sinopia.io/vocabulary/ResourceTemplate"/>
            <sinopia:hasResourceTemplate>sinopia:template:resource</sinopia:hasResourceTemplate>
            <xsl:call-template name="rt_hasClass">
                <xsl:with-param name="resource" select="$resource"/>
            </xsl:call-template>
            <sinopia:hasResourceId>
                <xsl:value-of select="$rt_id"/>
            </sinopia:hasResourceId>
            <rdfs:label>
                <!-- colons for RT ID, underscores for RT filename, spaces for RT label -->
                <xsl:value-of select="translate($rt_id, ':', ' ')"/>
            </rdfs:label>
            <sinopia:hasAuthor>
                <xsl:value-of select="uwlsinopia:author"/>
            </sinopia:hasAuthor>
            <sinopia:hasDate>
                <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
            </sinopia:hasDate>
            <xsl:if test="$suppressible = 'true'">
                <sinopia:hasResourceAttribute rdf:resource="http://sinopia.io/vocabulary/resourceAttribute/suppressible"/>
            </xsl:if>
            <!-- [!] use of rda_iri_slug is RDA-Registry-specific -->
            <sinopia:hasPropertyTemplate rdf:nodeID="{
                concat(bmrxml:rda_iri_slug($sorted_properties[position() = 1]/maps:prop_iri/@iri),
                '_order')}"/>
        </rdf:Description>
    </xsl:template>
    
    <xsl:template name="rt_hasClass">
        <xsl:param name="resource"/>
        <!-- these choices == schema definition for xs:simpleType mapid_resource_attr -->
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
            <!-- No sinopia:hasClass triple in RT may result in error and prevent loading? -->
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>