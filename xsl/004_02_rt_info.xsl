<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" exclude-result-prefixes="xs" version="3.0"
    expand-text="true">
    
    <!-- basic info about RT (may add more here?)-->
    <xsl:template name="rt_info">
        <!-- this template pulls from RDF/XML, forming file name based on variables -->
        <xsl:param name="file_name"/>
        <xsl:param name="rt_id"/>
        <xsl:param name="rt_remark"/>
        <xsl:param name="format"/>
        <xsl:param name="user"/>
        <xsl:variable name="rdf_about"
            select="concat('https://api.sinopia.io/resource/', $rt_id)"/> 
        <xsl:variable name="iri" select="document($file_name)/rdf:RDF/rdf:Description[@rdf:about = $rdf_about]/sinopia:hasClass/@rdf:resource"/>
        <xsl:variable name="id" select="document($file_name)/rdf:RDF/rdf:Description[@rdf:about = $rdf_about]/sinopia:hasResourceId"/>
        <xsl:variable name="author" select="document($file_name)/rdf:RDF/rdf:Description[@rdf:about = $rdf_about]/sinopia:hasAuthor"/>
        <xsl:variable name="date" select="document($file_name)/rdf:RDF/rdf:Description[@rdf:about = $rdf_about]/sinopia:hasDate"/>
       
        <table class="rtInfo">
            <thead>
                <tr>
                    <th colspan="2">
                        <xsl:text>Resource Template ID: </xsl:text>
                        <xsl:value-of select="$rt_id"/>
                    </th>
                </tr>
            </thead>
            <tbody>
                <xsl:if test="$rt_remark != ''">
                    <tr>
                        <td colspan="2" class="oneTwenty italic">
                            <xsl:value-of select="$rt_remark"/>
                        </td>
                    </tr>
                </xsl:if>
                <tr>
                    <th scope="row">Resource IRI</th>
                    <td>
                        <a href="{$iri}">
                            <xsl:value-of select="$iri"/>
                        </a>
                    </td>
                </tr>
               <tr>
                   <th scope="row">To describe</th>
                   <td>
                       <xsl:value-of select="$format"/>
                   </td>
               </tr> 
                <tr>
                    <th scope="row">For user/user group</th>
                    <td>
                        <xsl:value-of select="$user"/>
                    </td>
                </tr>    
                <tr>
                    <th scope="row">Author</th>
                    <td>
                        <xsl:value-of select="$author"/>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Last Updated</th>
                    <td>
                        <xsl:value-of select="$date"/>
                    </td>
                </tr>
                <tr class="backlink">
                    <th scope="row" colspan="2">
                        <a href="https://uwlib-cams.github.io/sinopia_maps/">
                            <xsl:text>RETURN TO SINOPIA_MAPS INDEX</xsl:text>
                        </a>
                    </th>
                </tr>
            </tbody>
        </table>
    </xsl:template>
</xsl:stylesheet>