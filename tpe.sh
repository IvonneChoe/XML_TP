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

function download() {
  url=$1
  output_file=$2
  curl -X GET "${url}" --header 'accept: application/xml' --header "x-api-key: ${SPORTRADAR_API}" > $output_file
}

season_id=$(extraction seasons_list.xml extract_season_id.xq $prefix | egrep -o 'season:\d+$' | egrep -o '\d+$')

url="https://api.sportradar.com/handball/trial/v2/en/seasons/sr%3Aseason%3A${season_id}/"

download "${url}/info.xml" season_info.xml

download "${url}/standings.xml" season_standings.xml

extraction handball_data.xml extract_handball_data.xq $prefix > handball_data.xml
