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
    
    <xsl:include href="001multiple_properties.xsl"/>
    <xsl:include href="001define_literal_pts.xsl"/>
    <xsl:include href="001define_uri_pts.xsl"/>
    <xsl:include href="001define_lookup_pts.xsl"/>
    <xsl:include href="001define_nested_resource_pts.xsl"/>
    
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
                <sinopia:hasPropertyType
                    rdf:resource="http://sinopia.io/vocabulary/propertyType/resource"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- ****create defining bnode for all property types**** -->
    <xsl:template name="define_all_pts">
        <xsl:param name="prop"/>
        <rdf:Description
            rdf:nodeID="{concat($prop/uwmaps:prop_iri/@iri => 
            translate('/.#', '') => substring-after('http:'), '_define')}">
            <!-- hard-code rdf:type sinopia:PropertyTemplate -->
            <rdf:type rdf:resource="http://sinopia.io/vocabulary/PropertyTemplate"/>
            <!-- output multiple-property dropdown, or not -->
            <xsl:choose>
                <xsl:when test="$prop/uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:multiple_prop/node()">
                    <xsl:call-template name="multiple_property_iris">
                        <xsl:with-param name="prop" select="$prop"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <sinopia:hasPropertyUri rdf:resource="{$prop/uwmaps:prop_iri/@iri}"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:call-template name="pt_hasPropertyType">
                <xsl:with-param name="sinopia_prop_type" select="
                    $prop/uwmaps:sinopia/uwsinopia:implementation_set/
                    uwsinopia:sinopia_prop_attributes/uwsinopia:sinopia_prop_type"/>
            </xsl:call-template>
            <!-- NOTE that lang tags will be pulled from sinopia implementation_set as-is to RTs, so
            **lang tags used in map_storage instances > sinopia should be those from BCP-47** -->
            <rdfs:label xml:lang="{$prop/uwmaps:prop_label/@xml:lang}">
                <xsl:value-of select="$prop/uwmaps:prop_label"/>
            </rdfs:label>
            <!-- *** output top-level/general PT attributes *** -->
            <!-- languageSuppressed -->
            <xsl:if test="
                matches($prop/uwmaps:sinopia/uwsinopia:implementation_set/
                uwsinopia:sinopia_prop_attributes/uwsinopia:language_suppressed, 'true|1')">
                <sinopia:hasPropertyAttribute
                    rdf:resource="http://sinopia.io/vocabulary/propertyAttribute/languageSuppressed"/>
            </xsl:if>
            <!-- required -->
            <xsl:if test="
                matches($prop/uwmaps:sinopia/uwsinopia:implementation_set/
                uwsinopia:sinopia_prop_attributes/uwsinopia:required, 'true|1')">
                <sinopia:hasPropertyAttribute
                    rdf:resource="http://sinopia.io/vocabulary/propertyAttribute/required"/>
            </xsl:if>
            <!-- repeatable -->
            <xsl:if test="
                matches($prop/uwmaps:sinopia/uwsinopia:implementation_set/
                uwsinopia:sinopia_prop_attributes/uwsinopia:repeatable, 'true|1')">
                <sinopia:hasPropertyAttribute
                    rdf:resource="http://sinopia.io/vocabulary/propertyAttribute/repeatable"/>
            </xsl:if>
            <!-- ordered -->
            <xsl:if test="
                matches($prop/uwmaps:sinopia/uwsinopia:implementation_set/
                uwsinopia:sinopia_prop_attributes/uwsinopia:ordered, 'true|1')">
                <sinopia:hasPropertyAttribute
                    rdf:resource="http://sinopia.io/vocabulary/propertyAttribute/ordered"/>
            </xsl:if>
            <!-- *** *** output bnodes for defaults by prop type and subtype *** *** -->
            <!-- *** literal PTs *** -->
            <xsl:if test="
                $prop/uwmaps:sinopia/uwsinopia:implementation_set/
                uwsinopia:sinopia_prop_attributes/uwsinopia:sinopia_prop_type = 'literal'
                and
                $prop/uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:sinopia_prop_attributes/
                uwsinopia:sinopia_prop_type_attributes/uwsinopia:literal_attributes/node()">
                <sinopia:hasLiteralAttributes
                    rdf:nodeID="{concat($prop/uwmaps:prop_iri/@iri => 
                    translate('/.#', '') => substring-after('http:'),
                    '_literal_attributes')}"/>
                <!-- see stylesheet define_literal_pts -->
            </xsl:if>
            <!-- *** lookup or uri PTs *** -->
            <xsl:if test="
                $prop/uwmaps:sinopia/uwsinopia:implementation_set/
                uwsinopia:sinopia_prop_attributes/uwsinopia:sinopia_prop_type = 'uri_or_lookup'">
                <xsl:choose>
                    <!-- *** uri PTs *** -->
                    <xsl:when test="
                        (: BMR QUESTION does node() below test for the uri_attributes node or its child?? :)
                        $prop/uwmaps:sinopia/uwsinopia:implementation_set/
                        uwsinopia:sinopia_prop_attributes/uwsinopia:sinopia_prop_type_attributes/uwsinopia:uri_attributes/node()">
                        <sinopia:hasUriAttributes
                            rdf:nodeID="{concat($prop/uwmaps:prop_iri/@iri => 
                            translate('/.#', '') => substring-after('http:'),
                            '_uri_attributes')}"/>
                        <!-- see stylesheet define_uri_pts -->
                    </xsl:when>
                    <!-- *** lookup PTs *** -->
                    <xsl:when test="
                        $prop/uwmaps:sinopia/uwsinopia:implementation_set/
                        uwsinopia:sinopia_prop_attributes/uwsinopia:sinopia_prop_type_attributes/uwsinopia:lookup_attributes/node()">
                        <sinopia:hasLookupAttributes
                            rdf:nodeID="{concat($prop/uwmaps:prop_iri/@iri => 
                            translate('/.#', '') => substring-after('http:'),
                            '_lookup_attributes')}"/>
                        <!-- see stylesheet define_lookup_pts -->
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:if>
            <!-- *** nested-resource PTs *** -->
            <xsl:if test="
                $prop/uwmaps:sinopia/uwsinopia:implementation_set/
                uwsinopia:sinopia_prop_attributes/uwsinopia:sinopia_prop_type = 'nested_resource'
                and
                $prop/uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:sinopia_prop_attributes/
                uwsinopia:sinopia_prop_type_attributes/uwsinopia:nested_resource_attributes/node()">
                <sinopia:hasResourceAttributes
                    rdf:nodeID="{concat($prop/uwmaps:prop_iri/@iri => 
                    translate('/.#', '') => substring-after('http:'),
                    '_resource_attributes')}"/>
                <!-- see stylesheet define_nested_resource_pts -->
            </xsl:if>
        </rdf:Description>
        <!-- call template to create another bnode to further define (provide defaults, etc.) each prop type -->
        <xsl:choose>
            <xsl:when test="
                $prop/uwmaps:sinopia/uwsinopia:implementation_set/
                uwsinopia:sinopia_prop_attributes/uwsinopia:sinopia_prop_type = 'literal'
                and
                $prop/uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:sinopia_prop_attributes/
                uwsinopia:sinopia_prop_type_attributes/uwsinopia:literal_attributes/node()">
                <xsl:call-template name="define_literal_pts">
                    <xsl:with-param name="prop" select="$prop"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="
                $prop/uwmaps:sinopia/uwsinopia:implementation_set/
                uwsinopia:sinopia_prop_attributes/uwsinopia:sinopia_prop_type = 'uri_or_lookup'">
                <!-- 'uri or lookup' props might have uri defaults, or lookup defaults... -->
                <!-- to do / QUESTION: could they have both?? -->
                <xsl:choose>
                    <xsl:when test="
                        $prop/uwmaps:sinopia/uwsinopia:implementation_set/
                        uwsinopia:sinopia_prop_attributes/uwsinopia:sinopia_prop_type_attributes/uwsinopia:uri_attributes/node()">
                        <xsl:call-template name="define_uri_pts">
                            <xsl:with-param name="prop" select="$prop"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="
                        $prop/uwmaps:sinopia/uwsinopia:implementation_set/
                        uwsinopia:sinopia_prop_attributes/uwsinopia:sinopia_prop_type_attributes/uwsinopia:lookup_attributes/node()">
                        <xsl:call-template name="define_lookup_pts">
                            <xsl:with-param name="prop" select="$prop"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="
                $prop/uwmaps:sinopia/uwsinopia:implementation_set/
                uwsinopia:sinopia_prop_attributes/uwsinopia:sinopia_prop_type = 'nested_resource'
                and
                $prop/uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:sinopia_prop_attributes/
                uwsinopia:sinopia_prop_type_attributes/uwsinopia:nested_resource_attributes/node()">
                <xsl:call-template name="define_nested_resource_pts">
                    <xsl:with-param name="prop" select="$prop"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
        <!-- output multiple-property labels if a multiple-property PT -->
        <xsl:if test="$prop/uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:multiple_prop/node()">
            <xsl:call-template name="multiple_property_labels">
                <xsl:with-param name="prop" select="$prop"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>