declare namespace h="http://schemas.sportradar.com/sportsapi/handball/v2";

declare variable $prefix as xs:string external;
declare variable $season_id as xs:string external;

declare function local:file-exists($filename as xs:string) as xs:boolean {
  exists(doc($filename)/*)
};

let $info_exists := local:file-exists("season_info.xml")
let $standings_exists := local:file-exists("season_standings.xml")
let $list_exists := local:file-exists("ordered_sesons_list.xml")

let $seasons := doc("ordered_seasons_list.xml")//season
let $matching_season := $seasons[starts-with(@name, $prefix)][1]

return
<handball_data>
{
  if ($prefix = "") then
    <error>Prefix must not be empty</error>
  else if (empty($matching_season)) then
    <error>No season found with the given prefix</error>
  else if (not($info_exists) or not($standings_exists) or empty(doc("season_standings.xml")//h:season_standing)) then
    <error>Season info or standings data not available</error>
  else
    let $season_info := doc("season_info.xml")//h:season[@id = $season_id]
    let $season_standings := doc("season_standings.xml")//h:season_standing[@type="total"]
    
    return (
      <season>
        <name>{string($season_info/@name)}</name>
        <year>{string($season_info/@year)}</year>
        <category>{string($season_info/h:category/@name)}</category>
        <gender>{string($season_info/h:competition/@gender)}</gender>
      </season>,
      <competitors>
      {
        for $competitor in $season_info/..//h:competitor
        let $competitor_id := string($competitor/@id)
        let $competitor_standings := $season_standings//h:standing[h:competitor/@id = $competitor_id]
        
        return
        <competitor name="{$competitor/@name}" country="{$competitor/@country}">
          <standings>
          {
            for $standing in $competitor_standings
            let $group := $standing/parent::h:standings/parent::h:group
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
