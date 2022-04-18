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
    
    <!-- output uri or lookup > uri PT attributes -->
    <xsl:template name="define_uri_pts">
        <xsl:param name="resource"/>
        <xsl:param name="format"/>
        <xsl:param name="user"/>
        <xsl:param name="prop"/>
        <rdf:Description
            rdf:nodeID="{concat($prop/uwmaps:prop_iri/@iri => 
            translate('/.#', '') => substring-after('http:'),
            '_uri_attributes')}">
            <!-- hard-code rdf:type for this node sinopia:UriPropertyTemplate-->
            <rdf:type rdf:resource="http://sinopia.io/vocabulary/UriPropertyTemplate"/>
            <!-- provide default uri -->
            <sinopia:hasDefault rdf:resource="{$prop/uwmaps:sinopia/uwsinopia:implementation_set
                [uwsinopia:resource = $resource]
                [uwsinopia:format = $format]
                [uwsinopia:user = $user]
                /uwsinopia:sinopia_prop_attributes/uwsinopia:sinopia_prop_type_attributes/
                uwsinopia:uri_attributes/uwsinopia:default_uri/@iri}"/>
        </rdf:Description>
        <!-- if label for default uri is provided in storage instance, output to RT -->
        <xsl:if test="
            $prop/uwmaps:sinopia/uwsinopia:implementation_set
            [uwsinopia:resource = $resource]
            [uwsinopia:format = $format]
            [uwsinopia:user = $user]
            /uwsinopia:sinopia_prop_attributes/uwsinopia:sinopia_prop_type_attributes/
            uwsinopia:uri_attributes/uwsinopia:default_uri_label/text()">
            <rdf:Description rdf:about="{$prop/uwmaps:sinopia/uwsinopia:implementation_set
                [uwsinopia:resource = $resource]
                [uwsinopia:format = $format]
                [uwsinopia:user = $user]
                /uwsinopia:sinopia_prop_attributes/uwsinopia:sinopia_prop_type_attributes/
                uwsinopia:uri_attributes/uwsinopia:default_uri/@iri}">
                <rdfs:label xml:lang="{$prop/uwmaps:sinopia/uwsinopia:implementation_set
                    [uwsinopia:resource = $resource]
                    [uwsinopia:format = $format]
                    [uwsinopia:user = $user]
                    /uwsinopia:sinopia_prop_attributes/uwsinopia:sinopia_prop_type_attributes/
                    uwsinopia:uri_attributes/uwsinopia:default_uri_label/@xml:lang}">
                    <xsl:value-of select="
                        $prop/uwmaps:sinopia/uwsinopia:implementation_set
                        [uwsinopia:resource = $resource]
                        [uwsinopia:format = $format]
                        [uwsinopia:user = $user]
                        /uwsinopia:sinopia_prop_attributes/uwsinopia:sinopia_prop_type_attributes/
                        uwsinopia:uri_attributes/uwsinopia:default_uri_label"/>
                </rdfs:label>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>