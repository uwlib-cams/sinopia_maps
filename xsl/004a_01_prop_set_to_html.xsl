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

    <xsl:include href="004a_02_pt_list.xsl"/>
    <xsl:include href="004a_03_pt_detail.xsl"/>
    <xsl:include href="https://uwlib-cams.github.io/webviews/xsl/CC0-footer.xsl"/>

    <xsl:template match="/">
        <xsl:for-each select="
                document('../xml/sinopia_maps.xml')/uwsinopia:sinopia_maps/uwsinopia:rts/
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
                </xsl:for-each>
            </xsl:variable>
            <xsl:result-document
                href="{concat($oxygenPath, 'html/', translate($rt_id, ':', '_'), 'a.html')}">
                <html>
                    <head>
                        <title>{concat(substring-after($resource, 'rda'), '_', $format, '_',
                            $user)}</title>
                        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                        <link href="https://uwlib-cams.github.io/webviews/css/UWSINOPIA_RTs.css"
                            rel="stylesheet" type="text/css"/>
                        <link href="https://uwlib-cams.github.io/webviews/images/book.png"
                            rel="icon" type="image/png"/>
                    </head>
                    <body>
                        <h1>{$rt_id}</h1>
                        <!-- ***** RT DETAILS ***** -->
                        <table>
                            <tbody>
                                <tr>
                                    <th scope="row">RESOURCE TEMPLATE ID</th>
                                    <td>{$rt_id}</td>
                                </tr>
                                <xsl:if test="$rt_remark != ''">
                                    <tr>
                                        <th scope="row">RESOURCE TEMPLATE REMARK</th>
                                        <td>{$rt_remark}</td>
                                    </tr>
                                </xsl:if>
                                <tr>
                                    <th scope="row">FOR DESCRIBING CLASS</th>
                                    <td>
                                        <a href="{$rt_rdfxml/rdf:RDF/rdf:Description
                                        [@rdf:about = concat('https://api.sinopia.io/resource/', $rt_id)]
                                        /sinopia:hasClass/@rdf:resource}"
                                            > {$rt_rdfxml/rdf:RDF/rdf:Description [@rdf:about =
                                            concat('https://api.sinopia.io/resource/', $rt_id)]
                                            /sinopia:hasClass/@rdf:resource}</a>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">FOR DESCRIBING FORMAT</th>
                                    <td>{$format}</td>
                                </tr>
                                <tr>
                                    <th scope="row">AUTHORED FOR USER/USER GROUP</th>
                                    <td>{$user}</td>
                                </tr>
                                <tr>
                                    <th scope="row">AUTHOR(S) INFORMATION</th>
                                    <td>
                                        <xsl:for-each select="$author/author">
                                            <xsl:choose>
                                                <xsl:when test="position() != last()">
                                                  <xsl:value-of select="concat(., ', ')"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of select="."/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">LAST UPDATED</th>
                                    <td>{$rt_rdfxml/rdf:RDF/rdf:Description [@rdf:about =
                                        concat('https://api.sinopia.io/resource/', $rt_id)]
                                        /sinopia:hasDate}</td>
                                </tr>
                            </tbody>
                        </table>
                        <span class="backlink">
                            <p>
                                <a href="https://uwlib-cams.github.io/sinopia_maps/">
                                    <xsl:text>RETURN TO SINOPIA_MAPS INDEX</xsl:text>
                                </a>
                            </p>
                        </span>
                        <xsl:call-template name="pt_list">
                            <xsl:with-param name="rt_id" select="$rt_id"/>
                            <xsl:with-param name="prop" select="$prop_info"/>
                        </xsl:call-template>
                        <xsl:call-template name="pt_detail">
                            <xsl:with-param name="rt_id" select="$rt_id"/>
                            <xsl:with-param name="rt_rdfxml" select="$rt_rdfxml"/>
                            <xsl:with-param name="prop" select="$prop_info"/>
                        </xsl:call-template>
                        <xsl:call-template name="CC0-footer">
                            <xsl:with-param name="resource_title"
                                select="translate($rt_id, ':', '_')"/>
                            <xsl:with-param name="org" select="'cams'"/>
                        </xsl:call-template>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
