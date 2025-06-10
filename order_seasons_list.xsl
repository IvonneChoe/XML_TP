<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:s="http://schemas.sportradar.com/sportsapi/handball/v2"
  exclude-result-prefixes="s">
  <xsl:output method="xml" encoding="UTF-8" namespace="http://schemas.sportradar.com/sportsapi/handball/v2" indent="yes"/>
  <xsl:template match="s:seasons">
    <seasons>
      <xsl:apply-templates select="s:season">
        <xsl:sort select="@start_date" order="ascending" data-type="text"/>
      </xsl:apply-templates>
    </seasons>
  </xsl:template>
  <xsl:template match="s:season">
    <xsl:element name="season">
      <xsl:copy-of select="@*|node()"/>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
