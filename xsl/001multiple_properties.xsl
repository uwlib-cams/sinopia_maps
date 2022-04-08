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

    <!-- Store RDA Registry prop files in vars (just a couple for testing; 13 total for implementation later) -->
    <!-- TO DO iterate over these docs, don't repeat result-doc elements as below -->
    <xsl:variable name="get_prop_sets"
        select="document('https://github.com/uwlib-cams/map_storage/raw/main/xml/get_prop_sets.xml')"/>

    <xsl:template name="multiple_property_iris">
        <xsl:param name="prop"/>
        <!-- determine whether the prop is RDA or some other -->
        <!-- then get either selected iris (each uwmaps:property), or all subprop iris (iterate over corresponding RDA Reg file -->
        <xsl:choose>
            <!-- for RDA PTs -->
            <xsl:when test="starts-with($prop/uwmaps:prop_iri/@iri, 'http://rdaregistry.info')">
                <xsl:choose>
                    <!-- when the implementation set contains a list of props, put each in the PT -->
                    <xsl:when test="
                            $prop/uwmaps:sinopia/uwsinopia:implementation_set/
                            uwsinopia:multiple_prop/uwsinopia:property/node()">
                        <!-- don't forget the iri for the 'main' property*! -->
                        <!-- *that is, the property in the prop_set where the implementation_set has been recorded -->
                        <sinopia:hasPropertyUri rdf:resource="{$prop/uwmaps:prop_iri/@iri}"/>
                        <xsl:for-each select="
                                $prop/uwmaps:sinopia/uwsinopia:implementation_set/
                                uwsinopia:multiple_prop/uwsinopia:property">
                            <sinopia:hasPropertyUri rdf:resource="{@property_iri}"/>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- when the implementation set says to to put all subprops in the PT, get these and put them in -->
                    <xsl:when test="
                            matches($prop/uwmaps:sinopia/uwsinopia:implementation_set/
                            uwsinopia:multiple_prop/uwsinopia:all_subprops, 'true|1')">
                        <!-- don't forget iri for the 'main' property! -->
                        <sinopia:hasPropertyUri rdf:resource="{$prop/uwmaps:prop_iri/@iri}"/>
                        <xsl:variable name="rda_set_source">
                            <xsl:choose>
                                <xsl:when
                                    test="starts-with(substring-after($prop/uwmaps:prop_iri/@iri, 'http://rdaregistry.info/Elements/'), 'w')">
                                    <xsl:value-of
                                        select="$get_prop_sets/uwmaps:get_prop_sets/uwmaps:get_set[uwmaps:set_name = 'rdaw_p10k']/uwmaps:set_source"
                                    />
                                </xsl:when>
                                <xsl:when
                                    test="starts-with(substring-after($prop/uwmaps:prop_iri/@iri, 'http://rdaregistry.info/Elements/'), 'e')">
                                    <xsl:value-of
                                        select="$get_prop_sets/uwmaps:get_prop_sets/uwmaps:get_set[uwmaps:set_name = 'rdae_p20k']/uwmaps:set_source"
                                    />
                                </xsl:when>
                                <xsl:when
                                    test="starts-with(substring-after($prop/uwmaps:prop_iri/@iri, 'http://rdaregistry.info/Elements/'), 'm')">
                                    <xsl:value-of
                                        select="$get_prop_sets/uwmaps:get_prop_sets/uwmaps:get_set[uwmaps:set_name = 'rdam_p30k']/uwmaps:set_source"
                                    />
                                </xsl:when>
                                <xsl:when
                                    test="starts-with(substring-after($prop/uwmaps:prop_iri/@iri, 'http://rdaregistry.info/Elements/'), 'i')">
                                    <xsl:value-of
                                        select="$get_prop_sets/uwmaps:get_prop_sets/uwmaps:get_set[uwmaps:set_name = 'rdai_p40k']/uwmaps:set_source"
                                    />
                                </xsl:when>
                                <!-- ... TO DO sources for other RDA element sets -->
                            </xsl:choose>
                        </xsl:variable>
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
        <xsl:param name="prop"/>
        <!-- determine whether the prop is RDA or some other -->
        <!-- then get either selected prop labels (each uwmaps:property), or all subprop iris (iterate over corresponding RDA Reg file -->
        <xsl:choose>
            <!-- for RDA PTs -->
            <xsl:when test="starts-with($prop/uwmaps:prop_iri/@iri, 'http://rdaregistry.info')">
                <xsl:choose>
                    <!-- when the implementation set contains a list of props with labels, put each in the PT -->
                    <xsl:when test="
                            $prop/uwmaps:sinopia/uwsinopia:implementation_set/
                            uwsinopia:multiple_prop/uwsinopia:property/node()">
                        <!-- label for the 'main' property -->
                        <rdf:Description rdf:about="{$prop/uwmaps:prop_iri/@iri}">
                            <rdfs:label xml:lang="{$prop/uwmaps:prop_label/@xml:lang}">
                                <xsl:value-of select="$prop/uwmaps:prop_label"/>
                            </rdfs:label>
                        </rdf:Description>
                        <!-- labels for all listed properties -->
                        <xsl:for-each select="
                                $prop/uwmaps:sinopia/uwsinopia:implementation_set/
                                uwsinopia:multiple_prop/uwsinopia:property">
                            <rdf:Description rdf:about="{@property_iri}">
                                <rdfs:label xml:lang="{@xml:lang}">
                                    <xsl:value-of select="."/>
                                </rdfs:label>
                            </rdf:Description>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- when the implementation set says to to put all subprops in the PT, get labels for all of these and put them in -->
                    <xsl:when test="
                            matches($prop/uwmaps:sinopia/uwsinopia:implementation_set/
                            uwsinopia:multiple_prop/uwsinopia:all_subprops, 'true|1')">
                        <!-- label for the 'main' property -->
                        <rdf:Description rdf:about="{$prop/uwmaps:prop_iri/@iri}">
                            <rdfs:label xml:lang="{$prop/uwmaps:prop_label/@xml:lang}">
                                <xsl:value-of select="$prop/uwmaps:prop_label"/>
                            </rdfs:label>
                        </rdf:Description>
                        <!-- retrive labels for all subproperties -->
                        <!-- need this var again, ideally it wouldn't be reproduced in two places -->
                        <xsl:variable name="rda_set_source">
                            <xsl:choose>
                                <xsl:when
                                    test="starts-with(substring-after($prop/uwmaps:prop_iri/@iri, 'http://rdaregistry.info/Elements/'), 'w')">
                                    <xsl:value-of
                                        select="$get_prop_sets/uwmaps:get_prop_sets/uwmaps:get_set[uwmaps:set_name = 'rdaw_p10k']/uwmaps:set_source"
                                    />
                                </xsl:when>
                                <xsl:when
                                    test="starts-with(substring-after($prop/uwmaps:prop_iri/@iri, 'http://rdaregistry.info/Elements/'), 'e')">
                                    <xsl:value-of
                                        select="$get_prop_sets/uwmaps:get_prop_sets/uwmaps:get_set[uwmaps:set_name = 'rdae_p20k']/uwmaps:set_source"
                                    />
                                </xsl:when>
                                <xsl:when
                                    test="starts-with(substring-after($prop/uwmaps:prop_iri/@iri, 'http://rdaregistry.info/Elements/'), 'm')">
                                    <xsl:value-of
                                        select="$get_prop_sets/uwmaps:get_prop_sets/uwmaps:get_set[uwmaps:set_name = 'rdam_p30k']/uwmaps:set_source"
                                    />
                                </xsl:when>
                                <xsl:when
                                    test="starts-with(substring-after($prop/uwmaps:prop_iri/@iri, 'http://rdaregistry.info/Elements/'), 'i')">
                                    <xsl:value-of
                                        select="$get_prop_sets/uwmaps:get_prop_sets/uwmaps:get_set[uwmaps:set_name = 'rdai_p40k']/uwmaps:set_source"
                                    />
                                </xsl:when>
                                <!-- ... TO DO sources for other RDA element sets -->
                            </xsl:choose>
                        </xsl:variable>
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
