<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" exclude-result-prefixes="xs" version="3.0"
    expand-text="true">
    
    <xsl:output method="html"/>
    <xsl:param name="oxygenPath"/>
    
    <!-- included xsl sheets -->
    <xsl:include href="004a_02_formatStrings.xsl"/>
    <xsl:include href="004cp_02_pt_list.xsl"/>
    
    <xsl:template match="/">
        <!-- get all necessary variables from prop_set files -->
        <!-- for each RT -->
        <!-- TEST change to sinopia_maps.xml before publishing -->
        <xsl:for-each select="
            document('../xml/test.xml')/uwsinopia:sinopia_maps/uwsinopia:rts/
            uwsinopia:rt[matches(@output_load, 'true|1')]">
            <xsl:variable name="institution" select="uwsinopia:institution"/>
            <xsl:variable name="resource" select="uwsinopia:resource"/>
            <xsl:variable name="format" select="uwsinopia:format"/>
            <xsl:variable name="user" select="uwsinopia:user"/>
            <xsl:variable name="rt_id">{concat('UWSINOPIA:', $institution, ':', $resource, ':',
                $format, ':', $user)}</xsl:variable>
            <xsl:variable name="author">
                <xsl:for-each select="uwsinopia:author">
                    <author>{.}</author>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="rt_remark" select="uwsinopia:rt_remark[@xml:lang = 'en']"/>
            <xsl:variable name="rt_rdfxml" select="
                document(concat('../', translate($rt_id, ':', '_'), '.rdf'))"/>
            <!-- prop_info: select needed guidance_set elements, implementation_set for each prop/PT -->
            <xsl:variable name="prop_info" as="node()*">
                <!-- for each prop in RT -->
                <xsl:for-each select=" 
                    collection('../../map_storage/?select=*.xml')/
                    uwmaps:prop_set/uwmaps:prop
                    [uwmaps:sinopia/uwsinopia:implementation_set
                    [uwsinopia:institution = $institution]
                    [uwsinopia:resource = $resource]
                    [uwsinopia:format = $format]
                    [uwsinopia:user = $user]]">
                    <xsl:sort select="
                        uwmaps:sinopia/uwsinopia:implementation_set
                        [uwsinopia:institution = $institution]
                        [uwsinopia:resource = $resource]
                        [uwsinopia:format = $format]
                        [uwsinopia:user = $user]
                        /uwsinopia:form_order"/>
                    <xsl:element name="prop"
                        namespace="https://uwlib-cams.github.io/map_storage/xsd/">
                        <xsl:attribute name="localid_prop">{uwmaps/@localid_prop}</xsl:attribute>
                        <xsl:copy-of select="uwmaps:prop_iri"/>
                        <xsl:copy-of select="uwmaps:prop_label"/>
                        <!-- skip some prop info -->
                        <!-- switch to uwsinopia namespace from here down -->
                        <xsl:element name="sinopia"
                            namespace="https://uwlib-cams.github.io/map_storage/xsd/">
                            <xsl:element name="toolkit"
                                namespace="https://uwlib-cams.github.io/sinopia_maps/xsd/">
                                <xsl:attribute name="url"
                                    >{uwmaps:sinopia/uwsinopia:toolkit/@url}</xsl:attribute>
                            </xsl:element>
                            <!-- guidance_set -->
                            <xsl:if test="uwmaps:sinopia/uwsinopia:guidance_set">
                                <xsl:element name="guidance_set"
                                    namespace="https://uwlib-cams.github.io/sinopia_maps/xsd/">
                                    <!-- general -->
                                    <xsl:if
                                        test="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:general">
                                        <xsl:element name="general"
                                            namespace="https://uwlib-cams.github.io/sinopia_maps/xsd/">
                                            <xsl:choose>
                                                <xsl:when test="
                                                    uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:general
                                                    [@rt_id = $rt_id]">
                                                    <xsl:for-each select="
                                                        uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:general
                                                        [@rt_id = $rt_id]/node()">
                                                        <xsl:copy-of copy-namespaces="no" select="."/>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:for-each select="
                                                        uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:general
                                                        [@rt_id = 'default']/node()">
                                                        <xsl:copy-of copy-namespaces="no" select="."/>
                                                    </xsl:for-each>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:element>
                                    </xsl:if>
                                    <!-- entity_boundary -->
                                    <xsl:if
                                        test="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:entity_boundary">
                                        <xsl:copy-of copy-namespaces="no"
                                            select="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:entity_boundary"
                                        />
                                    </xsl:if>
                                    <!-- recording_method -->
                                    <xsl:if
                                        test="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:recording_method">
                                        <xsl:element name="recording_method"
                                            namespace="https://uwlib-cams.github.io/sinopia_maps/xsd/">
                                            <xsl:choose>
                                                <xsl:when test="
                                                    uwmaps:sinopia/uwsinopia:guidance_set
                                                    /uwsinopia:recording_method[@rt_id = $rt_id]">
                                                    <xsl:for-each select="
                                                        uwmaps:sinopia/uwsinopia:guidance_set
                                                        /uwsinopia:recording_method[@rt_id = $rt_id]/uwsinopia:recording_method_option">
                                                        <xsl:copy-of copy-namespaces="no" select="."/>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:for-each select="
                                                        uwmaps:sinopia/uwsinopia:guidance_set
                                                        /uwsinopia:recording_method[@rt_id = 'default']/uwsinopia:recording_method_option">
                                                        <xsl:copy-of copy-namespaces="no" select="."/>
                                                    </xsl:for-each>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:element>
                                    </xsl:if>
                                    <!-- ses -->
                                    <xsl:if
                                        test="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:ses">
                                        <xsl:element name="ses"
                                            namespace="https://uwlib-cams.github.io/sinopia_maps/xsd/">
                                            <xsl:choose>
                                                <xsl:when test="
                                                    uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:ses
                                                    [@rt_id = $rt_id]">
                                                    <xsl:for-each select="
                                                        uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:ses
                                                        [@rt_id = $rt_id]/node()">
                                                        <xsl:copy-of copy-namespaces="no" select="."/>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:for-each select="
                                                        uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:ses
                                                        [@rt_id = 'default']/node()">
                                                        <xsl:copy-of copy-namespaces="no" select="."/>
                                                    </xsl:for-each>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:element>
                                    </xsl:if>
                                    <!-- transcription_standard -->
                                    <xsl:if
                                        test="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:transcription_standard">
                                        <xsl:element name="transcription_standard"
                                            namespace="https://uwlib-cams.github.io/sinopia_maps/xsd/">
                                            <xsl:choose>
                                                <xsl:when test="
                                                    uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:transcription_standard
                                                    [@rt_id = $rt_id]">
                                                    <xsl:copy-of copy-namespaces="no" select="
                                                        uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:transcription_standard
                                                        [@rt_id = $rt_id]"
                                                    />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:copy-of copy-namespaces="no" select="
                                                        uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:transcription_standard
                                                        [@rt_id = 'default']"
                                                    />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:element>
                                    </xsl:if>
                                    <!-- options -->
                                    <xsl:if
                                        test="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:options">
                                        <xsl:element name="options"
                                            namespace="https://uwlib-cams.github.io/sinopia_maps/xsd/">
                                            <xsl:choose>
                                                <xsl:when test="
                                                    uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:options
                                                    [@rt_id = $rt_id]">
                                                    <xsl:for-each select="
                                                        uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:options
                                                        [@rt_id = $rt_id]/node()">
                                                        <xsl:copy-of copy-namespaces="no" select="."/>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:for-each select="
                                                        uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:options
                                                        [@rt_id = 'default']/node()">
                                                        <xsl:copy-of copy-namespaces="no" select="."/>
                                                    </xsl:for-each>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:element>
                                    </xsl:if>
                                    <!-- TO DO mgds, following schema implementation -->
                                    <!-- examples -->
                                    <xsl:if
                                        test="uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:examples">
                                        <xsl:element name="examples"
                                            namespace="https://uwlib-cams.github.io/sinopia_maps/xsd/">
                                            <xsl:choose>
                                                <xsl:when test="
                                                    uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:examples
                                                    [@rt_id = $rt_id]">
                                                    <xsl:for-each select="
                                                        uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:examples
                                                        [@rt_id = $rt_id]/node()">
                                                        <xsl:copy-of copy-namespaces="no" select="."/>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:for-each select="
                                                        uwmaps:sinopia/uwsinopia:guidance_set/uwsinopia:examples
                                                        [@rt_id = 'default']/node()">
                                                        <xsl:copy-of copy-namespaces="no" select="."/>
                                                    </xsl:for-each>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:if>
                            <xsl:copy-of select="
                                uwmaps:sinopia/uwsinopia:implementation_set
                                [uwsinopia:institution = $institution]
                                [uwsinopia:resource = $resource]
                                [uwsinopia:format = $format]
                                [uwsinopia:user = $user]"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each> <!-- for each prop in RT -->
            </xsl:variable>
            
            <xsl:result-document
                href="{concat($oxygenPath, 'html/', translate($rt_id, ':', '_'), 'cp.html')}">
                <html>
                    <head>
                        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                        <title>
                            <xsl:text>UW Sinopia resource template | </xsl:text>
                            <xsl:call-template name="format_formats">
                                <xsl:with-param name="format" select="$resource"/>
                                <xsl:with-param name="case" select="'title'"/>
                            </xsl:call-template>
                        </title>
                        <link
                            href="https://uwlib-cams.github.io/webviews/css/rda3r_templates.css"
                            rel="stylesheet" type="text/css"/>
                        <link href="https://uwlib-cams.github.io/webviews/images/book.png"
                            rel="icon" type="image/png"/>
                    </head>
                    <body>
                        <h1 id="profile">
                            <xsl:text>University of Washington Libraries Sinopia Resource Template(s) for </xsl:text>
                            <xsl:call-template name="format_resources">
                                <xsl:with-param name="resource" select="$resource"/>
                            </xsl:call-template>
                            <xsl:text> </xsl:text>
                            <xsl:call-template name="format_formats">
                                <xsl:with-param name="format" select="$format"/>
                                <xsl:with-param name="case" select="'title'"/>
                            </xsl:call-template>
                        </h1>
                        <xsl:call-template name="pt_list">
                            <xsl:with-param name="rt_id" select="$rt_id"/>
                            <xsl:with-param name="prop" select="$prop_info"/>
                        </xsl:call-template>
                        <script type="text/javascript" src="create_human_readable_RTs-collapsible.js"/>
                    </body>
                </html>
                
                
            </xsl:result-document>
        </xsl:for-each> <!-- for each RT -->
        
    </xsl:template>
</xsl:stylesheet>