<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:bmrxml="https://briesenberg07.github.io/xml_stack/" exclude-result-prefixes="xs math"
    version="3.0">

    <xsl:output method="html" indent="1"/>

    <!-- to do: get enumerations -->

    <!-- output back-to-top link -->
    <xsl:variable name="back_to_top">
        <xsl:text>
*back to [top](#element-reference)*
        </xsl:text>
    </xsl:variable>

    <!-- xs:elements -->
    <xsl:function name="bmrxml:xselement">
        <xsl:param name="repo"/>
        <xsl:param name="document"/>
        <xsl:param name="name"/>
        <xsl:variable name="selected_element" select="
                document(concat('https://github.com/uwlib-cams/', $repo, '/raw/main/xsd/', $document, '.xsd'))
                /xs:schema//xs:element[@name = $name]"/>
        <xsl:choose>
            <!-- REQUIRED / OPTIONAL -->
            <xsl:when test="$selected_element/@minOccurs = '1'">
                <xsl:text>
- ***REQUIRED***
                </xsl:text>
            </xsl:when>
            <xsl:when test="$selected_element/@minOccurs = '0'">
                <xsl:text>
- ***OPTIONAL***
                </xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:choose>
            <!-- REPEATABLE / NOT REPEATABLE -->
            <xsl:when test="$selected_element/@maxOccurs = '1'">
                <xsl:text>
- ***NOT REPEATABLE***
                </xsl:text>
            </xsl:when>
            <xsl:when test="$selected_element/@maxOccurs = 'unbounded'">
                <xsl:text>
- ***REPEATABLE***
                </xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:text>&#10;</xsl:text>
        <xsl:value-of select="normalize-space(concat('- Data type: ', $selected_element/@type))"/>
        <xsl:for-each select="$selected_element/xs:annotation/xs:documentation">
            <xsl:text>&#10;</xsl:text>
            <xsl:value-of select="normalize-space(concat('- ', .))"/>
        </xsl:for-each>
        <xsl:value-of select="$back_to_top"/>
    </xsl:function>

    <!-- xs:simpleTypes -->
    <xsl:function name="bmrxml:simpleType">
        <xsl:param name="repo"/>
        <xsl:param name="document"/>
        <xsl:param name="name"/>
        <xsl:param name="type"/>
        <xsl:variable name="selected_element" select="
                document(concat('https://github.com/uwlib-cams/', $repo, '/raw/main/xsd/', $document, '.xsd'))
                /xs:schema//xs:element[@name = $name][@type = $type]"/>
        <xsl:variable name="selected_type" select="
                document(concat('https://github.com/uwlib-cams/', $repo, '/raw/main/xsd/', $document, '.xsd'))
                /xs:schema//xs:simpleType[@name = $type]"/>
        <!-- REQUIRED/OPTIONAL -->
        <html>
        <ul>
            <xsl:choose>
                <xsl:when test="$selected_element/@minOccurs = '1'">
                    <li>REQUIRED</li>
                </xsl:when>
                <xsl:when test="$selected_element/@minOccurs = '0'">
                    <li>OPTIONAL</li>
                </xsl:when>
            </xsl:choose>
            <!-- REPEATABLE / NOT REPEATABLE -->
            <xsl:choose>
                <xsl:when test="$selected_element/@maxOccurs = '1'">
                    <li>NOT REPEATABLE</li>
                </xsl:when>
                <xsl:when test="$selected_element/@maxOccurs = 'unbounded'">
                    <li>REPEATABLE</li>
                </xsl:when>
            </xsl:choose>
            <!-- Get annotation/documentation elements -->
            <xsl:choose>
                <xsl:when test="$selected_type/xs:annotation/xs:documentation/text()">
                    <xsl:for-each select="$selected_type/xs:annotation/xs:documentation">
                        <li>
                            <xsl:value-of select="."/>
                        </li>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <li>schema documentation under construction</li>
                </xsl:otherwise>
            </xsl:choose>
            <!-- get enumeration elements -->
            <xsl:choose>
                <xsl:when test="$selected_type/xs:restriction/xs:enumeration">
                    <li>ENUMERATIONS:</li>
                    <ul>
                        <xsl:for-each select="$selected_type/xs:restriction/xs:enumeration">
                            <li>
                                <xsl:value-of select="@value"/>
                            </li>
                        </xsl:for-each>
                    </ul>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </ul>
        </html>
    </xsl:function>

    <!-- xs:complexTypes -->
    <xsl:function name="bmrxml:complexType">
        <xsl:param name="repo"/>
        <xsl:param name="document"/>
        <xsl:param name="element"/>
        <xsl:variable name="selected_element" select="
                document(concat('https://github.com/uwlib-cams/', $repo, '/raw/main/xsd/', $document, '.xsd'))
                /xs:schema//xs:complexType[@name = $element]"/>
    </xsl:function>

    <xsl:template match="/">
        <!-- [!] NOTE filepath to output [!] -->
        <xsl:result-document href="../../sinopia_maps.wiki/element_reference.md">
            <xsl:text>

            </xsl:text>
            <xsl:text>
## ELEMENT DETAILS - SINOPIA_MAPS

### sinopia_maps</xsl:text>

            <xsl:text>
### rts</xsl:text>

            <xsl:text>
### rt</xsl:text>

            <xsl:text>
### institution</xsl:text>
            <xsl:value-of
                select="bmrxml:simpleType('sinopia_maps', 'sinopia_maps', 'institution', 'institution_type')"/>
            <xsl:text>
### resource</xsl:text>

            <xsl:text>
### optional_class</xsl:text>

            <xsl:text>
### format</xsl:text>

            <xsl:text>
### user</xsl:text>

            <xsl:text>
### author</xsl:text>

            <xsl:text>

## ELEMENT DETAILS - PROP_SET

### prop_set
- Root element of the `prop_set_[...].xml` instance
- No text content; contains multiple `prop` elements</xsl:text>
            <xsl:value-of select="$back_to_top"/>
            <xsl:text>
### prop
- No text content</xsl:text>
            <xsl:value-of select="$back_to_top"/>
            <xsl:text>
### \@localid_prop</xsl:text>

            <xsl:text>
### prop_set_label</xsl:text>

            <xsl:text>
### prop_iri</xsl:text>

            <xsl:text>
### \@iri</xsl:text>

            <xsl:text>
### prop_label</xsl:text>

            <xsl:text>
### \@xml:lang
- `xml:lang` attribute values: RDF language tags will be pulled from prop_sets as-is, so lang tags should be taken from the IANA Language Subtag Registry.
- For English-language text (for example, when providing) default literal values) use "en".
- For literal values without linguistic content (for example, when providing a default date or numeric value), use "zxx", or use the language_suppressed element.</xsl:text>
            <xsl:value-of select="$back_to_top"/>
            <xsl:text>
