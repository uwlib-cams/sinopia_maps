<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs fn" version="3.0">
    <xsl:output method="xml" indent="1"/>

    <xsl:template match="/">
        <xsl:apply-templates select="document('../xml/authorityConfig.xml')/data"/>
    </xsl:template>
    
    <xsl:template match="data">
        <xsl:copy-of select="fn:json-to-xml(.)"/>
    </xsl:template>    
</xsl:stylesheet>
