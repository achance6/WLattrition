function Server_StartGame(game, standing) 
	print("test")
	local def_bonuses = game.Map.Bonuses
	local overriden_bonuses = game.Settings.OverriddenBonuses
	local public_game_data = Mod.PublicGameData
	local supply_limit_mult = 15
	public_game_data.supply_limit_data = {}
	for area_id, bonus_details in pairs(def_bonuses) do
		public_game_data.supply_limit_data[area_id] = bonus_details.Amount * supply_limit_mult
	end
	for area_id, bonus_details in pairs(overriden_bonuses) do
		public_game_data.supply_limit_data[area_id] = bonus_details.Amount * supply_limit_mult
	end
	Mod.PublicGameData = public_game_data
end