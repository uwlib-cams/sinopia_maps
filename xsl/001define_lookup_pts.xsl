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
    
    <!-- output uri or lookup > lookup PT attributes -->
    <xsl:template name="define_lookup_pts">
        <xsl:param name="prop"/>
        <rdf:Description
            rdf:nodeID="{concat($prop/uwmaps:prop_iri/@iri => 
            translate('/.#', '') => substring-after('http:'),
            '_lookup_attributes')}">
            <!-- hard-code rdf:type for this node sinopia:LookupPropertyTemplate-->
            <rdf:type rdf:resource="http://sinopia.io/vocabulary/LookupPropertyTemplate"/>
            <!-- TO DO BELOW -->
            <xsl:for-each select="
                $prop/uwmaps:sinopia/uwsinopia:implementation_set/uwsinopia:sinopia_prop_attributes/
                uwsinopia:sinopia_prop_type_attributes/uwsinopia:lookup_attributes/uwsinopia:authorities/uwsinopia:authority_urn">
                <sinopia:hasAuthority rdf:resource="{.}"/>
            </xsl:for-each>
        </rdf:Description>
        <!-- map_storage doesn't allow for assigning labels to authority URNs, so no URN label output -->
    </xsl:template>
    
</xsl:stylesheet>