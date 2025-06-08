prefix=$1

if [[ -z "$1" ]]; then
  echo "Prefix required, use: $0 <prefix>"
  exit 1
fi

if [[ -z "${SPORTRADAR_API}" ]]; then
  echo 'SPORTRADAR_API environment variable not setted'
else
  echo "${SPORTRADAR_API} is your key"
fi

function extraction() {
  out=$1
  query=$2
  java net.sf.saxon.Query -s:$out -q:$query prefix="${prefix}"
}

function xml_linter() {
  file=$1
  touch hdata.tmp
  xmllint --format $file -o hdata.tmp && mv hdata.tmp $file
}

function download() {
  url=$1
  output_file=$2
  curl -X GET "${url}" --header 'accept: application/json' --header "x-api-key: ${SPORTRADAR_API}" > $output_file
  xml_linter $output_file
}

season_id=$(extraction seasons_list.xml extract_season_id.xq $prefix | egrep -o 'season:\d+$' | egrep -o '\d+$')

download "https://api.sportradar.com/handball/trial/v2/en/seasons/sr%3Aseason%3A${season_id}/info.xml" season_info.xml

download "https://api.sportradar.com/handball/trial/v2/en/seasons/sr%3Aseason%3A${season_id}/standings.xml" season_standings.xml

extraction handball_data.xml extract_handball_data.xq $prefix > handball_data.xml

xml_linter handball_data.xml

INPUT="handball_data.xml"
XSL="format.xsl"
PDF="handball_page.pdf"
fop -xml handball_data.xml -xsl format.xsl -foout salida.fo
fop -fo salida.fo -pdf $PDF
