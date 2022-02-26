<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:maps="https://uwlib-cams.github.io/map_storage/"
    xmlns:uwlsinopia="https://uwlib-cams.github.io/sinopia_maps/"
    xmlns:sinopia="http://sinopia.io/vocabulary/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:bmrxml="https://briesenberg07.github.io/xml_stack/" exclude-result-prefixes="xs"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:include href="rt_metadata.xsl"/>
    <xsl:include href="create_ordering.xsl"/>

    <xsl:template match="/">
        <xsl:for-each
            select="document('../../sinopia_maps.xml')/uwlsinopia:sinopia_maps/uwlsinopia:rts/uwlsinopia:rt">
            <!-- vars -->
            <xsl:variable name="propSet" select="uwlsinopia:propSet"/>
            <xsl:variable name="resource" select="uwlsinopia:resource"/>
            <xsl:variable name="format" select="uwlsinopia:format"/>
            <xsl:variable name="user" select="uwlsinopia:user"/>
            <!-- to do remove 'TEST' in rt_id to output for production -->
            <xsl:variable name="rt_id" select="
                    concat('TEST:WAU:',
                    format-date(current-date(), '[Y0001]-[M01]-[D01]'), ':',
                    $resource, ':', $format, ':', $user)"/>
            <xsl:variable name="sorted_properties" as="node()*">
                <!-- low-priority to do is gain better understanding of 'as="node()*"' syntax -->
                <xsl:for-each select="
                        (: [!] fn:document won't work for pulling from multiple propSets,
                        need fn:collection, etc. [!] 
                        also doc XPath will need to change once I'm not using test propSets :)
                        (: I'd also rather access propSets via HTTP :)
                        document(concat('../../../map_storage/test_propSet_', $propSet, '.xml'))/
                        maps:propSet/maps:prop
                        [maps:sinopia/maps:implementationSet
                        [maps:resource/@mapid_resource = $resource]
                        [maps:format = $format]
                        [maps:user = $user]]">
                    <xsl:sort select="
                            maps:sinopia/maps:implementationSet/maps:form_order"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:variable>
            <!-- to do change result-document path for production -->
            <!-- RT NAMING CONVENTIONS: colons for RT ID, underscores for RT filename, spaces for RT label -->
            <xsl:result-document href="../../docs/rdf/{translate($rt_id, ':', '_')}.rdf">
                <rdf:RDF>
                    <xsl:call-template name="rt_metadata">
                        <!-- to do: propSet param will not work as-is for pulling from multiple prop sets -->
                        <xsl:with-param name="propSet" select="$propSet"/>
                        <xsl:with-param name="resource" select="$resource"/>
                        <xsl:with-param name="suppressible" select="uwlsinopia:suppressible"/>
                        <xsl:with-param name="optional_classes">
                            <xsl:for-each select="uwlsinopia:optionalClass">
                                <optionalClass>
                                    <xsl:value-of select="."/>
                                </optionalClass>
                            </xsl:for-each>
                        </xsl:with-param>
                        <xsl:with-param name="format" select="$format"/>
                        <xsl:with-param name="user" select="$user"/>
                        <xsl:with-param name="rt_id" select="$rt_id"/>
                        <xsl:with-param name="sorted_properties" select="$sorted_properties"/>
                    </xsl:call-template>
                    <!-- see storage_to_rdfxml_templates.xsl for pts_start -->
                    <xsl:call-template name="create_ordering">
                        <xsl:with-param name="sorted_property" select="$sorted_properties"/>
                    </xsl:call-template>
                </rdf:RDF>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
