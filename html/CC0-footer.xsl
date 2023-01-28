<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- generate footer with CC0 dedication; 
        include spacing (see div w. class footer_workaround) at bottom of page to avoid overlap -->
    
    <xsl:template name="CC0-footer">
        <xsl:param name="resource_title"/>
        <xsl:param name="org"/>
        <!-- Markup adapted from HTML provided following form submission at Creative Commons for CC0 license usage -->
        <div  class="footer_workaround"/>
        <footer>
            <p xmlns:dct="http://purl.org/dc/terms/"
                xmlns:vcard="http://www.w3.org/2001/vcard-rdf/3.0#">
                <a rel="license" href="http://creativecommons.org/publicdomain/zero/1.0/">
                    <img src="http://i.creativecommons.org/p/zero/1.0/88x31.png"
                        style="border-style: none;" alt="CC0"/>
                </a>
                <br/>
                <xsl:text>To the extent possible under law, </xsl:text>
                <xsl:choose>
                    <xsl:when test="$org = 'cams'">
                        <a rel="dct:publisher" href="https://www.lib.washington.edu/cams">
                            <span property="dct:title">
                                <xsl:text>Cataloging and Metadata Services, University of Washington Libraries</xsl:text>
                            </span>
                        </a>
                    </xsl:when>
                    <xsl:when test="$org = 'mig'">
                        <a rel="dct:publisher" href="https://www.lib.washington.edu/cams/mig">
                            <span property="dct:title">
                                <xsl:text>Metadata Implementation Group, University of Washington Libraries</xsl:text>
                            </span>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>ERROR GENERATING ORG NAME FOR FOOTER</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                
                <xsl:text> has waived all copyright and related or neighboring rights to </xsl:text>
                <span property="dct:title">
                    <xsl:value-of select="$resource_title"/>
                </span>
                <xsl:text>. This work is published from: </xsl:text>
                <span property="vcard:Country" datatype="dct:ISO3166" content="US"
                    about="https://www.lib.washington.edu/cams">
                    <xsl:text>United States</xsl:text>
                </span>
                <xsl:text>. </xsl:text>
            </p>
        </footer>
    </xsl:template>
    
</xsl:stylesheet>