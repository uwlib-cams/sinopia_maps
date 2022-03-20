<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    xmlns:bmrxml="https://briesenberg07.github.io/xml_stack/" 
    exclude-result-prefixes="xs"
    version="3.0">
    
    <xsl:include href="define_all_pts.xsl"/>

    <!-- (there must be a better way to reuse a function than copying from start template and renaming here??) -->
    <xsl:function name="bmrxml:rda_iri_slug_ordering">
        <xsl:param name="path_to_iri"/>
        <xsl:value-of select="translate(substring-after($path_to_iri, 'Elements/'), '/', '_')"/>
    </xsl:function>

    <!-- *****create ordering bnodes***** -->
    <xsl:template name="create_ordering">
        <xsl:param name="sorted_property"/>
        <!-- create the 'ordering' bnode for each PT -->
        <xsl:for-each select="$sorted_property">
            <xsl:variable name="current_position" select="position()"/>
            <!-- create bnode to order PTs with first, rest -->
            <rdf:Description rdf:nodeID="{concat(bmrxml:rda_iri_slug_ordering(uwmaps:prop_iri/@iri),
                '_order')}">
                <rdf:first rdf:nodeID="{concat(bmrxml:rda_iri_slug_ordering(uwmaps:prop_iri/@iri),
                    '_define')}"/>
                <xsl:choose>
                    <xsl:when test="position() != last()">
                        <rdf:rest rdf:nodeID="{concat(
                            bmrxml:rda_iri_slug_ordering($sorted_property[position() = $current_position + 1]/uwmaps:prop_iri/@iri),
                            '_order')}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdf:rest rdf:resource="http://www.w3.org/1999/02/22-rdf-syntax-ns#nil"/>
                    </xsl:otherwise>
                </xsl:choose>
            </rdf:Description>
            <xsl:call-template name="define_all_pts">
                <xsl:with-param name="prop" select="."/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
