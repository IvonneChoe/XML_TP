function extraction() {
  java net.sf.saxon.Query -s:$1 -q:$2 prefix=$3
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

prefix=$1
INPUT="handball_data.xml"
LIST="seasons_list.xml"
INFO="season_info.xml"
STANDINGS="season_standings.xml"
XSL="format.xsl"
FO="handball_page.fo"
PDF="handball_report.pdf"
touch $INPUT $XSL $FO $INFO $STANDINGS

if [[ -z "${SPORTRADAR_API}" ]]; then
  echo 'SPORTRADAR_API environment variable not setted'
else
  echo "${SPORTRADAR_API} is your key"
fi

download "https://api.sportradar.com/handball/trial/v2/en/seasons.xml" $LIST

season_id=$(extraction $LIST extract_season_id.xq $prefix | egrep -o 'season:\d+$' | egrep -o '\d+$')

download "https://api.sportradar.com/handball/trial/v2/en/seasons/sr%3Aseason%3A${season_id}/info.xml" $INFO
download "https://api.sportradar.com/handball/trial/v2/en/seasons/sr%3Aseason%3A${season_id}/standings.xml" $STANDINGS

extraction $INPUT extract_handball_data.xq $prefix > $INPUT
xml_linter $INPUT

fop -xml $INPUT -xsl $XSL -foout $FO
fop -fo $FO -pdf $PDF
