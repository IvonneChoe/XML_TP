INPUT="handball_data.xml"
XSL="format.xsl"
PDF="handball_page.pdf"
fop -xml $INPUT -xsl $XSL -pdf $PDF

# java -jar net.sf.saxon.Transform -s:"$INPUT" -xsl:"$XSL" -o:/dev/stdout | fop - "$PDF" || {
#   echo "Error en la generación del PDF";
#   exit 1;
# }
#
# echo "Reporte generado: $PDF"
