for $s in doc("seasons_list.xml")//season
where starts-with($s/@name, "Champions")
return <season-id>{ $s/@id }</season-id>