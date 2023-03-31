<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    exclude-result-prefixes="xs"
    version="3.0">
    
    <xsl:variable name="get_prop_sets"
        select="document('https://github.com/uwlib-cams/map_storage/raw/main/xml/get_prop_sets.xml')"/>

    <xsl:template name="multiple_property_iris">
        <xsl:param name="institution"/>
        <xsl:param name="resource"/>
        <xsl:param name="format"/>
        <xsl:param name="user"/>
        <xsl:param name="prop"/>
        <xsl:variable name="rda_set_source">
            <xsl:value-of select="$get_prop_sets/uwmaps:get_prop_sets/uwmaps:get_set[uwmaps:set_domain = $resource]/uwmaps:set_source"/>
        </xsl:variable>
        <!-- determine whether the prop is RDA or some other -->
        <!-- then get either selected iris (each uwmaps:property), or all subprop iris (iterate over corresponding RDA Reg file -->
        <xsl:choose>
            <!-- for RDA PTs -->
            <xsl:when test="starts-with($prop/uwmaps:prop_iri/@iri, 'http://rdaregistry.info')">
                <xsl:choose>
                    <!-- put each property_selection in the PT -->
                    <xsl:when test="
                            $prop/uwmaps:sinopia/uwsinopia:implementation_set
                            [uwsinopia:institution = $institution]
                            [uwsinopia:resource = $resource]
                            [uwsinopia:format = $format]
                            [uwsinopia:user = $user]
                            /uwsinopia:multiple_prop/uwsinopia:property_selection">
                        <!-- add iri for the 'main'* property first -->
                        <!-- *the prop in the prop_set where the implementation_set has been recorded -->
                        <sinopia:hasPropertyUri rdf:resource="{$prop/uwmaps:prop_iri/@iri}"/>
                        <xsl:for-each select="
                                $prop/uwmaps:sinopia/uwsinopia:implementation_set
                                [uwsinopia:institution = $institution]
                                [uwsinopia:resource = $resource]
                                [uwsinopia:format = $format]
                                [uwsinopia:user = $user]
                                /uwsinopia:multiple_prop/uwsinopia:property_selection">
                            <sinopia:hasPropertyUri rdf:resource="{@property_iri}"/>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- all_all_subprops -->
                    <!-- put all subprops of the 'main'* property in the PT, get these and put them in -->
                    <!-- *the prop in the prop_set where the implementation_set has been recorded -->
                    <!-- this may result in duplicates, remove these in post-processing -->
                    <xsl:when test="
                            matches($prop/uwmaps:sinopia/uwsinopia:implementation_set
                            [uwsinopia:institution = $institution]
                            [uwsinopia:resource = $resource]
                            [uwsinopia:format = $format]
                            [uwsinopia:user = $user]
                            /uwsinopia:multiple_prop/uwsinopia:all_subprops, 'true|1')">
                        <!-- add iri for the 'main'* property first -->
                        <!-- *the prop in the prop_set where the implementation_set has been recorded -->
                        <sinopia:hasPropertyUri rdf:resource="{$prop/uwmaps:prop_iri/@iri}"/>
                        <!-- output all subprops from corresponding RDA Registry doc -->
                        <xsl:for-each select="
                                document($rda_set_source)/rdf:RDF/rdf:Description
                                [rdfs:subPropertyOf/@rdf:resource = $prop/uwmaps:prop_iri/@iri]
                                [not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]">
                            <sinopia:hasPropertyUri rdf:resource="{@rdf:about}"/>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- all_all_subprops -->
                    <xsl:when test="
                        matches($prop/uwmaps:sinopia/uwsinopia:implementation_set
                        [uwsinopia:institution = $institution]
                        [uwsinopia:resource = $resource]
                        [uwsinopia:format = $format]
                        [uwsinopia:user = $user]
                        /uwsinopia:multiple_prop/uwsinopia:all_all_subprops, 'true|1')">
                        <!-- add iri for the 'main'* property first -->
                        <!-- *the prop in the prop_set where the implementation_set has been recorded -->
                        <sinopia:hasPropertyUri rdf:resource="{$prop/uwmaps:prop_iri/@iri}"/>
                        <!-- output all subproperties, and subproperties of those subproperties, ..., recursively -->
                        <xsl:for-each select="
                            document($rda_set_source)/rdf:RDF/rdf:Description
                            [rdfs:subPropertyOf/@rdf:resource = $prop/uwmaps:prop_iri/@iri]
                            [not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]">
                            <xsl:call-template name="all_all_subprops_iris">
                                <xsl:with-param name="rda_set_source" select="$rda_set_source"/>
                                <xsl:with-param name="prop_iri" select="@rdf:about"/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>ERROR - NEITHER PROPERTY_SELECTION, ALL_SUBPROPS, OR ALL_ALL_SUBPROPS</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- when - for other-ontology PTs (TO DO LATER or never) -->
            <xsl:otherwise>
                <xsl:text>ERROR - MULTIPLE-PROPERTY PTs NOT CONFIGURED FOR THIS SOURCE</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="all_all_subprops_iris">
        <xsl:param name="rda_set_source"/>
        <xsl:param name="prop_iri"/>
        <sinopia:hasPropertyUri rdf:resource="{$prop_iri}"/>
        <xsl:for-each select="
            document($rda_set_source)/rdf:RDF/rdf:Description
            [rdfs:subPropertyOf/@rdf:resource = $prop_iri]
            [not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]">
            <xsl:call-template name="all_all_subprops_iris">
                <xsl:with-param name="rda_set_source" select="$rda_set_source"/>
                <xsl:with-param name="prop_iri" select="@rdf:about"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="multiple_property_labels">
        <xsl:param name="institution"/>
        <xsl:param name="resource"/>
        <xsl:param name="format"/>
        <xsl:param name="user"/>
        <xsl:param name="prop"/>
        <xsl:variable name="rda_set_source">
            <xsl:value-of select="$get_prop_sets/uwmaps:get_prop_sets/uwmaps:get_set[uwmaps:set_domain = $resource]/uwmaps:set_source"/>
        </xsl:variable>
        <!-- see comments above for multiple_property_iris, same pattern here -->
        <xsl:choose>
            <!-- for RDA PTs [!] only RDA PTs supported for multiple prop at this time! -->
            <xsl:when test="starts-with($prop/uwmaps:prop_iri/@iri, 'http://rdaregistry.info')">
                <xsl:choose>
                    <!-- property_selection -->
                    <xsl:when test="
                            $prop/uwmaps:sinopia/uwsinopia:implementation_set
                            [uwsinopia:institution = $institution]
                            [uwsinopia:resource = $resource]
                            [uwsinopia:format = $format]
                            [uwsinopia:user = $user]
                            /uwsinopia:multiple_prop/uwsinopia:property_selection">
                        <!-- label for 'main' property -->
                        <rdf:Description rdf:about="{$prop/uwmaps:prop_iri/@iri}">
                            <rdfs:label xml:lang="{$prop/uwmaps:prop_label/@xml:lang}">
                                <xsl:value-of select="$prop/uwmaps:prop_label"/>
                            </rdfs:label>
                        </rdf:Description>
                        <!-- labels for each property_selection -->
                        <xsl:for-each select="
                                $prop/uwmaps:sinopia/uwsinopia:implementation_set
                                [uwsinopia:institution = $institution]
                                [uwsinopia:resource = $resource]
                                [uwsinopia:format = $format]
                                [uwsinopia:user = $user]
                                /uwsinopia:multiple_prop/uwsinopia:property_selection">
                            <rdf:Description rdf:about="{@property_iri}">
                                <rdfs:label xml:lang="{@xml:lang}">
                                    <xsl:value-of select="."/>
                                </rdfs:label>
                            </rdf:Description>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- all_subprops -->
                    <xsl:when test="
                            matches($prop/uwmaps:sinopia/uwsinopia:implementation_set
                            [uwsinopia:institution = $institution]
                            [uwsinopia:resource = $resource]
                            [uwsinopia:format = $format]
                            [uwsinopia:user = $user]
                            /uwsinopia:multiple_prop/uwsinopia:all_subprops, 'true|1')">
                        <!-- label for 'main' property -->
                        <rdf:Description rdf:about="{$prop/uwmaps:prop_iri/@iri}">
                            <rdfs:label xml:lang="{$prop/uwmaps:prop_label/@xml:lang}">
                                <xsl:value-of select="$prop/uwmaps:prop_label"/>
                            </rdfs:label>
                        </rdf:Description>
                        <!-- label for all subproperties of 'main' property -->
                        <xsl:for-each select="
                            document($rda_set_source)/rdf:RDF/rdf:Description
                            [rdfs:subPropertyOf/@rdf:resource = $prop/uwmaps:prop_iri/@iri]
                            [not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]">
                            <rdf:Description rdf:about="{@rdf:about}">
                                <rdfs:label xml:lang="en">
                                    <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                                </rdfs:label>
                            </rdf:Description>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- all_all_subprops -->
                    <xsl:when test="
                        matches($prop/uwmaps:sinopia/uwsinopia:implementation_set
                        [uwsinopia:institution = $institution]
                        [uwsinopia:resource = $resource]
                        [uwsinopia:format = $format]
                        [uwsinopia:user = $user]
                        /uwsinopia:multiple_prop/uwsinopia:all_all_subprops, 'true|1')">
                        <!-- label for 'main' property -->
                        <rdf:Description rdf:about="{$prop/uwmaps:prop_iri/@iri}">
                            <rdfs:label xml:lang="{$prop/uwmaps:prop_label/@xml:lang}">
                                <xsl:value-of select="$prop/uwmaps:prop_label"/>
                            </rdfs:label>
                        </rdf:Description>
                        <!-- label for all subproperties, subproperties of subproperties, ..., recursively -->
                        <!-- this will most likely result in duplicates -->
                        <xsl:for-each select="
                            document($rda_set_source)/rdf:RDF/rdf:Description
                            [rdfs:subPropertyOf/@rdf:resource = $prop/uwmaps:prop_iri/@iri]
                            [not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]">
                            <xsl:call-template name="all_all_subprops_labels">
                                <xsl:with-param name="rda_set_source" select="$rda_set_source"/>
                                <xsl:with-param name="prop_iri" select="@rdf:about"/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>ERROR - NEITHER PROPERTY_SELECTION, ALL_SUBPROPS, OR ALL_ALL_SUBPROPS</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- for other-ontology PTs (TO DO LATER or never) -->
            <xsl:otherwise>
                <xsl:text>>ERROR - MULTIPLE-PROPERTY PT PROPERTY LABELS NOT CONFIGURED FOR THIS SOURCE</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="all_all_subprops_labels">
        <xsl:param name="rda_set_source"/>
        <xsl:param name="prop_iri"/>
        <rdf:Description rdf:about="{$prop_iri}">
            <rdfs:label xml:lang="en">
                <xsl:value-of select="document($rda_set_source)/rdf:RDF/rdf:Description
                    [@rdf:about = $prop_iri]/rdfs:label[@xml:lang = 'en']"/>
            </rdfs:label>
        </rdf:Description>
        <xsl:for-each select="
            document($rda_set_source)/rdf:RDF/rdf:Description
            [rdfs:subPropertyOf/@rdf:resource = $prop_iri]
            [not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]">
            <xsl:call-template name="all_all_subprops_labels">
                <xsl:with-param name="rda_set_source" select="$rda_set_source"/>
                <xsl:with-param name="prop_iri" select="@rdf:about"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
