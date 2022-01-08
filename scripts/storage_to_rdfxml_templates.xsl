<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:mapstor="https://uwlib-cams.github.io/map_storage/"
    xmlns:bmrxml="https://briesenberg07.github.io/xml_stack/" exclude-result-prefixes="xs"
    version="3.0">

    <!-- there must be a better way to reuse a function than copying and renaming here -->
    <xsl:function name="bmrxml:rda_iri_slug_templates">
        <xsl:param name="path_to_iri"/>
        <xsl:value-of select="translate(substring-after($path_to_iri, 'Elements/'), '/', '_')"/>
    </xsl:function>

    <xsl:template name="pts_start">
        <xsl:param name="sorted_property"/>
        <!-- create the 'ordering' bnode for each PT -->
        <xsl:for-each select="$sorted_property">
            <xsl:variable name="current_position" select="position()"/>
            <!-- create bnode to order PTs with first, rest -->
            <rdf:Description
                rdf:nodeID="{concat(bmrxml:rda_iri_slug_templates(mapstor:prop_iri/@iri),
                '_order')}">
                <rdf:first rdf:nodeID="{concat(bmrxml:rda_iri_slug_templates(mapstor:prop_iri/@iri),
                    '_define')}"/>
                <xsl:choose>
                    <xsl:when test="position() != last()">
                        <rdf:rest rdf:nodeID="{concat(
                            bmrxml:rda_iri_slug_templates($sorted_property[position() = $current_position + 1]/mapstor:prop_iri/@iri),
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

    <xsl:template name="pt_define">
        <xsl:param name="prop"/>
        <!-- create the 'defining' bnode with terms from Sinopia vocab -->
        <rdf:Description
            rdf:nodeID="{concat(bmrxml:rda_iri_slug_templates($prop/mapstor:prop_iri/@iri),
                '_define')}">
            <!-- hard-code rdf:type sinopia:PropertyTemplate -->
            <rdf:type rdf:resource="http://sinopia.io/vocabulary/PropertyTemplate"/>
            <!-- to do: bring in multiple prop URIs for choose-a-prop / see #7 -->
            <sinopia:hasPropertyUri rdf:resource="{$prop/mapstor:prop_iri/@iri}"/>
            <xsl:call-template name="pt_hasPropertyType">
                <xsl:with-param name="sinopia_prop_type" select="
                        $prop/mapstor:sinopia/mapstor:implementationSet/
                        mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type"/>
            </xsl:call-template>
            <!-- NOTE that lang tags will be pulled from sinopia implementationSet as-is to RTs, so
            **lang tags used in map_storage instances > sinopia should be those from BCP-47** -->
            <rdfs:label xml:lang="{$prop/mapstor:prop_label/@xml:lang}">
                <xsl:value-of select="$prop/mapstor:prop_label"/>
            </rdfs:label>
            <xsl:if test="
                    matches($prop/mapstor:sinopia/mapstor:implementationSet/
                    mapstor:sinopia_prop_attributes/mapstor:required, 'true|1')">
                <sinopia:hasPropertyAttribute
                    rdf:resource="http://sinopia.io/vocabulary/propertyAttribute/required"/>
            </xsl:if>
            <xsl:if test="
                    matches($prop/mapstor:sinopia/mapstor:implementationSet/
                    mapstor:sinopia_prop_attributes/mapstor:repeatable, 'true|1')">
                <sinopia:hasPropertyAttribute
                    rdf:resource="http://sinopia.io/vocabulary/propertyAttribute/repeatable"/>
            </xsl:if>
            <xsl:if test="
                    matches($prop/mapstor:sinopia/mapstor:implementationSet/
                    mapstor:sinopia_prop_attributes/mapstor:ordered, 'true|1')">
                <sinopia:hasPropertyAttribute
                    rdf:resource="http://sinopia.io/vocabulary/propertyAttribute/ordered"/>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="
                        $prop/mapstor:sinopia/mapstor:implementationSet/
                        mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type = 'literal'">
                    <sinopia:hasLiteralAttributes
                        rdf:nodeID="{concat(bmrxml:rda_iri_slug_templates($prop/mapstor:prop_iri/@iri),
                            '_literal_attributes')}"/>
                    <!-- rdf:Description for this bnode is output from template w name="pt_define_literal" -->
                </xsl:when>
                <xsl:when test="
                        $prop/mapstor:sinopia/mapstor:implementationSet/
                        mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type = 'uri_or_lookup'">
                    <xsl:choose>
                        <xsl:when test="
                                (: look for uri (not lookup) defaults :)
                                (: BMR QUESTION does node() below test for the uri_attributes node or its child?? :)
                                $prop/mapstor:sinopia/mapstor:implementationSet/
                                mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type_attributes/mapstor:uri_attributes/node()">
                            <sinopia:hasUriAttributes
                                rdf:nodeID="{concat(bmrxml:rda_iri_slug_templates($prop/mapstor:prop_iri/@iri),
                                '_uri_attributes')}"/>
                            <!-- rdf:Description for this bnode is output from template w name="pt_define_uri" -->
                        </xsl:when>
                        <xsl:when test="
                                (: look for lookup (not uri) attributes:)
                                $prop/mapstor:sinopia/mapstor:implementationSet/
                                mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type_attributes/mapstor:lookup_attributes/node()">
                            <sinopia:hasLookupAttributes
                                rdf:nodeID="{concat(bmrxml:rda_iri_slug_templates($prop/mapstor:prop_iri/@iri),
                                '_lookup_attributes')}"/>
                            <!-- rdf:Description for this bnode is output from template w name="pt_define_lookup" -->
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="
                        $prop/mapstor:sinopia/mapstor:implementationSet/
                        mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type = 'nested_resource'">
                    <!-- to do add triple for hasNestedResourceAttributes or whatever -->
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </rdf:Description>
        <!-- call template to create another bnode to further define (provide defaults, etc.) each prop type -->
        <xsl:choose>
            <xsl:when test="
                    (: to do? add additional test for presence of default literal?? :)
                    $prop/mapstor:sinopia/mapstor:implementationSet/
                    mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type = 'literal'">
                <xsl:call-template name="pt_define_literal">
                    <xsl:with-param name="prop" select="$prop"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="
                    (: to do? add test for defaults? :)
                    $prop/mapstor:sinopia/mapstor:implementationSet/
                    mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type = 'uri_or_lookup'">
                <!-- 'uri or lookup' props might have uri defaults, or lookup defaults... -->
                <!-- QUESTION: could they have both?? -->
                <xsl:choose>
                    <xsl:when test="
                            $prop/mapstor:sinopia/mapstor:implementationSet/
                            mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type_attributes/mapstor:uri_attributes/node()">
                        <xsl:call-template name="pt_define_uri">
                            <xsl:with-param name="prop" select="$prop"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="
                            $prop/mapstor:sinopia/mapstor:implementationSet/
                            mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type_attributes/mapstor:lookup_attributes/node()">
                        <xsl:call-template name="pt_define_lookup">
                            <xsl:with-param name="prop" select="$prop"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="
                    (: to do? test for defaults? :)
                    $prop/mapstor:sinopia/mapstor:implementationSet/
                    mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type = 'nested_resource'">
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

    <!-- literal PT attributes -->
    <xsl:template name="pt_define_literal">
        <xsl:param name="prop"/>
        <rdf:Description
            rdf:nodeID="{concat(bmrxml:rda_iri_slug_templates($prop/mapstor:prop_iri/@iri),
            '_literal_attributes')}">
            <!-- hard-code rdf:type for this node sinopia:LiteralPropertyTemplate -->
            <rdf:type rdf:resource="http://sinopia.io/vocabulary/LiteralPropertyTemplate"/>
            <sinopia:hasDefault
                xml:lang="{$prop/mapstor:sinopia/mapstor:implementationSet/
                mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type_attributes/
                mapstor:literal_attributes/mapstor:default_literal/@xml:lang}">
                <xsl:value-of select="
                        $prop/mapstor:sinopia/mapstor:implementationSet/
                        mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type_attributes/
                        mapstor:literal_attributes/mapstor:default_literal"/>
            </sinopia:hasDefault>
            <!-- to do bring in validation regex see sinopia_maps #9 -->
            <!-- to do bring in other validation selections see sinopia_maps #8 -->
        </rdf:Description>
    </xsl:template>

    <!-- uri or lookup > uri PT attributes -->
    <xsl:template name="pt_define_uri">
        <xsl:param name="prop"/>
        <rdf:Description
            rdf:nodeID="{concat(bmrxml:rda_iri_slug_templates($prop/mapstor:prop_iri/@iri),
            '_uri_attributes')}">
            <!-- hard-code type for this node sinopia:UriPropertyTemplate-->
            <rdf:type rdf:resource="http://sinopia.io/vocabulary/UriPropertyTemplate"/>
            <!-- provide default uri -->
            <sinopia:hasDefault rdf:resource="{
                $prop/mapstor:sinopia/mapstor:implementationSet/mapstor:sinopia_prop_attributes/
                mapstor:sinopia_prop_type_attributes/mapstor:uri_attributes/mapstor:default_uri/@iri}"
            />
        </rdf:Description>
        <!-- if label for default uri is provided in storage instance, output to RT -->
        <xsl:if test="
                $prop/mapstor:sinopia/mapstor:implementationSet/mapstor:sinopia_prop_attributes/
                mapstor:sinopia_prop_type_attributes/mapstor:uri_attributes/mapstor:default_uri_label">
            <rdf:Description rdf:about="{
                $prop/mapstor:sinopia/mapstor:implementationSet/mapstor:sinopia_prop_attributes/
                mapstor:sinopia_prop_type_attributes/mapstor:uri_attributes/mapstor:default_uri/@iri}">
                <rdfs:label xml:lang="{
                    $prop/mapstor:sinopia/mapstor:implementationSet/mapstor:sinopia_prop_attributes/
                    mapstor:sinopia_prop_type_attributes/mapstor:uri_attributes/mapstor:default_uri_label/@xml:lang}">
                    <xsl:value-of select="
                            $prop/mapstor:sinopia/mapstor:implementationSet/mapstor:sinopia_prop_attributes/
                            mapstor:sinopia_prop_type_attributes/mapstor:uri_attributes/mapstor:default_uri_label"
                    />
                </rdfs:label>
            </rdf:Description>
        </xsl:if>
    </xsl:template>

    <!-- uri or lookup > lookup PT attributes -->
    <xsl:template name="pt_define_lookup">
        <xsl:param name="prop"/>
        <!--see above for nodeID construction -->
    </xsl:template>

    <!-- nested resource PT attributes -->
    <xsl:template name="pt_define_nested_resource">
        <xsl:param name="prop"/>
    </xsl:template>

</xsl:stylesheet>
