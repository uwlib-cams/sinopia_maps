<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mapstor="https://uwlib-cams.github.io/map_storage/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:sin="http://sinopia.io/vocabulary/"
    exclude-result-prefixes="xs mapstor" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="/">
        <!-- WAU:RT:RDA:Work:monograph:default -->
        <xsl:variable name="mapid_institution" select="'WAU'"/>
        <xsl:variable name="mapid_resource" select="'Work'"/>
        <xsl:variable name="mapid_format" select="'monograph'"/>
        <xsl:variable name="mapid_user" select="'default'"/>
        <!-- **NOTE: file path for output here** -->
        <xsl:result-document href="../../uwl_sinopia_maps/tests/fromTestXslt001_{format-date(current-date(), '[Y0001]-[M01]-[D01]')}_{$mapid_institution}_RT_{$mapid_resource}_{$mapid_format}_{$mapid_user}.rdf">
            <xsl:call-template name="create_RT">
                <xsl:with-param name="mapid_institution" select="$mapid_institution"/>
                <xsl:with-param name="mapid_resource" select="$mapid_resource"/>
                <xsl:with-param name="mapid_format" select="$mapid_format"/>
                <xsl:with-param name="mapid_user" select="$mapid_user"/>
            </xsl:call-template>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template name="create_RT">
        <xsl:param name="mapid_institution"/>
        <xsl:param name="mapid_resource"/>
        <xsl:param name="mapid_format"/>
        <xsl:param name="mapid_user"/>
        <xsl:variable name="resourceID"
            select="concat('TEST:', $mapid_institution, ':RT:', $mapid_resource, ':', $mapid_format, ':', $mapid_user)"/>
        <rdf:RDF>
            <!-- Resource template -->
            <rdf:Description rdf:about="https://api.stage.sinopia.io/resource/{$resourceID}">
                <sin:hasResourceTemplate>
                    <xsl:text>sinopia:template:resource</xsl:text>
                </sin:hasResourceTemplate>
                <rdf:type rdf:resource="http://sinopia.io/vocabulary/ResourceTemplate"/>
                <sin:hasResourceId>
                    <xsl:value-of select="$resourceID"/>
                </sin:hasResourceId>
                <sin:hasClass rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
                <rdfs:label>
                    <xsl:value-of
                        select="
                        concat('TEST ', format-date(current-date(), '[Y0001]-[M01]-[D01]'), $mapid_institution, ' RT ', $mapid_resource, ' ', $mapid_format, ' ', $mapid_user)"
                    />
                </rdfs:label>
                <sin:hasAuthor>
                    <xsl:text>mcm104@uw.edu</xsl:text>
                </sin:hasAuthor>
                <sin:hasDate>
                    <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
                </sin:hasDate>
                
                <!-- Output first ordering bnode for properties here -->
                <xsl:for-each select="//mapstor:prop
                    [mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/mapstor:resource[@mapid_resource = $mapid_resource]/
                    mapstor:format[@mapid_format = $mapid_format][mapstor:user/@mapid_user = $mapid_user]]">
                    <xsl:sort select="
                        mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/mapstor:resource[@mapid_resource=$mapid_resource]
                        [mapstor:user/@mapid_user = $mapid_user]/mapstor:form_order[@value]"/>
                    <xsl:if test="position() = 1">
                        <xsl:call-template name="start_PT_list">
                            <xsl:with-param name="prop_node_id" select="concat(substring-after(@localid_prop, '/'), '_order')"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:for-each>
                
            </rdf:Description>
            
            <!-- BMR: A triple I'm not sure about -->
            <rdf:Description rdf:about="http://rdaregistry.info/Elements/c/C10001">
                <rdfs:label>work</rdfs:label>
            </rdf:Description>
            
            <!-- Nodes for properties -->
            <!-- BMR: Did I screw up the XPaths in the for-each here and above? We should be matching on something, but no props are output -->
            <xsl:for-each select="//mapstor:prop
                [mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/mapstor:resource[@mapid_resource = $mapid_resource]/
                mapstor:format[@mapid_format = $mapid_format][mapstor:user/@mapid_user = $mapid_user]]">
                <xsl:sort select="
                    mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/mapstor:resource[@mapid_resource=$mapid_resource]
                    [mapstor:user/@mapid_user = $mapid_user]/mapstor:form_order[@value]"/>
               
                <!-- List nodes -->
                <rdf:Description rdf:nodeID="{concat(substring-after(@localid_prop, '/'), '_order')}">
                    <rdf:first rdf:nodeID="{substring-after(@localid_prop, '/')}"/>
                    <xsl:choose>
                        <!-- BMR: Still unsure on XPaths for xsl:when > test, rdf:rest > rdf:nodeID -->
                        <xsl:when test="following-sibling::mapstor:prop[mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/mapstor:resource
                            [@mapid_resource = $mapid_resource][mapstor:format/@mapid_format = $mapid_format][mapstor:user/@mapid_user = $mapid_user]]">
                            <rdf:rest rdf:nodeID="{concat(substring-after(following-sibling::mapstor:prop[1]/@localid_prop, '/'), '_order')}"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdf:rest rdf:resource="http://www.w3.org/1999/02/22-rdf-syntax-ns#nil"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdf:Description>
                
                <!-- BMR: Another triple I'm unsure about; why is prop label needed outside of PT information? -->
                <rdf:Description rdf:about="{mapstor:prop_iri/@iri}">
                    <rdfs:label>
                        <xsl:value-of select="mapstor:prop_label"/>
                    </rdfs:label>
                </rdf:Description>
                
                <!-- Property templates -->
                <rdf:Description rdf:nodeID="{substring-after(@localid_prop, '/')}">
                    <rdf:type rdf:resource="http://sinopia.io/vocabulary/PropertyTemplate"/>
                    <rdfs:label xml:lang="{mapstor:prop_label/@xml:lang}">
                        <xsl:value-of select="mapstor:prop_label"/>
                    </rdfs:label>
                    <sin:hasPropertyUri rdf:resource="{mapstor:prop_iri/@iri}"/>
                    <xsl:variable name="implementationSet" select="mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/mapstor:resource[@mapid_resource = $mapid_resource][mapstor:user/@mapid_user = $mapid_user]"/>
                    <xsl:if test="$implementationSet/mapstor:sinopia_prop_attributes/mapstor:required/@value='true'">
                        <sin:hasPropertyAttribute rdf:resource="http://sinopia.io/vocabulary/propertyAttribute/required"/>
                    </xsl:if>
                    <xsl:if test="$implementationSet/mapstor:sinopia_prop_attributes/mapstor:repeatable/@value='true'">
                        <sin:hasPropertyAttribute rdf:resource="http://sinopia.io/vocabulary/propertyAttribute/repeatable"/>
                    </xsl:if>
                    <xsl:if test="$implementationSet/mapstor:sinopia_prop_attributes/mapstor:ordered/@value='true'">
                        <sin:hasPropertyAttribute rdf:resource="http://sinopia.io/vocabulary/propertyAttribute/ordered"/>
                    </xsl:if>
                    <xsl:if test="$implementationSet/mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type_attributes/mapstor:literal_attributes">
                        <sin:hasLiteralAttributes rdf:nodeID="{concat(substring-after(@localid_prop, '/'), '_literalAttributes')}"/>
                    </xsl:if>
                    <xsl:variable name="prop_type" select="$implementationSet/mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type[@value]"/>
                    <xsl:choose>
                        <xsl:when test="$prop_type='literal'">
                            <sin:hasPropertyType rdf:resource="http://sinopia.io/vocabulary/propertyType/literal"/>
                        </xsl:when>
                        <xsl:when test="$prop_type='nested_resource'">
                            <sin:hasPropertyType rdf:resource="http://sinopia.io/vocabulary/propertyType/resource"/>
                        </xsl:when>
                        <xsl:when test="$prop_type='uri_or_lookup'">
                            <sin:hasPropertyType rdf:resource="http://sinopia.io/vocabulary/propertyType/uri"/>
                        </xsl:when>
                    </xsl:choose>
                    <sin:hasRemark xml:lang="{$implementationSet/mapstor:remark/@xml:lang}"><xsl:value-of select="$implementationSet/mapstor:remark"/></sin:hasRemark>
                </rdf:Description>
                <!-- Literal attributes -->
                <xsl:if test="mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/mapstor:resource[@mapid_resource = $mapid_resource]/mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type_attributes/mapstor:literal_attributes">
                    <rdf:Description rdf:nodeID="{concat(substring-after(@localid_prop, '/'), '_literalAttributes')}">
                        <rdf:type rdf:resource="http://sinopia.io/vocabulary/LiteralPropertyTemplate"/>
                        <!-- Default value -->
                        <xsl:if test="mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/mapstor:resource[@mapid_resource = $mapid_resource][mapstor:user/@mapid_user = $mapid_user]/mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type_attributes/mapstor:literal_attributes/mapstor:default_literal">
                            <sin:hasDefault xml:lang="{mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/mapstor:resource[@mapid_resource = $mapid_resource][mapstor:user/@mapid_user = $mapid_user]/mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type_attributes/mapstor:literal_attributes/mapstor:default_literal/@xml:lang}">
                                <xsl:value-of select="mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/mapstor:resource[@mapid_resource = $mapid_resource]/mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type_attributes/mapstor:literal_attributes/mapstor:default_literal"/>
                            </sin:hasDefault>
                        </xsl:if>
                    </rdf:Description>
                </xsl:if>
            </xsl:for-each>
            
            <!-- skip labelling property types for now
            <xsl:if test="//mapstor:resource[@mapid_resource=$resource and 
                mapstor:format/@mapid_format=$format]/mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type[@value='literal']">
                <rdf:Description rdf:about="http://sinopia.io/vocabulary/propertyType/literal">
                    <rdfs:label>literal</rdfs:label>
                </rdf:Description>
            </xsl:if>
            <xsl:if test="//mapstor:resource[@mapid_resource=$resource and 
                mapstor:format/@mapid_format=$format]/mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type[@value='nested_resource']">
                <rdf:Description rdf:about="http://sinopia.io/vocabulary/propertyType/resource">
                    <rdfs:label>nested resource</rdfs:label>
                </rdf:Description>
            </xsl:if>
            <xsl:if test="//mapstor:resource[@mapid_resource=$resource and 
                mapstor:format/@mapid_format=$format]/mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type[@value='uri_or_lookup']">
                <rdf:Description rdf:about="http://sinopia.io/vocabulary/propertyType/uri">
                    <rdfs:label>uri or lookup</rdfs:label>
                </rdf:Description>
            </xsl:if> -->
            
            <!-- Skip labelling property attributes for now
            <xsl:if test="//mapstor:resource[@mapid_resource=$resource and mapstor:format/@mapid_format=$format]/mapstor:sinopia_prop_attributes/mapstor:required/@value='true'">
                <rdf:Description rdf:about="http://sinopia.io/vocabulary/propertyAttribute/required">
                    <rdfs:label>required</rdfs:label>
                </rdf:Description>
            </xsl:if>
            <xsl:if test="//mapstor:resource[@mapid_resource=$resource and mapstor:format/@mapid_format=$format]/mapstor:sinopia_prop_attributes/mapstor:repeatable/@value='true'">
                <rdf:Description rdf:about="http://sinopia.io/vocabulary/propertyAttribute/repeatable">
                    <rdfs:label>repeatable</rdfs:label>
                </rdf:Description>
            </xsl:if>
            <xsl:if test="//mapstor:resource[@mapid_resource=$resource and mapstor:format/@mapid_format=$format]/mapstor:sinopia_prop_attributes/mapstor:ordered/@value='true'">
                <rdf:Description rdf:about="http://sinopia.io/vocabulary/propertyAttribute/ordered">
                    <rdfs:label>ordered</rdfs:label>
                </rdf:Description>
            </xsl:if> -->
            
        </rdf:RDF>
    </xsl:template>
    <!-- Naming first list node -->
    <xsl:template name="start_PT_list">
        <xsl:param name="prop_node_id"/>
        <sin:hasPropertyTemplate rdf:nodeID="{$prop_node_id}"/>
    </xsl:template>
</xsl:stylesheet>
