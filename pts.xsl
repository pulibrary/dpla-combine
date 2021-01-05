<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:ptsem="http://digital.library.ptsem.edu/ns/dcterms"
    xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
    xmlns:edm="http://www.europeana.eu/schemas/edm/"
    exclude-result-prefixes="xs"
    version="3.0">
    
    <xsl:output indent="yes" />
    
    <xsl:variable name="and"><![CDATA[&]]></xsl:variable>
    
    
    <xsl:template name="data_provider">
        <edm:dataProvider>Princeton Theological Seminary</edm:dataProvider>
    </xsl:template>
    
    <xsl:template name="data_provider_state">
        <dc:data.state>NJ</dc:data.state>
    </xsl:template>
    
    <xsl:template name="preview">
        <xsl:variable name="identifier">
            <xsl:value-of select="//oai:header/oai:identifier"/>
        </xsl:variable>
        <edm:preview>
            <xsl:analyze-string select="$identifier"
                regex="^.*:(.*)$">
                <xsl:matching-substring>
                    <xsl:value-of select="concat('https://commons.ptsem.edu/?cover=', regex-group(1), $and, 'size=L')"/>
                </xsl:matching-substring>
                <xsl:fallback/>
            </xsl:analyze-string>
        </edm:preview>
    </xsl:template>
    
    <xsl:template name="is_shown_at">
        <xsl:variable name="last_identifier">
            <xsl:value-of select="ptsem:dcterms/dc:identifier[last()]"/>
        </xsl:variable>
        <edm:isShownAt>
            <xsl:analyze-string select="$last_identifier"
                regex="^(.*)/id/(.*)$">
                <xsl:matching-substring>
                    <xsl:value-of select="concat(regex-group(1), '/?cover=', regex-group(2), $and, 'size=L')"/>
                </xsl:matching-substring>
                <xsl:fallback />
            </xsl:analyze-string>            
        </edm:isShownAt>
    </xsl:template>
    
    <xsl:template match="documents">
        <records>
            <xsl:apply-templates select="oai:record" />
        </records>
    </xsl:template>
    
    <xsl:template match="oai:record">
        <record xmlns="http://www.openarchives.org/OAI/2.0/">
            <xsl:apply-templates select="oai:metadata"/>
        </record>
    </xsl:template>
    
    <xsl:template match="oai:header | oai:about" />
    
    <xsl:template match="oai:metadata">
        <metadata xmlns="http://www.openarchives.org/OAI/2.0/">
            <xsl:apply-templates select="ptsem:dcterms" />
            <edmterms xmlns:edm="http://www.europeana.eu/schemas/edm/">
                <xsl:call-template name="data_provider" />
                <xsl:call-template name="is_shown_at" />
                <xsl:call-template name="preview" />
            </edmterms>
        </metadata>
    </xsl:template>
    
    <xsl:template match="ptsem:dcterms">
        <dcterms  xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns="http://digital.library.ptsem.edu/ns/dcterms" xsi:schemaLocation="http://digital.library.ptsem.edu/ns/dcterms http://commons.ptsem.edu/api/schema/dcterms.xsd">
            <xsl:apply-templates />
            <xsl:call-template name="data_provider_state"></xsl:call-template>
        </dcterms>
    </xsl:template>
    
    <xsl:template match="dc:title">
        <dc:title>
            <xsl:apply-templates/>
        </dc:title>
    </xsl:template>
    
    <xsl:template match="dcterms:isPartOf">
        <dcterms:isPartOf>
            <xsl:apply-templates />
        </dcterms:isPartOf>
    </xsl:template>
    
    <xsl:template match="dc:language">
        <dc:language>
            <xsl:apply-templates select="node()|@*"/>
        </dc:language>
    </xsl:template>
    
    <xsl:template match="dc:identifier">
        <dc:identifier>
            <xsl:apply-templates select="node()|@*"/>
        </dc:identifier>
    </xsl:template>

    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>