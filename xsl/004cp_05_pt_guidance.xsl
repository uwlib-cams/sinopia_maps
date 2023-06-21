<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:j="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs j" version="3.0"
    expand-text="true">
    
    <!-- CONTAINS PT_GUIDANCE TEMPLATE -->
    
    <xsl:template name="pt_guidance">
        <xsl:param name="prop"/>
        <xsl:param name="rt_id"/>
        <span class="ptInfoGuidance">
            <xsl:text>&#160;</xsl:text>
            <span class="caret"/>
            <ul class="nested">  
                
                <!-- general guidance -->
                <xsl:apply-templates
                    select="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:general/node()"/>
                
                <!-- entity_boundary -->
                <xsl:if test="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:entity_boundary">
                    <p>
                        <strong>NOTE: A significant difference in the value of this element may
                            indicate an entity boundary.</strong>
                    </p>
                </xsl:if>
                
                <!-- recording method -->
                <xsl:if test="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:recording_method">
                    <h5>RECORDING METHOD(S)</h5>
                    <p>Use the following recording method or methods (listed in order of preference):</p>
                    <ol>
                        <xsl:for-each select="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:recording_method/uwsinopia:recording_method_option">
                            <li>{.}</li>
                        </xsl:for-each>
                    </ol>
                </xsl:if>
                
                <!-- ses -->
                <xsl:if test="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:ses">
                    <h5>SYNTAX ENCODING SCHEME(S)</h5>
                    <xsl:apply-templates select="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:ses/node()"/>
                </xsl:if>
                
                <!-- transcription_standard -->
                <xsl:if test="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:transcription_standard">
                    <h5>TRANSCRIPTION STANDARD</h5>
                    <xsl:choose>
                        <xsl:when test="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:transcription_standard = 'basic'">
                            <p>Apply the 
                                <a href="https://access.rdatoolkit.org/Guidance/GuidanceById/a250ac26-e281-4285-b68b-5934bfe12cdc">
                                    guidelines on basic transcription
                                </a>.
                            </p>
                        </xsl:when>
                        <xsl:when test="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:transcription_standard = 'normalized'">
                            <p>Apply the 
                                <a href="https://access.rdatoolkit.org/Guidance/GuidanceById/b399fc77-84c9-4fe8-bccb-59b4dd37f948">
                                    guidelines on normalized transcription
                                </a>.
                            </p>
                        </xsl:when>
                        <xsl:otherwise>
                            <p>ERROR</p>
                        </xsl:otherwise>
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
                
                <!-- mgds -->
                <xsl:if test="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:mgds">
                    <h5>METADATA GUIDANCE DOCUMENTATION</h5>
                    <ul>
                        <xsl:for-each select="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:mgds/uwsinopia:mgd">
                            <xsl:call-template name="mgd_links">
                                <xsl:with-param name="title" select="."/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </ul>
                </xsl:if>
                
                <!-- examples -->
                <xsl:if test="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:examples">
                    <h5>EXAMPLE VALUE(S)</h5>
                    <xsl:apply-templates select="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:examples/node()"/>
                </xsl:if>
                
            </ul>
        </span>
    </xsl:template>
    
    <!-- template for getting links for mgds guidance -->
    <!-- pulls data from sinopia_maps/xml/mgd_docs.xml -->
    <xsl:template name="mgd_links">      
        <xsl:param name="title"/>
        <xsl:variable name="mgd_docs" select="(document('../xml/mgd_docs.xml')/data)"/>
        <xsl:variable name="uri" select="j:json-to-xml($mgd_docs)/j:array/j:map[j:string[@key = 'title'] = $title]/j:string[@key = 'uri']"/>
        <li>
            <a href="{$uri}">{$title}</a>
        </li>
    </xsl:template>
    
    <!-- GUIDANCE_SET CHILD-ELEMENT TEMPLATES -->
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