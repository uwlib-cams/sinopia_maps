<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    xmlns:bmrxml="https://briesenberg07.github.io/xml_stack/" 
    exclude-result-prefixes="xs"
    version="3.0">
    
    <xsl:include href="reuse.xsl"/>

    <!-- *****metadata for the RT is output from this template***** -->
    <xsl:template name="rt_metadata">
        <xsl:param name="resource"/>
        <xsl:param name="suppressible"/>
        <xsl:param name="optional_classes"/>
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
                <xsl:value-of select="uwsinopia:author"/>
            </sinopia:hasAuthor>
            <sinopia:hasDate>
                <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
            </sinopia:hasDate>
            <!-- output resource attribute = suppressible if present -->
            <!-- TO DO: should not be able to output suppressible RT if more than one prop has been marked for inclusion -->
            <!-- [!] CAUTION [!] Sinopia RTs which are suppressible may not have any more than one PT -->
            <xsl:if test="matches($suppressible, 'true|1')">
                <sinopia:hasResourceAttribute
                    rdf:resource="http://sinopia.io/vocabulary/resourceAttribute/suppressible"/>
            </xsl:if>
            <!-- output optional resource classes if present -->
            <xsl:if test="$optional_classes/node()">
                <xsl:for-each select="$optional_classes/optional_class">
                    <sinopia:hasOptionalClass rdf:resource="{.}"/>
                </xsl:for-each>
            </xsl:if>
            <!-- [!] TO DO use of rda_iri_slug is RDA-Registry-specific, need other choices in future -->
            <sinopia:hasPropertyTemplate rdf:nodeID="{
                concat(bmrxml:rda_iri_slug($sorted_properties[position() = 1]/uwmaps:prop_iri/@iri),
                '_order')}"/>
        </rdf:Description>
    </xsl:template>

    <xsl:template name="rt_hasClass">
        <xsl:param name="resource"/>
        <!-- these choices == schema definition for xs:simpleType mapid_resource_attr -->
        <xsl:choose>
            <xsl:when test="$resource = 'rdaWork'">
                <sinopia:hasClass rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
            </xsl:when>
            <xsl:when test="$resource = 'rdaAgent'">
                <sinopia:hasClass rdf:resource="http://rdaregistry.info/Elements/c/C10002"/>
            </xsl:when>
            <xsl:when test="$resource = 'rdaItem'">
                <sinopia:hasClass rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
            </xsl:when>
            <xsl:when test="$resource = 'rdaPerson'">
                <sinopia:hasClass rdf:resource="http://rdaregistry.info/Elements/c/C10004"/>
            </xsl:when>
            <xsl:when test="$resource = 'rdaCorporateBody'">
                <sinopia:hasClass rdf:resource="http://rdaregistry.info/Elements/c/C10005"/>
            </xsl:when>
            <xsl:when test="$resource = 'rdaExpression'">
                <sinopia:hasClass rdf:resource="http://rdaregistry.info/Elements/c/C10006"/>
            </xsl:when>
            <xsl:when test="$resource = 'rdaManifestation'">
                <sinopia:hasClass rdf:resource="http://rdaregistry.info/Elements/c/C10007"/>
            </xsl:when>
            <xsl:when test="$resource = 'rdaFamily'">
                <sinopia:hasClass rdf:resource="http://rdaregistry.info/Elements/c/C10008"/>
            </xsl:when>
            <xsl:when test="$resource = 'rdaPlace'">
                <sinopia:hasClass rdf:resource="http://rdaregistry.info/Elements/c/C10009"/>
            </xsl:when>
            <xsl:when test="$resource = 'rdaTimespan'">
                <sinopia:hasClass rdf:resource="http://rdaregistry.info/Elements/c/C10010"/>
            </xsl:when>
            <xsl:when test="$resource = 'rdaCollectiveAgent'">
                <sinopia:hasClass rdf:resource="http://rdaregistry.info/Elements/c/C10011"/>
            </xsl:when>
            <xsl:when test="$resource = 'rdaNomen'">
                <sinopia:hasClass rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
            </xsl:when>
            <xsl:when test="$resource = 'rdaEntity'">
                <sinopia:hasClass rdf:resource="http://rdaregistry.info/Elements/c/C10013"/>
            </xsl:when>
            <!-- to do update for additional resource types for description -->
            <!-- (some kind of admin metadata resource, etc... -->
            <!-- No sinopia:hasClass triple in RT may result in error and prevent loading? -->
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
