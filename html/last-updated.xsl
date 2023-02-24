<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">
    
    <!-- provide date of last update...
    or more accurately, the last time that a page was generated from stylesheet(s) -->

    <xsl:template name="lastUpdate">
        <p>
            <span class="lastUpdate">
                <xsl:text>This page last updated: </xsl:text>
                <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
            </span>
        </p>
    </xsl:template>

</xsl:stylesheet>
