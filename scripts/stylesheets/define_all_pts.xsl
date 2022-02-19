<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:maps="https://uwlib-cams.github.io/map_storage/"
    xmlns:bmrxml="https://briesenberg07.github.io/xml_stack/" 
    exclude-result-prefixes="xs"
    version="3.0">
    
    <xsl:include href="define_literal_pts.xsl"/>
    <xsl:include href="define_uri_pts.xsl"/>
    <xsl:include href="define_lookup_pts.xsl"/>
    <xsl:include href="define_nested_resource_pts.xsl"/>
    
    <!-- (there must be a better way to reuse a function than copying and renaming in each file??) -->
    <xsl:function name="bmrxml:rda_iri_slug_define_all">
        <xsl:param name="path_to_iri"/>
        <xsl:value-of select="translate(substring-after($path_to_iri, 'Elements/'), '/', '_')"/>
    </xsl:function>
    
    <!-- ****create defining bnode for all property types**** -->
    <xsl:template name="define_all_pts">
        <xsl:param name="prop"/>
        <rdf:Description
            rdf:nodeID="{concat(bmrxml:rda_iri_slug_define_all($prop/maps:prop_iri/@iri),
            '_define')}">
            <!-- hard-code rdf:type sinopia:PropertyTemplate -->
            <rdf:type rdf:resource="http://sinopia.io/vocabulary/PropertyTemplate"/>
            <!-- to do bring in multiple prop URIs for choose-a-prop / see #7 -->
            <sinopia:hasPropertyUri rdf:resource="{$prop/maps:prop_iri/@iri}"/>
            <xsl:call-template name="pt_hasPropertyType">
                <xsl:with-param name="sinopia_prop_type" select="
                    $prop/maps:sinopia/maps:implementationSet/
                    maps:sinopia_prop_attributes/maps:sinopia_prop_type"/>
            </xsl:call-template>
            <!-- NOTE that lang tags will be pulled from sinopia implementationSet as-is to RTs, so
            **lang tags used in map_storage instances > sinopia should be those from BCP-47** -->
            <rdfs:label xml:lang="{$prop/maps:prop_label/@xml:lang}">
                <xsl:value-of select="$prop/maps:prop_label"/>
            </rdfs:label>
            <!-- assign 'general' PT attributes -->
            <xsl:if test="
                matches($prop/maps:sinopia/maps:implementationSet/
                maps:sinopia_prop_attributes/maps:required, 'true|1')">
                <sinopia:hasPropertyAttribute
                    rdf:resource="http://sinopia.io/vocabulary/propertyAttribute/required"/>
            </xsl:if>
            <xsl:if test="
                matches($prop/maps:sinopia/maps:implementationSet/
                maps:sinopia_prop_attributes/maps:repeatable, 'true|1')">
                <sinopia:hasPropertyAttribute
                    rdf:resource="http://sinopia.io/vocabulary/propertyAttribute/repeatable"/>
            </xsl:if>
            <xsl:if test="
                matches($prop/maps:sinopia/maps:implementationSet/
                maps:sinopia_prop_attributes/maps:ordered, 'true|1')">
                <sinopia:hasPropertyAttribute
                    rdf:resource="http://sinopia.io/vocabulary/propertyAttribute/ordered"/>
            </xsl:if>
            <!-- test for defaults, output bnodes for defaults by prop type and subtype -->
            <!-- for literal PTs -->
            <xsl:if test="
                $prop/maps:sinopia/maps:implementationSet/
                maps:sinopia_prop_attributes/maps:sinopia_prop_type = 'literal'
                and
                $prop/maps:sinopia/maps:implementationSet/maps:sinopia_prop_attributes/
                maps:sinopia_prop_type_attributes/maps:literal_attributes/node()">
                <sinopia:hasLiteralAttributes
                    rdf:nodeID="{concat(bmrxml:rda_iri_slug_define_all($prop/maps:prop_iri/@iri),
                    '_literal_attributes')}"/>
                <!-- see template pt_define_literal -->
            </xsl:if>
            <!-- for lookup or uri PTs -->
            <xsl:if test="
                $prop/maps:sinopia/maps:implementationSet/
                maps:sinopia_prop_attributes/maps:sinopia_prop_type = 'uri_or_lookup'">
                <xsl:choose>
                    <!-- for uri PTs -->
                    <xsl:when test="
                        (: BMR QUESTION does node() below test for the uri_attributes node or its child?? :)
                        $prop/maps:sinopia/maps:implementationSet/
                        maps:sinopia_prop_attributes/maps:sinopia_prop_type_attributes/maps:uri_attributes/node()">
                        <sinopia:hasUriAttributes
                            rdf:nodeID="{concat(bmrxml:rda_iri_slug_define_all($prop/maps:prop_iri/@iri),
                            '_uri_attributes')}"/>
                        <!-- see template pt_define_uri -->
                    </xsl:when>
                    <!-- for lookup PTs -->
                    <xsl:when test="
                        $prop/maps:sinopia/maps:implementationSet/
                        maps:sinopia_prop_attributes/maps:sinopia_prop_type_attributes/maps:lookup_attributes/node()">
                        <sinopia:hasLookupAttributes
                            rdf:nodeID="{concat(bmrxml:rda_iri_slug_define_all($prop/maps:prop_iri/@iri),
                            '_lookup_attributes')}"/>
                        <!-- see template pt_define_lookup -->
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:if>
            <!-- for nested-resource PTs -->
            <xsl:if test="
                $prop/maps:sinopia/maps:implementationSet/
                maps:sinopia_prop_attributes/maps:sinopia_prop_type = 'nested_resource'
                and
                $prop/maps:sinopia/maps:implementationSet/maps:sinopia_prop_attributes/
                maps:sinopia_prop_type_attributes/maps:nested_resource_attributes/node()">
                <sinopia:hasResourceAttributes
                    rdf:nodeID="{concat(bmrxml:rda_iri_slug_define_all($prop/maps:prop_iri/@iri),
                    '_resource_attributes')}"/>
            </xsl:if>
        </rdf:Description>
        <!-- call template to create another bnode to further define (provide defaults, etc.) each prop type -->
        <xsl:choose>
            <xsl:when test="
                $prop/maps:sinopia/maps:implementationSet/
                maps:sinopia_prop_attributes/maps:sinopia_prop_type = 'literal'
                and
                $prop/maps:sinopia/maps:implementationSet/maps:sinopia_prop_attributes/
                maps:sinopia_prop_type_attributes/maps:literal_attributes/node()">
                <xsl:call-template name="define_literal_pts">
                    <xsl:with-param name="prop" select="$prop"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="
                $prop/maps:sinopia/maps:implementationSet/
                maps:sinopia_prop_attributes/maps:sinopia_prop_type = 'uri_or_lookup'">
                <!-- 'uri or lookup' props might have uri defaults, or lookup defaults... -->
                <!-- to do / QUESTION: could they have both?? -->
                <xsl:choose>
                    <xsl:when test="
                        $prop/maps:sinopia/maps:implementationSet/
                        maps:sinopia_prop_attributes/maps:sinopia_prop_type_attributes/maps:uri_attributes/node()">
                        <xsl:call-template name="define_uri_pts">
                            <xsl:with-param name="prop" select="$prop"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="
                        $prop/maps:sinopia/maps:implementationSet/
                        maps:sinopia_prop_attributes/maps:sinopia_prop_type_attributes/maps:lookup_attributes/node()">
                        <xsl:call-template name="define_lookup_pts">
                            <xsl:with-param name="prop" select="$prop"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="
                $prop/maps:sinopia/maps:implementationSet/
                maps:sinopia_prop_attributes/maps:sinopia_prop_type = 'nested_resource'
                and
                $prop/maps:sinopia/maps:implementationSet/maps:sinopia_prop_attributes/
                maps:sinopia_prop_type_attributes/maps:nested_resource_attributes/node()">
                <xsl:call-template name="define_nested_resource_pts">
                    <xsl:with-param name="prop" select="$prop"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="pt_hasPropertyType">
        <xsl:param name="sinopia_prop_type"/>
        <xsl:choose>
            <xsl:when test="$sinopia_prop_type = 'literal'">
                <sinopia:hasPropertyType
                    rdf:resource="http://sinopia.io/vocabulary/propertyType/literal"/>
            </xsl:when>
            <xsl:when test="$sinopia_prop_type = 'uri_or_lookup'">
                <sinopia:hasPropertyType
                    rdf:resource="http://sinopia.io/vocabulary/propertyType/uri"/>
            </xsl:when>
            <xsl:when test="$sinopia_prop_type = 'nested_resource'">
                <!-- to do -->
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>