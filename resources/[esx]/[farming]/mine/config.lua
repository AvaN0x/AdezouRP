config = {}

config.items = {
	copper = 10,
	iron = 50,
	gold = 200,
	diamond = 500
}
RegisterNetEvent("market:change:copper")
AddEventHandler('market:change:copper', function(price)
	config.items['copper'] = price
end)
RegisterNetEvent("market:change:diamond")
AddEventHandler('market:change:diamond', function(price)
	config.items['diamond'] = price
end)

config.zones = {
	MineDealer = {coords = vector3(406.78, -349.7, 46.89), name = 'Acheteur de minerais', color = 70, sprite = 207},
	Mine = { coords = vector3(2946.40, 2793.20, 40.39), name = 'Mine', color = 70, sprite = 318},
	MineProcessing = {coords = vector3(1109.24, -2007.90, 31.64), name = 'Fonderie', color = 70, sprite = 318},
}