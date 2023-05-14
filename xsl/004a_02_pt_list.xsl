<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" exclude-result-prefixes="xs" version="3.0"
    expand-text="true">
    
    <xsl:output method="html"/>
    
    <xsl:template name="pt_list">
        <xsl:param name="rt_id"/>
        <xsl:param name="prop"/>
        <h2 id="prop_list">PROPERTY TEMPLATES IN {$rt_id}</h2>
        <ul>
            <xsl:for-each select="$prop">
                <!-- TO DO decide how to display primary prop label if alt_label -->
                <li>
                    <xsl:choose>
                        <xsl:when test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:alt_pt_label"
                            >{uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:alt_pt_label}</xsl:when>
                        <xsl:otherwise>{uwmaps:prop_label}</xsl:otherwise>
                    </xsl:choose>
                </li>
                <!-- TO DO: 
                link to details for each PT
                if multiple_prop include all collapsible -->
            </xsl:for-each>
        </ul>
        <span class="backlink">
            <p>
                <a href="https://uwlib-cams.github.io/sinopia_maps/">
                    <xsl:text>RETURN TO SINOPIA_MAPS INDEX</xsl:text>
                </a>
            </p>
        </span>
    </xsl:template>
    
</xsl:stylesheet>