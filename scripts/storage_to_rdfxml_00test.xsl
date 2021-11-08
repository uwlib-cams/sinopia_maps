<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mapstor="https://uwlib-cams.github.io/map_storage/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:sin="http://sinopia.io/vocabulary/"
    exclude-result-prefixes="xs" version="3.0">
    <xsl:output method="xml" indent="yes"/>

    <!-- Import named templates -->
    <xsl:import href="storage_to_rdfxml_002_templates.xsl"/>

    <xsl:variable name="mapid_resource" select="'Manifestation'"/>
    <xsl:variable name="mapid_format" select="'monograph'"/>
    <xsl:variable name="mapid_user" select="'ries07'"/>

    <xsl:template match="/">
        <xsl:result-document
            href="{concat('../tests/', format-date(current-date(), '[Y0001]-[M01]-[D01]'), '.rdf')}">
            <rdf:RDF>
                <rdf:Description
                    rdf:about="{concat('https://api.stage.sinopia.io/resource/WAU_RT_RDA', 
                    $mapid_resource, '_', $mapid_format, '_', $mapid_user)}">
                    <rdf:type rdf:resource="http://sinopia.io/vocabulary/ResourceTemplate"/>
                    <sin:hasResourceTemplate>
                        <!-- Hard code the resource template for resource templates -->
                        <xsl:text>sinopia:template:resource</xsl:text>
                    </sin:hasResourceTemplate>
                    <sin:hasResourceId>
                        <xsl:value-of
                            select="concat('TEST_WAU_RT_RDA_', $mapid_resource, '_', $mapid_format, '_', $mapid_user)"/>
                    </sin:hasResourceId>
                    <!-- Call rtHasClass for sin:hasClass value -->
                    <xsl:call-template name="rtHasClass">
                        <xsl:with-param name="mapid_resource" select="$mapid_resource"/>
                    </xsl:call-template>
                    <rdfs:label>
                        <xsl:value-of
                            select="
                            concat('TEST WAU RT ', $mapid_resource, ' ', $mapid_format, ' ', $mapid_user)"/>
                    </rdfs:label>
                    <!-- Call rtHasAuthor for sin:hasAuthor value -->
                    <xsl:call-template name="rtHasAuthor">
                        <xsl:with-param name="mapid_user" select="$mapid_user"/>
                    </xsl:call-template>
                    <sin:hasDate>
                        <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
                    </sin:hasDate>
                    
                    <!-- ... -->

                    <!-- apply-templates to output PTs -->
                    <xsl:apply-templates select="
                            collection('../../map_storage/?select=*.xml')/
                            mapstor:propSet/mapstor:prop
                            [mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/
                            (: might want to pull props from multiple propSets into one MAP at some point,
                            matches allows for providing a regex in the var to match :)
                            mapstor:resource[matches(@mapid_resource, $mapid_resource)]
                            [mapstor:format[@mapid_format = $mapid_format]]
                            [mapstor:user[@mapid_user = $mapid_user]]]">
                        <xsl:sort select="
                                mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/
                                mapstor:resource/mapstor:form_order/@value"
                            data-type="number"/>
                    </xsl:apply-templates>
                </rdf:Description>
            </rdf:RDF>
        </xsl:result-document>
    </xsl:template>

    <!-- replace this with a template that actually outputs PTs -->
    <xsl:template match="mapstor:prop">
        <mapstor:prop_label>
            <xsl:value-of select="mapstor:prop_label"/>
        </mapstor:prop_label>
    </xsl:template>

</xsl:stylesheet>
