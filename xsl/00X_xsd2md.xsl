<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <xsl:output method="text" indent="1"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="xs:schema/xs:element"/>
    </xsl:template>
    
    <xsl:template match="xs:element[child::node()]">
        <xsl:variable name="type" select="@type"/>
        <xsl:value-of select="concat('# ', @name)"/>
        <xsl:text>&#10;</xsl:text>
        <xsl:apply-templates select="../xs:complexType[@name = $type]"/>
    </xsl:template>
    
    <xsl:template match="xs:complexType">
        <xsl:variable name="type" select="@name"/>
        <xsl:for-each select="xs:sequence/xs:element">
            <xsl:value-of select="concat('# ', @name)"/>
            <xsl:text>&#10;</xsl:text>
            <xsl:apply-templates select="../../xs:complexType[@name = $type]"/>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>