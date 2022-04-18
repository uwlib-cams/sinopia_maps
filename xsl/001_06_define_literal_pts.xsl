<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/" 
    exclude-result-prefixes="xs"
    version="3.0">
    
    <!-- output literal PT attributes -->
    <xsl:template name="define_literal_pts">
        <xsl:param name="resource"/>
        <xsl:param name="format"/>
        <xsl:param name="user"/>
        <xsl:param name="prop"/>
        <rdf:Description
            rdf:nodeID="{concat($prop/uwmaps:prop_iri/@iri => 
            translate('/.#', '') => substring-after('http:'),
            '_literal_attributes')}">
            <!-- hard-code rdf:type for this node sinopia:LiteralPropertyTemplate -->
            <rdf:type rdf:resource="http://sinopia.io/vocabulary/LiteralPropertyTemplate"/>
            <!-- user ID, date, or specified literal by default? -->
            <xsl:choose>
                <xsl:when test="
                    matches($prop/uwmaps:sinopia/uwsinopia:implementation_set
                    [uwsinopia:resource = $resource]
                    [uwsinopia:format = $format]
                    [uwsinopia:user = $user]
                    /uwsinopia:literal_pt/uwsinopia:date_default, 'true|1')">
                    <sinopia:hasLiteralPropertyAttributes rdf:resource="http://sinopia.io/vocabulary/literalPropertyAttribute/dateDefault"/>
                </xsl:when>
                <xsl:when test="
                    matches($prop/uwmaps:sinopia/uwsinopia:implementation_set
                    [uwsinopia:resource = $resource]
                    [uwsinopia:format = $format]
                    [uwsinopia:user = $user]
                    /uwsinopia:literal_pt/uwsinopia:userId_default, 'true|1')">
                    <sinopia:hasLiteralPropertyAttributes rdf:resource="http://sinopia.io/vocabulary/literalPropertyAttribute/userIdDefault"/>
                </xsl:when>
                <xsl:when test="
                    $prop/uwmaps:sinopia/uwsinopia:implementation_set
                    [uwsinopia:resource = $resource]
                    [uwsinopia:format = $format]
                    [uwsinopia:user = $user]
                    /uwsinopia:literal_pt/uwsinopia:default_literal">
                    <!-- output default literal -->
                    <sinopia:hasDefault xml:lang="{$prop/uwmaps:sinopia/uwsinopia:implementation_set
                        [uwsinopia:resource = $resource]
                        [uwsinopia:format = $format]
                        [uwsinopia:user = $user]
                        /uwsinopia:literal_pt/uwsinopia:default_literal/@xml:lang}">
                        <xsl:value-of select="
                            $prop/uwmaps:sinopia/uwsinopia:implementation_set
                            [uwsinopia:resource = $resource]
                            [uwsinopia:format = $format]
                            [uwsinopia:user = $user]
                            /uwsinopia:literal_pt/uwsinopia:default_literal"/>
                    </sinopia:hasDefault>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
            <!-- output validation datatype if one exists -->
            <xsl:if test="$prop/uwmaps:sinopia/uwsinopia:implementation_set
                [uwsinopia:resource = $resource]
                [uwsinopia:format = $format]
                [uwsinopia:user = $user]
                /uwsinopia:literal_pt/uwsinopia:validation_datatype/text()">
                <xsl:choose>
                    <xsl:when test="$prop/uwmaps:sinopia/uwsinopia:implementation_set
                        [uwsinopia:resource = $resource]
                        [uwsinopia:format = $format]
                        [uwsinopia:user = $user]
                        /uwsinopia:literal_pt/uwsinopia:validation_datatype = 
                        'Date and time with or without timezone'">
                        <sinopia:hasValidationDataType rdf:resource="http://www.w3.org/2001/XMLSchema#dateTime"/>
                    </xsl:when>
                    <xsl:when test="$prop/uwmaps:sinopia/uwsinopia:implementation_set
                        [uwsinopia:resource = $resource]
                        [uwsinopia:format = $format]
                        [uwsinopia:user = $user]
                        /uwsinopia:literal_pt/uwsinopia:validation_datatype = 
                        'Date and time with required timezone'">
                        <sinopia:hasValidationDataType rdf:resource="http://www.w3.org/2001/XMLSchema#dateTimeStamp"/>
                    </xsl:when>
                    <xsl:when test="$prop/uwmaps:sinopia/uwsinopia:implementation_set
                        [uwsinopia:resource = $resource]
                        [uwsinopia:format = $format]
                        [uwsinopia:user = $user]
                        /uwsinopia:literal_pt/uwsinopia:validation_datatype = 
                        'Extended Date/Time Format (EDTF)'">
                        <sinopia:hasValidationDataType rdf:resource="http://id.loc.gov/datatypes/edtf/"/>
                    </xsl:when>
                    <xsl:when test="$prop/uwmaps:sinopia/uwsinopia:implementation_set
                        [uwsinopia:resource = $resource]
                        [uwsinopia:format = $format]
                        [uwsinopia:user = $user]
                        /uwsinopia:literal_pt/uwsinopia:validation_datatype = 
                        'Integer'">
                        <sinopia:hasValidationDataType rdf:resource="http://www.w3.org/2001/XMLSchema#integer"/>
                    </xsl:when>
                    <xsl:otherwise>ERROR - UNKNOWN VALIDATION DATATYPE LABEL PROVIDED</xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <!-- output validation regex if one exists -->
            <xsl:if test="$prop/uwmaps:sinopia/uwsinopia:implementation_set
                [uwsinopia:resource = $resource]
                [uwsinopia:format = $format]
                [uwsinopia:user = $user]
                /uwsinopia:literal_pt/uwsinopia:validation_regex/text()">
                <sinopia:hasValidationRegex xml:lang="zxx">
                    <xsl:value-of select="$prop/uwmaps:sinopia/uwsinopia:implementation_set
                        [uwsinopia:resource = $resource]
                        [uwsinopia:format = $format]
                        [uwsinopia:user = $user]
                        /uwsinopia:literal_pt/uwsinopia:validation_regex"/>
                </sinopia:hasValidationRegex>
            </xsl:if>
        </rdf:Description>
    </xsl:template>
</xsl:stylesheet>