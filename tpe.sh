prefix=$1

if [[ -z "$1" ]]; then
  echo "Prefix required, use: $0 <prefix>"
  exit 1
fi

if [[ -z "${SPORTRADAR_API}" ]]; then
  echo "SPORTRADAR_API environment variable not setted"
fi

# Windows comands
# request_command="Invoke-WebRequest -Uri"
# flags="-Headers @{ 'accept' = 'application/json'; 'x-api-key' = '${SPORTRADAR_API}' } -OutFile"

request_command="curl -X GET"
flags="--header \"accept: application/json\" --header \"x-api-key: ${SPORTRADAR_API}\" -o"

# Recibe un parámetro llamado “prefix” y que devuelva el id de la primer temporada (o elemento season) cuyo nombre (atributo name) comience con lo 
# definido en el parámetro prefix. En caso de no haber ninguna temporada que cumpla dicha característica, debe devolver un string vacío.
# C:\Users\ivonn\Documents\SaxonHE9-5-1-2J\ esto no tiene que estar para el saxon9he.jar
java net.sf.saxon.Query -s:seasons_list.xml -q:extract_season_id.xq prefix="${prefix}"

function download() {
  url=$1
  output_file_name=$2
  $request_command $url $output_file_name
}

# Dado un id de temporada (o season_id), este método devuelve características de la misma.
# NOTE: sr%3Aseason%3AXXXXX --> modificar XXXXX por el id de temporada que se quiera consultar.
download "https://api.sportradar.com/handball/trial/v2/en/seasons/sr%3Aseason%3A95495/info.xml" "season_info.xml"

# Dado un id de temporada (o season_id), este método devuelve las estadísticas (tales como: puntos, goles a favor, goles en 
# contra, diferencia de goles, partidos ganados, etc) de los equipos que compitieron en ella.
# NOTE: sr%3Aseason%3AXXXXX --> modificar XXXXX por el id de temporada que se quiera consultar.
download "https://api.sportradar.com/handball/trial/v2/en/seasons/sr%3Aseason%3A95495/standings.xml" "season_standings.xml"
