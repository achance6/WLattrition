
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
    playerOwners = {}
    local count = 1
		for _, currTerID in pairs(bonusDetails.Territories) do
      if not isInWhiteList(standing.Territories[currTerID].OwnerPlayerID) and not standing.Territories[currTerID].IsNeutral then
        totalArmies = totalArmies + standing.Territories[currTerID].NumArmies.NumArmies
      end
      playerOwners[count] = standing.Territories[currTerID].OwnerPlayerID
		end
		if totalArmies > Mod.PublicGameData.supplyLimitData[bonusID] then
			for _, currTerID in pairs(bonusDetails.Territories) do
        if not isInWhiteList(standing.Territories[currTerID].OwnerPlayerID) and not standing.Territories[currTerID].IsNeutral then
          terrMod = WL.TerritoryModification.Create(currTerID);
          terrMod.SetArmiesTo = standing.Territories[currTerID].NumArmies.NumArmies * 0.8; --TODO: Variable attrition
          attritionOrder[cur] = terrMod
          cur = cur + 1
        end
			end
		end
	end
	addOrder(WL.GameOrderEvent.Create(WL.PlayerID.Neutral, 'Attrition', nil, attritionOrder));
end

function isInWhiteList(playerID)
  for _, whiteID in pairs(Mod.PublicGameData.whiteList) do
    if whiteID == playerID then
      return true
    end
  end
  return false
end