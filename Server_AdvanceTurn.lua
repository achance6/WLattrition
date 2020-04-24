
function Server_AdvanceTurn_Start(game,addOrder)
  local standing = game.ServerGame.LatestTurnStanding;
	local defaultBonuses = game.Map.Bonuses
	local overriddenBonuses = game.Settings.OverriddenBonuses
	local bonuses = {}
	
	--put overridden bonuses into our bonuses map
	for bonusID, _ in pairs(defaultBonuses) do
		bonuses[bonusID] = defaultBonuses[bonusID]
		if overriddenBonuses[bonusID] ~= nil then
			bonuses[bonusID] = overriddenBonuses[bonusID]
		end
	end
	
	attritionOrder = {}
  cur = 1
	for bonusID, bonusDetails in pairs(bonuses) do
		local totalArmies = 0
    --TODO: don't count neutral armies
		for _, currTerID in pairs(bonusDetails.Territories) do
			totalArmies = totalArmies + standing.Territories[currTerID].NumArmies.NumArmies
		end
		if totalArmies > Mod.PublicGameData.supplyLimitData[bonusID] then
			for _, currTerID in pairs(bonusDetails.Territories) do
			terrMod = WL.TerritoryModification.Create(currTerID);
			terrMod.SetArmiesTo = standing.Territories[currTerID].NumArmies.NumArmies * 0.8; --TODO: Variable attrition
			attritionOrder[cur] = terrMod
			cur = cur + 1
			end
		end
	end
	addOrder(WL.GameOrderEvent.Create(WL.PlayerID.Neutral, 'Attrition', nil, attritionOrder));
end