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
                <li>
                    <xsl:choose>
                        <xsl:when test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:alt_pt_label"
                            >{uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:alt_pt_label}</xsl:when>
                        <xsl:otherwise>{uwmaps:prop_label}</xsl:otherwise>
                    </xsl:choose>
                </li>
                
                <!-- TO DO -->
                <!-- link to details for each PT -->
                <!-- INCLUDED PROPS if multiple_prop -->
                <!-- decide how to display primary prop label if alt_label -->
                
                
                <!--
                                    <xsl:if test="
                                            uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:alt_pt_label"
                                        >{uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:alt_pt_label ||': '}</xsl:if>
                                    <a href="{concat('#', 
                                                uwmaps:sinopia/uwsinopia:implementation_set/@localid_implementation_set)}"
                                        >{uwmaps:prop_label}</a>
                                    <xsl:if test="
                                            $full_prop/uwmaps:sinopia/uwsinopia:implementation_set
                                            [uwsinopia:institution = $institution]
                                            [uwsinopia:resource = $resource]
                                            [uwsinopia:format = $format]
                                            [uwsinopia:user = $user]
                                            /uwsinopia:multiple_prop">
                                        <xsl:variable name="localid_implementation_set" select="
                                                uwmaps:sinopia/uwsinopia:implementation_set
                                                [uwsinopia:institution = $institution]
                                                [uwsinopia:resource = $resource]
                                                [uwsinopia:format = $format]
                                                [uwsinopia:user = $user]
                                                /@localid_implementation_set"/>
                                        <xsl:variable name="prop_iri" select="uwmaps:prop_iri/@iri"/>
                                        <ul>
                                            <xsl:for-each select="
                                                    $RT_RDFXML/rdf:RDF/rdf:Description
                                                    [rdf:type/@rdf:resource = 'http://sinopia.io/vocabulary/PropertyTemplate']
                                                    [sinopia:hasPropertyUri[position() = 1]/@rdf:resource = $prop_iri]
                                                    /sinopia:hasPropertyUri[position() > 1]">
                                                <xsl:variable name="repeating_prop_iri"
                                                  select="@rdf:resource"/>
                                                <li>
                                                  <a href="{concat('#',
                                                      $localid_implementation_set)}"
                                                  > {../..//rdf:Description[@rdf:about =
                                                  $repeating_prop_iri] /rdfs:label[@xml:lang =
                                                  'en']} </a>
                                                </li>
                                            </xsl:for-each>

                                        </ul>
                                    </xsl:if>
                                </li> 
                                -->
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