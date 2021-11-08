<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mapstor="https://uwlib-cams.github.io/map_storage/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:sin="http://sinopia.io/vocabulary/"
    exclude-result-prefixes="xs" version="3.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="mapid_resource" select="'^Manifestation$|^Expression$'"/>
    <xsl:variable name="mapid_format" select="'monograph'"/>
    <xsl:variable name="mapid_user" select="'ries07'"/>

    <xsl:template match="/">
        <are_these_props_sorted>
            <xsl:apply-templates select="
                    collection('../../map_storage/?select=*.xml')/
                    mapstor:propSet/mapstor:prop
                    [mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/
                    mapstor:resource[matches(@mapid_resource, $mapid_resource)]
                    [mapstor:format[@mapid_format = $mapid_format]]
                    [mapstor:user[@mapid_user = $mapid_user]]]">
                <xsl:sort select="
                        mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/
                        mapstor:resource/mapstor:form_order/@value"
                    data-type="number"/>
            </xsl:apply-templates>
        </are_these_props_sorted>
    </xsl:template>

    <xsl:template match="mapstor:prop">
        <prop_label>
            <xsl:value-of select="mapstor:prop_label"/>
        </prop_label>
    </xsl:template>

</xsl:stylesheet>
