<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    xmlns:bmrxml="https://briesenberg07.github.io/xml_stack/" 
    exclude-result-prefixes="xs"
    version="3.0">
    
    <!-- (there must be a better way to reuse a function than copying and renaming in each file??) -->
    <xsl:function name="bmrxml:rda_iri_slug_define_literal">
        <xsl:param name="path_to_iri"/>
        <xsl:value-of select="translate(substring-after($path_to_iri, 'Elements/'), '/', '_')"/>
    </xsl:function>
    
    <!-- output literal PT attributes -->
    <xsl:template name="define_literal_pts">
        <xsl:param name="prop"/>
        <rdf:Description
            rdf:nodeID="{concat(bmrxml:rda_iri_slug_define_literal($prop/uwmaps:prop_iri/@iri),
            '_literal_attributes')}">
            <!-- hard-code rdf:type for this node sinopia:LiteralPropertyTemplate -->
            <rdf:type rdf:resource="http://sinopia.io/vocabulary/LiteralPropertyTemplate"/>
            <sinopia:hasDefault xml:lang="{$prop/uwmaps:sinopia/uwsinopia:implementation_set/
                uwsinopia:sinopia_prop_attributes/uwsinopia:sinopia_prop_type_attributes/
                uwsinopia:literal_attributes/uwsinopia:default_literal/@xml:lang}">
                <xsl:value-of select="
                    $prop/uwmaps:sinopia/uwsinopia:implementation_set/
                    uwsinopia:sinopia_prop_attributes/uwsinopia:sinopia_prop_type_attributes/
                    uwsinopia:literal_attributes/uwsinopia:default_literal"/>
            </sinopia:hasDefault>
            <!-- bring in validation datatype if one exists -->
            <xsl:if test="$prop/uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:sinopia_prop_attributes/
                uwsinopia:sinopia_prop_type_attributes/uwsinopia:literal_attributes/uwsinopia:validation_datatype/text()">
                <xsl:choose>
                    <xsl:when test="$prop/uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:sinopia_prop_attributes/
                        uwsinopia:sinopia_prop_type_attributes/uwsinopia:literal_attributes/uwsinopia:validation_datatype = 
                        'Date and time with or without timezone'">
                        <sinopia:hasValidationDataType rdf:resource="http://www.w3.org/2001/XMLSchema#dateTime"/>
                    </xsl:when>
                    <xsl:when test="$prop/uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:sinopia_prop_attributes/
                        uwsinopia:sinopia_prop_type_attributes/uwsinopia:literal_attributes/uwsinopia:validation_datatype = 
                        'Date and time with required timezone'">
                        <sinopia:hasValidationDataType rdf:resource="http://www.w3.org/2001/XMLSchema#dateTimeStamp"/>
                    </xsl:when>
                    <xsl:when test="$prop/uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:sinopia_prop_attributes/
                        uwsinopia:sinopia_prop_type_attributes/uwsinopia:literal_attributes/uwsinopia:validation_datatype = 
                        'Extended Date/Time Format (EDTF)'">
                        <sinopia:hasValidationDataType rdf:resource="http://id.loc.gov/datatypes/edtf/"/>
                    </xsl:when>
                    <xsl:when test="$prop/uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:sinopia_prop_attributes/
                        uwsinopia:sinopia_prop_type_attributes/uwsinopia:literal_attributes/uwsinopia:validation_datatype = 'Integer'">
                        <sinopia:hasValidationDataType rdf:resource="http://www.w3.org/2001/XMLSchema#integer"/>
                    </xsl:when>
                    <xsl:otherwise>ERROR - UNKNOWN VALIDATION DATATYPE PROVIDED</xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <!-- output literal property attribute > validation regex if one exists see sinopia_maps #9 -->
            <xsl:if test="$prop/uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:sinopia_prop_attributes/
                uwsinopia:sinopia_prop_type_attributes/uwsinopia:literal_attributes/uwsinopia:validation_regex/text()">
                <sinopia:hasValidationRegex xml:lang="zxx">
                    <xsl:value-of select="$prop/uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:sinopia_prop_attributes/
                        uwsinopia:sinopia_prop_type_attributes/uwsinopia:literal_attributes/uwsinopia:validation_regex"/>
                </sinopia:hasValidationRegex>
            </xsl:if>
            <!-- output literal property attribute > date default -->
            <xsl:if test="matches($prop/uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:sinopia_prop_attributes/
                uwsinopia:sinopia_prop_type_attributes/uwsinopia:literal_attributes/uwsinopia:date_default, 'true|1')">
                <sinopia:hasLiteralPropertyAttributes rdf:resource="http://sinopia.io/vocabulary/literalPropertyAttribute/dateDefault"/>
                <!-- should I be outputting the rdfs:label triple as well? Will it be missed in the Sinopia UI? -->
            </xsl:if>
            <!-- output literal property attribute > user ID default -->
            <xsl:if test="matches($prop/uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:sinopia_prop_attributes/
                uwsinopia:sinopia_prop_type_attributes/uwsinopia:literal_attributes/uwsinopia:userId_default, 'true|1')">
                <sinopia:hasLiteralPropertyAttributes rdf:resource="http://sinopia.io/vocabulary/literalPropertyAttribute/userIdDefault"/>
                <!-- should I be outputting the rdfs:label triple as well? Will it be missed in the Sinopia UI? -->
            </xsl:if>
        </rdf:Description>
    </xsl:template>
    
</xsl:stylesheet>