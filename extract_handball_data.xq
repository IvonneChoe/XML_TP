declare variable $prefix as xs:string external;

let $list := doc("seasons_list.xml")
let $info := doc("season_info.xml")
let $standings := doc("season_standings.xml")

let $matching_season := $list//*[local-name() = "season"][starts-with(@name, $prefix)][1]
let $season_id := string($matching_season/@id)

return
  if ($prefix = "") then
    <handball_data>
      <error>Prefix must not be empty</error>
    </handball_data>
  else if (empty($matching_season)) then
    <handball_data>
      <error>No season found with the given prefix</error>
    </handball_data>
  else
    let $season_info := $info//*[local-name() = "season"][@id = $season_id]
    let $season_name := $season_info/@name
    let $season_year := $season_info/@year
    let $season_category := $season_info/@category
    let $season_gender := $season_info/@gender
    let $groups := $standings//*[local-name() = "season_standing"][@type = "total"]//*[local-name() = "group"]
    let $competitor_data :=
      for $group in $groups
      let $group_name := $group/@group_name
      let $group_code := $group/@name
      for $standing in $group//*[local-name() = "standing"]
      let $competitor := $standing//*[local-name() = "competitor"]
      let $name := $competitor/@name
      let $country := $competitor/@country
      return
        <competitor name="{$name}" country="{$country}">
          <standings>
            <standing
              group_name_code="{$group_code}"
              group_name="{$group_name}"
              rank="{$standing/@rank}"
              played="{$standing/@played}"
              win="{$standing/@win}"
              loss="{$standing/@loss}"
              draw="{$standing/@draw}"
              goals_for="{$standing/@goals_for}"
              goals_against="{$standing/@goals_against}"
              goals_diff="{$standing/@goals_diff}"
              points="{$standing/@points}">stats</standing>
          </standings>
        </competitor>

    return
      <handball_data>
        <season>
          <name>{string($season_name)}</name>
          <year>{string($season_year)}</year>
          <category>{string($season_category)}</category>
          <gender>{string($season_gender)}</gender>
        </season>
        <competitors>
          { $competitor_data }
        </competitors>
      </handball_data>
