<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="xs" version="3.0">

    <xsl:include href="001_05_multiple_properties.xsl"/>
    <xsl:include href="001_06_define_literal_pts.xsl"/>
    <xsl:include href="001_07_define_uri_pts.xsl"/>
    <xsl:include href="001_08_define_lookup_pts.xsl"/>
    <xsl:include href="001_09_define_nested_resource_pts.xsl"/>

    <xsl:template name="pt_hasPropertyType">
        <xsl:param name="implementation_set"/>
        <xsl:choose>
            <xsl:when test="$implementation_set/uwsinopia:literal_pt">
                <sinopia:hasPropertyType
                    rdf:resource="http://sinopia.io/vocabulary/propertyType/literal"/>
            </xsl:when>
            <xsl:when test="$implementation_set/uwsinopia:uri_pt">
                <sinopia:hasPropertyType
                    rdf:resource="http://sinopia.io/vocabulary/propertyType/uri"/>
            </xsl:when>
            <xsl:when test="$implementation_set/uwsinopia:lookup_pt">
                <sinopia:hasPropertyType
                    rdf:resource="http://sinopia.io/vocabulary/propertyType/uri"/>
            </xsl:when>
            <xsl:when test="$implementation_set/uwsinopia:nested_resource_pt">
                <sinopia:hasPropertyType
                    rdf:resource="http://sinopia.io/vocabulary/propertyType/resource"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- ****create defining bnode - all PT types**** -->
    <xsl:template name="define_all_pts">
        <xsl:param name="institution"/>
        <xsl:param name="resource"/>
        <xsl:param name="format"/>
        <xsl:param name="user"/>
        <xsl:param name="prop"/>
        <xsl:variable name="node_ID" as="xs:string">
            <xsl:choose>
                <xsl:when test="substring-before($prop/uwmaps:prop_iri/@iri, '//') = 'https:'">
                    <xsl:copy-of select="concat($prop/uwmaps:prop_iri/@iri => 
                        translate('/.#', '') => substring-after('https:'), '_define')"></xsl:copy-of>
                </xsl:when>
                <xsl:when test="substring-before($prop/uwmaps:prop_iri/@iri, '//') = 'http:'">
                    <xsl:copy-of select="concat($prop/uwmaps:prop_iri/@iri => 
                        translate('/.#', '') => substring-after('http:'), '_define')"></xsl:copy-of>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <rdf:Description rdf:nodeID="{$node_ID}">
            <!-- hard-code rdf:type sinopia:PropertyTemplate -->
            <rdf:type rdf:resource="http://sinopia.io/vocabulary/PropertyTemplate"/>
            <!-- ** output property label ** -->
            <rdfs:label xml:lang="{$prop/uwmaps:prop_label/@xml:lang}">
                <xsl:value-of select="$prop/uwmaps:prop_label"/>
            </rdfs:label>
            <!-- ** output property IRI, or multiple-prop IRIs if applicable ** -->
            <xsl:choose>
                <xsl:when test="
                    $prop/uwmaps:sinopia/uwsinopia:implementation_set
                    [uwsinopia:institution = $institution]
                    [uwsinopia:resource = $resource]
                    [uwsinopia:format = $format]
                    [uwsinopia:user = $user]
                    /uwsinopia:multiple_prop/node()">
                    <xsl:call-template name="multiple_property_iris">
                        <xsl:with-param name="institution" select="$institution"/>
                        <xsl:with-param name="resource" select="$resource"/>
                        <xsl:with-param name="format" select="$format"/>
                        <xsl:with-param name="user" select="$user"/>
                        <xsl:with-param name="prop" select="$prop"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <sinopia:hasPropertyUri rdf:resource="{$prop/uwmaps:prop_iri/@iri}"/>
                </xsl:otherwise>
            </xsl:choose>
            <!-- *** output top-level/general PT attributes *** -->
            <!-- http://sinopia.io/vocabulary/hasRemarkUrl -->
            <xsl:if test="
                $prop/uwmaps:sinopia/uwsinopia:implementation_set
                [uwsinopia:institution = $institution]
                [uwsinopia:resource = $resource]
                [uwsinopia:format = $format]
                [uwsinopia:user = $user]
                /uwsinopia:remark_url/@iri">
                <sinopia:hasRemarkUrl rdf:resource="{$prop/uwmaps:sinopia/uwsinopia:implementation_set
                    [uwsinopia:institution = $institution]
                    [uwsinopia:resource = $resource]
                    [uwsinopia:format = $format]
                    [uwsinopia:user = $user]
                    /uwsinopia:remark_url/@iri}"/>
            </xsl:if>
            <!-- languageSuppressed -->
            <xsl:if test="
                    matches($prop/uwmaps:sinopia/uwsinopia:implementation_set
                    [uwsinopia:institution = $institution]
                    [uwsinopia:resource = $resource]
                    [uwsinopia:format = $format]
                    [uwsinopia:user = $user]
                    /uwsinopia:language_suppressed, 'true|1')">
                <sinopia:hasPropertyAttribute
                    rdf:resource="http://sinopia.io/vocabulary/propertyAttribute/languageSuppressed"
                />
            </xsl:if>
            <!-- required -->
            <xsl:if test="
                    matches($prop/uwmaps:sinopia/uwsinopia:implementation_set
                    [uwsinopia:institution = $institution]
                    [uwsinopia:resource = $resource]
                    [uwsinopia:format = $format]
                    [uwsinopia:user = $user]
                    /uwsinopia:required, 'true|1')">
                <sinopia:hasPropertyAttribute
                    rdf:resource="http://sinopia.io/vocabulary/propertyAttribute/required"/>
            </xsl:if>
            <!-- repeatable -->
            <xsl:if test="
                    $prop/uwmaps:sinopia/uwsinopia:implementation_set
                    [uwsinopia:institution = $institution]
                    [uwsinopia:resource = $resource]
                    [uwsinopia:format = $format]
                    [uwsinopia:user = $user]
                    /uwsinopia:repeatable">
                <sinopia:hasPropertyAttribute
                    rdf:resource="http://sinopia.io/vocabulary/propertyAttribute/repeatable"/>
            </xsl:if>
            <!-- ordered -->
            <xsl:if test="
                    matches($prop/uwmaps:sinopia/uwsinopia:implementation_set
                    [uwsinopia:institution = $institution]
                    [uwsinopia:resource = $resource]
                    [uwsinopia:format = $format]
                    [uwsinopia:user = $user]
                    /uwsinopia:repeatable/@ordered, 'true|1')">
                <sinopia:hasPropertyAttribute
                    rdf:resource="http://sinopia.io/vocabulary/propertyAttribute/ordered"/>
            </xsl:if>
            <!-- ** output PT type ** -->
            <xsl:call-template name="pt_hasPropertyType">
                <xsl:with-param name="implementation_set" select="
                    $prop/uwmaps:sinopia/uwsinopia:implementation_set
                    [uwsinopia:institution = $institution]
                    [uwsinopia:resource = $resource]
                    [uwsinopia:format = $format]
                    [uwsinopia:user = $user]"/>
            </xsl:call-template>
            <!-- *** *** output bnodes for defaults by prop type and subtype *** *** -->
            <!-- *** literal PTs *** -->
            <xsl:choose>
                <xsl:when test="
                        $prop/uwmaps:sinopia/uwsinopia:implementation_set
                        [uwsinopia:institution = $institution]
                        [uwsinopia:resource = $resource]
                        [uwsinopia:format = $format]
                        [uwsinopia:user = $user]
                        /uwsinopia:literal_pt/node()">
                    <xsl:variable name="literal_attributes_node_ID" as="xs:string">
                        <xsl:choose>
                            <xsl:when test="substring-before($prop/uwmaps:prop_iri/@iri, '//') = 'https:'">
                                <xsl:copy-of select="concat($prop/uwmaps:prop_iri/@iri => 
                                    translate('/.#', '') => substring-after('https:'),
                                    '_literal_attributes')"></xsl:copy-of>
                            </xsl:when>
                            <xsl:when test="substring-before($prop/uwmaps:prop_iri/@iri, '//') = 'http:'">
                                <xsl:copy-of select="concat($prop/uwmaps:prop_iri/@iri => 
                                    translate('/.#', '') => substring-after('http:'),
                                    '_literal_attributes')"></xsl:copy-of>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <sinopia:hasLiteralAttributes rdf:nodeID="{$literal_attributes_node_ID}"/>
                </xsl:when>
                <!-- *** uri PTs *** -->
                <xsl:when test="
                        $prop/uwmaps:sinopia/uwsinopia:implementation_set
                        [uwsinopia:institution = $institution]
                        [uwsinopia:resource = $resource]
                        [uwsinopia:format = $format]
                        [uwsinopia:user = $user]
                        /uwsinopia:uri_pt/node()">
                    <xsl:variable name="uri_attributes_node_ID" as="xs:string">
                        <xsl:choose>
                            <xsl:when test="substring-before($prop/uwmaps:prop_iri/@iri, '//') = 'https:'">
                                <xsl:copy-of select="concat($prop/uwmaps:prop_iri/@iri => 
                                    translate('/.#', '') => substring-after('https:'),
                                    '_uri_attributes')"></xsl:copy-of>
                            </xsl:when>
                            <xsl:when test="substring-before($prop/uwmaps:prop_iri/@iri, '//') = 'http:'">
                                <xsl:copy-of select="concat($prop/uwmaps:prop_iri/@iri => 
                                    translate('/.#', '') => substring-after('http:'),
                                    '_uri_attributes')"></xsl:copy-of>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <sinopia:hasUriAttributes rdf:nodeID="{$uri_attributes_node_ID}"/>
                </xsl:when>
                <!-- *** lookup PTs *** -->
                <xsl:when test="
                        $prop/uwmaps:sinopia/uwsinopia:implementation_set
                        [uwsinopia:institution = $institution]
                        [uwsinopia:resource = $resource]
                        [uwsinopia:format = $format]
                        [uwsinopia:user = $user]
                        /uwsinopia:lookup_pt/node()">
                    <xsl:variable name="lookup_attributes_node_ID" as="xs:string">
                        <xsl:choose>
                            <xsl:when test="substring-before($prop/uwmaps:prop_iri/@iri, '//') = 'https:'">
                                <xsl:copy-of select="concat($prop/uwmaps:prop_iri/@iri => 
                                    translate('/.#', '') => substring-after('https:'),
                                    '_lookup_attributes')"></xsl:copy-of>
                            </xsl:when>
                            <xsl:when test="substring-before($prop/uwmaps:prop_iri/@iri, '//') = 'http:'">
                                <xsl:copy-of select="concat($prop/uwmaps:prop_iri/@iri => 
                                    translate('/.#', '') => substring-after('http:'),
                                    '_lookup_attributes')"></xsl:copy-of>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <sinopia:hasLookupAttributes rdf:nodeID="{$lookup_attributes_node_ID}"/>
                </xsl:when>
                <!-- *** nested-resource PTs *** -->
                <xsl:when test="
                        $prop/uwmaps:sinopia/uwsinopia:implementation_set
                        [uwsinopia:institution = $institution]
                        [uwsinopia:resource = $resource]
                        [uwsinopia:format = $format]
                        [uwsinopia:user = $user]
                        /uwsinopia:nested_resource_pt/node()">
                    <xsl:variable name="resource_attributes_node_ID" as="xs:string">
                        <xsl:choose>
                            <xsl:when test="substring-before($prop/uwmaps:prop_iri/@iri, '//') = 'https:'">
                                <xsl:copy-of select="concat($prop/uwmaps:prop_iri/@iri => 
                                    translate('/.#', '') => substring-after('https:'),
                                    '_resource_attributes')"></xsl:copy-of>
                            </xsl:when>
                            <xsl:when test="substring-before($prop/uwmaps:prop_iri/@iri, '//') = 'http:'">
                                <xsl:copy-of select="concat($prop/uwmaps:prop_iri/@iri => 
                                    translate('/.#', '') => substring-after('http:'),
                                    '_resource_attributes')"></xsl:copy-of>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <sinopia:hasResourceAttributes
                        rdf:nodeID="{$resource_attributes_node_ID}"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </rdf:Description>
        <!-- call templates to describe PTs by type -->
        <xsl:choose>
            <!-- *** literal PTs *** -->
            <!-- see stylesheet define_literal_pts -->
            <xsl:when test="
                $prop/uwmaps:sinopia/uwsinopia:implementation_set
                [uwsinopia:institution = $institution]
                [uwsinopia:resource = $resource]
                [uwsinopia:format = $format]
                [uwsinopia:user = $user]
                /uwsinopia:literal_pt/node()">
                <xsl:call-template name="define_literal_pts">
                    <xsl:with-param name="institution" select="$institution"/>
                    <xsl:with-param name="resource" select="$resource"/>
                    <xsl:with-param name="format" select="$format"/>
                    <xsl:with-param name="user" select="$user"/>
                    <xsl:with-param name="prop" select="$prop"/>
                </xsl:call-template>
            </xsl:when>
            <!-- *** uri PTs *** -->
            <!-- see stylesheet define_uri_pts -->
            <xsl:when test="
                $prop/uwmaps:sinopia/uwsinopia:implementation_set
                [uwsinopia:institution = $institution]
                [uwsinopia:resource = $resource]
                [uwsinopia:format = $format]
                [uwsinopia:user = $user]
                /uwsinopia:uri_pt/node()">
                <xsl:call-template name="define_uri_pts">
                    <xsl:with-param name="institution" select="$institution"/>
                    <xsl:with-param name="resource" select="$resource"/>
                    <xsl:with-param name="format" select="$format"/>
                    <xsl:with-param name="user" select="$user"/>
                    <xsl:with-param name="prop" select="$prop"/>
                </xsl:call-template>
            </xsl:when>
            <!-- *** lookup PTs *** -->
            <!-- see stylesheet define_lookup_pts -->
            <xsl:when test="
                $prop/uwmaps:sinopia/uwsinopia:implementation_set
                [uwsinopia:institution = $institution]
                [uwsinopia:resource = $resource]
                [uwsinopia:format = $format]
                [uwsinopia:user = $user]
                /uwsinopia:lookup_pt/node()">
                <xsl:call-template name="define_lookup_pts">
                    <xsl:with-param name="institution" select="$institution"/>
                    <xsl:with-param name="resource" select="$resource"/>
                    <xsl:with-param name="format" select="$format"/>
                    <xsl:with-param name="user" select="$user"/>
                    <xsl:with-param name="prop" select="$prop"/>
                </xsl:call-template>
            </xsl:when>
            <!-- *** nested-resource PTs *** -->
            <!-- see stylesheet define_nested_resource_pts -->
            <xsl:when test="
                $prop/uwmaps:sinopia/uwsinopia:implementation_set
                [uwsinopia:institution = $institution]
                [uwsinopia:resource = $resource]
                [uwsinopia:format = $format]
                [uwsinopia:user = $user]
                /uwsinopia:nested_resource_pt/node()">
                <xsl:call-template name="define_nested_resource_pts">
                    <xsl:with-param name="institution" select="$institution"/>
                    <xsl:with-param name="resource" select="$resource"/>
                    <xsl:with-param name="format" select="$format"/>
                    <xsl:with-param name="user" select="$user"/>
                    <xsl:with-param name="prop" select="$prop"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
        <!-- **output multiple-prop labels if applicable** -->
        <xsl:if test="
                $prop/uwmaps:sinopia/uwsinopia:implementation_set
                [uwsinopia:institution = $institution]
                [uwsinopia:resource = $resource]
                [uwsinopia:format = $format]
                [uwsinopia:user = $user]
                /uwsinopia:multiple_prop">
            <xsl:call-template name="multiple_property_labels">
                <xsl:with-param name="institution" select="$institution"/>
                <xsl:with-param name="resource" select="$resource"/>
                <xsl:with-param name="format" select="$format"/>
                <xsl:with-param name="user" select="$user"/>
                <xsl:with-param name="prop" select="$prop"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
