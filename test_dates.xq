declare namespace h="http://schemas.sportradar.com/sportsapi/handball/v2";
for $season in doc("seasons_list.xml")//h:season[starts-with(@name, "Champions League")]
order by $season/@start_date ascending
return concat($season/@name, " (", $season/@start_date, ")")
