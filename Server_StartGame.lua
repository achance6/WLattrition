function Server_StartGame(game, standing) 
  local SUPPLYLIMITMULT = 30
	local defaultBonuses = game.Map.Bonuses
	local overriddenBonuses = game.Settings.OverriddenBonuses
	local publicGameData = Mod.PublicGameData
	publicGameData.supplyLimitData = {}
  publicGameData.whiteList = {} --Array of player IDs for whom attrition is nullified
  local whiteListBonuses = {} --Array of bonus IDs that, if controlled by a player, nullify attrition for that player globally
  local whiteBonusCount = 1
	for bonusID, bonusDetails in pairs(defaultBonuses) do
		publicGameData.supplyLimitData[bonusID] = bonusDetails.Amount * SUPPLYLIMITMULT
    if bonusDetails.Name == "The March of the White Walkers" then
      whiteListBonuses[whiteBonusCount] = bonusDetails
      whiteBonusCount = whiteBonusCount + 1
    end
	end
	for bonusID, bonusDetails in pairs(overriddenBonuses) do
		publicGameData.supplyLimitData[bonusID] = bonusDetails.Amount * SUPPLYLIMITMULT
    if bonusDetails.Name == "The March of the White Walkers" then
      whiteListBonuses[whiteBonusCount] = bonusDetails
      whiteBonusCount = whiteBonusCount + 1
    end
	end
  
  local cur = 1
  for _, bonusDetails in pairs(whiteListBonuses) do
    for _, terrID in pairs(bonusDetails.Territories) do
      if not standing.Territories[terrID].IsNeutral then
        publicGameData.whiteList[cur] = standing.Territories[terrID].OwnerPlayerID
        cur = cur + 1
      end
    end
  end
  
	Mod.PublicGameData = publicGameData
end