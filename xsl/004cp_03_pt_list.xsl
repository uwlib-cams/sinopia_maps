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
        <xsl:param name="file_name"/>
        <section class="ptList"> 
            <h3 id="prop_list">Property Templates in {$rt_id}</h3>
            <ul>
                <xsl:for-each select="$prop">
                    <!-- TO DO decide how to display primary prop label if alt_label -->
                    <li>
                        <xsl:choose>
                            <xsl:when test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:multiple_prop">
                                <a href="#{uwmaps:sinopia/uwsinopia:implementation_set/@localid_implementation_set}">
                                    <xsl:choose>
                                        <xsl:when test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:alt_pt_label">
                                            {uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:alt_pt_label}
                                        </xsl:when>
                                        <xsl:otherwise>{uwmaps:prop_label}</xsl:otherwise>
                                    </xsl:choose>
                                </a>
                                
                                <xsl:variable name="node_id" select="concat('rdaregistryinfoElements', translate(substring-after(uwmaps:prop_iri/@iri, 'Elements/'), '/', ''), '_define')"/>
                                <xsl:choose>
                                    <xsl:when test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:alt_pt_label">
                                        <xsl:call-template name="carat_list">
                                            <xsl:with-param name="file_name" select="$file_name"/>
                                            <xsl:with-param name="alt_id" select="number(0)"/>
                                            <xsl:with-param name="node_id" select="$node_id"/>
                                        </xsl:call-template>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:call-template name="carat_list">
                                            <xsl:with-param name="file_name" select="$file_name"/>
                                            <xsl:with-param name="alt_id" select="number(1)"/>
                                            <xsl:with-param name="node_id" select="$node_id"/>
                                        </xsl:call-template>
                                    </xsl:otherwise>
                                </xsl:choose>                             
                            </xsl:when>
                            <xsl:otherwise>
                                <a href="#{uwmaps:sinopia/uwsinopia:implementation_set/@localid_implementation_set}">
                                <xsl:choose>
                                    <xsl:when test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:alt_pt_label"
                                        >{uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:alt_pt_label}</xsl:when>
                                    <xsl:otherwise>{uwmaps:prop_label}</xsl:otherwise>
                                </xsl:choose>
                                </a>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                    <!-- TO DO: 
                    link to details for each PT
                    if multiple_prop include all w. collapsible -->
                </xsl:for-each>
            </ul>
        </section>
    </xsl:template>
    
    <xsl:template name="carat_list">
        <xsl:param name="file_name"/>
        <xsl:param name="alt_id"/>
        <xsl:param name="node_id"/>
        
        <xsl:if test="count(document($file_name)/rdf:RDF/rdf:Description[@rdf:nodeID = $node_id]/sinopia:hasPropertyUri[position() != 1]) gt 0">
            <xsl:text>&#160;</xsl:text>
            <span class="caret"/>
            <ul class="nested">
                <xsl:for-each select="document($file_name)/rdf:RDF/rdf:Description[@rdf:nodeID = $node_id]/sinopia:hasPropertyUri[position() != $alt_id]">
                    <xsl:variable name="subprop_URI" select="@rdf:resource"/>
                    <xsl:variable name="entity">
                        <xsl:variable name="remove_prop_ID"
                            select="substring-before($subprop_URI, '/P')"/>
                        <xsl:value-of
                            select="substring-after($remove_prop_ID, 'http://rdaregistry.info/Elements/')"
                        />
                    </xsl:variable>
                    <xsl:variable name="rdaRegistry_xml"
                        select="concat('http://www.rdaregistry.info/xml/Elements/', $entity, '.xml')"/>
                    <xsl:variable name="subprop_label" select="
                        document($rdaRegistry_xml)/rdf:RDF/
                        rdf:Description[@rdf:about = $subprop_URI]/rdfs:label[@xml:lang = 'en']"/>
                    <li>
                        <xsl:value-of select="$subprop_label"/>
                    </li>
                </xsl:for-each>
            </ul>     
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>