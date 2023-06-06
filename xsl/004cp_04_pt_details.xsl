<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" exclude-result-prefixes="xs" version="3.0"
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
                            <xsl:if test="uwmaps:sinopia/uwsinopia:implementaiton_set/uwsinopia:required"> 
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
                                
                                <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:literal_pt/*">
                                    <li>Value constraint(s): 
                                    </li>
                                </xsl:if>
                            </xsl:when>
                            <xsl:when test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:lookup_pt">
                                <li>Property type: lookup</li>
                                
                                <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:lookup_pt/*">
                                    <li>Value constraint(s): 
                                    </li>
                                </xsl:if>
                            </xsl:when>
                            <xsl:when test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:uri_pt">
                                <li>Property type: URI</li>
                                
                                <xsl:if test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:uri_pt/*">
                                    <li>Value constraint(s): 
                                    </li>
                                </xsl:if>
                            </xsl:when>
                            <xsl:when test="uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:nested_resource_pt">
                                <li>Property type: nested resource</li>
                            </xsl:when>
                        </xsl:choose>
                        
                        
                    </ul>
                </section>
            </xsl:for-each>
        </section>
    </xsl:template>
</xsl:stylesheet>