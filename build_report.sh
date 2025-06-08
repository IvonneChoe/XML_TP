#!/usr/bin/env bash -> cada uno tiene que poner el interprete que tenga

# --- rutas relativas desde scripts/ ---
INPUT="handball_data.xml"
XSL="format.xsl"
PDF="handball_page.pdf"
SAXON_JAR="saxon-he-12.7.jar"

java -jar "$SAXON_JAR" \
  -s:"$INPUT" \
  -xsl:"$XSL" \
  -o:/dev/stdout \ 
  | fop - "$PDF" \
  || { echo "Error en la generación del PDF"; exit 1; }

echo "Reporte generado: $PDF"

