function Server_StartGame(game, standing) 
	local def_bonuses = game.MapDetails.Bonuses
	local overriden_bonuses = game.GameSettings.OverriddenBonuses
	local public_game_data = Mod.PublicGameData
	local supply_limit_mult = 15
	public_game_data.supply_limit_data = {}
	for area_id, bonus in pairs(def_bonuses) do
		public_game_data.supply_limit_data[area_id] = bonus * supply_limit_mult
	end
	for area_id, bonus_details in pairs(overriden_bonuses) do
		public_game_data.supply_limit_data[area_id] = bonus_details.Amount * supply_limit_mult
	end
	Mod.PublicGameData = public_game_data
end