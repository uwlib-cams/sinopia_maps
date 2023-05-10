<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" exclude-result-prefixes="xs" version="3.0"
    expand-text="true">

    <xsl:template name="pt_detail">
        <xsl:param name="rt_id"/>
        <xsl:param name="prop"/>
        <h2>PROPERTY TEMPLATE GUIDANCE AND CONFIGURATION</h2>
        <xsl:for-each select="$prop">
            <h3 id="{$prop/uwmaps:sinopia/uwsinopia:implementation_set/@localid_implementation_set}">
                <xsl:choose>
                    <xsl:when
                        test="$prop/uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:alt_pt_label"
                        >{$prop/uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:alt_pt_label}</xsl:when>
                    <xsl:otherwise>{$prop/uwmaps:prop_label}</xsl:otherwise>
                </xsl:choose>
            </h3>
            <p>SEE</p>
            <ul>
                <li>
                    <a href="{uwmaps:sinopia/uwsinopia:toolkit/@url}">RDA Toolkit element page</a>
                </li>
                <li>
                    <a href="{uwmaps:prop_iri/@iri}">RDA Registry property detail</a>
                </li>
            </ul>
            <!-- ******** GUIDANCE_SET ******** -->
            <xsl:if test="uwmaps:sinopia/uwsinopia:guidance_set">
                <h4>GUIDANCE</h4>
                <!-- general -->
                    <xsl:apply-templates
                        select="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:general/node()"/>
                <!-- entity_boundary -->
                <xsl:if test="
                        uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:entity_boundary">
                    <p>
                        <strong>NOTE: A significant difference in the value of this element may
                            indicate an entity boundary.</strong>
                    </p>
                </xsl:if>
                <!-- recording method -->
                <xsl:if
                    test="uwmaps:sinopia/uwsinopia:guidance_set/sinopia:recording_method">
                    <h5>RECORDING METHOD(S)</h5>
                    <p>Use the following recording method or methods, in order of preference (first
                        choice, second choice, etc.)</p>
                    <ol>
                        <xsl:for-each select="
                                uwmaps:sinopia/uwsinopia:guidance_set
                                /uwsinopia:recording_method/recording_method_option"
                            >{.}</xsl:for-each>
                    </ol>
                </xsl:if>
                <!-- ses -->

                <p>more stuff to go here</p>
            </xsl:if>
            <h4>CONFIGURATION</h4>
            <p>stuff will go here</p>
            <span class="backlink">
                <p>
                    <a href="#prop_list">RETURN TO PROPERTY TEMPLATES LIST</a>
                </p>
                <p>
                    <a href="https://uwlib-cams.github.io/sinopia_maps/">
                        <xsl:text>RETURN TO SINOPIA_MAPS INDEX</xsl:text>
                    </a>
                </p>
            </span>
        </xsl:for-each>
    </xsl:template>

    <!-- ***** GUIDANCE_SET CHILD-ELEMENT TEMPLATES -->
    <xsl:template match="uwsinopia:p">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="uwsinopia:strong">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="uwsinopia:ul">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="uwsinopia:ol">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="uwsinopia:li">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="uwsinopia:a">
        <a href="{@href}">
            <xsl:value-of select="."/>
        </a>
    </xsl:template>

</xsl:stylesheet>
