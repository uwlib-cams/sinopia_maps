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
    
    <xsl:template name="pt_details">
        <xsl:param name="rt_id"/>
        <xsl:param name="prop"/>
        <xsl:param name="file_name"/>
        <section class="ptList"> 
            <xsl:for-each select="$prop">
                <section class="ptInfo" id="{uwmaps:sinopia/uwsinopia:implementation_set/@localid_implementation_set}">
                    <h4>
                        <span>
                            <xsl:text>Property Template: </xsl:text>
                            <xsl:choose>
                                <xsl:when test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:alt_pt_label">
                                    {uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:alt_pt_label}
                                </xsl:when>
                                <xsl:otherwise>{uwmaps:prop_label}</xsl:otherwise>                               
                            </xsl:choose>     
                            <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:required"> 
                                <xsl:text>(*)</xsl:text>
                            </xsl:if>
                        </span>
                    </h4>
                    <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:remark">
                        <p>
                            <span class="ptInfoRemark">
                                {uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:remark}
                            </span>
                        </p>
                    </xsl:if>
                    <ul>
                        <li>Property IRI: <a href="{uwmaps:prop_iri/@iri}">{uwmaps:prop_iri/@iri}</a></li>
                        <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:remark_url">
                            <li>RDA Toolkit URL: <a href="{uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:remark_url/@iri}">{uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:remark_url/@iri}</a></li>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:required">
                                <li>Mandatory</li>
                            </xsl:when>
                            <xsl:otherwise>
                                <li>Optional</li>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:repeatable">
                                <li>Repeatable</li>
                            </xsl:when>
                            <xsl:otherwise>
                                <li>Not repeatable</li>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                        <xsl:choose>
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
                                <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:uri_pt/*">
                                    <li>Value constraint(s): 
                                        
                                    </li>
                                </xsl:if>
                            </xsl:when>
                            <xsl:when test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:nested_resource_pt">
                                <li>Property type: nested resource</li>
                            </xsl:when>                        
                        </xsl:choose>
                        <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:alt_pt_label or uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:multiple_prop"> 
                            <xsl:variable name="node_id" select="concat('rdaregistryinfoElements', translate(substring-after(uwmaps:prop_iri/@iri, 'Elements/'), '/', ''), '_define')"/>
                                <xsl:choose>
                                    <xsl:when test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:alt_pt_label">
                                        <xsl:call-template name="subprop_list">
                                            <xsl:with-param name="file_name" select="$file_name"/>
                                            <xsl:with-param name="alt_id" select="number(0)"/>
                                            <xsl:with-param name="node_id" select="$node_id"/>
                                        </xsl:call-template>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:call-template name="subprop_list">
                                            <xsl:with-param name="file_name" select="$file_name"/>
                                            <xsl:with-param name="alt_id" select="number(1)"/>
                                            <xsl:with-param name="node_id" select="$node_id"/>
                                        </xsl:call-template>
                                    </xsl:otherwise>
                                </xsl:choose>   
                        </xsl:if>
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
    
    <xsl:template name="subprop_list">
        <xsl:param name="file_name"/>
        <xsl:param name="alt_id"/>
        <xsl:param name="node_id"/>
        
        <xsl:if test="($alt_id = number(1) and count(document($file_name)/rdf:RDF/rdf:Description[@rdf:nodeID = $node_id]/sinopia:hasPropertyUri[position() != 1]) gt 0)
            or ($alt_id = number(0))">  
            <li>Other properties included in this property template:</li>
            <ul>
                <xsl:for-each select="document($file_name)/rdf:RDF/rdf:Description[@rdf:nodeID = $node_id]/sinopia:hasPropertyUri[position() gt $alt_id]">
                    <xsl:variable name="subprop_URI" select="@rdf:resource"/>
                    <xsl:variable name="entity">
                        <xsl:variable name="remove_prop_ID" select="substring-before($subprop_URI, '/P')"/>
                        <xsl:value-of select="substring-after($remove_prop_ID, 'http://rdaregistry.info/Elements/')"/>
                    </xsl:variable>
                    <xsl:variable name="rdaRegistry_xml" select="concat('http://www.rdaregistry.info/xml/Elements/', $entity, '.xml')"/>
                    <xsl:variable name="subprop_label" select="document($rdaRegistry_xml)/rdf:RDF/rdf:Description[@rdf:about = $subprop_URI]/rdfs:label[@xml:lang = 'en']"/>
                    <li>
                        <xsl:value-of select="$subprop_label"/>
                    </li>
                </xsl:for-each>
            </ul>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>