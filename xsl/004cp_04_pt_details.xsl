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
    
    <xsl:output method="html"/>
    
    <xsl:include href="004cp_05_pt_guidance.xsl"/>
    
    <!-- CONTAINS PT_DETAILS, LOOKUP_DETAILS, AND SUBPROP_LIST TEMPLATES -->
    
    <!-- template to generate all information about properties -->
    <!-- pulls data from prop_set files -->
    <xsl:template name="pt_details">
        <xsl:param name="rt_id"/>
        <xsl:param name="prop"/>
        <xsl:param name="file_name"/>
        <section class="ptInfo"> 
            <xsl:for-each select="$prop">
                <section class="ptInfo" id="{uwmaps:sinopia/uwsinopia:implementation_set/@localid_implementation_set}">
                    
                    <h4>
                        <span>
                            <xsl:text>Property Template: </xsl:text>
                            <!-- use alt label if available -->
                            <xsl:choose>
                                <xsl:when test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:alt_pt_label">
                                    {uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:alt_pt_label}
                                </xsl:when>
                                <xsl:otherwise>{uwmaps:prop_label}</xsl:otherwise>                               
                            </xsl:choose>
                            <!-- add asterisk if prop is required in RT -->
                            <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:required"> 
                                <xsl:text>(*)</xsl:text>
                            </xsl:if>
                        </span>
                    </h4>
                    
                    <!-- include remark if available -->
                    <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:remark">
                        <p>
                            <span class="ptInfoRemark">
                                {uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:remark}
                            </span>
                        </p>
                    </xsl:if>
                    
                    <!-- include Guidance if available -->
                    <xsl:if test="uwmaps:sinopia/uwsinopia:guidance_set">
                        <span class="ptInfoGuidance">
                            <b>Guidance and Configuration</b>
                            <xsl:call-template name="pt_guidance">
                                <xsl:with-param name="prop" select="$prop"/>
                                <xsl:with-param name="rt_id" select="$rt_id"/>
                            </xsl:call-template>
                        </span>
                    </xsl:if>
                    <ul>
                        <li>Property IRI: <a href="{uwmaps:prop_iri/@iri}">{uwmaps:prop_iri/@iri}</a></li>
                        
                        <!-- include toolkit url if available -->
                        <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:remark_url">
                            <li>RDA Toolkit URL: <a href="{uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:remark_url/@iri}">{uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:remark_url/@iri}</a></li>
                        </xsl:if>
                        
                        <!-- mark as required or optional -->
                        <xsl:choose>
                            <xsl:when test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:required">
                                <li>Required</li>
                            </xsl:when>
                            <xsl:otherwise>
                                <li>Optional</li>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                        <!-- indicate if repeatable/ordered -->
                        <xsl:choose>
                            <xsl:when test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:repeatable">
                                <xsl:choose>
                                    <xsl:when test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:repeatable/@ordered">
                                        <li>Reapeatable (ordered)</li>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <li>Repeatable</li>
                                    </xsl:otherwise>
                                </xsl:choose>                              
                            </xsl:when>
                            <xsl:otherwise>
                                <li>Not repeatable</li>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                        <!-- indicate if language suppressed -->
                        <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:language_suppressed">
                            <li>Language suppressed</li>
                        </xsl:if>
                        
                        <!-- indicate property type -->
                        <!-- include additional details based on property type -->
                        <xsl:choose>
                            <!-- literal pt -->
                            <xsl:when test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:literal_pt">
                                <li>Property type: literal</li>
                                <!-- NEEDS TESTING -->
                                <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:literal_pt/*">
                                    <ul>
                                        <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:literal_pt/uwsinopia:date_default">
                                             <li>Defaults to current date</li>
                                         </xsl:if>
                                         <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:literal_pt/uwsinopia:userId_default">
                                             <li>Defaults to user id</li>
                                         </xsl:if>
                                         <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:literal_pt/uwsinopia:default_literal">
                                             <li>Defaults to </li>
                                             {uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:literal_pt/uwsinopia:default_literal}
                                         </xsl:if>
                                         <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:literal_pt/uwsinopia:validation_datatype">
                                             <li>Validation type: </li>
                                             {uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:literal_pt/uwsinopia:validation_datatype}
                                         </xsl:if>
                                         <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:literal_pt/uwsinopia:validation_datatype">
                                             <li>Validation type: </li>
                                             {uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:literal_pt/uwsinopia:validation_datatype}
                                        </xsl:if>
                                        <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:literal_pt/uwsinopia:validation_regex">
                                            <li>Validation regex: </li>
                                            {uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:literal_pt/uwsinopia:validation_regex}
                                        </xsl:if>
                                    </ul>
                                </xsl:if>
                            </xsl:when>
                            
                            <!-- lookup pt -->
                            <xsl:when test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:lookup_pt">
                                <li>Property type: lookup</li> 
                                <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:lookup_pt/uwsinopia:lookup_default_iri or uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:lookup_pt/uwsinopia:lookup_default_iri_label">
                                    <ul>
                                        <li>Default:
                                            <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:lookup_pt/uwsinopia:lookup_default_iri_label">
                                                {uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:lookup_pt/uwsinopia:lookup_default_iri_label}
                                                <xsl:text> - </xsl:text>
                                            </xsl:if>
                                            <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:lookup_pt/uwsinopia:lookup_default_iri">
                                                {uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:lookup_pt/uwsinopia:lookup_default_iri/@iri}
                                            </xsl:if>
                                        </li>
                                    </ul>
                                </xsl:if>
                                    <li>Value constraint(s): 
                                        <ul>
                                            <li>Value lookup source(s) via the <a
                                                href="https://lookup.ld4l.org/">LD4P Authority Lookup
                                                Service</a>: <ul>              
                                                    <xsl:for-each select="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:lookup_pt/uwsinopia:authorities/uwsinopia:authority_urn">
                                                        <li>
                                                            <!-- list lookup authorities using lookup_details template -->
                                                            <xsl:call-template name="lookup_details">
                                                                <xsl:with-param name="label" select="."/>
                                                            </xsl:call-template>                                                     
                                                        </li>
                                                    </xsl:for-each>
                                                </ul>
                                            </li>
                                        </ul>
                                    </li>
                            </xsl:when>
                            
                            <!-- URI pt -->
                            <xsl:when test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:uri_pt">
                                <!-- NEEDS TESTING -->
                                <li>Property type: URI</li>
                                <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:uri_pt/uwsinopia:default_iri or uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:uri_pt/uwsinopia:default_iri_label">
                                    <ul>
                                        <li>Default:
                                            <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:uri_pt/uwsinopia:default_iri_label">
                                                {uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:uri_pt/uwsinopia:_default_iri_label}
                                                <xsl:text> - </xsl:text>
                                            </xsl:if>
                                            <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:uri_pt/uwsinopia:default_iri">
                                                {uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:uri_pt/uwsinopia:default_iri/@iri}
                                            </xsl:if>
                                        </li>
                                    </ul>
                                </xsl:if>
                            </xsl:when>
                            
                            <!-- nested resource -->
                            <!-- NOTE: currently not in use, so no details have been added here-->
                            <xsl:when test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:nested_resource_pt">
                                <li>Property type: nested resource</li>
                            </xsl:when>                        
                        </xsl:choose>
                        
                        <!-- if alt label is used, or prop has subprops, needs list -->
                        <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:alt_pt_label or uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:multiple_prop"> 
                            <xsl:variable name="node_id" select="concat('rdaregistryinfoElements', translate(substring-after(uwmaps:prop_iri/@iri, 'Elements/'), '/', ''), '_define')"/>
                                <xsl:choose>
                                    <!-- call subprop_list template -->
                                    <!-- if there is an alt label, list starts with first prop uri (param alt_id = 0) -->
                                    <xsl:when test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:alt_pt_label">
                                        <xsl:call-template name="subprop_list">
                                            <xsl:with-param name="file_name" select="$file_name"/>
                                            <xsl:with-param name="alt_id" select="number(0)"/>
                                            <xsl:with-param name="node_id" select="$node_id"/>
                                        </xsl:call-template>
                                    </xsl:when>
                                    <!-- otherwise, list starts with second prop uri (param alt_id = 1) -->
                                    <xsl:otherwise>
                                        <xsl:call-template name="subprop_list">
                                            <xsl:with-param name="file_name" select="$file_name"/>
                                            <xsl:with-param name="alt_id" select="number(1)"/>
                                            <xsl:with-param name="node_id" select="$node_id"/>
                                        </xsl:call-template>
                                    </xsl:otherwise>
                                </xsl:choose>   
                        </xsl:if>
                        
                        <!-- links -->
                        <li>
                            <span class="backlink">
                                <a href="#prop_list">
                                    <strong>RETURN TO PROPERTY LIST</strong>
                                </a>
                            </span>
                        </li>
                        <li>
                            <span class="backlink">
                                <a href="#profile">
                                    <strong>RETURN TO PROFILE TOP</strong>
                                </a>
                            </span>
                        </li>
                    </ul>
                </section>
            </xsl:for-each>
        </section>
    </xsl:template>
    
    <!-- template for getting authorities for lookup pts -->
    <!-- pulls data from sinopia_maps/xml/authorityConfig.xml -->
    <xsl:template name="lookup_details">      
        <xsl:param name="label"/>
        <xsl:variable name="authorities_xml" select="(document('../xml/authorityConfig.xml')/data)"/>
        <strong>
            <xsl:value-of select="$label"/>
        </strong>
        <xsl:text> : </xsl:text>
        <xsl:value-of
            select="j:json-to-xml($authorities_xml)/j:array/j:map[j:string[@key = 'label'] = $label]/j:string[@key = 'uri']"/>
    </xsl:template>
    
    <!-- template for generating list of subprops with registry and toolkit links -->
    <!-- pulls data from rdf/xml files, rdaregistry, and map_storage/xml/RDA_alignments.xml -->
    <xsl:template name="subprop_list">
        <xsl:param name="file_name"/>
        <xsl:param name="alt_id"/>
        <xsl:param name="node_id"/>
        
        <!-- list is only generated if it is a multiprop (and it has subprops) OR if it has an alternate id -->
        <xsl:if test="($alt_id = number(1) and count(document($file_name)/rdf:RDF/rdf:Description[@rdf:nodeID = $node_id]/sinopia:hasPropertyUri[position() != 1]) gt 0)
            or ($alt_id = number(0))">  
            <li>Other properties included in this property template:</li>
            <ul>
                <!-- list starts at first or second instance of hasPropertyUri, depending on value of alt_id (0 or 1) -->
                <xsl:for-each select="document($file_name)/rdf:RDF/rdf:Description[@rdf:nodeID = $node_id]/sinopia:hasPropertyUri[position() gt $alt_id]">
                    
                    <!-- subprop_URI is registry link -->
                    <xsl:variable name="subprop_URI" select="@rdf:resource"/>
                    
                    <!-- get all the pieces to find label and toolkit url -->
                    <xsl:variable name="entity">
                        <xsl:variable name="remove_prop_ID" select="substring-before($subprop_URI, '/P')"/>                       
                        <xsl:value-of select="substring-after($remove_prop_ID, 'http://rdaregistry.info/Elements/')"/>
                    </xsl:variable>
                    
                    <!-- get label from rdaregistry -->
                    <xsl:variable name="rdaRegistry_xml" select="concat('http://www.rdaregistry.info/xml/Elements/', $entity, '.xml')"/>
                    <xsl:variable name="subprop_label" select="document($rdaRegistry_xml)/rdf:RDF/rdf:Description[@rdf:about = $subprop_URI]/rdfs:label[@xml:lang = 'en']"/>

                    <!-- get toolkit url from RDA_alignments.xml -->
                    <xsl:variable name="url_end" select="concat('P', substring-after($subprop_URI, '/P'))"/>
                    <xsl:variable name="toolkit_url">
                        <xsl:variable name="prop_number" select="concat('rda', $entity, ':', $url_end)"/>
                        <xsl:value-of select="document('../../map_storage/xml/RDA_alignments.xml')/alignmentPairs/alignmentPair[rdaPropertyNumber = $prop_number]/rdaToolkitURL/@uri"/>
                    </xsl:variable>
                    
                    <li>
                        <xsl:value-of select="$subprop_label"/>
                        [<a
                            href="{$subprop_URI}">RDA REGISTRY</a>] [<a
                                href="{$toolkit_url}">RDA TOOLKIT</a>]
                    </li>
                </xsl:for-each>
            </ul>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>