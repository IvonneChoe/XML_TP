function extraction() {
  out=$1
  query=$2
  pf=$3
  id=$4
  java net.sf.saxon.Query -s:$out -q:$query prefix="${pf}" season_id="sr:season:${id}"
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

function grepper() {
  if [[ $(echo $SHELL) == "/bin/bash" ]]; then
    grep -oP 'season:\K\d+$'
  else
    grep -Eo 'season:\d+$' | grep -Eo '\d+$'
  fi
}

prefix=$1
INPUT="handball_data.xml"
LIST="seasons_list.xml"
ORDERED_LIST="ordered_seasons_list.xml"
INFO="season_info.xml"
STANDINGS="season_standings.xml"
XSL_DATA="format.xsl"
XSL_ID="order_seasons_list.xsl"
FO="handball_page.fo"
PDF="handball_report.pdf"
touch $INPUT $ORDERED_LIST $LIST $FO $INFO $STANDINGS

if [[ -z "${SPORTRADAR_API}" ]]; then
  echo 'SPORTRADAR_API environment variable not setted'
fi

download "https://api.sportradar.com/handball/trial/v2/en/seasons.xml" $LIST

xsltproc $XSL_ID $LIST > $ORDERED_LIST

season_id=$(extraction $ORDERED_LIST extract_season_id.xq $prefix | grepper)

echo $season_id

download "https://api.sportradar.com/handball/trial/v2/en/seasons/sr%3Aseason%3A${season_id}/info.xml" $INFO
download "https://api.sportradar.com/handball/trial/v2/en/seasons/sr%3Aseason%3A${season_id}/standings.xml" $STANDINGS

extraction $INPUT extract_handball_data.xq $prefix $season_id > $INPUT
xml_linter $INPUT

fop -xml $INPUT -xsl $XSL_DATA -foout $FO
fop -fo $FO -pdf $PDF
