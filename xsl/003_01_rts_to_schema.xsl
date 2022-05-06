<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    exclude-result-prefixes="xs uwsinopia" version="3.0">
    
    <xsl:output method="xml" indent="1"/>

    <xsl:variable name="sinopia_maps_xml" select="document('../xml/sinopia_maps.xml')"/>

    <xsl:mode on-no-match="shallow-copy"/>

    <xsl:template match="xs:simpleType[@name = 'rt_id_type']">
        <xs:simpleType name="rt_id_type">
            <xs:restriction base="xs:string">
                <xsl:for-each select="$sinopia_maps_xml/uwsinopia:sinopia_maps/uwsinopia:rts/uwsinopia:rt">
                    <!-- [!]  -->
                    <xs:enumeration value="{concat('WAU:', 
                        uwsinopia:resource, ':', uwsinopia:format, ':', uwsinopia:user)}"/>
                </xsl:for-each>
            </xs:restriction>
        </xs:simpleType>
    </xsl:template>


</xsl:stylesheet>
