<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mapstor="https://uwlib-cams.github.io/map_storage/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:sin="http://sinopia.io/vocabulary/"
    exclude-result-prefixes="xs" version="3.0">
    <xsl:output method="xml" indent="yes"/>

    <!-- Import named templates -->
    <xsl:import href="storage_to_rdfxml_002_named_templates.xsl"/>
   
    <!-- Supply params when invoking XSLT transformation (oXygen scenario, Java command) -->
    <xsl:param name="mapid_institution"/>
    <xsl:param name="mapid_resource"/>
    <xsl:param name="mapid_format"/>
    <xsl:param name="mapid_user"/>
    <xsl:param name="rtId"
        select="concat('TEST', $mapid_institution, ':RT:', $mapid_resource, ':', $mapid_format, ':', $mapid_user)"/>
    
    <xsl:template match="/">
        <!-- BEWARE output file path may not fit your filesystem -->
        <xsl:result-document
            href="../../uwl_sinopia_maps/tests/fromTestXslt002_{format-date(current-date(), '[Y0001]-[M01]-[D01]')}_{$mapid_institution}_RT_{$mapid_resource}_{$mapid_format}_{$mapid_user}.rdf">
            <rdf:RDF>
                <rdf:Description rdf:about="https://api.stage.sinopia.io/resource/{$rtId}">
                    <rdf:type rdf:resource="http://sinopia.io/vocabulary/ResourceTemplate"/>
                    <sin:hasResourceTemplate>
                        <!-- Hard code the resource template for resource templates -->
                        <xsl:text>sinopia:template:resource</xsl:text>
                    </sin:hasResourceTemplate>
                    <sin:hasResourceId>
                        <xsl:value-of select="$rtId"/>
                    </sin:hasResourceId>
                    <!-- Call rtHasClass for sin:hasClass value -->
                    <xsl:call-template name="rtHasClass">
                        <xsl:with-param name="mapid_resource" select="$mapid_resource"/>
                    </xsl:call-template>
                    <rdfs:label>
                        <xsl:value-of
                            select="
                            concat('TEST ', format-date(current-date(), '[Y0001]-[M01]-[D01]'), $mapid_institution, ' RT ', $mapid_resource, ' ', $mapid_format, ' ', $mapid_user)"
                        />
                    </rdfs:label>
                    <!-- Call rtHasAuthor for sin:hasAuthor value -->
                    <xsl:call-template name="rtHasAuthor">
                        <xsl:with-param name="mapid_user" select="$mapid_user"/>
                    </xsl:call-template>
                    <sin:hasDate>
                        <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
                    </sin:hasDate>
                    <!-- BMR: grabbing the nodeID for the first PT seems to work here
                        but seems very duplicative and computing-resource-intensive...
                        is there a better way to get the needed value here? -->
                    <xsl:for-each select="
                        mapstor:mapStorage[@mapid_institution = $mapid_institution]/
                        mapstor:propSet/
                        mapstor:prop
                        [mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/
                        mapstor:resource[@mapid_resource = $mapid_resource]
                        [mapstor:format[@mapid_format = $mapid_format]]
                        [mapstor:user[@mapid_user = $mapid_user]]]">
                        <xsl:sort select="
                            mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/
                            mapstor:resource[@mapid_resource = $mapid_resource]
                            [mapstor:format[@mapid_format = $mapid_format]]
                            [mapstor:user[@mapid_user = $mapid_user]]/
                            mapstor:form_order/@value"/>
                        <xsl:if test="position() = 1">
                            <sin:hasPropertyTemplate 
                                rdf:nodeID="{concat(substring-after(@localid_prop, '/'), '_ordering_bnode')}">
                            </sin:hasPropertyTemplate>
                        </xsl:if>
                    </xsl:for-each>                    
                </rdf:Description>
                <xsl:apply-templates
                    select="
                        mapstor:mapStorage[@mapid_institution = $mapid_institution]/
                        mapstor:propSet/
                        mapstor:prop
                        [mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/
                        mapstor:resource[@mapid_resource = $mapid_resource]
                        [mapstor:format[@mapid_format = $mapid_format]]
                        [mapstor:user[@mapid_user = $mapid_user]]]">
                    <xsl:sort data-type="number"
                        select="
                            mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/
                            mapstor:resource[@mapid_resource = $mapid_resource]
                            [mapstor:format[@mapid_format = $mapid_format]]
                            [mapstor:user[@mapid_user = $mapid_user]]/
                            mapstor:form_order/@value"
                    />
                </xsl:apply-templates>
            </rdf:RDF>
        </xsl:result-document>
    </xsl:template>

    <!-- BMR: Never quite sure if I need to repeat the whole XPath from xsl:apply-templates in xsl:template...
        Or is it needed here but not above?
        But maybe it really is needed in both places??
        TO DO testing, remove details from apply-templates above and run, remove from here and run... -->
    <xsl:template
        match="
            mapstor:mapStorage[@mapid_institution = $mapid_institution]/
            mapstor:propSet/
            mapstor:prop
            [mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/
            mapstor:resource[@mapid_resource = $mapid_resource]
            [mapstor:format[@mapid_format = $mapid_format]]
            [mapstor:user[@mapid_user = $mapid_user]]]">
        <!-- BMR: Here's the triple I don't quite understand... must be for sinopia to have a property label (?)
            but that doesn't quite make sense as the PT includes a label -->
        <rdf:Description rdf:about="{mapstor:prop_iri/@iri}">
            <rdfs:label>
                <xsl:value-of select="mapstor:prop_label"/>
            </rdfs:label>
        </rdf:Description>
        <!-- Output 'ordering bnode' for the PT -->
        <!-- BMR: Using MCM's work here -->
        <rdf:Description
            rdf:nodeID="{concat(substring-after(@localid_prop, '/'), '_ordering_bnode')}">
            <rdf:first rdf:nodeID="{concat(substring-after(@localid_prop, '/'), '_pt_bnode')}"/>
            <xsl:choose>
                <!-- BMR: I believe this works for filtering out the last ordering bnode and outputting rdf:rest = nil -->
                <xsl:when test="position() = last()">
                    <rdf:rest rdf:resource="http://www.w3.org/1999/02/22-rdf-syntax-ns#nil"/>
                </xsl:when>
                <xsl:otherwise>
                    <!-- BMR: TO DO does not work -->
                    <xsl:variable name="current_position" select="position()"/>
                    <rdf:rest rdf:nodeID="{concat(substring-after(../mapstor:prop[position() = $current_position + 1]/@localid_prop, '/'), '_ordering_bnode')}"/>
                </xsl:otherwise>
            </xsl:choose>
        </rdf:Description>
        <!-- Output PT bnode -->
        <!-- BMR: Using MCM's work here -->
        <rdf:Description rdf:nodeID="{concat(substring-after(@localid_prop, '/'), '_pt_bnode')}">
            <rdf:type rdf:resource="http://sinopia.io/vocabulary/PropertyTemplate"/>
            <rdfs:label xml:lang="{mapstor:prop_label/@xml:lang}">
                <xsl:value-of select="mapstor:prop_label"/>
            </rdfs:label>
            <sin:hasPropertyUri rdf:resource="{mapstor:prop_iri/@iri}"/>
            <!-- Call ptHasAttributes for sin:hasPropertyAttribute value(s) -->
            <xsl:call-template name="ptHasAttributes">
                <xsl:with-param name="sinopia_prop_attributes"
                    select="
                        mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/
                        mapstor:resource[@mapid_resource = $mapid_resource]
                        [mapstor:format[@mapid_format = $mapid_format]]
                        [mapstor:user[@mapid_user = $mapid_user]]/
                        mapstor:sinopia_prop_attributes"
                />
            </xsl:call-template>
        </rdf:Description>
    </xsl:template>

</xsl:stylesheet>
