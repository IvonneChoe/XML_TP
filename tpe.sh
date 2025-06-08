let prefix=$1
let request_command="Invoke-WebRequest -Uri"
let flags="-Headers @{ 'accept' = 'application/json'; 'x-api-key' = '$env:SPORTRADAR_API' } -OutFile"

# bash flags: 
# Tira error si no se pasan los parámetros necesarios.

if [[ "$OSTYPE" == linux* || "$OSTYPE" == darwin* ]]; then
  request_command="curl -X GET"
  flags="--header 'accept: application/json' --header 'x-api-key: ${SPORTRADAR_API}' -o"
fi

# Recibe un parámetro llamado “prefix” y que devuelva el id de la primer temporada (o elemento season) cuyo nombre (atributo name) comience con lo 
# definido en el parámetro prefix. En caso de no haber ninguna temporada que cumpla dicha característica, debe devolver un string vacío.
# C:\Users\ivonn\Documents\SaxonHE9-5-1-2J\ esto no tiene que estar para el saxon9he.jar

java -cp C:\Users\ivonn\Documents\SaxonHE9-5-1-2J\saxon9he.jar  net.sf.saxon.Query -s:seasons_list.xml -q:extract_season_id.xq prefix="${prefix}"

# Dado un id de temporada (o season_id), este método devuelve características de la misma.
# NOTE: sr%3Aseason%3AXXXXX --> modificar XXXXX por el id de temporada que se quiera consultar.

$request_command "https://api.sportradar.com/handball/trial/v2/en/seasons/sr%3Aseason%3A95495/info.xml" $flags "season_info.xml"


# Dado un id de temporada (o season_id), este método devuelve las estadísticas (tales como: puntos, goles a favor, goles en 
# contra, diferencia de goles, partidos ganados, etc) de los equipos que compitieron en ella.
# NOTE: sr%3Aseason%3AXXXXX --> modificar XXXXX por el id de temporada que se quiera consultar.

$request_command "https://api.sportradar.com/handball/trial/v2/en/seasons/sr%3Aseason%3A95495/standings.xml" $flags "season_standings.xml"
