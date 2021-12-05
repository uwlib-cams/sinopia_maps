<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mapstor="https://uwlib-cams.github.io/map_storage/"
    xmlns:uwlsinopia="https://uwlib-cams.github.io/sinopia_maps/"
    xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:bmrxml="https://briesenberg07.github.io/xml_stack/" exclude-result-prefixes="xs"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:include href="storage_to_rdfxml_templates.xsl"/>

    <!-- there must be a better way to reuse a function than copying and renaming in included stylesheet? -->
    <xsl:function name="bmrxml:rda_iri_slug">
        <xsl:param name="path_to_iri"/>
        <xsl:value-of select="translate(substring-after($path_to_iri, 'Elements/'), '/', '_')"/>
    </xsl:function>

    <xsl:template match="/">
        <xsl:for-each select="document('../sinopia_maps.xml')/uwlsinopia:maps/uwlsinopia:rts/uwlsinopia:rt">
            <!-- vars in root template -->
            <xsl:variable name="propSet" select="uwlsinopia:propSet"/>
            <xsl:variable name="resource" select="uwlsinopia:resource"/>
            <xsl:variable name="format" select="uwlsinopia:format"/>
            <xsl:variable name="user" select="uwlsinopia:user"/>
            <!-- to do remove 'TEST' in rt_id to output for production -->
            <xsl:variable name="rt_id"
                select="concat('TEST:WAU:', $resource, ':', $format, ':', $user)"/>
            <xsl:variable name="sorted_property" as="node()*">
                <!-- low-priority to do is gain better understanding of 'as="node()*"' syntax -->
                <xsl:for-each select="
                        (: [!] fn:document won't work for pulling from multiple propSets,
                        need fn:collection, etc. [!] 
                        also doc XPath will need to change once I'm not using test propSets :)
                        document(concat('../../map_storage/test_propSet_', $propSet, '.xml'))/
                        mapstor:propSet/mapstor:prop
                        [mapstor:sinopia/mapstor:implementationSet
                        [mapstor:resource/@mapid_resource = $resource]
                        [mapstor:format = $format]
                        [mapstor:user = $user]]">
                    <xsl:sort select="
                            mapstor:sinopia/mapstor:implementationSet/mapstor:form_order"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:variable>
            <!-- to do change result-document path for production -->
            <!-- underscores for RT filename, spaces for RT label -->
            <xsl:result-document href="../tests/{translate($rt_id, ':', '_')}.rdf">
                <rdf:RDF>
                    <xsl:call-template name="start_rdf_map">
                        <!-- to do: propSet param will not work as-is for pulling from multiple prop sets -->
                        <xsl:with-param name="propSet" select="$propSet"/>
                        <xsl:with-param name="resource" select="$resource"/>
                        <xsl:with-param name="format" select="$format"/>
                        <xsl:with-param name="user" select="$user"/>
                        <xsl:with-param name="rt_id" select="$rt_id"/>
                        <xsl:with-param name="sorted_property" select="$sorted_property"/>
                    </xsl:call-template>
                    <xsl:call-template name="property_templates_start">
                        <xsl:with-param name="sorted_property" select="$sorted_property"/>
                    </xsl:call-template>
                </rdf:RDF>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="start_rdf_map">
        <xsl:param name="propSet"/>
        <xsl:param name="resource"/>
        <xsl:param name="format"/>
        <xsl:param name="user"/>
        <xsl:param name="rt_id"/>
        <xsl:param name="sorted_property"/>
        <rdf:Description
            rdf:about="{concat('https://api.development.sinopia.io/resource/', $rt_id)}">
            <!-- to do: output remark in RT description -->
            <rdf:type rdf:resource="http://sinopia.io/vocabulary/ResourceTemplate"/>
            <sinopia:hasResourceTemplate>sinopia:template:resource</sinopia:hasResourceTemplate>
            <xsl:call-template name="rt_HasClass">
                <xsl:with-param name="resource" select="$resource"/>
            </xsl:call-template>
            <sinopia:hasResourceId>
                <xsl:value-of select="$rt_id"/>
            </sinopia:hasResourceId>
            <rdfs:label>
                <!-- underscores for RT filename, spaces for RT label -->
                <xsl:value-of select="translate($rt_id, ':', ' ')"/>
            </rdfs:label>
            <sinopia:hasAuthor>
                <xsl:value-of select="uwlsinopia:author"/>
            </sinopia:hasAuthor>
            <sinopia:hasDate>
                <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
            </sinopia:hasDate>
            <!-- [!] use of rda_iri_slug is RDA-Registry-specific -->
            <sinopia:hasPropertyTemplate
                rdf:nodeID="{concat(bmrxml:rda_iri_slug($sorted_property[position() = 1]/mapstor:prop_iri/@iri),
                        '_order')}"/>
        </rdf:Description>
    </xsl:template>

</xsl:stylesheet>