### prop_domain</xsl:text>

            <xsl:text>
### prop_domain_includes</xsl:text>

            <xsl:text>
### prop_range</xsl:text>

            <xsl:text>
### prop_range_includes</xsl:text>

            <xsl:text>
### prop_related_url</xsl:text>

            <xsl:text>
### sinopia</xsl:text>

            <xsl:text>
### implementation_set</xsl:text>

            <xsl:text>
### resource</xsl:text>

            <xsl:text>
### format</xsl:text>

            <xsl:text>
### user</xsl:text>

            <xsl:text>
### form_order</xsl:text>
            <!-- <xsl:value-of select="bmrxml:doc_bullets('uwsinopia', 'simple', 'form_order_type')"/> -->
            <xsl:text>
### multiple_prop</xsl:text>
            <!-- <xsl:value-of select="bmrxml:doc_bullets('uwsinopia', 'complex', 'multiple_prop_type')"/> -->
            <xsl:text>
### all_subprops
- When the `multiple_prop` &gt; `all_subprops` element is entered, all properties existing the source document which are subproperties of the `prop` element's property will be output as options in the property template.
- [! NOTE 2022-05-13] Tthe `all_subprops` element may only be used in RDA Registry prop_set instances.</xsl:text>
            <xsl:value-of select="$back_to_top"/>
            <xsl:text>
### property_selection</xsl:text>

            <xsl:text>
### remark_url</xsl:text>

            <xsl:text>
### remark</xsl:text>

            <xsl:text>
### language_suppressed
- To indicate that any value provided for a given property template will not have linguistic content, enter the `language_suppressed` element with value 'true' or '1'.</xsl:text>
            <xsl:value-of select="$back_to_top"/>
            <xsl:text>
### required
- To indicate that a value must be provided for a given property template, enter the `required` element with value 'true' or '1'.</xsl:text>
            <xsl:value-of select="$back_to_top"/>
            <xsl:text>
### repeatable</xsl:text>

            <xsl:text>
### \@ordered
- To indicate that the order of multiple values for a repeatable property should be preserved, use the `ordered` attribute with value 'true' or '1'.</xsl:text>
            <xsl:value-of select="$back_to_top"/>
            <xsl:text>
### literal_pt</xsl:text>

            <xsl:text>
### date_default</xsl:text>

            <xsl:text>
### userId_default</xsl:text>

            <xsl:text>
### default_literal</xsl:text>

            <xsl:text>
### validation_datatype</xsl:text>

            <xsl:text>
### validation_regex</xsl:text>

            <xsl:text>
### uri_pt</xsl:text>

            <xsl:text>
### default_uri</xsl:text>

            <xsl:text>
### default_uri_label</xsl:text>

            <xsl:text>
### lookup_pt</xsl:text>

            <xsl:text>
### authorities</xsl:text>

            <xsl:text>
### authority_urn</xsl:text>

            <xsl:text>
### lookup_default_iri</xsl:text>

            <xsl:text>
### lookup_default_iri_label</xsl:text>

            <xsl:text>
### nested_resource_pt</xsl:text>

            <xsl:text>
### rt_id</xsl:text>

        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
