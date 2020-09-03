Config = {}

Config.Locale = 'fr'

Config.DrawTextDist = 1.0 -- LAISSER A 1

Config.Delays = {
	WeedProcessing = 1000 * 10,
	CokeProcessing = 1000 * 15,
	MethProcessing = 1000 * 10,
	ExtaProcessing = 1000 * 5,
	ExtapProcessing = 1000 * 5,	
}



Config.ChemicalsLicenseEnabled = false --Will Enable or Disable the need for a Chemicals License.
Config.MoneyWashLicenseEnabled = false --Will Enable or Disable the need for a MoneyWash License.

Config.CircleZones = {
	--Weed
	WeedField = {coords = vector3(3824.07, 4429.46, 3.0), name = _U('blip_WeedFarm'), color = 25, sprite = 496, radius = 100.0, price = 30000},
	WeedProcessing = {coords = vector3(859.08, 2877.4, 57.98), name = _U('blip_weedprocessing'), color = 25, sprite = 496, radius = 100.0, price = 40000},

	--Coke
	CokeField = {coords = vector3(-294.48, 2524.97, 74.62), name = _U('blip_CokeFarm'), color = 25, sprite = 496, radius = 20.0, price = 30000},
	CokeProcessing = {coords = vector3(1019.13, -2511.48, 28.48), name = _U('blip_Cokeprocessing'),color = 25, sprite = 496, radius = 20.0, price = 40000},
	CokeProcessing2 = {coords = vector3(1017.72, -2529.39, 28.3), name = _U('blip_Cokeprocessing2'),color = 25, sprite = 496, radius = 20.0, price = 40000},

	--meth
	MethylaField = {coords = vector3(1595.49, -1702.09, 88.12), name = _U('blip_methylaFarm'), color = 25, sprite = 496, radius = 0.0, price = 30000},
	PseudoField = {coords = vector3(1762.37, -1654.8, 112.68), name = _U('blip_pseudoFarm'), color = 25, sprite = 496, radius = 0.0, price = 30000},
	MethaField = {coords = vector3(1112.49, -2299.49, 30.5), name = _U('blip_methaFarm'), color = 25, sprite = 496, radius = 0.0, price = 30000},
	MethProcessing = {coords = vector3(1390.33, 3608.5, 38.94), name = _U('blip_methprocessing'), color = 25, sprite = 496, radius = 0.0, price = 40000},

	--Extazy
	MdmaField = {coords = vector3(-1063.23, -1113.14, 2.16), name = _U('blip_mdmalFarm'), color = 25, sprite = 496, radius = 0.0, price = 30000},
	AmphetField = {coords = vector3(177.98, 306.6, 105.37), name = _U('blip_amphetFarm'), color = 25, sprite = 496, radius = 0.0, price = 30000},
	ExtapProcessing = {coords = vector3(1983.23, 3026.61, 47.69), name = _U('blip_methprocessing'), color = 25, sprite = 496, radius = 0.0, price = 40000}, -- prix pas utilisé car trop proche du second
	ExtaProcessing = {coords = vector3(1984.5, 3054.88, 47.22), name = _U('blip_methprocessing'), color = 25, sprite = 496, radius = 0.0, price = 40000},






	
	--Chemicals
	--ChemicalsField = {coords = vector3(817.46, -3192.84, 5.9), name = _U('blip_ChemicalsFarm'), color = 25, sprite = 496, radius = 0.0},
	--ChemicalsConvertionMenu = {coords = vector3(3718.8, 4533.45, 21.67), name = _U('blip_ChemicalsProcessing'), color = 25, sprite = 496, radius = 0.0},
	
	--LSD
	--lsdProcessing = {coords = vector3(91.26, 3749.31, 40.77), name = _U('blip_lsdprocessing'),color = 25, sprite = 496, radius = 20.0},
	--thionylchlorideProcessing = {coords = vector3(1903.98, 4922.70, 48.16), name = _U('blip_lsdprocessing'),color = 25, sprite = 496, radius = 20.0},
	
	--Heroin
	--HeroinField = {coords = vector3(16.34, 6875.94, 12.64), name = _U('blip_heroinfield'), color = 25, sprite = 496, radius = 20},
	--HeroinProcessing = {coords = vector3(-65.43, 6243.36, 31.08), name = _U('blip_heroinprocessing'), color = 25, sprite = 496, radius = 100.0},

	--DrugDealer
	--DrugDealer = {coords = vector3(-1115.0523, -1593.569, 3.57), name = _U('blip_drugdealer'), color = 6, sprite = 378, radius = 25.0},
	
}
