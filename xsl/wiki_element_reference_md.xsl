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
    <!-- need function or addition to get attribute annotations -->
    <!-- add choose, etc. to add note in cases where annotations still need to be added to schema -->
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
    <!-- function for getting enumeration bullets?? -->

    <xsl:template match="/">
        <!-- [!] NOTE filepath to output -->
        <xsl:result-document href="../../sinopia_maps.wiki/element_reference.md">
            <xsl:text>
# ELEMENT REFERENCE
DRAFT documentation - *please provide documentation feedback [here](https://github.com/uwlib-cams/sinopia_maps/issues/new?assignees=briesenberg07&amp;labels=documentation&amp;template=documentation.md&amp;title=documentation+work+needed)*

## OVERVIEW: SINOPIA_MAPS STRUCTURE
- [sinopia_maps](#sinopia_maps)
    - [rts](#rts)
        - [rt](#rt)
            - [institution](#institution)
            - [resource](#resource)
            - [format](#format)
            - [author(#author)

## OVERVIEW: PROP_SET STRUCTURE
- [prop_set](#prop_set)
    - [prop_set_label](#prop_set_label)
    - [prop](#prop) / [\@localid_prop](#localid_prop)
        - [prop_iri](#prop_iri)
        - [prop_label](#prop_label)
        - [prop_domain](#prop_domain)
        - [prop_domain_includes](#prop_domain_includes)
        - [prop_range](#prop_range)
        - [prop_range_includes](#prop_range_includes)
        - [prop_related_url](#prop_related_url)
        - [sinopia](#sinopia)
            - [implementation_set](#implementation_set) / [\@localid_implementation_set](#localid_implementation_set)
                - [resource](#resource)
                - [format](#format)
                - [user](#user)
                - [form_order](#form_order)
                - [multiple_prop](#multiple_prop)
                    - [all_subprops](#all_subprops)
                    - [property_selection](#property_selection)
                - [remark_url](#remark_url)
                - [remark](#remark)
                - [language_suppressed](#language_suppressed)
                - [required](#required)
                - [repeatable](#repeatable)
                - [literal_pt](#literal_pt)
                    - [date_default](#date_default)
                    - [userId_default](#userId_default)
                    - [default_literal](#default_literal)
                    - [validation_datatype](#validation_datatype)
                    - [validation_regex](#validation_regex)
                - [uri_pt](#uri_pt)
                    - [default_uri](#default_uri) / [\@iri](#iri)
                    - [default_uri_label](#default_uri_label) / [\@xml:lang](#xml_lang)
                - [lookup_pt](#lookup_pt)
                    - [authorities](#authorities)
                        - [authority_urn](#authority_urn)
                    - [lookup_default_iri](#lookup_default_iri) / [\@iri](#iri)
                    - [lookup_default_iri_label](#lookup_default_iri_label) / [\@xml:lang](#xml_lang)
                - [nested_resource_pt](#nested_resource_pt)
                    - [rt_id](#rt_id)
            </xsl:text>
            <xsl:text>
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
...
...
...
            </xsl:text>
            <xsl:text>
### multiple_prop
        </xsl:text>
            <xsl:value-of select="bmrxml:uwsinopia_doc_bullets('complex', 'multiple_prop_type')"/>
            <xsl:text>
### property_selection
        </xsl:text>
            <xsl:value-of
                select="bmrxml:uwsinopia_doc_bullets('complex', 'property_selection_type')"/>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
