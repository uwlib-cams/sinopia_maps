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
        <xsl:param name="rt_rdfxml"/>
        <xsl:param name="prop"/>
        <h2>PROPERTY TEMPLATE GUIDANCE AND CONFIGURATION</h2>
        <xsl:for-each select="$prop">
            <h3 id="{uwmaps:sinopia/uwsinopia:implementation_set/@localid_implementation_set}">
                <xsl:choose>
                    <xsl:when
                        test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:alt_pt_label"
                        >{uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:alt_pt_label}</xsl:when>
                    <xsl:otherwise>{uwmaps:prop_label}</xsl:otherwise>
                </xsl:choose>
            </h3>
            
            <!-- TO DO:
            need all props available in PT here, with Toolkit link and Registry link for each -->
            
            <!-- ******** GUIDANCE_SET ******** -->
            <xsl:if test="uwmaps:sinopia/uwsinopia:guidance_set">
                <h4>GUIDANCE</h4>
                <!-- TO DO
                add remark if available -->
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
                <xsl:if test="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:recording_method">
                    <h5>RECORDING METHOD(S)</h5>
                    <p>Use the following recording method or methods, in order of preference (first
                        choice, second choice, etc.)</p>
                    <ol>
                        <xsl:for-each select="
                                uwmaps:sinopia/uwsinopia:guidance_set
                                /uwsinopia:recording_method/uwsinopia:recording_method_option"
                            >{.}</xsl:for-each>
                    </ol>
                </xsl:if>
                <!-- ses -->
                <xsl:if test="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:ses">
                    <h5>SYNTAX ENCODING SCHEME(S)</h5>
                    <xsl:apply-templates
                        select="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:ses/node()"/>
                </xsl:if>
                <!-- transcription_standard -->
                <xsl:if test="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:transcription_standard">
                    <h5>TRANSCRIPTION STANDARD</h5>
                    <xsl:choose>
                        <xsl:when test="uwmaps:sinopia/uwsinopia:guidance_set
                            /uwsinopia:transcription_standard = 'basic'">
                            <p>Apply the <a 
                                href="https://access.rdatoolkit.org/Guidance/GuidanceById/a250ac26-e281-4285-b68b-5934bfe12cdc"
                                >guidelines on basic transcription</a>.</p>
                        </xsl:when>
                        <xsl:when test="uwmaps:sinopia/uwsinopia:guidance_set
                            /uwsinopia:transcription_standard = 'normalized'">
                            <p>Apply the <a 
                                href="https://access.rdatoolkit.org/Guidance/GuidanceById/b399fc77-84c9-4fe8-bccb-59b4dd37f948"
                                >guidelines on normalized transcription</a>.</p>
                        </xsl:when>
                        <xsl:otherwise><p>ERROR</p></xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <!-- options -->
                <xsl:if test="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:options">
                    <h5>OPTION(S)</h5>
                    <p>The following options may be applied:</p>
                    <ul>
                    <xsl:for-each select="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:options/uwsinopia:a">
                        <li>
                            <a href="{@href}">{.}</a>
                        </li>
                    </xsl:for-each>
                    </ul>
                </xsl:if>
                <!-- TO DO mgds, following schema implementation -->
                <!-- examples -->
                <xsl:if test="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:examples">
                    <h5>EXAMPLE VALUE(S)</h5>
                    <xsl:apply-templates select="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:examples/node()"/>
                </xsl:if>
            </xsl:if>
            
            <!-- ******** IMPLEMENTATION_SET ******** -->
            <h4>CONFIGURATION</h4>
            
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
