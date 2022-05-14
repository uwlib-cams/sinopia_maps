<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:bmrxml="https://briesenberg07.github.io/xml_stack/" exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="text" indent="0"/>
    <!-- schema docs -->
    <xsl:variable name="uwmaps"
        select="document('https://github.com/uwlib-cams/map_storage/raw/main/xsd/prop_set.xsd')/xs:schema"/>
    <xsl:variable name="uwsinopia"
        select="document('https://github.com/uwlib-cams/sinopia_maps/raw/main/xsd/uwsinopia.xsd')/xs:schema"/>
    
    <!-- functions -->
    <xsl:function name="bmrxml:uwmaps_doc_bullets">
        <xsl:param name="element_type" as="xs:string"/>
        <xsl:param name="element_type_name" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="$element_type = 'complex'">
                <xsl:for-each
                    select="$uwmaps//xs:complexType[@name = $element_type_name]/xs:annotation/xs:documentation">
                    <xsl:text>&#10;</xsl:text>
                    <xsl:value-of select="normalize-space(concat('- ', .))"/>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="$element_type = 'simple'">
                <xsl:for-each
                    select="$uwmaps//xs:simpleType[@name = $element_type_name]/xs:annotation/xs:documentation">
                    <xsl:text>&#10;</xsl:text>
                    <xsl:value-of select="normalize-space(concat('- ', .))"/>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>ERROR - NO MATCH GIVEN TYPE OR GIVEN TYPE NAME</xsl:text>
                <xsl:text>$element_type value must be either 'simple' or 'complex'</xsl:text>
                <xsl:text>$element_type_name must be the simpleType or complexType @name value</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="bmrxml:uwsinopia_doc_bullets">
        <xsl:param name="element_type" as="xs:string"/>
        <xsl:param name="element_type_name" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="$element_type = 'complex'">
                <xsl:for-each
                    select="$uwsinopia//xs:complexType[@name = $element_type_name]/xs:annotation/xs:documentation">
                    <xsl:text>&#10;</xsl:text>
                    <xsl:value-of select="normalize-space(concat('- ', .))"/>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="$element_type = 'simple'">
                <xsl:for-each
                    select="$uwsinopia//xs:simpleType[@name = $element_type_name]/xs:annotation/xs:documentation">
                    <xsl:text>&#10;</xsl:text>
                    <xsl:value-of select="normalize-space(concat('- ', .))"/>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>ERROR - NO MATCH GIVEN TYPE OR GIVEN TYPE NAME</xsl:text>
                <xsl:text>$element_type value must be either 'simple' or 'complex'</xsl:text>
                <xsl:text>$element_type_name must be the simpleType or complexType @name value</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:template match="/">
        <!-- [!] NOTE filepath to output -->
        <xsl:result-document href="../../sinopia_maps.wiki/element_reference.md">
            <xsl:text>
# ELEMENT REFERENCE
DRAFT documentation - *please provide documentation feedback [here](https://github.com/uwlib-cams/sinopia_maps/issues/new?assignees=briesenberg07&amp;labels=documentation&amp;template=documentation.md&amp;title=documentation+work+needed)*
## OVERVIEW: PROP_SET STRUCTURE
- prop_set
    - prop_set_label - [details](#prop_set_label)
    - prop - [details](#prop)

## ELEMENT DETAILS
### prop_set
- Root element of the instance
### prop_set_label
            </xsl:text>
            <xsl:value-of select="bmrxml:uwmaps_doc_bullets('simple', 'prop_set_label_type')"/>
            <xsl:text>
### prop
            </xsl:text>
            <xsl:value-of select="bmrxml:uwmaps_doc_bullets('complex', 'prop_type')"/>
            <xsl:text>
### prop_set_label

            </xsl:text>
            <xsl:text>
### multiple_prop
        </xsl:text>
            <xsl:value-of select="bmrxml:uwsinopia_doc_bullets('complex', 'multiple_prop_type')"/>
            <xsl:text>
### property
        </xsl:text>
            <xsl:value-of
                select="bmrxml:uwsinopia_doc_bullets('complex', 'property_selection_type')"/>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
