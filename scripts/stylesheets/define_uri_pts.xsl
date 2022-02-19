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
    <xsl:function name="bmrxml:rda_iri_slug_define_uri">
        <xsl:param name="path_to_iri"/>
        <xsl:value-of select="translate(substring-after($path_to_iri, 'Elements/'), '/', '_')"/>
    </xsl:function>
    
    <!-- output uri or lookup > uri PT attributes -->
    <xsl:template name="define_uri_pts">
        <xsl:param name="prop"/>
        <rdf:Description
            rdf:nodeID="{concat(bmrxml:rda_iri_slug_define_uri($prop/maps:prop_iri/@iri),
            '_uri_attributes')}">
            <!-- hard-code rdf:type for this node sinopia:UriPropertyTemplate-->
            <rdf:type rdf:resource="http://sinopia.io/vocabulary/UriPropertyTemplate"/>
            <!-- provide default uri -->
            <sinopia:hasDefault rdf:resource="{
                $prop/maps:sinopia/maps:implementationSet/maps:sinopia_prop_attributes/
                maps:sinopia_prop_type_attributes/maps:uri_attributes/maps:default_uri/@iri}"
            />
        </rdf:Description>
        <!-- if label for default uri is provided in storage instance, output to RT -->
        <xsl:if test="
            $prop/maps:sinopia/maps:implementationSet/maps:sinopia_prop_attributes/
            maps:sinopia_prop_type_attributes/maps:uri_attributes/maps:default_uri_label">
            <rdf:Description rdf:about="{
                $prop/maps:sinopia/maps:implementationSet/maps:sinopia_prop_attributes/
                maps:sinopia_prop_type_attributes/maps:uri_attributes/maps:default_uri/@iri}">
                <rdfs:label xml:lang="{
                    $prop/maps:sinopia/maps:implementationSet/maps:sinopia_prop_attributes/
                    maps:sinopia_prop_type_attributes/maps:uri_attributes/maps:default_uri_label/@xml:lang}">
                    <xsl:value-of select="
                        $prop/maps:sinopia/maps:implementationSet/maps:sinopia_prop_attributes/
                        maps:sinopia_prop_type_attributes/maps:uri_attributes/maps:default_uri_label"
                    />
                </rdfs:label>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>