declare variable $prefix as xs:string external;

let $season := doc("seasons_list.xml")//season[starts-with(@name, $prefix) and matches(@id, 'sr:season:\d+$')][1]
return
  if (exists($season)) then
    data($season/@id)
  else
    ""
