<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:sinopia="http://sinopia.io/vocabulary/"
    exclude-result-prefixes="xs"
    version="3.0">

    <!-- return format as text -->
    <xsl:template name="format_resources">
        <xsl:param name="resource"/>
        <!-- [!] THESE OPTIONS MUST MATCH
            resources.xsd > xs:simpleType @name="resource_label_type" > enumerations [!] -->
        <xsl:choose>
            <xsl:when test="$resource = 'rdaWork'">
                <xsl:text>RDA Work</xsl:text>
            </xsl:when>
            <xsl:when test="$resource = 'rdaAgent'">
                <xsl:text>RDA Agent</xsl:text>
            </xsl:when>
            <xsl:when test="$resource = 'rdaItem'">
                <xsl:text>RDA Item</xsl:text>
            </xsl:when>
            <xsl:when test="$resource = 'rdaPerson'">
                <xsl:text>RDA Person</xsl:text>
            </xsl:when>
            <xsl:when test="$resource = 'rdaCorporateBody'">
                <xsl:text>RDA Corporate Body</xsl:text>
            </xsl:when>
            <xsl:when test="$resource = 'rdaExpression'">
                <xsl:text>RDA Expression</xsl:text>
            </xsl:when>
            <xsl:when test="$resource = 'rdaManifestation'">
                <xsl:text>RDA Manifestation</xsl:text>
            </xsl:when>
            <xsl:when test="$resource = 'rdaFamily'">
                <xsl:text>RDA Family</xsl:text>
            </xsl:when>
            <xsl:when test="$resource = 'rdaPlace'">
                <xsl:text>RDA Place</xsl:text>
            </xsl:when>
            <xsl:when test="$resource = 'rdaTimespan'">
                <xsl:text>RDA Timespan</xsl:text>
            </xsl:when>
            <xsl:when test="$resource = 'rdaCollectiveAgent'">
                <xsl:text>RDA Collective Agent</xsl:text>
            </xsl:when>
            <xsl:when test="$resource = 'rdaNomen'">
                <xsl:text>RDA Nomen</xsl:text>
            </xsl:when>
            <xsl:when test="$resource = 'rdaEntity'">
                <xsl:text>RDA Entity</xsl:text>
            </xsl:when>
            <xsl:when test="$resource = 'test'">
                <xsl:text>TEST</xsl:text>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    
    <!-- return format as text - determine case -->
    <xsl:template name="format_formats">
        <xsl:param name="case"/>
        <xsl:param name="format"/>
        <!-- [!] THESE OPTIONS MUST MATCH
            formats.xsd > xs:simpleType @name="format_type" > enumerations [!] -->
        <xsl:choose>
            <xsl:when test="$format = 'standalone'">
                <xsl:choose>
                    <xsl:when test="$case = 'title'">
                        <xsl:text>Standalone Template</xsl:text>
                    </xsl:when>
                    <xsl:when test="$case = 'sentence'">
                        <xsl:text>standalone template</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$format = 'printMonograph'">
                <xsl:choose>
                    <xsl:when test="$case = 'title'">
                        <xsl:text>Print Monograph</xsl:text>
                    </xsl:when>
                    <xsl:when test="$case = 'sentence'">
                        <xsl:text>print monograph</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$format = 'aggregating_printMonograph'">
                <xsl:choose>
                    <xsl:when test="$case = 'title'">
                        <xsl:text>Print Monograph (Aggregating)</xsl:text>
                    </xsl:when>
                    <xsl:when test="$case = 'sentence'">
                        <xsl:text>print monograph (aggregating)</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$format = 'accessPoint'">
                <xsl:choose>
                    <xsl:when test="$case = 'title'">
                        <xsl:text>Access Point</xsl:text>
                    </xsl:when>
                    <xsl:when test="$case = 'sentence'">
                        <xsl:text>access point</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$format = 'identifier'">
                <xsl:choose>
                    <xsl:when test="$case = 'title'">
                        <xsl:text>Identifier</xsl:text>
                    </xsl:when>
                    <xsl:when test="$case = 'sentence'">
                        <xsl:text>identifier</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$format = 'na'"/>
            <xsl:when test="$format = 'test'">
                <xsl:text>TEST</xsl:text>
            </xsl:when>
            <!-- 
            <xsl:when test="$format = ''">
                <xsl:choose>
                    <xsl:when test="$case = 'title'"></xsl:when>
                    <xsl:when test="$case = 'sentence'"></xsl:when>
                </xsl:choose>
            </xsl:when>
            -->
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
