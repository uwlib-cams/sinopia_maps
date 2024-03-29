<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    exclude-result-prefixes="xs sinopia uwmaps uwsinopia rdf rdfs"
    version="3.0"
    expand-text="true">
    
    <xsl:output method="html"/>
    
    <!-- CONTAINS PT_LIST AND CARAT_LIST TEMPLATES -->
    
    <!-- template to generate list of PTs in RT including subprops -->
    <!-- pulls data from prop_sets -->
    <xsl:template name="pt_list">
        <xsl:param name="rt_id"/>
        <xsl:param name="prop"/>
        <xsl:param name="file_name"/>
        <section> 
            <h2 id="prop_list">Property Templates in {$rt_id}</h2>
            <div class="ptList">
                <ul>
                    <xsl:for-each select="$prop">
                        <li>              
                            <a href="#{uwmaps:sinopia/uwsinopia:implementation_set/@localid_implementation_set}">
                                <!-- use alt label if available -->
                                <xsl:choose>
                                    <xsl:when test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:alt_pt_label">
                                        {uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:alt_pt_label}
                                    </xsl:when>
                                    <xsl:otherwise>{uwmaps:prop_label}</xsl:otherwise>
                                </xsl:choose>
                                <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:required"> 
                                    <xsl:text>(*)</xsl:text>
                                </xsl:if>
                            </a>
                            
                            <!-- if alt label is used, or prop has subprops, need drop-down list -->
                            <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:alt_pt_label or uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:multiple_prop">
                                <xsl:variable name="node_id" select="concat(translate(substring-after(uwmaps:prop_iri/@iri, '://'), '/.#', ''), '_define')"/>
                                <!-- call carat_list template -->
                                <xsl:call-template name="carat_list">
                                    <xsl:with-param name="file_name" select="$file_name"/>
                                    <xsl:with-param name="node_id" select="$node_id"/>
                                </xsl:call-template>
                            </xsl:if>
                        </li>
                    </xsl:for-each>
                    
                    <!-- links -->
                    <li>
                        <span class="backlink">
                            <a href="#profile">
                                <strong>RETURN TO PROFILE TOP</strong>
                            </a>
                        </span>
                    </li>
                </ul>   
            </div>
        </section>
    </xsl:template>
    
    <!-- template for generating drop-down list for subprops -->
    <!-- pulls data from rdf/xml files and rdaregistry -->
    <xsl:template name="carat_list">
        <xsl:param name="file_name"/>
        <xsl:param name="node_id"/>
        
        <!-- drop down list is only generated if it is a multiprop (it has subprops) OR if it has an alternate id -->
        <xsl:text>&#160;</xsl:text>
        <span class="caret"/>
        <ul class="nested">
            <xsl:for-each select="document($file_name)/rdf:RDF/rdf:Description[@rdf:nodeID = $node_id]/sinopia:hasPropertyUri">
                <xsl:variable name="subprop_URI" select="@rdf:resource"/>
                <xsl:choose>
                    <!-- RDA prop -->
                    <xsl:when test="starts-with($subprop_URI, 'http://rdaregistry.info')">
                        <xsl:variable name="entity">
                            <xsl:variable name="remove_prop_ID" select="substring-before($subprop_URI, '/P')"/>
                            <xsl:value-of select="substring-after($remove_prop_ID, 'http://rdaregistry.info/Elements/')"/>
                        </xsl:variable>
                        <xsl:variable name="rdaRegistry_xml"
                            select="concat('http://www.rdaregistry.info/xml/Elements/', $entity, '.xml')"/>
                        <xsl:variable name="subprop_label" select="
                            document($rdaRegistry_xml)/rdf:RDF/
                            rdf:Description[@rdf:about = $subprop_URI]/rdfs:label[@xml:lang = 'en']"/>
                        <xsl:if test="not(contains($subprop_label, 'agent'))">
                            <li>
                                <xsl:value-of select="$subprop_label"/>
                            </li>
                        </xsl:if>
                        
                    <!-- UW RDA ext. prop -->
                    </xsl:when>
                    <xsl:when test="starts-with($subprop_URI, 'https://doi.org/10.6069/uwlib.55.d.4')">
                        <xsl:variable name="subprop_label" select="
                            document('../../map_storage/prop_set_uwRdaExtension.xml')/uwmaps:prop_set/uwmaps:prop[uwmaps:prop_iri[@iri = $subprop_URI]]/uwmaps:prop_label"
                        />
                        <li>
                            <xsl:value-of select="$subprop_label"/>
                        </li>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:text>ERROR - MULTIPLE-PROPERTY PTs NOT CONFIGURED FOR THIS SOURCE</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </ul>     
    </xsl:template>
</xsl:stylesheet>