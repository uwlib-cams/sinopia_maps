<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:maps="https://uwlib-cams.github.io/map_storage/"
    xmlns:bmrxml="https://briesenberg07.github.io/xml_stack/"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    exclude-result-prefixes="xs"
    version="3.0">
    
    <!-- Store RDA Registry prop files in vars (just a couple for testing; 13 total for implementation later) -->
    <!-- TO DO iterate over these docs, don't repeat result-doc elements as below -->
    <xsl:variable name="rda_Work"
        select="document('https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/w.xml')"/>
    <xsl:variable name="rda_Expression"
        select="document('https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/e.xml')"/>
    <xsl:variable name="rda_Manifestation"
        select="document('https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/m.xml')"/>
    
    <xsl:template name="multiple_property_iris">
        <xsl:param name="prop"/>
        <!-- determine whether the prop is RDA or some other -->
        <!-- then get either selected iris (each maps:property), or all subprop iris (iterate over corresponding RDA Reg file -->
        <xsl:choose>
            <!-- for RDA PTs -->
            <xsl:when test="starts-with($prop/maps:prop_iri/@iri, 'http://rdaregistry.info')">
                <xsl:choose>
                    <xsl:when test="$prop/maps:sinopia/maps:implementation_set/
                        maps:multiple_prop/maps:property/node()">
                        <sinopia:hasPropertyUri rdf:resource="{$prop/maps:prop_iri/@iri}"/>
                        <xsl:for-each select="$prop/maps:sinopia/maps:implementation_set/
                            maps:multiple_prop/maps:property">
                            <sinopia:hasPropertyUri rdf:resource="{@property_iri}"/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="matches($prop/maps:sinopia/maps:implementation_set/
                        maps:multiple_prop/maps:all_subprops, 'true|1')">
                        <xsl:choose>
                            <xsl:when test="starts-with($prop/maps:prop_iri/@iri, 'http://rdaregistry.info/Elements/w/')">
                                <!-- TO DO -->
                            </xsl:when>
                            <xsl:when test="starts-with($prop/maps:prop_iri/@iri, 'http://rdaregistry.info/Elements/e/')">
                                <xsl:variable name="iri" select="$prop/maps:prop_iri/@iri"/>
                                <xsl:for-each select="$rda_Expression/rdf:RDF/rdf:Description
                                    [rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']]
                                    [not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]
                                    [rdfs:subPropertyOf/@rdf:resource = $iri]">
                                    <sinopia:hasPropertyUri rdf:resource="{@rdf:about}"/>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="starts-with($prop/maps:prop_iri/@iri, 'http://rdaregistry.info/Elements/m/')">
                                <!-- TO DO -->
                            </xsl:when>
                            <!-- when for each RDA entity / RDA Registry RDF/XML propfile -->
                            <xsl:otherwise>&#10;ERROR - PROPERTY FOR ALL_SUBPROPS DOESN'T SEEM TO COME FROM ANY RDA REGISTRY PROPERTY FILE&#10;</xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <!-- when - for other-ontology PTs (TO DO LATER) -->
            <xsl:otherwise>
                <xsl:text>ERROR: MULTIPLE-PROPERTY FUNCTIONALITY CANNOT YET HANDLE NON-RDA ONTOLOGIES</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="multiple_property_labels">
        <xsl:param name="prop"/>
        <!-- determine whether the prop is RDA or some other -->
        <!-- then get either selected prop labels (each maps:property), or all subprop iris (iterate over corresponding RDA Reg file -->
        <xsl:choose>
            <!-- for RDA PTs -->
            <xsl:when test="starts-with($prop/maps:prop_iri/@iri, 'http://rdaregistry.info')">
                <xsl:choose>
                    <xsl:when test="$prop/maps:sinopia/maps:implementation_set/
                        maps:multiple_prop/maps:property/node()">
                        <rdf:Description rdf:about="{$prop/maps:prop_iri/@iri}">
                            <rdfs:label xml:lang="{$prop/maps:prop_label/@xml:lang}">
                                <xsl:value-of select="$prop/maps:prop_label"/>
                            </rdfs:label>
                        </rdf:Description>
                        <xsl:for-each select="$prop/maps:sinopia/maps:implementation_set/
                            maps:multiple_prop/maps:property">
                            <rdf:Description rdf:about="{@property_iri}">
                                <rdfs:label xml:lang="{@xml:lang}">
                                    <xsl:value-of select="."/>
                                </rdfs:label>
                            </rdf:Description>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="matches($prop/maps:sinopia/maps:implementation_set/
                        maps:multiple_prop/maps:all_subprops, 'true|1')">
                        <xsl:choose>
                            <xsl:when test="starts-with($prop/maps:prop_iri/@iri, 'http://rdaregistry.info/Elements/w/')">
                                <!-- TO DO -->
                            </xsl:when>
                            <xsl:when test="starts-with($prop/maps:prop_iri/@iri, 'http://rdaregistry.info/Elements/e/')">
                                <xsl:variable name="iri" select="$prop/maps:prop_iri/@iri"/>
                                <xsl:for-each select="$rda_Expression/rdf:RDF/rdf:Description
                                    [rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']]
                                    [not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]
                                    [rdfs:subPropertyOf/@rdf:resource = $iri]">
                                    <rdf:Description rdf:about="{@rdf:about}">
                                        <rdfs:label xml:lang="en">
                                            <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                                        </rdfs:label>
                                    </rdf:Description>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="starts-with($prop/maps:prop_iri/@iri, 'http://rdaregistry.info/Elements/m/')">
                                <!-- TO DO -->
                            </xsl:when>
                            <!-- when for each RDA entity / RDA Registry RDF/XML propfile -->
                            <xsl:otherwise>&#10;ERROR - PROPERTY FOR ALL_SUBPROPS DOESN'T SEEM TO COME FROM ANY RDA REGISTRY PROPERTY FILE&#10;</xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <!-- for other-ontology PTs (TO DO LATER) -->
            <xsl:otherwise>
                <xsl:text>ERROR: MULTIPLE-PROPERTY FUNCTIONALITY CANNOT YET HANDLE NON-RDA ONTOLOGIES</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>