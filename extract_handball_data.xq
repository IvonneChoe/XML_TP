(: Función para validar si un archivo existe y tiene contenido :)
declare function local:file-exists($filename as xs:string) as xs:boolean {
  exists(doc($filename)/*)
};

declare variable $prefix as xs:string external;

let $info_exists := local:file-exists("season_info.xml")
let $standings_exists := local:file-exists("season_standings.xml")
(:let $list_exists := local:file-exists("seasons_list.xml"):)

(: Main processing :)
let $seasons := 
  if (local:file-exists("seasons_list.xml")) then
    doc("seasons_list.xml")//season
  else ()

let $matching_season := $seasons[starts-with(@name, $prefix)][1]
let $season_id := string($matching_season/@id)

return
<handball_data>
{
  if ($prefix = "") then
    <error>Prefix must not be empty</error>
  else if (empty($matching_season)) then
    <error>No season found with the given prefix</error>
  else if (not($info_exists) or not($standings_exists)) then
    <error>Season info or standings data not available</error>
  else
    let $season_info := doc("season_info.xml")//season
    let $season_standings := doc("season_standings.xml")//season_standing[@type="total"]
    
    return (
      <season>
        <name>{string($season_info/@name)}</name>
        <year>{string($season_info/@year)}</year>
        <category>{string($season_info/category/@name)}</category>
        <gender>{string($season_info/competition/@gender)}</gender>
      </season>,
      <competitors>
      {
        for $competitor in $season_info//competitor
        let $competitor_id := string($competitor/@id)
        let $competitor_standings := $season_standings//standing[competitor/@id = $competitor_id]
        
        return
        <competitor name="{$competitor/@name}" country="{$competitor/@country}">
          <standings>
          {
            for $standing in $competitor_standings
            let $group := $standing/parent::standings/parent::group
            order by xs:integer($standing/@points) descending, xs:integer($standing/@goals_diff) ascending
            return
            <standing 
              group_name_code="{$group/@group_name}"
              group_name="{$group/@name}"
              rank="{$standing/@rank}"
              played="{$standing/@played}"
              win="{$standing/@win}"
              loss="{$standing/@loss}"
              draw="{$standing/@draw}"
              goals_for="{$standing/@goals_for}"
              goals_against="{$standing/@goals_against}"
              goals_diff="{$standing/@goals_diff}"
              points="{$standing/@points}"/>
          }
          </standings>
        </competitor>
      }
      </competitors>
    )
}
</handball_data>