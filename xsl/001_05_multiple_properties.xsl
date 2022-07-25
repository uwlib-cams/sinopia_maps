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
                    <!-- when the implementation set contains a list of props, put each in the PT -->
                    <xsl:when test="
                            $prop/uwmaps:sinopia/uwsinopia:implementation_set
                            [uwsinopia:institution = $institution]
                            [uwsinopia:resource = $resource]
                            [uwsinopia:format = $format]
                            [uwsinopia:user = $user]
                            /uwsinopia:multiple_prop/uwsinopia:property_selection">
                        <!-- don't forget the iri for the 'main' property*! -->
                        <!-- *that is, the property in the prop_set where the implementation_set has been recorded -->
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
                    <!-- when the implementation set says to to include all subprops [!] in the PT, get these and put them in -->
                    <!-- [!] all_subprops feature only available for RDA Registry sources -->
                    <xsl:when test="
                            matches($prop/uwmaps:sinopia/uwsinopia:implementation_set
                            [uwsinopia:institution = $institution]
                            [uwsinopia:resource = $resource]
                            [uwsinopia:format = $format]
                            [uwsinopia:user = $user]
                            /uwsinopia:multiple_prop/uwsinopia:all_subprops, 'true|1')">
                        <!-- don't forget iri for the 'main' property! -->
                        <sinopia:hasPropertyUri rdf:resource="{$prop/uwmaps:prop_iri/@iri}"/>
                        <!-- output all subprops from RDA Registry doc -->
                        <!-- [!] all_subprops feature only available for RDA Registry sources -->
                        <xsl:for-each select="
                                document($rda_set_source)/rdf:RDF/rdf:Description
                                [rdfs:subPropertyOf/@rdf:resource = $prop/uwmaps:prop_iri/@iri]
                                [not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]">
                            <sinopia:hasPropertyUri rdf:resource="{@rdf:about}"/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>ERROR - NEITHER PROPERTY ELEMENTS OR ALL_SUBPROPS ELEMENT IN SOURCE</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- when - for other-ontology PTs (TO DO LATER or never) -->
            <xsl:otherwise>
                <xsl:text>ERROR - MULTIPLE-PROPERTY PTs NOT CONFIGURED FOR THIS SOURCE</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
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
        <!-- determine whether the prop is RDA or some other -->
        <!-- then get either selected prop labels (each uwmaps:property), or all subprop iris (iterate over corresponding RDA Reg file -->
        <xsl:choose>
            <!-- for RDA PTs [!] only RDA PTs supported for multiple prop at this time! -->
            <xsl:when test="starts-with($prop/uwmaps:prop_iri/@iri, 'http://rdaregistry.info')">
                <xsl:choose>
                    <!-- when the implementation set contains a list of props with labels, put each in the PT -->
                    <xsl:when test="
                            $prop/uwmaps:sinopia/uwsinopia:implementation_set
                            [uwsinopia:institution = $institution]
                            [uwsinopia:resource = $resource]
                            [uwsinopia:format = $format]
                            [uwsinopia:user = $user]
                            /uwsinopia:multiple_prop/uwsinopia:property_selection">
                        <!-- don't forget label for the 'main' property -->
                        <rdf:Description rdf:about="{$prop/uwmaps:prop_iri/@iri}">
                            <rdfs:label xml:lang="{$prop/uwmaps:prop_label/@xml:lang}">
                                <xsl:value-of select="$prop/uwmaps:prop_label"/>
                            </rdfs:label>
                        </rdf:Description>
                        <!-- labels for all listed properties -->
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
                    <!-- when the implementation set says to to put all subprops in the PT, get labels for all of these and put them in -->
                    <xsl:when test="
                            matches($prop/uwmaps:sinopia/uwsinopia:implementation_set
                            [uwsinopia:institution = $institution]
                            [uwsinopia:resource = $resource]
                            [uwsinopia:format = $format]
                            [uwsinopia:user = $user]
                            /uwsinopia:multiple_prop/uwsinopia:all_subprops, 'true|1')">
                        <!-- don't forget label for the 'main' property -->
                        <rdf:Description rdf:about="{$prop/uwmaps:prop_iri/@iri}">
                            <rdfs:label xml:lang="{$prop/uwmaps:prop_label/@xml:lang}">
                                <xsl:value-of select="$prop/uwmaps:prop_label"/>
                            </rdfs:label>
                        </rdf:Description>
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
                    <xsl:otherwise>
                        <xsl:text>ERROR - NEITHER PROPERTY ELEMENTS OR ALL_SUBPROPS ELEMENT IN SOURCE</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- for other-ontology PTs (TO DO LATER or never) -->
            <xsl:otherwise>
                <xsl:text>>ERROR - MULTIPLE-PROPERTY PTs NOT CONFIGURED FOR THIS SOURCE</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
