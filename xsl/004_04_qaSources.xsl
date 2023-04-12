<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:j="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="j" version="3.0">

    <xsl:variable name="authorities_xml" select="(document('../xml/authorityConfig.xml')/data)"/>

    <xsl:variable name="viaQaText">
        <xsl:text> via the </xsl:text>
        <a href="https://lookup.ld4l.org/">
            <xsl:text>LD4P Authority Lookup Service</xsl:text>
        </a>
        <xsl:text> > </xsl:text>
        <a href="https://lookup.ld4l.org/authority_list">
            <xsl:text>Authorities</xsl:text>
        </a>
        <xsl:text> (cached) > </xsl:text>
    </xsl:variable>

    <xsl:template name="lookup_details">
        <xsl:param name="uri"/>
        <strong>
            <xsl:value-of
                select="j:json-to-xml($authorities_xml)/j:array/j:map[j:string[@key = 'uri'] = $uri]/j:string[@key = 'label']"
            />
        </strong>
        <xsl:text> : </xsl:text>
        <xsl:value-of select="$uri"/>
    </xsl:template>
    
</xsl:stylesheet>
