<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs fn" version="3.0">
    <xsl:output method="xml" indent="1"/>

    <xsl:variable name="mgds_xml" select="(document('../xml/mgd_docs.xml')/data)"/>

    <xsl:mode on-no-match="shallow-copy"/>

    <xsl:template match="xs:simpleType[@name = 'mgds_type']">
        <xs:simpleType name="mgds_type">
            <xs:restriction base="xs:string">
                <xsl:for-each select="fn:json-to-xml($mgds_xml)/fn:array/fn:map">
                    <xs:enumeration value="{fn:string[@key = 'title']}"/>
                </xsl:for-each>
            </xs:restriction>
        </xs:simpleType>
    </xsl:template>

</xsl:stylesheet>
