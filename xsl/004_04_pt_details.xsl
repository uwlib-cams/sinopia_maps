<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:j="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs sinopia uwmaps uwsinopia rdf rdfs j"
    version="3.0"
    expand-text="true">
    
    <xsl:output method="html"/>
    
    <xsl:include href="004_05_pt_guidance.xsl"/>
    
    <!-- CONTAINS PT_DETAILS, LOOKUP_DETAILS, AND SUBPROP_LIST TEMPLATES -->
    
    <!-- template to generate all information about properties -->
    <!-- pulls data from prop_set files -->
    <xsl:template name="pt_details">
        <xsl:param name="rt_id"/>
        <xsl:param name="prop"/>
        <xsl:param name="file_name"/>
        <section> 
            <h2>Property Template Details</h2>
            <div class="ptInfo">
            <xsl:for-each select="$prop">
                <section class="ptInfo" id="{uwmaps:sinopia/uwsinopia:implementation_set/@localid_implementation_set}">
                    
                    <h3>
                        <span>
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
                    </h3>
                    
                    <!-- include remark if available -->
                    <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:remark">
                        <p>
                            <span class="ptInfoRemark">
                                {uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:remark}
                            </span>
                        </p>
                    </xsl:if>
                    
                    <!-- include Guidance if available -->
                    <xsl:if test="uwmaps:sinopia/uwsinopia:guidance_set and uwmaps:sinopia/uwsinopia:guidance_set != ''">
                        <span class="ptInfoGuidance">
                            <b>Cataloging Guidance</b>
                            <xsl:call-template name="pt_guidance">
                                <xsl:with-param name="prop" select="$prop"/>
                                <xsl:with-param name="rt_id" select="$rt_id"/>
                            </xsl:call-template>
                        </span>
                    </xsl:if>
                 
                    <!-- show prop label with links -->
                    <xsl:variable name="node_id" select="concat(translate(substring-after(uwmaps:prop_iri/@iri, '://'), '/.#', ''), '_define')"/>
                    <p>
                    <xsl:call-template name="prop_list">
                        <xsl:with-param name="file_name" select="$file_name"/>
                        <xsl:with-param name="node_id" select="$node_id"/>
                        <xsl:with-param name="prop" select="$prop"/>
                        <xsl:with-param name="prop_iri" select="uwmaps:prop_iri/@iri"/>
                    </xsl:call-template>
                    </p>
                    <ul>
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
                                <li>Repeatable</li>
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
                                <li>Property Template type: literal
                                <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:literal_pt/*">
                                    <ul>
                                        <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:literal_pt/uwsinopia:date_default">
                                             <li>Defaults to current date</li>
                                         </xsl:if>
                                         <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:literal_pt/uwsinopia:userId_default">
                                             <li>Defaults to user id</li>
                                         </xsl:if>
                                         <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:literal_pt/uwsinopia:default_literal">
                                             <li>Defaults to: 
                                                {uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:literal_pt/uwsinopia:default_literal}
                                             </li>
                                         </xsl:if>
                                         <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:literal_pt/uwsinopia:validation_datatype">
                                             <li>Validation type: 
                                                {uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:literal_pt/uwsinopia:validation_datatype}
                                             </li>
                                         </xsl:if>
                                        <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:literal_pt/uwsinopia:validation_regex">
                                            <li>Validation regex: 
                                                {uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:literal_pt/uwsinopia:validation_regex}
                                            </li>
                                        </xsl:if>
                                    </ul>
                                </xsl:if>
                                </li>
                            </xsl:when>
                            
                            <!-- lookup pt -->
                            <xsl:when test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:lookup_pt">
                                <li>Property Template type: lookup
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
                                </li>
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
                                <li>Property Template type: URI
                                <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:uri_pt/uwsinopia:default_uri">
                                    <ul>
                                        <li>Default:
                                            <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:uri_pt/uwsinopia:default_uri_label">
                                                {uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:uri_pt/uwsinopia:default_uri_label}
                                                <xsl:text> - </xsl:text>
                                            </xsl:if>
                                            <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:uri_pt/uwsinopia:default_uri">
                                                {uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:uri_pt/uwsinopia:default_uri/@iri}
                                            </xsl:if>
                                        </li>
                                    </ul>
                                </xsl:if>
                                </li>
                            </xsl:when>
                            
                            <!-- nested resource -->
                            <!-- NOTE: currently not in use, so no details have been added here-->
                            <xsl:when test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:nested_resource_pt">
                                <li>Property Template type: nested resource</li>
                            </xsl:when>                        
                        </xsl:choose>                  
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
            </div>
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
    <!-- pulls data from rdf/xml files, prop_set files, rdaregistry, and map_storage/xml/RDA_alignments.xml -->
    <xsl:template name="prop_list">
        <xsl:param name="file_name"/>
        <xsl:param name="node_id"/>
        <xsl:param name="prop"/>
        <xsl:param name="prop_iri"/>
        
        <xsl:choose>
            <!-- list is only generated if more than two properties -->
            <xsl:when test="count(document($file_name)/rdf:RDF/rdf:Description[@rdf:nodeID = $node_id]/sinopia:hasPropertyUri) gt 1">  
                Properties included in this property template:
                <ul>
                    <xsl:for-each select="document($file_name)/rdf:RDF/rdf:Description[@rdf:nodeID = $node_id]/sinopia:hasPropertyUri">   
                        <!-- subprop_URI is registry link -->
                        <xsl:variable name="subprop_URI" select="@rdf:resource"/>
                        <xsl:choose>
                            <!-- RDA prop multiprop -->
                            <xsl:when test="starts-with($subprop_URI, 'http://rdaregistry.info')">
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
                               
                               <!-- get property id -->
                               <xsl:variable name="last_8_characters"
                                   select="substring-after($subprop_URI, 'http://rdaregistry.info/Elements/')"/>
                               <xsl:variable name="prop_id"
                                   select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                               
                               <xsl:if test="not(contains($subprop_label, 'agent'))">
                                   <li>
                                       <xsl:value-of select="$subprop_label"/>
                                       [<a href="{$subprop_URI}"><xsl:value-of select="$prop_id"/> RDA REGISTRY</a>] [<a href="{$toolkit_url}"><xsl:value-of select="$prop_id"/> RDA TOOLKIT</a>]
                                   </li>
                               </xsl:if>
                            </xsl:when>
                            
                            <!-- UW RDA ext. prop link and label -->
                            <xsl:when test="starts-with($subprop_URI, 'https://doi.org/10.6069/uwlib.55.d.4')">
                                <!-- get label from uwRDaExtension prop_set -->
                                <xsl:variable name="subprop_label" select="
                                    document('../../map_storage/prop_set_uwRdaExtension.xml')/uwmaps:prop_set/uwmaps:prop[uwmaps:prop_iri[@iri = $subprop_URI]]/uwmaps:prop_label"
                                    />
                                <li>
                                    <xsl:value-of select="$subprop_label"/>
                                    [<a href="{$subprop_URI}">UW RDA Application Profile Extension</a>]
                                </li>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <xsl:text>ERROR - MULTIPLE-PROPERTY PTs NOT CONFIGURED FOR THIS SOURCE</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </ul>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="document($file_name)/rdf:RDF/rdf:Description[@rdf:nodeID = $node_id]/sinopia:hasPropertyUri">
                   
                    <!-- prop_URI is registry link (or link to uw extension) -->
                    <xsl:variable name="prop_URI" select="@rdf:resource"/>
                    
                    <xsl:choose>
                        <!-- RDA prop label and links -->
                        <xsl:when test="starts-with($prop_URI, 'http://rdaregistry.info')">
                        
                             <!-- get all the pieces to find label and toolkit url -->
                             <xsl:variable name="entity">
                                 <xsl:variable name="remove_prop_ID" select="substring-before($prop_URI, '/P')"/>                       
                                 <xsl:value-of select="substring-after($remove_prop_ID, 'http://rdaregistry.info/Elements/')"/>
                             </xsl:variable>
                             
                             <!-- get toolkit url from RDA_alignments.xml -->
                             <xsl:variable name="url_end" select="concat('P', substring-after($prop_URI, '/P'))"/>
                             <xsl:variable name="toolkit_url">
                                 <xsl:variable name="prop_number" select="concat('rda', $entity, ':', $url_end)"/>
                                 <xsl:value-of select="document('../../map_storage/xml/RDA_alignments.xml')/alignmentPairs/alignmentPair[rdaPropertyNumber = $prop_number]/rdaToolkitURL/@uri"/>
                             </xsl:variable>
                             
                             <!-- get property id -->
                             <xsl:variable name="last_8_characters"
                                 select="substring-after($prop_URI, 'http://rdaregistry.info/Elements/')"/>
                             <xsl:variable name="prop_id"
                                 select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                            
                            <xsl:variable name="prop_label" select="$prop[uwmaps:prop_iri[@iri = $prop_iri]]/uwmaps:prop_label"/>
                            <xsl:value-of select="$prop_label"/>
                             [<a href="{$prop_URI}"><xsl:value-of select="$prop_id"/> RDA REGISTRY</a>] [<a href="{$toolkit_url}"><xsl:value-of select="$prop_id"/> RDA TOOLKIT</a>]
                        </xsl:when>
                        
                        <!-- UW RDA ext. prop link and label -->
                        <xsl:when test="starts-with($prop_URI, 'https://doi.org/10.6069/uwlib.55.d.4')">
                            <xsl:variable name="prop_label" select="$prop[uwmaps:prop_iri[@iri = $prop_iri]]/uwmaps:prop_label"/>
                            <xsl:value-of select="$prop_label"/>
                            [<a href="{$prop_URI}">UW RDA Application Profile Extension</a>]
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:text>ERROR - MULTIPLE-PROPERTY PTs NOT CONFIGURED FOR THIS SOURCE</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>          
    </xsl:template>
</xsl:stylesheet>