<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:jix="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs jix" version="3.0">

    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="source_doc"
        select="document('https://github.com/LD4P/sinopia_editor/raw/main/static/authorityConfig.json')"/>
    <xsl:variable name="source_in_xml">
        <jix:map>
            <xsl:for-each select="jix:json-to-xml($source_doc)/jix:array/jix:map">
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </jix:map>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:value-of select="$source_in_xml"/>
    </xsl:template>

</xsl:stylesheet>
