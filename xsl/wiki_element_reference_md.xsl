<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:bmrxml="https://briesenberg07.github.io/xml_stack/" exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="text" indent="0"/>

    <!-- schema docs as vars -->
    <xsl:variable name="prop_set"
        select="document('https://github.com/uwlib-cams/map_storage/raw/main/xsd/prop_set.xsd')/xs:schema"/>
    <xsl:variable name="sinopia_maps"
        select="document('https://github.com/uwlib-cams/sinopia_maps/raw/main/xsd/sinopia_maps.xsd')/xs:schema"/>
    <xsl:variable name="uwsinopia"
        select="document('https://github.com/uwlib-cams/sinopia_maps/raw/main/xsd/uwsinopia.xsd')/xs:schema"/>
    <xsl:variable name="back_to_top">
        <xsl:text>
- *back to [top](#element-reference)*
        </xsl:text>
    </xsl:variable>

    <!-- function -->
    <!-- add mechanism to output enumerations?? -->
    <!-- [!] this function will not retrieve element annotations which are children of xs:element, 
            or attribute annotations which are children of xs:attribute
                **SEE workarounds:**
                - all_subprops
                - xml:lang attributes
                - language_suppressed
                - required
                - ... -->
    <xsl:function name="bmrxml:doc_bullets">
        <xsl:param name="schemadoc"/>
        <xsl:param name="element_type" as="xs:string"/>
        <xsl:param name="element_type_name" as="xs:string"/>
        <!-- I shouldn't have to choose and repeat for the different source docs... 
            but haven't been able to make document() work otherwise -->
        <xsl:choose>
            <xsl:when test="$schemadoc = 'prop_set'">
                <xsl:choose>
                    <xsl:when test="$element_type = 'complex'">
                        <xsl:choose>
                            <xsl:when
                                test="$prop_set//xs:complexType[@name = $element_type_name]/xs:annotation/xs:documentation/text()">
                                <xsl:for-each
                                    select="$prop_set//xs:complexType[@name = $element_type_name]/xs:annotation/xs:documentation">
                                    <xsl:text>&#10;</xsl:text>
                                    <xsl:value-of select="normalize-space(concat('- ', .))"/>
                                </xsl:for-each>
                                <xsl:text>
- *back to [top](#element-reference)*
                                </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>
&#10;- *schema annotations currently under construction*
- *back to [top](#element-reference)*
                            </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$element_type = 'simple'">
                        <xsl:choose>
                            <xsl:when
                                test="$prop_set//xs:simpleType[@name = $element_type_name]/xs:annotation/xs:documentation/text()">
                                <xsl:for-each
                                    select="$prop_set//xs:simpleType[@name = $element_type_name]/xs:annotation/xs:documentation">
                                    <xsl:text>&#10;</xsl:text>
                                    <xsl:value-of select="normalize-space(concat('- ', .))"/>
                                </xsl:for-each>
                                <xsl:text>
- *back to [top](#element-reference)*
                                </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>
&#10;- *schema annotations currently under construction*
- *back to [top](#element-reference)*
                            </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>&#10;- **ERROR** - NO MATCH, given schema URL, element type, and/or element type name</xsl:text>
                        <xsl:text>&#10;- `$element_type` value must be either 'simple' or 'complex'</xsl:text>
                        <xsl:text>&#10;- `$element_type_name` must be the simpleType or complexType `@name` value</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$schemadoc = 'sinopia_maps'">
                <xsl:choose>
                    <xsl:when test="$element_type = 'complex'">
                        <xsl:choose>
                            <xsl:when
                                test="$sinopia_maps//xs:complexType[@name = $element_type_name]/xs:annotation/xs:documentation/text()">
                                <xsl:for-each
                                    select="$sinopia_maps//xs:complexType[@name = $element_type_name]/xs:annotation/xs:documentation">
                                    <xsl:text>&#10;</xsl:text>
                                    <xsl:value-of select="normalize-space(concat('- ', .))"/>
                                </xsl:for-each>
                                <xsl:text>
- *back to [top](#element-reference)*
                                </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>
&#10;- *schema annotations currently under construction*
- *back to [top](#element-reference)*
                            </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$element_type = 'simple'">
                        <xsl:choose>
                            <xsl:when
                                test="$sinopia_maps//xs:simpleType[@name = $element_type_name]/xs:annotation/xs:documentation/text()">
                                <xsl:for-each
                                    select="$sinopia_maps//xs:simpleType[@name = $element_type_name]/xs:annotation/xs:documentation">
                                    <xsl:text>&#10;</xsl:text>
                                    <xsl:value-of select="normalize-space(concat('- ', .))"/>
                                </xsl:for-each>
                                <xsl:text>
- *back to [top](#element-reference)*
                                </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>
&#10;- *schema annotations currently under construction*
- *back to [top](#element-reference)*
                            </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>&#10;- **ERROR** - NO MATCH, given schema URL, element type, and/or element type name</xsl:text>
                        <xsl:text>&#10;- `$element_type` value must be either 'simple' or 'complex'</xsl:text>
                        <xsl:text>&#10;- `$element_type_name` must be the simpleType or complexType `@name` value</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$schemadoc = 'uwsinopia'">
                <xsl:choose>
                    <xsl:when test="$element_type = 'complex'">
                        <xsl:choose>
                            <xsl:when
                                test="$uwsinopia//xs:complexType[@name = $element_type_name]/xs:annotation/xs:documentation/text()">
                                <xsl:for-each
                                    select="$uwsinopia//xs:complexType[@name = $element_type_name]/xs:annotation/xs:documentation">
                                    <xsl:text>&#10;</xsl:text>
                                    <xsl:value-of select="normalize-space(concat('- ', .))"/>
                                </xsl:for-each>
                                <xsl:text>
- *back to [top](#element-reference)*
                                </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>
&#10;- *schema annotations currently under construction*
- *back to [top](#element-reference)*
                            </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$element_type = 'simple'">
                        <xsl:choose>
                            <xsl:when
                                test="$uwsinopia//xs:simpleType[@name = $element_type_name]/xs:annotation/xs:documentation/text()">
                                <xsl:for-each
                                    select="$uwsinopia//xs:simpleType[@name = $element_type_name]/xs:annotation/xs:documentation">
                                    <xsl:text>&#10;</xsl:text>
                                    <xsl:value-of select="normalize-space(concat('- ', .))"/>
                                </xsl:for-each>
                                <xsl:text>
- *back to [top](#element-reference)*
                                </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>
&#10;- *schema annotations currently under construction*
- *back to [top](#element-reference)*
                            </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>&#10;- **ERROR** - NO MATCH, given schema URL, element type, and/or element type name</xsl:text>
                        <xsl:text>&#10;- `$element_type` value must be either 'simple' or 'complex'</xsl:text>
                        <xsl:text>&#10;- `$element_type_name` must be the simpleType or complexType `@name` value</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>
&#10;- **ERROR** - NO MATCH, given schema name
                </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:template match="/">
        <!-- [!] NOTE filepath to output [!] -->
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
            - [user](#user)
            - [author](#author)

## OVERVIEW: PROP_SET STRUCTURE
- [prop_set](#prop_set)
    - [prop_set_label](#prop_set_label)
    - [prop](#prop) / [\@localid_prop](#localid_prop)
        - [prop_iri](#prop_iri) / [\@iri](#iri)
        - [prop_label](#prop_label)
        - [prop_domain](#prop_domain) / [\@iri](#iri)
        - [prop_domain_includes](#prop_domain_includes) / [\@iri](#iri)
        - [prop_range](#prop_range) / [\@iri](#iri)
        - [prop_range_includes](#prop_range_includes) / [\@iri](#iri)
        - [prop_related_url](#prop_related_url) / [\@iri](#iri)
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
                - [remark](#remark) / [\@xml:lang](#xmllang)
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
                    - [default_uri_label](#default_uri_label) / [\@xml:lang](#xmllang)
                - [lookup_pt](#lookup_pt)
                    - [authorities](#authorities)
                        - [authority_urn](#authority_urn)
                    - [lookup_default_iri](#lookup_default_iri) / [\@iri](#iri)
                    - [lookup_default_iri_label](#lookup_default_iri_label) / [\@xml:lang](#xmllang)
                - [nested_resource_pt](#nested_resource_pt)
                    - [rt_id](#rt_id)
            </xsl:text>
            <xsl:text>
## ELEMENT DETAILS - SINOPIA_MAPS

### sinopia_maps
- Root element of the `sinopia_maps.xml` instance</xsl:text>
            <xsl:value-of select="$back_to_top"/>
            <xsl:text>
### rts
- No text content; contains multiple `rt` elements</xsl:text>
            <xsl:value-of select="$back_to_top"/>
            <xsl:text>
### rt
- No text content; contains resource template information
- `institution`, `resource`, `format`, and `user` contents are output as contents of resource template ID</xsl:text>
            <xsl:value-of select="$back_to_top"/>
            <xsl:text>
### institution</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('sinopia_maps', 'simple', 'institution_type')"/>
            <xsl:text>
### resource</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('uwsinopia', 'simple', 'resource_label_type')"/>
            <xsl:text>
### format</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('uwsinopia', 'simple', 'format_type')"/>
            <xsl:text>
### user</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('uwsinopia', 'simple', 'user_type')"/>
            <xsl:text>
### author</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('uwsinopia', 'simple', 'author_type')"/>
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
            <xsl:value-of select="bmrxml:doc_bullets('prop_set', 'simple', 'localid_attr')"/>
            <xsl:text>
### prop_set_label</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('prop_set', 'simple', 'prop_set_label_type')"/>
            <xsl:text>
### prop_iri</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('prop_set', 'complex', 'iri_type')"/>
            <xsl:text>
### \@iri</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('prop_set', 'complex', 'iri_type')"/>
            <xsl:text>
### prop_label</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('', '', '')"/>
            <xsl:text>
### \@xml:lang
- `xml:lang` attribute values: RDF language tags will be pulled from prop_sets as-is, so lang tags should be taken from the IANA Language Subtag Registry.
- For English-language text (for example, when providing) default literal values) use "en".
- For literal values without linguistic content (for example, when providing a default date or numeric value), use "zxx", or use the language_suppressed element.</xsl:text>
            <xsl:value-of select="$back_to_top"/>
            <xsl:text>
### prop_domain</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('prop_set', 'complex', 'iri_type')"/>
            <xsl:text>
### prop_domain_includes</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('prop_set', 'complex', 'iri_type')"/>
            <xsl:text>
### prop_range</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('prop_set', 'complex', 'iri_type')"/>
            <xsl:text>
### prop_range_includes</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('prop_set', 'complex', 'iri_type')"/>
            <xsl:text>
### prop_related_url</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('prop_set', 'complex', 'url_type')"/>
            <xsl:text>
### sinopia</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('uwsinopia', 'complex', 'sinopia_type')"/>
            <xsl:text>
### implementation_set</xsl:text>
            <xsl:value-of
                select="bmrxml:doc_bullets('uwsinopia', 'complex', 'implementation_set_type')"/>
            <xsl:text>
### resource</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('uwsinopia', 'simple', 'resource_label_type')"/>
            <xsl:text>
### format</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('uwsinopia', 'simple', 'format_type')"/>
            <xsl:text>
### user</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('uwsinopia', 'simple', 'user_type')"/>
            <xsl:text>
### form_order</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('uwsinopia', 'simple', 'form_order_type')"/>
            <xsl:text>
### multiple_prop</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('uwsinopia', 'complex', 'multiple_prop_type')"/>
            <xsl:text>
### all_subprops
- When the `multiple_prop` &gt; `all_subprops` element is entered, all properties existing the source document which are subproperties of the `prop` element's property will be output as options in the property template.
- [! NOTE 2022-05-13] Tthe `all_subprops` element may only be used in RDA Registry prop_set instances.</xsl:text>
            <xsl:value-of select="$back_to_top"/>
            <xsl:text>
### property_selection</xsl:text>
            <xsl:value-of
                select="bmrxml:doc_bullets('uwsinopia', 'complex', 'property_selection_type')"/>
            <xsl:text>
### remark_url</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('prop_set', 'complex', 'iri_type')"/>
            <xsl:text>
### remark</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('prop_set', 'complex', 'lang_string_type')"/>
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
            <xsl:value-of select="bmrxml:doc_bullets('uwsinopia', 'complex', 'repeatable_type')"/>
            <xsl:text>
### \@ordered
- To indicate that the order of multiple values for a repeatable property should be preserved, use the `ordered` attribute with value 'true' or '1'.</xsl:text>
            <xsl:value-of select="$back_to_top"/>
            <xsl:text>
### literal_pt</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('uwsinopia', 'complex', 'literal_attributes_type')"/>
            <xsl:text>
### date_default</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('', '', '')"/>
            <xsl:text>
### userId_default</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('', '', '')"/>
            <xsl:text>
### default_literal</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('prop_set', 'complex', 'lang_string_type')"/>
            <xsl:text>
### validation_datatype</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('uwsinopia', 'simple', 'validation_datatype_type')"/>
            <xsl:text>
### validation_regex</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('uwsinopia', 'simple', 'validation_regex_type')"/>
            <xsl:text>
### uri_pt</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('uwsinopia', 'complex', 'uri_attributes_type')"/>
            <xsl:text>
### default_uri</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('prop_set', 'complex', 'iri_type')"/>
            <xsl:text>
### default_uri_label</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('prop_set', 'complex', 'lang_string_type')"/>
            <xsl:text>
### lookup_pt</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('uwsinopia', 'complex', 'lookup_attributes_type')"/>
            <xsl:text>
### authorities</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('uwsinopia', 'complex', 'authorities_type')"/>
            <xsl:text>
### authority_urn</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('uwsinopia', 'simple', 'authority_urn_type')"/>
            <xsl:text>
### lookup_default_iri</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('prop_set', 'complex', 'iri_type')"/>
            <xsl:text>
### lookup_default_iri_label</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('prop_set', 'complex', 'lang_string_type')"/>
            <xsl:text>
### nested_resource_pt</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('uwsinopia', 'complex', 'nested_resource_attributes_type')"/>
            <xsl:text>
### rt_id</xsl:text>
            <xsl:value-of select="bmrxml:doc_bullets('uwsinopia', 'simple', 'rt_id_type')"/>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
