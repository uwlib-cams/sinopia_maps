<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:jix="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs jix"
    version="3.0">
    
    <xsl:output indent="yes"/>
    
    <xsl:variable name="source_doc" 
        select="document('https://github.com/LD4P/sinopia_editor/raw/main/static/authorityConfig.json')"/>
    
    <xsl:template match="/">
        <xsl:for-each select="jix:json-to-xml($source_doc/jix:array/jix:map/jix:string[@key = 'label'])">
            <xsl:value-of select="."/>
        </xsl:for-each>>
    </xsl:template>
    
    <!--
    <xsl:variable name="qa_urn" as="node()*"/>
    -->
    
</xsl:stylesheet>