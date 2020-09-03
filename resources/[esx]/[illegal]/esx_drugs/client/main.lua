Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)


-- INFOS


function DrawMissionText(msg, time)
	ClearPrints()
	SetTextEntry_2('STRING')
	AddTextComponentString(msg)
	DrawSubtitleTimed(time, 1)
end

function KnockDoor(door)
	local plyPed = PlayerPedId()
	TaskGoStraightToCoord(plyPed, door.x, door.y, door.z, 10.0, 10, door.w, 0.5)
	Wait(1000)
	ClearPedTasksImmediately(plyPed)

	while not HasAnimDictLoaded("timetable@jimmy@doorknock@") do 
		RequestAnimDict("timetable@jimmy@doorknock@")
		Citizen.Wait(0)
	end
	TaskPlayAnim(plyPed, "timetable@jimmy@doorknock@", "knockdoor_idle", 8.0, 8.0, -1, 4, 0, 0, 0, 0 )     
	Citizen.Wait(0)
	while IsEntityPlayingAnim(plyPed, "timetable@jimmy@doorknock@", "knockdoor_idle", 3) do 
		Citizen.Wait(0)
	end    

	ClearPedTasksImmediately(plyPed)

end

function BuyField(location, price)
	ESX.TriggerServerCallback('asEnoughMoney', function(enoughMoney)
		if enoughMoney then
			SetBlipAndNotif(location)
		else
			ESX.ShowNotification("T'as cru j'étais ta salope? Reviens quand tu auras de l'argent")
		end
	end, price)
end

function BuyProcess(location, price)
	ESX.TriggerServerCallback('asEnoughMoney', function(enoughMoney)
		if enoughMoney then

		SetBlipAndNotif(location)
		ESX.ShowAdvancedNotification(
			'Gars de la street', 
			'', 
			"Yo man si tu veux voir la suite, t'auras besoin de ~y~oim~s~", 'CHAR_DEFAULT', 1)
		else
			ESX.ShowNotification("T'as cru j'étais ta salope? Reviens quand tu auras de l'argent")
		end
	end, price)
end

function SetBlipAndNotif(location)
	local newLocation = {x = (location.x + math.random(-150,150)), y = (location.y + math.random(-150,150)), z = location.z}
	local nearStreet = GetStreetNameFromHashKey(GetStreetNameAtCoord(newLocation.x, newLocation.y, newLocation.z))

	zoneBlip = AddBlipForRadius(newLocation.x, newLocation.y, newLocation.z, 400.0)
		SetBlipSprite(zoneBlip,9)
		SetBlipColour(zoneBlip,1)
		SetBlipAlpha(zoneBlip,95)

	DrawMissionText("Tu trouveras ce que tu cherches près de ~y~"..nearStreet.."~s~.", 5000)
end