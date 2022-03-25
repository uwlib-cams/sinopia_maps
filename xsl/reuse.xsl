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
    
    <!-- TEST 001rt_metadata -->
    <xsl:function name="bmrxml:rda_iri_slug">
        <xsl:param name="path_to_iri"/>
        <xsl:value-of select="translate(substring-after($path_to_iri, 'Elements/'), '/', '_')"/>
    </xsl:function>
    
</xsl:stylesheet>