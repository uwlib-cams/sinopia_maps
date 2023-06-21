<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" exclude-result-prefixes="xs" version="3.0"
    expand-text="true">
    
    <!-- generates string from resource when resource is "rda[A-Z]*" -->
    <xsl:template name="format_resource">
        <xsl:param name="resource"/>
        <xsl:variable name="formatted_resource" select="replace($resource, 'rda', 'RDA ')"/>
        <xsl:text>{$formatted_resource}</xsl:text>
    </xsl:template>
    
    <!-- generates string from format -->
    <xsl:template name="format_format">
        <xsl:param name="format"/>
        <!-- check for qualifier at beginning of format (e.g. aggregating_printMonograph) -->
        <xsl:choose>
            <!-- if qualifier exists, separate string into qualifier and the rest and pass on -->
            <xsl:when test="contains($format, '_')">
                <xsl:variable name="qualifier" select="substring-before($format, '_')"/>
                <xsl:variable name="format_wq" select="substring-after($format, '_')"/>
                <xsl:call-template name="format_postq">
                    <xsl:with-param name="format" select="$format_wq"/>
                    <xsl:with-param name="qualifier" select="$qualifier"/>
                </xsl:call-template>
            </xsl:when>
            <!-- otherwise pass empty string as qualifier -->
            <xsl:otherwise>
                <xsl:call-template name="format_postq">
                    <xsl:with-param name="format" select="$format"/>
                    <xsl:with-param name="qualifier" select="''"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- post qualifier test, generate string from format -->
    <xsl:template name="format_postq">
        <xsl:param name="format"/>
        <xsl:param name="qualifier"/>
        <xsl:choose>
            <!-- if format contains capital letter (e.g. printMonograph) -->
            <xsl:when test="contains($format, '[A-Z]')">
                <xsl:variable name="formatted_format">
                    <!-- add space before capital letter -->
                    <xsl:variable name="first_word" select="replace(substring-before($format, '[A-Z]'), '/.*', '/.* ')"/>
                    <xsl:variable name="First_word" select="concat(
                        upper-case(substring($format, 1, 1)), substring($first_word,2)
                        )"/>
                    <xsl:variable name="Second_word" select="substring-after($format, $First_word)"/>
                    <!-- add qualifier at end of string if it exists -->
                    <xsl:choose>
                        <xsl:when test="$qualifier != ''">
                            <xsl:value-of select="concat($First_word, ' ', $Second_word, 
                                ' (', upper-case(substring($format, 1, 1)), substring($qualifier,2), ')')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($First_word, ' ', $Second_word)"/>    
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:text>{$formatted_format}</xsl:text>
            </xsl:when>
            <!-- if format is just one word (e.g. "test") -->
            <xsl:otherwise>
                <xsl:variable name="formatted_format">
                    <xsl:choose>
                        <xsl:when test="$qualifier != ''">
                            <xsl:value-of select="concat(
                                translate(substring($format, 1, 1),'[a-z]','[A-Z]'), 
                                substring($format, 2), 
                                ' (', replace(substring($qualifier, 1, 1),'[a-z]','[A-Z]'),
                                substring($qualifier,2), ')')"/>
                            <xsl:value-of select="rep"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat(
                                upper-case(substring($format, 1, 1)), substring($format,2)
                                )"/>   
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:text>{$formatted_format}</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>