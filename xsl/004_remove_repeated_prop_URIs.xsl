<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:template match="/">
        <!-- for each RDF file -->
        <!-- Collection of RDF files -->
        <xsl:variable name="rdf_files" as="xs:string*">
            <xsl:for-each select="collection('../?select=*.rdf')/rdf:RDF/rdf:Description/sinopia:hasResourceId">
                <xsl:copy-of select="replace(., ':', '_')"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:for-each select="$rdf_files">
            <xsl:variable name="file_name" select="."/>
            <xsl:result-document href="../{$file_name}_test.rdf">
                <rdf:RDF>
                    <xsl:for-each select="document(concat('../',$file_name,'.rdf'))/rdf:RDF/rdf:Description">
                        <xsl:choose>
                            <xsl:when test="rdf:type/@rdf:resource='http://sinopia.io/vocabulary/PropertyTemplate'">
                                <xsl:variable name="node_id" select="@rdf:nodeID"/>
                                <rdf:Description rdf:nodeID="{$node_id}">
                                    <xsl:copy-of select="rdf:type"/>
                                    <xsl:copy-of select="rdfs:label"/>
                                    <xsl:for-each select="sinopia:hasPropertyUri">
                                        <xsl:variable name="prop_uri" select="@rdf:resource"/>
                                        <xsl:choose>
                                            <xsl:when test="/rdf:RDF/rdf:Description[not(@rdf:nodeID=$node_id)]/sinopia:hasPropertyUri/@rdf:resource=$prop_uri">
                                                <xsl:variable name="node_id_list" as="xs:string*">
                                                    <xsl:for-each select="/rdf:RDF/rdf:Description[sinopia:hasPropertyUri/@rdf:resource=$prop_uri]">
                                                        <xsl:copy-of select="@rdf:nodeID"/>
                                                    </xsl:for-each>
                                                </xsl:variable>
                                                <xsl:choose>
                                                    <xsl:when test="$node_id = $node_id_list[1]">
                                                        <!-- <xsl:comment> it's the first! </xsl:comment> -->
                                                        <xsl:copy-of select="."/>
                                                        <!-- <xsl:comment> end of first </xsl:comment> -->
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <!-- <xsl:comment> it's not the first </xsl:comment> -->
                                                        <xsl:comment> &lt;sinopia:hasPropertyUri rdf:resource="<xsl:value-of select="@rdf:resource"/>"/&gt; </xsl:comment>
                                                        <!-- <xsl:comment> end of NOT first</xsl:comment> -->
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <!-- <xsl:comment> it doesn't repeat anywhere </xsl:comment> -->
                                                <xsl:copy-of select="."/>
                                                <!-- <xsl:comment> end of not repeat</xsl:comment> -->
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each>
                                    <xsl:if test="sinopia:hasRemarkUrl">
                                        <xsl:copy-of select="sinopia:hasRemarkUrl"/>
                                    </xsl:if>
                                    <xsl:if test="sinopia:hasPropertyAttribute">
                                        <xsl:copy-of select="sinopia:hasPropertyAttribute"/>
                                    </xsl:if>
                                    <xsl:if test="sinopia:hasPropertyType">
                                        <xsl:copy-of select="sinopia:hasPropertyType"/>
                                    </xsl:if>
                                    <xsl:if test="sinopia:hasResourceAttributes">
                                        <xsl:copy-of select="sinopia:hasResourceAttributes"></xsl:copy-of>
                                    </xsl:if>
                                    <xsl:if test="sinopia:hasLookupAttributes">
                                        <xsl:copy-of select="sinopia:hasLookupAttributes"/>
                                    </xsl:if>
                                </rdf:Description>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:copy-of select="."/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </rdf:RDF>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>