<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
    
  <!-- Declaración de salida indentada -->
  <xsl:output method="xml" indent="yes"/>

  <!-- Plantilla principal que transforma handball_data.xml a XSL-FO -->
  <xsl:template match="/handball">
    <!-- Raíz FO -->
    <fo:root>
      <!-- Definición del maestro de página A4 con márgenes especificados -->
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

      <!-- Secuencia de páginas usando el maestro A4 -->
      <fo:page-sequence master-reference="A4">
        <!-- Encabezado estático en la zona superior -->
        <fo:static-content flow-name="xsl-region-before">
          <fo:block font-size="10pt" text-align="center">
            <xsl:value-of select="handball/season/@category"/>
            Handball season for
            <xsl:value-of select="handball/season/@gender"/>
            -
            <xsl:value-of select="handball/season/@year"/>
          </fo:block>
        </fo:static-content>

        <!-- Cuerpo principal -->
        <fo:flow flow-name="xsl-region-body">

          <!-- Título de la sección -->
          <fo:block font-size="16pt" space-after="12pt">
            Competitors of <xsl:value-of select="handball/season/@name"/>
          </fo:block>

          <!-- Iterar cada competidor -->
          <xsl:for-each select="handball/season/competitor">
            <!-- Nombre y país del competidor -->
            <fo:block font-size="12pt" space-before="6pt" space-after="6pt">
              <xsl:value-of select="name"/>
              <xsl:if test="country">
                (<xsl:value-of select="country"/>)
              </xsl:if>
            </fo:block>

            <!-- Tabla de standings -->
            <fo:table table-layout="fixed" width="100%" border="1pt solid black">
              <!-- Definición de columnas -->
              <fo:table-column column-width="40%"/>
              <fo:table-column column-width="7%"/>
              <fo:table-column column-width="7%"/>
              <fo:table-column column-width="7%"/>
              <fo:table-column column-width="7%"/>
              <fo:table-column column-width="7%"/>
              <fo:table-column column-width="7%"/>
              <fo:table-column column-width="7%"/>

              <!-- Cabecera de la tabla -->
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

              <!-- Cuerpo de la tabla con ordenamiento -->
              <fo:table-body>
                <xsl:for-each select="standings/standing">
                  <!-- Ordenar por puntos descendente y goals_diff ascendente -->
                  <xsl:sort select="number(points)" order="descending" data-type="number"/>
                  <xsl:sort select="number(goals_diff)" order="ascending" data-type="number"/>
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
