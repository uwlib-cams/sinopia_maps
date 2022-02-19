<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:maps="https://uwlib-cams.github.io/map_storage/"
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
            rdf:nodeID="{concat(bmrxml:rda_iri_slug_define_literal($prop/maps:prop_iri/@iri),
            '_literal_attributes')}">
            <!-- hard-code rdf:type for this node sinopia:LiteralPropertyTemplate -->
            <rdf:type rdf:resource="http://sinopia.io/vocabulary/LiteralPropertyTemplate"/>
            <sinopia:hasDefault xml:lang="{$prop/maps:sinopia/maps:implementationSet/
                maps:sinopia_prop_attributes/maps:sinopia_prop_type_attributes/
                maps:literal_attributes/maps:default_literal/@xml:lang}">
                <xsl:value-of select="
                    $prop/maps:sinopia/maps:implementationSet/
                    maps:sinopia_prop_attributes/maps:sinopia_prop_type_attributes/
                    maps:literal_attributes/maps:default_literal"/>
            </sinopia:hasDefault>
            <!-- bring in validation datatype if one exists -->
            <xsl:if test="$prop/maps:sinopia/maps:implementationSet/maps:sinopia_prop_attributes/
                maps:sinopia_prop_type_attributes/maps:literal_attributes/maps:validation_datatype/text()">
                <xsl:choose>
                    <xsl:when test="$prop/maps:sinopia/maps:implementationSet/maps:sinopia_prop_attributes/
                        maps:sinopia_prop_type_attributes/maps:literal_attributes/maps:validation_datatype = 
                        'Date and time with or without timezone'">
                        <sinopia:hasValidationDataType rdf:resource="http://www.w3.org/2001/XMLSchema#dateTime"/>
                    </xsl:when>
                    <xsl:when test="$prop/maps:sinopia/maps:implementationSet/maps:sinopia_prop_attributes/
                        maps:sinopia_prop_type_attributes/maps:literal_attributes/maps:validation_datatype = 
                        'Date and time with required timezone'">
                        <sinopia:hasValidationDataType rdf:resource="http://www.w3.org/2001/XMLSchema#dateTimeStamp"/>
                    </xsl:when>
                    <xsl:when test="$prop/maps:sinopia/maps:implementationSet/maps:sinopia_prop_attributes/
                        maps:sinopia_prop_type_attributes/maps:literal_attributes/maps:validation_datatype = 
                        'Extended Date/Time Format (EDTF)'">
                        <sinopia:hasValidationDataType rdf:resource="http://id.loc.gov/datatypes/edtf/"/>
                    </xsl:when>
                    <xsl:when test="$prop/maps:sinopia/maps:implementationSet/maps:sinopia_prop_attributes/
                        maps:sinopia_prop_type_attributes/maps:literal_attributes/maps:validation_datatype = 'Integer'">
                        <sinopia:hasValidationDataType rdf:resource="http://www.w3.org/2001/XMLSchema#integer"/>
                    </xsl:when>
                    <xsl:otherwise>ERROR - UNKNOWN VALIDATION DATATYPE PROVIDED</xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <!-- to do bring in validation regex see sinopia_maps #9 -->
            <!-- to do output date default PT attribute -->
            <!-- to do output userID default PT attribute -->
        </rdf:Description>
    </xsl:template>
    
</xsl:stylesheet>