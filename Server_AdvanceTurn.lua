
function Server_AdvanceTurn_Start(game,addOrder)
  local standing = game.ServerGame.LatestTurnStanding;
	local default_areas = game.Map.Bonuses
	local overridden_areas = game.Settings.OverriddenBonuses
	local areas = {}
	
	--put overridden areas into our areas map
	for area_id, bonus_details in pairs(default_areas) do
		areas[area_id] = default_areas[area_id]
		if overridden_areas[area_id] ~= nil then
			areas[area_id] = overridden_areas[area_id]
		end
	end
	
	attritionOrder = {}
  cur = 1
	for area_id, bonus_details in pairs(areas) do
		local total_armies = 0
		for _, curr_ter_ID in pairs(bonus_details.Territories) do
			total_armies = total_armies + standing.Territories[curr_ter_ID].NumArmies.NumArmies
		end
		if total_armies > Mod.PublicGameData.supply_limit_data[area_id] then
			for _, curr_ter_ID in pairs(bonus_details.Territories) do
			terrMod = WL.TerritoryModification.Create(curr_ter_ID);
			terrMod.SetArmiesTo = standing.Territories[curr_ter_ID].NumArmies.NumArmies * 0.8; --TODO: Variable attrition
			attritionOrder[cur] = terrMod
			cur = cur + 1
			end
		end
	end
	addOrder(WL.GameOrderEvent.Create(WL.PlayerID.Neutral, 'Attrition', nil, attritionOrder));
end