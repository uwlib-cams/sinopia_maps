<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:maps="https://uwlib-cams.github.io/map_storage/"
    xmlns:bmrxml="https://briesenberg07.github.io/xml_stack/" exclude-result-prefixes="xs"
    version="3.0">

    <!-- (there must be a better way to reuse a function than copying from start template and renaming here??) -->
    <xsl:function name="bmrxml:rda_iri_slug_templates">
        <xsl:param name="path_to_iri"/>
        <xsl:value-of select="translate(substring-after($path_to_iri, 'Elements/'), '/', '_')"/>
    </xsl:function>

    <!-- *****create ordering bnodes***** -->
    <xsl:template name="pts_start">
        <xsl:param name="sorted_property"/>
        <!-- create the 'ordering' bnode for each PT -->
        <xsl:for-each select="$sorted_property">
            <xsl:variable name="current_position" select="position()"/>
            <!-- create bnode to order PTs with first, rest -->
            <rdf:Description rdf:nodeID="{concat(bmrxml:rda_iri_slug_templates(maps:prop_iri/@iri),
                '_order')}">
                <rdf:first rdf:nodeID="{concat(bmrxml:rda_iri_slug_templates(maps:prop_iri/@iri),
                    '_define')}"/>
                <xsl:choose>
                    <xsl:when test="position() != last()">
                        <rdf:rest rdf:nodeID="{concat(
                            bmrxml:rda_iri_slug_templates($sorted_property[position() = $current_position + 1]/maps:prop_iri/@iri),
                            '_order')}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdf:rest rdf:resource="http://www.w3.org/1999/02/22-rdf-syntax-ns#nil"/>
                    </xsl:otherwise>
                </xsl:choose>
            </rdf:Description>
            <xsl:call-template name="pt_define">
                <xsl:with-param name="prop" select="."/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <!-- ****create defining bnodes**** -->
    <xsl:template name="pt_define">
        <xsl:param name="prop"/>
        <rdf:Description
            rdf:nodeID="{concat(bmrxml:rda_iri_slug_templates($prop/maps:prop_iri/@iri),
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
                    rdf:nodeID="{concat(bmrxml:rda_iri_slug_templates($prop/maps:prop_iri/@iri),
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
                            rdf:nodeID="{concat(bmrxml:rda_iri_slug_templates($prop/maps:prop_iri/@iri),
                                '_uri_attributes')}"/>
                        <!-- see template pt_define_uri -->
                    </xsl:when>
                    <!-- for lookup PTs -->
                    <xsl:when test="
                            $prop/maps:sinopia/maps:implementationSet/
                            maps:sinopia_prop_attributes/maps:sinopia_prop_type_attributes/maps:lookup_attributes/node()">
                        <sinopia:hasLookupAttributes
                            rdf:nodeID="{concat(bmrxml:rda_iri_slug_templates($prop/maps:prop_iri/@iri),
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
                    rdf:nodeID="{concat(bmrxml:rda_iri_slug_templates($prop/maps:prop_iri/@iri),
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
                <xsl:call-template name="pt_define_literal">
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
                        <xsl:call-template name="pt_define_uri">
                            <xsl:with-param name="prop" select="$prop"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="
                            $prop/maps:sinopia/maps:implementationSet/
                            maps:sinopia_prop_attributes/maps:sinopia_prop_type_attributes/maps:lookup_attributes/node()">
                        <xsl:call-template name="pt_define_lookup">
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
                <xsl:call-template name="pt_define_nested_resource">
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

    <!-- ***provide further definition (defaults, etc.) for PTs of each type -->
    <!-- output literal PT attributes -->
    <xsl:template name="pt_define_literal">
        <xsl:param name="prop"/>
        <rdf:Description
            rdf:nodeID="{concat(bmrxml:rda_iri_slug_templates($prop/maps:prop_iri/@iri),
            '_literal_attributes')}">
            <!-- hard-code rdf:type for this node sinopia:LiteralPropertyTemplate -->
            <rdf:type rdf:resource="http://sinopia.io/vocabulary/LiteralPropertyTemplate"/>
            <sinopia:hasDefault xml:lang="{$prop/maps:sinopia/maps:implementationSet/
                maps:sinopia_prop_attributes/maps:sinopia_prop_type_attributes/
                maps:literal_attributes/maps:default_literal/@xml:lang}">
                <xsl:value-of select="
                        $prop/maps:sinopia/maps:implementationSet/
                        maps:sinopia_prop_attributes/maps:sinopia_prop_type_attributes/
                        maps:literal_attributes/maps:default_literal"/>
            </sinopia:hasDefault>
            <!-- bring in validation datatype if one exists -->
            <xsl:if test="$prop/maps:sinopia/maps:implementationSet/maps:sinopia_prop_attributes/
                maps:sinopia_prop_type_attributes/maps:literal_attributes/maps:validation_datatype/text()">
                <xsl:choose>
                    <xsl:when test="$prop/maps:sinopia/maps:implementationSet/maps:sinopia_prop_attributes/
                        maps:sinopia_prop_type_attributes/maps:literal_attributes/maps:validation_datatype = 
                        'Date and time with or without timezone'">
                        <sinopia:hasValidationDataType rdf:resource="http://www.w3.org/2001/XMLSchema#dateTime"/>
                    </xsl:when>
                    <xsl:when test="$prop/maps:sinopia/maps:implementationSet/maps:sinopia_prop_attributes/
                        maps:sinopia_prop_type_attributes/maps:literal_attributes/maps:validation_datatype = 
                        'Date and time with required timezone'">
                        <sinopia:hasValidationDataType rdf:resource="http://www.w3.org/2001/XMLSchema#dateTimeStamp"/>
                    </xsl:when>
                    <xsl:when test="$prop/maps:sinopia/maps:implementationSet/maps:sinopia_prop_attributes/
                        maps:sinopia_prop_type_attributes/maps:literal_attributes/maps:validation_datatype = 
                        'Extended Date/Time Format (EDTF)'">
                        <sinopia:hasValidationDataType rdf:resource="http://id.loc.gov/datatypes/edtf/"/>
                    </xsl:when>
                    <xsl:when test="$prop/maps:sinopia/maps:implementationSet/maps:sinopia_prop_attributes/
                        maps:sinopia_prop_type_attributes/maps:literal_attributes/maps:validation_datatype = 'Integer'">
                        <sinopia:hasValidationDataType rdf:resource="http://www.w3.org/2001/XMLSchema#integer"/>
                    </xsl:when>
                    <xsl:otherwise>ERROR - UNKNOWN VALIDATION DATATYPE PROVIDED</xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <!-- to do bring in validation regex see sinopia_maps #9 -->
        </rdf:Description>
    </xsl:template>

    <!-- output uri or lookup > uri PT attributes -->
    <xsl:template name="pt_define_uri">
        <xsl:param name="prop"/>
        <rdf:Description
            rdf:nodeID="{concat(bmrxml:rda_iri_slug_templates($prop/maps:prop_iri/@iri),
            '_uri_attributes')}">
            <!-- hard-code rdf:type for this node sinopia:UriPropertyTemplate-->
            <rdf:type rdf:resource="http://sinopia.io/vocabulary/UriPropertyTemplate"/>
            <!-- provide default uri -->
            <sinopia:hasDefault rdf:resource="{
                $prop/maps:sinopia/maps:implementationSet/maps:sinopia_prop_attributes/
                maps:sinopia_prop_type_attributes/maps:uri_attributes/maps:default_uri/@iri}"
            />
        </rdf:Description>
        <!-- if label for default uri is provided in storage instance, output to RT -->
        <xsl:if test="
                $prop/maps:sinopia/maps:implementationSet/maps:sinopia_prop_attributes/
                maps:sinopia_prop_type_attributes/maps:uri_attributes/maps:default_uri_label">
            <rdf:Description rdf:about="{
                $prop/maps:sinopia/maps:implementationSet/maps:sinopia_prop_attributes/
                maps:sinopia_prop_type_attributes/maps:uri_attributes/maps:default_uri/@iri}">
                <rdfs:label xml:lang="{
                    $prop/maps:sinopia/maps:implementationSet/maps:sinopia_prop_attributes/
                    maps:sinopia_prop_type_attributes/maps:uri_attributes/maps:default_uri_label/@xml:lang}">
                    <xsl:value-of select="
                            $prop/maps:sinopia/maps:implementationSet/maps:sinopia_prop_attributes/
                            maps:sinopia_prop_type_attributes/maps:uri_attributes/maps:default_uri_label"
                    />
                </rdfs:label>
            </rdf:Description>
        </xsl:if>
    </xsl:template>

    <!-- output uri or lookup > lookup PT attributes -->
    <xsl:template name="pt_define_lookup">
        <xsl:param name="prop"/>
        <rdf:Description
            rdf:nodeID="{concat(bmrxml:rda_iri_slug_templates($prop/maps:prop_iri/@iri),
            '_lookup_attributes')}">
            <!-- hard-code rdf:type for this node sinopia:LookupPropertyTemplate-->
            <rdf:type rdf:resource="http://sinopia.io/vocabulary/LookupPropertyTemplate"/>
            <xsl:for-each select="
                    $prop/maps:sinopia/maps:implementationSet/maps:sinopia_prop_attributes/
                    maps:sinopia_prop_type_attributes/maps:lookup_attributes/maps:authorities/maps:authority_urn">
                <sinopia:hasAuthority rdf:resource="{.}"/>
            </xsl:for-each>
        </rdf:Description>
        <!-- map_storage doesn't allow for assigning labels to authority URNs, so no URN label output -->
    </xsl:template>

    <!-- output nested resource PT attributes -->
    <xsl:template name="pt_define_nested_resource">
        <xsl:param name="prop"/>
        <rdf:Description
            rdf:nodeID="{concat(bmrxml:rda_iri_slug_templates($prop/maps:prop_iri/@iri),
            '_resource_attributes')}">
            <!-- hard-code rdf:type for this node sinopia:ResourcePropertyTemplate -->
            <rdf:type rdf:resource="http://sinopia.io/vocabulary/ResourcePropertyTemplate"/>
            <xsl:for-each select="
                    $prop/maps:sinopia/maps:implementationSet/maps:sinopia_prop_attributes/
                    maps:sinopia_prop_type_attributes/maps:nested_resource_attributes/maps:rt_id">
                <sinopia:hasResourceTemplateId rdf:resource="{.}"/>
            </xsl:for-each>
        </rdf:Description>
    </xsl:template>

</xsl:stylesheet>
