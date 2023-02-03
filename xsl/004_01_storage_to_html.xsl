<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:sinopia="http://sinopia.io/vocabulary/"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="html"/>

    <xsl:include href="004_02_formatStrings.xsl"/>
    <xsl:include href="004_03_readComments.xsl"/>
    <xsl:include href="004_04_qaSources.xsl"/>

    <xsl:template match="/">
        <xsl:for-each
            select="document('../xml/sinopia_maps.xml')/uwsinopia:sinopia_maps/uwsinopia:rts/uwsinopia:rt[matches(@output_load, 'true|1')]">
            <xsl:variable name="institution" select="uwsinopia:institution"/>
            <xsl:variable name="resource" select="uwsinopia:resource"/>
            <xsl:variable name="format" select="uwsinopia:format"/>
            <xsl:variable name="user" select="uwsinopia:user"/>
            <xsl:variable name="author" select="uwsinopia:author"/>
            <xsl:variable name="file_name"
                select="concat('UWSINOPIA_', $institution, '_', $resource, '_', $format, '_', $user)"/>
            <xsl:choose>
                <xsl:when test="$format!='na'">
                    <xsl:result-document href="../html/{$file_name}.html">
                        <html>
                            <head>
                                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                                <title>
                                    <xsl:value-of
                                        select="concat('UW Sinopia resource templates | ', $format)"/>
                                </title>
                                <link href="mockups.css" rel="stylesheet" type="text/css"/>
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
                                <xsl:call-template name="rt_list">
                                    <xsl:with-param name="institution" select="$institution"/>
                                    <xsl:with-param name="resource" select="$resource"/>
                                    <xsl:with-param name="format" select="$format"/>
                                    <xsl:with-param name="user" select="$user"/>
                                    <xsl:with-param name="author" select="$author"/>
                                </xsl:call-template>
                                <xsl:call-template name="rtInfo">
                                    <xsl:with-param name="institution" select="$institution"/>
                                    <xsl:with-param name="resource" select="$resource"/>
                                    <xsl:with-param name="format" select="$format"/>
                                    <xsl:with-param name="user" select="$user"/>
                                    <xsl:with-param name="author" select="$author"/>
                                </xsl:call-template>
                                <xsl:call-template name="ptList">
                                    <xsl:with-param name="institution" select="$institution"/>
                                    <xsl:with-param name="resource" select="$resource"/>
                                    <xsl:with-param name="format" select="$format"/>
                                    <xsl:with-param name="user" select="$user"/>
                                    <xsl:with-param name="author" select="$author"/>
                                </xsl:call-template>
                                <script type="text/javascript" src="create_human_readable_RTs-collapsible.js">&amp;#160;</script>
                            </body>
                        </html>
                    </xsl:result-document>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:result-document href="../html/{$file_name}.html">
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
                                <link href="mockups.css" rel="stylesheet" type="text/css"/>
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
                                <xsl:call-template name="rt_list">
                                    <xsl:with-param name="institution" select="$institution"/>
                                    <xsl:with-param name="resource" select="$resource"/>
                                    <xsl:with-param name="format" select="$format"/>
                                    <xsl:with-param name="user" select="$user"/>
                                    <xsl:with-param name="author" select="$author"/>
                                </xsl:call-template>
                                <xsl:call-template name="rtInfo">
                                    <xsl:with-param name="institution" select="$institution"/>
                                    <xsl:with-param name="resource" select="uwsinopia:resource"/>
                                    <xsl:with-param name="format" select="$format"/>
                                    <xsl:with-param name="user" select="$user"/>
                                    <xsl:with-param name="author" select="uwsinopia:author"/>
                                </xsl:call-template>
                                <xsl:call-template name="ptList">
                                    <xsl:with-param name="institution" select="$institution"/>
                                    <xsl:with-param name="resource" select="uwsinopia:resource"/>
                                    <xsl:with-param name="format" select="$format"/>
                                    <xsl:with-param name="user" select="$user"/>
                                    <xsl:with-param name="author" select="uwsinopia:author"/>
                                </xsl:call-template>
                                <script type="text/javascript" src="create_human_readable_RTs-collapsible.js">&amp;#160;</script>
                            </body>
                            
                        </html>
                    </xsl:result-document>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="profileInfo">
        <xsl:param name="institution"/>
        <xsl:param name="resource"/>
        <xsl:param name="format"/>
        <xsl:param name="user"/>
        <xsl:param name="author"/>
        <xsl:for-each
            select="document('../xml/sinopia_maps.xml')/uwsinopia:sinopia_maps/uwsinopia:rts/uwsinopia:rt[uwsinopia:institution = $institution and uwsinopia:format = $format and uwsinopia:user = $user]">
            <table class="profileInfo">
                <thead>
                    <tr>
                        <th colspan="2">
                            <xsl:text>RT: </xsl:text>
                            <xsl:value-of select="$institution"/>
                            <xsl:text> RT RDA for </xsl:text>
                            <xsl:call-template name="format_resources">
                                <xsl:with-param name="resource" select="uwsinopia:resource"/>
                            </xsl:call-template>
                            <xsl:text> </xsl:text>
                            <xsl:call-template name="format_formats">
                                <xsl:with-param name="format" select="$format"/>
                                <xsl:with-param name="case" select="'title'"/>
                            </xsl:call-template>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <th scope="row">ID</th>
                        <td>
                            <xsl:value-of
                                select="concat('UWSINOPIA:', uwsinopia:institution, ':', uwsinopia:resource, ':', $format, ':', $user)"
                            />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Author</th>
                        <td>
                            <xsl:value-of select="uwsinopia:author"/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Last Updated</th>
                        <td>
                            <xsl:value-of
                                select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Description</th>
                        <td>
                            <xsl:text>Resource templates and property templates for </xsl:text>
                            <xsl:call-template name="format_formats">
                                <xsl:with-param name="format" select="$format"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Schema</th>
                        <!-- I imagine this link needs to be updated? -->
                        <td>
                            <a href="https://ld4p.github.io/sinopia/schemas/0.2.1/profile.json">
                                <xsl:text>https://ld4p.github.io/sinopia/schemas/0.2.1/profile.json</xsl:text>
                            </a>
                        </td>
                    </tr>
                </tbody>
            </table>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="rt_list">
        <xsl:param name="institution"/>
        <xsl:param name="resource"/>
        <xsl:param name="format"/>
        <xsl:param name="user"/>
        <xsl:param name="author"/>
        <xsl:choose>
            <xsl:when test="$format!='na'">
                <section class="rtList">
                    <h2 id="rtList">
                        <span>
                            <xsl:text>Resource Templates for </xsl:text>
                            <xsl:call-template name="format_formats">
                                <xsl:with-param name="format" select="$format"/>
                                <xsl:with-param name="case" select="'title'"/>
                            </xsl:call-template>
                        </span>
                    </h2>
                    <ul>
                        <xsl:for-each select="document('../xml/sinopia_maps.xml')/uwsinopia:sinopia_maps/uwsinopia:rts/uwsinopia:rt[uwsinopia:institution = $institution and uwsinopia:format = $format and uwsinopia:user = $user]">
                            <xsl:variable name="section_id"
                                select="concat($institution, 'RT', uwsinopia:resource)"/>
                            <li>
                                <xsl:choose>
                                    <xsl:when test="$resource=uwsinopia:resource">
                                        <b><xsl:text>UW Sinopia </xsl:text>
                                        <xsl:value-of select="$institution"/>
                                        <xsl:text> RT </xsl:text>
                                        <xsl:call-template name="format_resources">
                                            <xsl:with-param name="resource" select="uwsinopia:resource"/>
                                        </xsl:call-template>
                                        <xsl:text> </xsl:text>
                                        <xsl:call-template name="format_formats">
                                            <xsl:with-param name="format" select="$format"/>
                                            <xsl:with-param name="case" select="'title'"/>
                                        </xsl:call-template></b>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:variable name="url" select="concat('UWSINOPIA_', $institution, '_', uwsinopia:resource, '_', $format, '_', $user, '.html')"/>
                                        <a href="{$url}">
                                            <xsl:text>UW Sinopia </xsl:text>
                                            <xsl:value-of select="$institution"/>
                                            <xsl:text> RT </xsl:text>
                                            <xsl:call-template name="format_resources">
                                                <xsl:with-param name="resource" select="uwsinopia:resource"/>
                                            </xsl:call-template>
                                            <xsl:text> </xsl:text>
                                            <xsl:call-template name="format_formats">
                                                <xsl:with-param name="format" select="$format"/>
                                                <xsl:with-param name="case" select="'title'"/>
                                            </xsl:call-template>
                                        </a>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </li>
                        </xsl:for-each>
                    </ul>
                </section>
            </xsl:when>
            <xsl:otherwise>
                <section class="rtList">
                    <h2 id="rtList">
                        <span>
                            <xsl:text>Resource Template for </xsl:text>
                            <xsl:call-template name="format_formats">
                                <xsl:with-param name="format" select="$resource"/>
                                <xsl:with-param name="case" select="'title'"/>
                            </xsl:call-template>
                        </span>
                    </h2>
                    <ul>
                        <xsl:variable name="section_id"
                            select="concat($institution, 'RT', uwsinopia:resource)"/>
                        <li>
                            <a href="#{$section_id}">
                                <xsl:text>UW Sinopia </xsl:text>
                                <xsl:value-of select="$institution"/>
                                <xsl:text> RT </xsl:text>
                                <xsl:call-template name="format_resources">
                                    <xsl:with-param name="resource" select="uwsinopia:resource"/>
                                </xsl:call-template>
                                <xsl:text> </xsl:text>
                                <xsl:call-template name="format_formats">
                                    <xsl:with-param name="format" select="$resource"/>
                                    <xsl:with-param name="case" select="'title'"/>
                                </xsl:call-template>
                            </a>
                        </li>
                    </ul>
                </section>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="rtInfo">
        <xsl:param name="institution"/>
        <xsl:param name="resource"/>
        <xsl:param name="format"/>
        <xsl:param name="user"/>
        <xsl:param name="author"/>

        <xsl:variable name="file_name"
            select="concat('UWSINOPIA_', $institution, '_', $resource, '_', $format, '_', $user)"/>
        <xsl:variable name="resource_id"
            select="concat('UWSINOPIA:', $institution, ':', $resource, ':', $format, ':', $user)"/>
        <xsl:variable name="section_id" select="concat($institution, 'RT', uwsinopia:resource)"/>

        <table class="rtInfo" id="{$section_id}">
            <thead>
                <tr>
                    <th colspan="2">
                        <xsl:text>Resource Template: </xsl:text>
                        <xsl:value-of select="$institution"/>
                        <xsl:text> RT </xsl:text>
                        <xsl:call-template name="format_resources">
                            <xsl:with-param name="resource" select="$resource"/>
                        </xsl:call-template>
                        <xsl:text> for </xsl:text>
                        <xsl:choose>
                            <xsl:when test="$format!='na'">
                                <xsl:call-template name="format_formats">
                                    <xsl:with-param name="format" select="$format"/>
                                    <xsl:with-param name="case" select="'title'"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="format_formats">
                                    <xsl:with-param name="format" select="$resource"/>
                                    <xsl:with-param name="case" select="'title'"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <th scope="row">Resource IRI</th>
                    <td>
                        <xsl:variable name="rdf_about" select="concat('https://api.sinopia.io/resource/', $resource_id)"/>
                        <xsl:variable name="class_IRI" select="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[@rdf:about=$rdf_about]/sinopia:hasClass/@rdf:resource"/>
                        <a href="{$class_IRI}"><xsl:value-of select="$class_IRI"/></a>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Label</th>
                    <td>
                        <xsl:variable name="rdf_about" select="concat('https://api.sinopia.io/resource/', $resource_id)"/>
                        <xsl:variable name="rt_label" select="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[@rdf:about=$rdf_about]/rdfs:label"/>
                        <xsl:value-of select="$rt_label"/>
                    </td>
                </tr>
                <tr>
                    <th scope="row">ID</th>
                    <td>
                        <xsl:variable name="rdf_about" select="concat('https://api.sinopia.io/resource/', $resource_id)"/>
                        <xsl:variable name="rt_id" select="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[@rdf:about=$rdf_about]/sinopia:hasResourceId"/>
                        <xsl:value-of select="$rt_id"/>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Author</th>
                    <td>
                        <xsl:variable name="rdf_about" select="concat('https://api.sinopia.io/resource/', $resource_id)"/>
                        <xsl:variable name="author" select="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[@rdf:about=$rdf_about]/sinopia:hasAuthor"/>
                        <xsl:value-of select="$author"/>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Last Updated</th>
                    <td>
                        <xsl:variable name="rdf_about" select="concat('https://api.sinopia.io/resource/', $resource_id)"/>
                        <xsl:variable name="date" select="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[@rdf:about=$rdf_about]/sinopia:hasDate"/>
                        <xsl:value-of select="$date"/>
                    </td>
                </tr>
                <tr class="backlink">
                    <th scope="row" colspan="2"><a href="#profile">RETURN TO TOP</a></th>
                </tr>
            </tbody>
        </table>
    </xsl:template>
    <xsl:template name="ptList">
        <xsl:param name="institution"/>
        <xsl:param name="resource"/>
        <xsl:param name="format"/>
        <xsl:param name="user"/>
        <xsl:param name="author"/>
        <xsl:variable name="section_id" select="concat($institution, 'RT', uwsinopia:resource, 'ptList')"/>
        <section class="ptList">
            <h3 id="{$section_id}"><span>
                <xsl:text>Property Templates in </xsl:text>
                <xsl:value-of select="$institution"/>
                <xsl:text> RT </xsl:text>
                <xsl:call-template name="format_resources">
                    <xsl:with-param name="resource" select="$resource"/>
                </xsl:call-template>
                <xsl:text> for </xsl:text>
                <xsl:choose>
                    <xsl:when test="$format!='na'">
                        <xsl:call-template name="format_formats">
                            <xsl:with-param name="format" select="$format"/>
                            <xsl:with-param name="case" select="'title'"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="format_formats">
                            <xsl:with-param name="format" select="$resource"/>
                            <xsl:with-param name="case" select="'title'"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </span></h3>
            <ul id="BT">
                <xsl:variable name="file_name"
                    select="concat('UWSINOPIA_', $institution, '_', $resource, '_', $format, '_', $user)"/>
                <xsl:for-each select="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[rdf:type/@rdf:resource='http://sinopia.io/vocabulary/PropertyTemplate']">
                    <xsl:variable name="label_without_note" as="xs:string">
                        <xsl:choose>
                            <xsl:when test="contains(rdfs:label, '[')">
                                <li><xsl:value-of select="substring-before(rdfs:label, '[')"/></li>
                            </xsl:when>
                            <xsl:otherwise>
                                <li><xsl:value-of select="rdfs:label"/></li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="pt_id" select="replace($label_without_note, ' ', '')"/>
                    <xsl:choose>
                        <xsl:when test="sinopia:hasPropertyUri[position()!=1]">
                            <li>
                                <a href="#{$pt_id}"><xsl:value-of select="$label_without_note"/></a>&#160;<span class="caret"> </span>
                                <ul class="nested">
                                    <xsl:for-each select="sinopia:hasPropertyUri[position()!=1]">
                                        <xsl:variable name="subprop_URI" select="@rdf:resource"/>
                                        <xsl:variable name="entity">
                                            <xsl:variable name="remove_prop_ID" select="substring-before($subprop_URI, '/P')"/>
                                            <xsl:value-of select="substring-after($remove_prop_ID, 'http://rdaregistry.info/Elements/')"/>
                                        </xsl:variable>
                                        <xsl:variable name="rdaRegistry_xml" select="concat('http://www.rdaregistry.info/xml/Elements/', $entity, '.xml')"/>
                                        <xsl:variable name="subprop_label" select="document($rdaRegistry_xml)/rdf:RDF/rdf:Description[@rdf:about=$subprop_URI or @rdf:about=replace($subprop_URI, 'object/', '') or @rdf:about=replace($subprop_URI, 'datatype/', '')]/rdfs:label[@xml:lang='en']"/>
                                        <li><xsl:value-of select="$subprop_label"/></li>
                                    </xsl:for-each>
                                    <xsl:call-template name="add_comments">
                                        <xsl:with-param name="nodeID" select="@rdf:nodeID"></xsl:with-param>
                                    </xsl:call-template>
                                </ul>
                            </li>
                        </xsl:when>
                        <xsl:otherwise>
                            <li><a href="#{$pt_id}"><xsl:value-of select="$label_without_note"/></a></li>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <xsl:variable name="rt_id" select="concat($institution, 'RT', $resource)"/>
                <li><span class="backlink"><a href="#{$rt_id}"><strong>RETURN TO RESOURCE TEMPLATE TOP</strong></a></span></li>
                <li><span class="backlink"><a href="#profile"><strong>RETURN TO PROFILE TOP</strong></a></span></li>
            </ul>
            <xsl:variable name="file_name"
                select="concat('UWSINOPIA_', $institution, '_', $resource, '_', $format, '_', $user)"/>
            <xsl:for-each select="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[rdf:type/@rdf:resource='http://sinopia.io/vocabulary/PropertyTemplate']">
                <xsl:variable name="label_without_note" as="xs:string">
                    <xsl:choose>
                        <xsl:when test="contains(rdfs:label, '[')">
                            <li><xsl:value-of select="substring-before(rdfs:label, '[')"/></li>
                        </xsl:when>
                        <xsl:otherwise>
                            <li><xsl:value-of select="rdfs:label"/></li>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="pt_info">
                    <xsl:with-param name="institution" select="$institution"/>
                    <xsl:with-param name="prop_URI" select="sinopia:hasPropertyUri[position()=1]/@rdf:resource"/>
                    <xsl:with-param name="prop_label" select="$label_without_note"/>
                    <xsl:with-param name="file_name" select="$file_name"/>
                    <xsl:with-param name="pt_list_id" select="$section_id"/>
                </xsl:call-template>
            </xsl:for-each>
        </section>
    </xsl:template>
    <xsl:template name="pt_info">
        <xsl:param name="institution"/>
        <xsl:param name="prop_URI"/>
        <xsl:param name="prop_label"/>
        <xsl:param name="file_name"/>
        <xsl:param name="pt_list_id"/>
        <xsl:variable name="prop_id" select="replace($prop_label, ' ', '')"/>
        <section class="ptInfo" id="{$prop_id}">
            <h4>
                <span>Property Template: <xsl:value-of select="$prop_label"/> <xsl:if test="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[sinopia:hasPropertyUri/@rdf:resource=$prop_URI]/sinopia:hasPropertyAttribute/@rdf:resource='http://sinopia.io/vocabulary/propertyAttribute/required'">(*)</xsl:if></span>
            </h4>
            <ul>
                <li>Property IRI: <a href="{$prop_URI}"><xsl:value-of select="$prop_URI"/></a></li>
                <xsl:if test="contains($prop_URI, 'rdaregistry')">
                    <xsl:variable name="toolit" select="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[sinopia:hasPropertyUri/@rdf:resource=$prop_URI]/sinopia:hasRemarkUrl/@rdf:resource"/>
                    <li>RDA Toolkit URL: <a href="{$toolit}"><xsl:value-of select="$toolit"/></a></li>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[sinopia:hasPropertyUri/@rdf:resource=$prop_URI]/sinopia:hasPropertyAttribute/@rdf:resource='http://sinopia.io/vocabulary/propertyAttribute/required'">
                        <li>Mandatory</li>
                    </xsl:when>
                    <xsl:otherwise>
                        <li>Optional</li>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[sinopia:hasPropertyUri/@rdf:resource=$prop_URI]/sinopia:hasPropertyAttribute/@rdf:resource='http://sinopia.io/vocabulary/propertyAttribute/repeatable'">
                        <li>Repeatable</li>
                    </xsl:when>
                    <xsl:otherwise>
                        <li>Not repeatable</li>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[sinopia:hasPropertyUri/@rdf:resource=$prop_URI]/sinopia:hasPropertyType/@rdf:resource='http://sinopia.io/vocabulary/propertyType/literal'">
                        <li>Property type: literal</li>
                    </xsl:when>
                    <xsl:when test="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[sinopia:hasPropertyUri/@rdf:resource=$prop_URI]/sinopia:hasPropertyType/@rdf:resource='http://sinopia.io/vocabulary/propertyType/uri'">
                        <xsl:choose>
                            <xsl:when test="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[sinopia:hasPropertyUri/@rdf:resource=$prop_URI]/sinopia:hasLookupAttributes">
                                <li>Property type: lookup</li>
                            </xsl:when>
                            <xsl:otherwise>
                                <li>Property type: URI</li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[sinopia:hasPropertyUri/@rdf:resource=$prop_URI]/sinopia:hasPropertyType/@rdf:resource='http://sinopia.io/vocabulary/propertyType/resource'">
                        <li>Property type: nested resource</li>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[sinopia:hasPropertyUri/@rdf:resource=$prop_URI][sinopia:hasLookupAttributes or sinopia:hasLiteralAttributes or sinopia:hasResourceAttributes]">
                    <li>Value constraint(s):
                        <ul>
                            <xsl:if test="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[sinopia:hasPropertyUri/@rdf:resource=$prop_URI][sinopia:hasLookupAttributes or sinopia:hasLiteralAttributes]">
                                <xsl:variable name="attributes_id">
                                    <xsl:choose>
                                        <xsl:when test="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[sinopia:hasPropertyUri/@rdf:resource=$prop_URI]/sinopia:hasLookupAttributes/@rdf:nodeID">
                                            <xsl:value-of select="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[sinopia:hasPropertyUri/@rdf:resource=$prop_URI]/sinopia:hasLookupAttributes/@rdf:nodeID"/>
                                        </xsl:when>
                                        <xsl:when test="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[sinopia:hasPropertyUri/@rdf:resource=$prop_URI]/sinopia:hasLiteralAttributes/@rdf:nodeID">
                                            <xsl:value-of select="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[sinopia:hasPropertyUri/@rdf:resource=$prop_URI]/sinopia:hasLiteralAttributes/@rdf:nodeID"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:if test="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[@rdf:nodeID=$attributes_id]/sinopia:hasDefault">
                                    <li>Default: 
                                        <xsl:choose>
                                            <xsl:when test="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[@rdf:nodeID=$attributes_id]/sinopia:hasDefault/@rdf:resource">
                                                <xsl:variable name="default_uri" select="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[@rdf:nodeID=$attributes_id]/sinopia:hasDefault/@rdf:resource"/>
                                                <xsl:variable name="default_label" select="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[@rdf:about=$default_uri]"/>
                                                <a href="{$default_uri}"><xsl:value-of select="$default_label"/></a>
                                            </xsl:when>
                                            <!-- Option for literal default values... I don't think we currently have any...? -->
                                        </xsl:choose>
                                    </li>
                                </xsl:if>
                            </xsl:if>
                            <xsl:if test="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[sinopia:hasPropertyUri/@rdf:resource=$prop_URI]/sinopia:hasLookupAttributes">
                                <xsl:variable name="lookup_attributes_id" select="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[sinopia:hasPropertyUri/@rdf:resource=$prop_URI]/sinopia:hasLookupAttributes/@rdf:nodeID"/>
                                <li>Value lookup source(s):
                                    <ul>
                                        <xsl:for-each select="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[@rdf:nodeID=$lookup_attributes_id]/sinopia:hasAuthority">
                                            <li>
                                                <xsl:call-template name="qaLinks">
                                                    <xsl:with-param name="node" select="@rdf:resource"/>
                                                </xsl:call-template>
                                            </li>
                                        </xsl:for-each>
                                    </ul>
                                </li>
                            </xsl:if>
                            <xsl:if test="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[sinopia:hasPropertyUri/@rdf:resource=$prop_URI]/sinopia:hasResourceAttributes">
                                <xsl:variable name="resource_attributes_id" select="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[sinopia:hasPropertyUri/@rdf:resource=$prop_URI]/sinopia:hasResourceAttributes/@rdf:nodeID"/>
                                <xsl:variable name="nested_resource_ID" select="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[@rdf:nodeID=$resource_attributes_id]/sinopia:hasResourceTemplateId/@rdf:resource"/>
                                <xsl:variable name="nested_resource_URL_institution" select="substring-before(substring-after($nested_resource_ID, 'UWSINOPIA:'), ':')"/>
                                <xsl:variable name="nested_resource_URL_resource" select="substring-before(substring-after($nested_resource_ID, concat($nested_resource_URL_institution, ':')), ':')"/>
                                <xsl:variable name="nested_resource_URL_format" select="substring-before(substring-after($nested_resource_ID, concat($nested_resource_URL_resource, ':')), ':')"/>
                                <xsl:variable name="nested_resource_URL_user" select="substring-after($nested_resource_ID, concat($nested_resource_URL_format, ':'))"/>
                                <xsl:variable name="nested_resource_URL" select="concat('UWSINOPIA_', $nested_resource_URL_institution, '_', $nested_resource_URL_resource, '_', $nested_resource_URL_format, '_', $nested_resource_URL_user, '.html')"/>
                                <!-- UWSINOPIA_WAU_rdaItem_monograph_CAMS -->
                                <li>Resource template ID: <a href="{$nested_resource_URL}"><xsl:value-of select="$nested_resource_ID"/></a></li>
                            </xsl:if>
                        </ul>
                    </li>
                </xsl:if>
                <xsl:if test="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[sinopia:hasPropertyUri/@rdf:resource=$prop_URI][sinopia:hasPropertyUri[position()!=1]]">
                    <li>Other properties included in this property template:
                        <ul>
                            <xsl:for-each select="document(concat('../', $file_name, '.rdf'))/rdf:RDF/rdf:Description[sinopia:hasPropertyUri/@rdf:resource=$prop_URI]/sinopia:hasPropertyUri[position()!=1]">
                                <xsl:variable name="subprop_URI" select="@rdf:resource"/>
                                <xsl:variable name="entity">
                                    <xsl:variable name="remove_prop_ID" select="substring-before($subprop_URI, '/P')"/>
                                    <xsl:value-of select="substring-after($remove_prop_ID, 'http://rdaregistry.info/Elements/')"/>
                                </xsl:variable>
                                <xsl:variable name="prefixed_prop">
                                    <xsl:choose>
                                        <xsl:when test="contains($entity, 'datatype') or contains($entity, 'object')">
                                            <xsl:value-of select="concat('rda', substring-before($entity, '/'), ':P', substring-after($subprop_URI, '/P'))"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="concat('rda', $entity, ':P', substring-after($subprop_URI, '/P'))"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="rdaRegistry_xml" select="concat('http://www.rdaregistry.info/xml/Elements/', $entity, '.xml')"/>
                                <xsl:variable name="subprop_label" select="document($rdaRegistry_xml)/rdf:RDF/rdf:Description[@rdf:about=$subprop_URI or @rdf:about=replace($subprop_URI, 'object/', '') or @rdf:about=replace($subprop_URI, 'datatype/', '')]/rdfs:label[@xml:lang='en']"/>
                                <xsl:variable name="toolkit_url" select="document('../../map_storage/xml/RDA_alignments.xml')/alignmentPairs/alignmentPair[rdaPropertyNumber=$prefixed_prop]/rdaToolkitURL/@uri"/>
                                <li><xsl:value-of select="$subprop_label"/> [<a href="{$subprop_URI}">RDA REGISTRY</a>] [<a href="{$toolkit_url}">RDA TOOLKIT</a>]</li>
                            </xsl:for-each>
                        </ul>
                    </li>
                </xsl:if>
                <li><span class="backlink"><a href="#{$pt_list_id}"><strong>RETURN TO PROPERTY LIST</strong></a></span></li>
                <li><span class="backlink"><a href="#profile"><strong>RETURN TO PROFILE TOP</strong></a></span></li>
            </ul>
        </section>
    </xsl:template>
</xsl:stylesheet>
