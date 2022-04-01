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
    
    <xsl:include href="001define_all_pts.xsl"/>

    <!-- *****create ordering bnodes***** -->
    <xsl:template name="create_ordering">
        <xsl:param name="sorted_property"/>
        <!-- create the 'ordering' bnode for each PT -->
        <xsl:for-each select="$sorted_property">
            <xsl:variable name="current_position" select="position()"/>
            <!-- create bnode to order PTs with first, rest -->
            <xsl:choose>
                <!-- [!] xsl:when needed for each possible property base uri -->
                <xsl:when test="starts-with(uwmaps:prop_iri/@iri, 'http://rdaregistry.info/Elements/')">
                    <rdf:Description rdf:nodeID="{concat('rda_',
                        translate(substring-after(uwmaps:prop_iri/@iri, 'Elements/'), '/', '_'), '_order')}">
                        <rdf:first rdf:nodeID="{concat('rda_',
                            translate(substring-after(uwmaps:prop_iri/@iri, 'Elements/'), '/', '_'), '_define')}"/>
                        <xsl:choose>
                            <xsl:when test="position() != last()">
                                <rdf:rest rdf:nodeID="{concat('rda_',
                                    translate(substring-after($sorted_property[position() = $current_position + 1]/uwmaps:prop_iri/@iri, 'Elements/'), '/', '_'),
                                    '_order')}"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <rdf:rest rdf:resource="http://www.w3.org/1999/02/22-rdf-syntax-ns#nil"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdf:Description>
                </xsl:when>
                <xsl:when test="starts-with(uwmaps:prop_iri/@iri, 'http://purl.org/dc/terms/')">
                    <rdf:Description rdf:nodeID="{concat('dcterms_', 
                        substring-after(uwmaps:prop_iri/@iri, 'http://purl.org/dc/terms/'), '_order')}">
                        <rdf:first rdf:nodeID="{concat('dcterms_', 
                            substring-after(uwmaps:prop_iri/@iri, 'http://purl.org/dc/terms/'), '_define')}"/>
                        <xsl:choose>
                            <xsl:when test="position() != last()">
                                <xsl:choose>
                                    <xsl:when test="starts-with($sorted_property[position() = $current_position + 1]/uwmaps:prop_iri/@iri, 'http://purl.org/dc/terms/')">
                                        <rdf:rest rdf:nodeID="{concat('dcterms_',
                                            substring-after($sorted_property[position() = $current_position + 1]/uwmaps:prop_iri/@iri, 'http://purl.org/dc/terms/'), '_order')}"/>
                                    </xsl:when>
                                    <xsl:when test="starts-with($sorted_property[position() = $current_position + 1]/uwmaps:prop_iri/@iri, 'http://www.w3.org/ns/prov#')">
                                        <rdf:rest rdf:nodeID="{concat('prov_',
                                            substring-after($sorted_property[position() = $current_position + 1]/uwmaps:prop_iri/@iri, 'http://www.w3.org/ns/prov#'), '_order')}"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>ERROR - ONLY PROV AND DCTERMS MAY BE COMBINED IN ONE TEMPLATE!!</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <rdf:rest rdf:resource="http://www.w3.org/1999/02/22-rdf-syntax-ns#nil"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdf:Description>
                </xsl:when>
                <xsl:when test="starts-with(uwmaps:prop_iri/@iri, 'http://www.w3.org/ns/prov#')">
                    <rdf:Description rdf:nodeID="{concat('prov_', 
                        substring-after(uwmaps:prop_iri/@iri, 'http://www.w3.org/ns/prov#'), '_order')}">
                        <rdf:first rdf:nodeID="{concat('prov_', 
                            substring-after(uwmaps:prop_iri/@iri, 'http://www.w3.org/ns/prov#'), '_define')}"/>
                        <xsl:choose>
                            <xsl:when test="position() != last()">
                                <xsl:choose>
                                    <xsl:when test="starts-with($sorted_property[position() = $current_position + 1]/uwmaps:prop_iri/@iri, 'http://purl.org/dc/terms/')">
                                        <rdf:rest rdf:nodeID="{concat('dcterms_',
                                            substring-after($sorted_property[position() = $current_position + 1]/uwmaps:prop_iri/@iri, 'http://purl.org/dc/terms/'), '_order')}"/>
                                    </xsl:when>
                                    <xsl:when test="starts-with($sorted_property[position() = $current_position + 1]/uwmaps:prop_iri/@iri, 'http://www.w3.org/ns/prov#')">
                                        <rdf:rest rdf:nodeID="{concat('prov_',
                                            substring-after($sorted_property[position() = $current_position + 1]/uwmaps:prop_iri/@iri, 'http://www.w3.org/ns/prov#'), '_order')}"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>ERROR - ONLY PROV AND DCTERMS MAY BE COMBINED IN ONE TEMPLATE!!</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <rdf:rest rdf:resource="http://www.w3.org/1999/02/22-rdf-syntax-ns#nil"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdf:Description>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>ERROR - PROP BASE URI NOT RECOGNIZED</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:call-template name="define_all_pts">
                <xsl:with-param name="prop" select="."/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
