declare namespace h="http://schemas.sportradar.com/sportsapi/handball/v2";
declare variable $prefix as xs:string external;
let $seasons := doc("seasons_list.xml")//h:season[starts-with(@name, $prefix)]
for $season in $seasons
order by $season/@start_date ascending
return concat($season/@name, " - ", $season/@start_date)
