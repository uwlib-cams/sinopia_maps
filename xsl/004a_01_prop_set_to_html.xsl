<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" exclude-result-prefixes="xs" version="3.0"
    expand-text="true">

    <xsl:output method="html"/>
    <!-- <xsl:param name="oxygenPath"/> -->
    <xsl:include href="https://uwlib-cams.github.io/webviews/xsl/CC0-footer.xsl"/>

    <xsl:template match="/">
        <xsl:for-each select="
                document('../xml/sinopia_maps.xml')/uwsinopia:sinopia_maps/uwsinopia:rts/
                uwsinopia:rt[matches(@output_load, 'true|1')]">
            <xsl:variable name="institution" select="uwsinopia:institution"/>
            <xsl:variable name="resource" select="uwsinopia:resource"/>
            <xsl:variable name="format" select="uwsinopia:format"/>
            <xsl:variable name="user" select="uwsinopia:user"/>
            <xsl:variable name="author" select="uwsinopia:author"/>
            <xsl:variable name="rt_remark" select="uwsinopia:rt_remark[@xml:lang = 'en']"/>
            <xsl:variable name="RT_ID" select="
                    concat('UWSINOPIA:', $institution, ':', $resource, ':', $format, ':', $user)"/>
            <xsl:variable name="RT_RDFXML" select="
                    document(concat('../', translate($RT_ID, ':', '_'), '.rdf'))"/>
            <xsl:variable name="sorted_properties" as="node()*">
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
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:result-document href="{concat('../html/', translate($RT_ID, ':', '_'), '.html')}">
                <html>
                    <head>
                        <title>{concat(substring-after($resource, 'rda'), '_', $format, '_',
                            $user)}</title>
                        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                        <!-- TO DO switch to use webviews css [!] -->
                        <link href="../../webviews/css/UWSINOPIA_RTs.css" rel="stylesheet"
                            type="text/css"/>
                        <link href="https://uwlib-cams.github.io/webviews/images/book.png"
                            rel="icon" type="image/png"/>
                    </head>
                    <body>
                        <h1>{$RT_ID}</h1>
                        <table>
                            <thead>
                                <tr>
                                    <th scope="row">RESOURCE TEMPLATE ID</th>
                                    <td>{$RT_ID}</td>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:if test="$rt_remark != ''">
                                    <tr>
                                        <th scope="row">RESOURCE TEMPLATE REMARK</th>
                                        <td>{$rt_remark}</td>
                                    </tr>
                                </xsl:if>
                                <tr>
                                    <th scope="row">FOR DESCRIBING INSTANCES OF CLASS</th>
                                    <td>
                                        <a href="{$RT_RDFXML/rdf:RDF/rdf:Description
                                        [@rdf:about = concat('https://api.sinopia.io/resource/', $RT_ID)]
                                        /sinopia:hasClass/@rdf:resource}"
                                            > {$RT_RDFXML/rdf:RDF/rdf:Description [@rdf:about =
                                            concat('https://api.sinopia.io/resource/', $RT_ID)]
                                            /sinopia:hasClass/@rdf:resource}</a>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">FOR DESCRIBING FORMAT</th>
                                    <td>{$format}</td>
                                </tr>
                                <tr>
                                    <th scope="row">DEFINED BY USER/USER GROUP</th>
                                    <td>{$user}</td>
                                </tr>
                                <tr>
                                    <th scope="row">AUTHOR</th>
                                    <td>{$author}</td>
                                </tr>
                                <tr>
                                    <th scope="row">LAST UPDATED</th>
                                    <td>{$RT_RDFXML/rdf:RDF/rdf:Description [@rdf:about =
                                        concat('https://api.sinopia.io/resource/', $RT_ID)]
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
                        <h2>PROPERTY TEMPLATES IN {$RT_ID}</h2>
                        <ul>
                            <xsl:for-each select="$sorted_properties">
                                <xsl:choose>
                                    <xsl:when test="
                                            uwmaps:sinopia/uwsinopia:implementation_set
                                            [uwsinopia:institution = $institution]
                                            [uwsinopia:resource = $resource]
                                            [uwsinopia:format = $format]
                                            [uwsinopia:user = $user]
                                            /uwsinopia:alt_pt_label">
                                        <li>{uwmaps:sinopia/uwsinopia:implementation_set
                                            [uwsinopia:institution = $institution]
                                            [uwsinopia:resource = $resource] [uwsinopia:format =
                                            $format] [uwsinopia:user = $user]
                                            /uwsinopia:alt_pt_label}</li>
                                        <ul>
                                            <li>
                                                <a href="{concat('#', 
                                                uwmaps:sinopia/uwsinopia:implementation_set
                                                [uwsinopia:institution = $institution]
                                                [uwsinopia:resource = $resource]
                                                [uwsinopia:format = $format]
                                                [uwsinopia:user = $user]
                                                /@localid_implementation_set)}"
                                                  > {uwmaps:prop_label} </a>
                                                <!-- add xsl:if for multiple_prop -->
                                            </li>
                                        </ul>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <li>
                                            <a href="{concat('#', 
                                            uwmaps:sinopia/uwsinopia:implementation_set
                                            [uwsinopia:institution = $institution]
                                            [uwsinopia:resource = $resource]
                                            [uwsinopia:format = $format]
                                            [uwsinopia:user = $user]
                                            /@localid_implementation_set)}"
                                                > {uwmaps:prop_label} </a>
                                        </li>
                                        <!-- add xsl:if for multiple_prop -->
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                            <xsl:if test="
                                    $RT_RDFXML/rdf:RDF/rdf:Description
                                    [rdf:type/@rdf:resource = 'http://sinopia.io/vocabulary/PropertyTemplate']
                                    /sinopia:hasPropertyUri[position() = 1]
                                    [@rdf:resource = $sorted_properties/uwmaps:prop_iri]
                                    /following-sibling::sinopia:hasPropertyUri">
                                <xsl:for-each select="
                                        $RT_RDFXML/rdf:RDF/rdf:Description
                                        [rdf:type/@rdf:resource = 'http://sinopia.io/vocabulary/PropertyTemplate']
                                        /sinopia:hasPropertyUri[position() > 1]">
                                    <xsl:variable name="prop_iri" select="@rdf:resource"/>
                                    <li>{//rdf:Description[@rdf:about =
                                        $prop_iri]/rdfs:label[@xml:lang = 'en']}</li>
                                </xsl:for-each>
                            </xsl:if>
                        </ul>

                        <xsl:call-template name="CC0-footer">
                            <xsl:with-param name="resource_title"
                                select="translate($RT_ID, ':', '_')"/>
                            <xsl:with-param name="org" select="'cams'"/>
                        </xsl:call-template>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
