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
    <xsl:function name="bmrxml:rda_iri_slug_define_nested">
        <xsl:param name="path_to_iri"/>
        <xsl:value-of select="translate(substring-after($path_to_iri, 'Elements/'), '/', '_')"/>
    </xsl:function>
    
    <!-- output nested resource PT attributes -->
    <xsl:template name="define_nested_resource_pts">
        <xsl:param name="prop"/>
        <rdf:Description
            rdf:nodeID="{concat(bmrxml:rda_iri_slug_define_nested($prop/uwmaps:prop_iri/@iri),
            '_resource_attributes')}">
            <!-- hard-code rdf:type for this node sinopia:ResourcePropertyTemplate -->
            <rdf:type rdf:resource="http://sinopia.io/vocabulary/ResourcePropertyTemplate"/>
            <xsl:for-each select="
                $prop/uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:sinopia_prop_attributes/
                uwsinopia:sinopia_prop_type_attributes/uwsinopia:nested_resource_attributes/uwsinopia:rt_id">
                <sinopia:hasResourceTemplateId rdf:resource="{.}"/>
            </xsl:for-each>
        </rdf:Description>
    </xsl:template>
    
</xsl:stylesheet>