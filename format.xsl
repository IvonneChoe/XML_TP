<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes"/>
  <xsl:strip-space elements="*"/>
  <xsl:template match="/">
    <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
      <fo:layout-master-set>
        <fo:simple-page-master
        master-name="A4"
        page-width="21cm"
        page-height="29.7cm"
        margin-top="1cm"
        margin-bottom="2cm"
        margin-left="1.5cm"
        margin-right="1.5cm">
        <fo:region-body/>
        <fo:region-before extent="1cm"/>
      </fo:simple-page-master>
    </fo:layout-master-set>
    <fo:page-sequence master-reference="A4">
      <!-- Encabezado estático en la zona superior -->
      <fo:static-content flow-name="xsl-region-before">
        <fo:block font-size="10pt" text-align="center">
          <xsl:value-of select="handball_data/season/category"/> Handball season for <xsl:value-of select="handball_data/season/gender"/> - <xsl:value-of select="handball_data/season/year"/>
        </fo:block>
      </fo:static-content>
      <fo:flow flow-name="xsl-region-body">
        <fo:block font-size="16pt" space-after="12pt">
          Competitors of <xsl:value-of select="handball_data/season/name"/>
        </fo:block>
        <xsl:for-each select="handball_data//competitor">
          <fo:block font-size="12pt" space-before="6pt" space-after="6pt">
            <xsl:value-of select="./@name"/>
            <xsl:if test="./@country"> (<xsl:value-of select="./@country"/>)
          </xsl:if>
        </fo:block>
        <fo:table table-layout="fixed" width="100%" border="1pt solid black">
          <fo:table-column column-width="40%"/>
          <fo:table-column column-width="7%"/>
          <fo:table-column column-width="7%"/>
          <fo:table-column column-width="7%"/>
          <fo:table-column column-width="7%"/>
          <fo:table-column column-width="7%"/>
          <fo:table-column column-width="7%"/>
          <fo:table-column column-width="7%"/>
          <fo:table-header>
            <fo:table-row background-color="rgb(215,245,250)">
              <fo:table-cell border="1pt solid black"><fo:block font-size="8pt">Group</fo:block></fo:table-cell>
              <fo:table-cell border="1pt solid black"><fo:block font-size="8pt">Rank</fo:block></fo:table-cell>
              <fo:table-cell border="1pt solid black"><fo:block font-size="8pt">Played</fo:block></fo:table-cell>
              <fo:table-cell border="1pt solid black"><fo:block font-size="8pt">Wins</fo:block></fo:table-cell>
              <fo:table-cell border="1pt solid black"><fo:block font-size="8pt">Loss</fo:block></fo:table-cell>
              <fo:table-cell border="1pt solid black"><fo:block font-size="8pt">Draws</fo:block></fo:table-cell>
              <fo:table-cell border="1pt solid black"><fo:block font-size="8pt">Goals Diff</fo:block></fo:table-cell>
              <fo:table-cell border="1pt solid black"><fo:block font-size="8pt">Points</fo:block></fo:table-cell>
            </fo:table-row>
          </fo:table-header>
          <fo:table-body>
            <xsl:for-each select="//standing">
              <xsl:sort select="./number(@points)" order="descending" data-type="number"/>
              <xsl:sort select="./number(@goals_diff)" order="ascending" data-type="number"/>
              <fo:table-row>
                <fo:table-cell border="1pt solid black"><fo:block font-size="8pt"><xsl:value-of select="group_name"/></fo:block></fo:table-cell>
                <fo:table-cell border="1pt solid black"><fo:block font-size="8pt"><xsl:value-of select="rank"/></fo:block></fo:table-cell>
                <fo:table-cell border="1pt solid black"><fo:block font-size="8pt"><xsl:value-of select="played"/></fo:block></fo:table-cell>
                <fo:table-cell border="1pt solid black"><fo:block font-size="8pt"><xsl:value-of select="win"/></fo:block></fo:table-cell>
                <fo:table-cell border="1pt solid black"><fo:block font-size="8pt"><xsl:value-of select="loss"/></fo:block></fo:table-cell>
                <fo:table-cell border="1pt solid black"><fo:block font-size="8pt"><xsl:value-of select="draw"/></fo:block></fo:table-cell>
                <fo:table-cell border="1pt solid black"><fo:block font-size="8pt"><xsl:value-of select="goals_diff"/></fo:block></fo:table-cell>
                <fo:table-cell border="1pt solid black"><fo:block font-size="8pt"><xsl:value-of select="points"/></fo:block></fo:table-cell>
              </fo:table-row>
            </xsl:for-each>
          </fo:table-body>
        </fo:table>
      </xsl:for-each>
    </fo:flow>
  </fo:page-sequence>
</fo:root>
  </xsl:template>
</xsl:stylesheet>
