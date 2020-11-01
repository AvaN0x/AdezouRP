local GUI = {} -- don't touch
ESX = nil -- don't touch
GUI.Time = 0 -- don't touch
local stealing = false -- don't touch
local timer = false
local savedDoor = nil
local doorTime = {}
peds = {}
------------------------------------------------------
------------------------------------------------------
local chancePoliceNoti = 70 -- the procent police get notified (only numbers like 30, 10, 40. You get it.)
------------------------------------------------------
------------------------------------------------------

------ l o c a l e s ------
local textUnlock = "~g~[E]~w~ Entrer" -- enter the house
local insideText = "~g~[E]~w~ Sortir" -- exit the door
local searchText = "~g~[E]~w~ Chercher" -- search the spot
local emptyMessage = "Il n'y a rien ici !" -- if you press E where it is empty
local emptyMessage3D = "~r~Vide" -- if the spot is empty
local item = {
  'diamond',
  'gold',
  'bagweed',
  'bagexta',
  'bagcoke',
  'methamphetamine',
  'balisegps',
  'lockpick'
}
local exitPos = {pos = {x = 0, y = 0, z = 0, h = 0 }}
local lastDoor = -1
---------------------------

Citizen.CreateThread(function ()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(1)
  end
end)

RegisterNetEvent('esx_ava_lockpick:onUse')
AddEventHandler('esx_ava_lockpick:onUse', function(xPlayer)
  canLockPick = true
  Citizen.Wait(100)
  canLockPick = false
end)

RegisterNetEvent('avan0x_lockpicking:LockpickingComplete')
AddEventHandler('avan0x_lockpicking:LockpickingComplete', function(result)
  local playerPed   = GetPlayerPed(-1)
  ClearPedTasksImmediately(playerPed)
  if result then
    lockpicking = true
    Citizen.Wait(100)
    lockpicking = false
  end
end)

local burglaryPlaces = {
  {
    pos = { x = 206.4, y = -86.0, z = 69.38, h = 159.15 },
    locked = true, doorTime = {}
  },
  {
    pos = { x = -842.29, y = -25.05, z = 40.4, h = 88.4 },
    locked = true, doorTime = {}
  },
  {
    pos = { x = -947.94, y = 567.71, z = 101.51, h = 159.54 },
    locked = true, doorTime = {}
  },
  {
    pos = { x = -1104.04, y = -1059.98, z = 2.73, h = 207.11 },
    locked = true, doorTime = {}
  },
  {
    pos = { x = -309.54, y = -825.43, z = 32.42, h = 10.11 },
    locked = true, doorTime = {}
  },
  {
    pos = { x = 259.69, y = -783.11, z = 30.50, h = 250.0 },
    locked = true, doorTime = {}
  },
  {
    pos = { x = 363.92, y = -711.99, z = 29.29, h = 248.0 },
    locked = true, doorTime = {}
  },
  {
    pos = { x = 222.59, y = -595.38, z = 43.87, h = 348.0 },
    locked = true, doorTime = {}
  },
  {
    pos = { x = 499.72, y = -651.95, z = 24.90, h = 81.0 },
    locked = true, doorTime = {}
  },
  {
    pos = { x = 224.39, y = -1871.97, z = 26.87, h = 309.0 },
    locked = true, doorTime = {}
  },
  {
    pos = { x = 6.22, y = -1673.38, z = 29.30, h = 32.8 },
    locked = true, doorTime = {}
  },
  {
    pos = { x = 92.61, y = -819.76, z = 31.28, h = 245.96 },
    locked = true, doorTime = {}
  },
  {
    pos = { x = 87.11, y = -834.97, z = 31.06, h = 247.99 },
    locked = true, doorTime = {}
  },
  {
    pos = { x = 156.53, y = -1065.74, z = 30.05, h = 337.67 },
    locked = true, doorTime = {}
  },
  {
    pos = { x = -38.20, y = -1071.71, z = 27.54, h = 338.59 },
    locked = true, doorTime = {}
  }
}

burglaryInsideCoord = { x = 346.52, y = -1013.19, z = -99.2, h = 357.81 }

residents = {
  {
    coord = vec3(349.8, -996.141, -98.7399),
    rotation = 90.0,
    animation = { dict = "amb@lo_res_idles@", anim = "lying_face_up_lo_res_base" }, -- sleeping animation
    model = "a_f_y_hipster_01",
  }
}




local burglaryInside = {
  ["Vous avez trouvé un objet sur la table de la cuisine!"] = { x = 342.23, y = -1003.29, z = -99.0,  amount = 0},
  ["Vous avez trouvé un objet dans le meuble TV!"] = { x = 338.14, y = -997.69,  z = -99.2,  amount = 0},
  ["Vous avez trouvé un objet dans la chambre!"] = { x = 350.91, y = -999.26,  z = -99.2,  amount = 0},
  ["Vous avez trouvé un objet dans la table de chevet de la chambre!"] = { x = 349.19, y = -994.83,  z = -99.2,  amount = 0},
  ["Vous avez trouvé un objet dans la bibliothèque!"] = { x = 345.3,  y = -995.76,  z = -99.2,  amount = 0},
  ["Vous avez trouvé un objet dans la table du couloir!"] = { x = 346.14, y = -1001.55, z = -99.2,  amount = 0},
  ["Vous avez trouvé un objet dans la salle de bain!"] = { x = 347.23, y = -994.09,  z = -99.2,  amount = 0},
  ["Vous avez trouvé un objet dans l'armoire du salon!"] = { x = 339.23, y = -1003.35, z = -99.2,  amount = 0},
  ["Vous avez trouvé un objet dans le placard!"] = { x = 351.24, y = -993.53,  z = -99.2,  amount = 0}
}

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(5)
    for k, v in ipairs(burglaryPlaces) do
      local playerPed = PlayerPedId()
      local house = k
      local coords = GetEntityCoords(playerPed)
      local dist   = GetDistanceBetweenCoords(v.pos.x, v.pos.y, v.pos.z, coords.x, coords.y, coords.z, false)
      if dist <= 2.5 and v.locked == true then
          DrawText3D(v.pos.x, v.pos.y, v.pos.z, 'Porte fragile', 0.4)
          if canLockPick == true then
            TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
            TriggerEvent('avan0x_lockpicking:StartLockPicking')
            canLockPick = false
          end

          if lockpicking == true then
            RemoveResidents()
            savedDoor = v.door
            v.doorTime = GetGameTimer() + 30 * 60 * 1000
            for k_inside, v_inside in pairs(burglaryInside) do
              if v_inside.amount < 1 then
                v_inside.amount = v_inside.amount + 1
              end
            end
            confMenu(house)
            lockpicking = false
          end
      else
        if dist <= 1.2 and timer == true then
          local secsRemaining = math.ceil((v.doorTime - GetGameTimer()) / 1000)
          if secsRemaining > 0 then
            DrawText3D(v.pos.x, v.pos.y, v.pos.z,'Le temps qu\'il faut attendre pour voler à nouveau est de ~r~'..secsRemaining..' seconde(s) ~w~.', 0.4)
          else
            timer = false
            v.locked = true
            doorTime = {}
          end
        end
      end
    end
  end
end)

Citizen.CreateThread(function()
  while stealing == false do
    Citizen.Wait(5)
    for k, v in pairs(burglaryInside) do
      local playerPed = PlayerPedId()
      local coords = GetEntityCoords(playerPed)
      local dist = GetDistanceBetweenCoords(v.x, v.y, v.z, coords.x, coords.y, coords.z, false)
      if dist <= 1.0 and v.amount > 0 then
        DrawText3D(v.x, v.y, v.z, searchText, 0.4)
        if IsControlJustPressed(0, 38) then
          steal(k)
        end
      elseif v.amount < 1 and dist <= 1.0 then
        DrawText3D(v.x, v.y, v.z, emptyMessage3D, 0.4)
        if IsControlJustPressed(0, 38) then
          ESX.ShowHelpNotification(emptyMessage)
        end
      end
    end
  end
end)


Citizen.CreateThread(function()
  while true do
    Citizen.Wait(5)
    for k, v in ipairs(burglaryPlaces) do
      local playerPed = PlayerPedId()
      local coords = GetEntityCoords(playerPed)
      if GetDistanceBetweenCoords(burglaryInsideCoord.x, burglaryInsideCoord.y, burglaryInsideCoord.z, coords.x, coords.y, coords.z, true) <= 3.0 then
        DrawText3D(burglaryInsideCoord.x, burglaryInsideCoord.y, burglaryInsideCoord.z, insideText, 0.4)
        if GetDistanceBetweenCoords(burglaryInsideCoord.x, burglaryInsideCoord.y, burglaryInsideCoord.z, coords.x, coords.y, coords.z, false) <= 1.2 and IsControlJustPressed(0, 38) then
          RemoveResidents()
          fade()
          teleport(exitPos)
          lastDoor = 0
          timer = true
        end
      end
    end
  end
end)


function confMenu(house)
  Citizen.Wait(6)
  RemoveResidents()
  local v = burglaryPlaces[house]
  exitPos = {pos = v.pos}
  SpawnResidents()
  local playerPed = PlayerPedId()
  fade()
  SetCoords(playerPed, burglaryInsideCoord.x, burglaryInsideCoord.y, burglaryInsideCoord.z - 0.98)
  SetEntityHeading(playerPed, burglaryInsideCoord.h)

  v.locked = false
  Citizen.Wait(math.random(5000, 20000))
  local random = math.random(0, 100)
  if random <= chancePoliceNoti then
    callCops()
  end
end

function steal(k)
  local goods = item[math.random(#item)]
  local values = burglaryInside[k]
  local playerPed = PlayerPedId()
  stealing = true
  FreezeEntityPosition(playerPed, true)
  TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
  exports['progressBars']:startUI(3000, "Recherche en cours")
  Citizen.Wait(3000)
  TriggerServerEvent('99kr-burglary:Add', goods, 1)
  ESX.ShowHelpNotification(k)
  values.amount = values.amount - 1
  ClearPedTasksImmediately(playerPed)
  FreezeEntityPosition(playerPed, false)
  stealing = false
end

function ShowSubtitle(text)
  BeginTextCommandPrint("STRING")
  AddTextComponentSubstringPlayerName(text)
  EndTextCommandPrint(3500, 1)
end

function SetCoords(playerPed, x, y, z)
  SetEntityCoords(playerPed, x, y, z)
  Citizen.Wait(100)
  SetEntityCoords(playerPed, x, y, z)
end

function DrawText2d(text, x, y, scale, right, width)
  SetTextFont(0)
  SetTextScale(scale, scale)
  SetTextColour(254, 254, 254, 255)

  if right then
    SetTextWrap(x - width, x)
    SetTextRightJustify(true)
  end

  BeginTextCommandDisplayText("STRING") 
  AddTextComponentSubstringPlayerName(text)
  EndTextCommandDisplayText(x, y)
end

function callCops()
    if savedDoor ~= lastDoor then
      TriggerServerEvent("esx_phone:sendEmergency", "police", "Un cambriolage est suspecté dans cette maison.", true, { ["x"] = exitPos.pos.x, ["y"] = exitPos.pos.y, ["z"] = exitPos.pos.z })
      lastDoor = savedDoor
    end
end

function fade()
  DoScreenFadeOut(1000)
  Citizen.Wait(1000)
  DoScreenFadeIn(1000)
end

function loaddict(dict)
  while not HasAnimDictLoaded(dict) do
    RequestAnimDict(dict)
    Wait(10)
  end
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(6)
    if GetPlayerCurrentStealthNoise(PlayerId()) > 5 then
      if CanPedHearPlayer(PlayerId(), peds[1]) then
        callCops()
        ClearPedTasksImmediately(peds[1])
        Citizen.Wait(5)
        PlayPain(peds[1], 8, 0)
      end
    end
  end
end)

function SpawnResidents()
    RequestModel("a_f_y_hipster_01")
    while not HasModelLoaded("a_f_y_hipster_01") do 
      Wait(0)
    end
    for _,resident in pairs(residents) do
      ped = CreatePed(4, resident.model, resident.coord, resident.rotation, false, false)
      table.insert(peds, ped)
      -- animation
      RequestAnimDict(resident.animation.dict)
      while not HasAnimDictLoaded(resident.animation.dict) do 
        Wait(0)
      end

      TaskPlayAnimAdvanced(ped, resident.animation.dict, resident.animation.anim, resident.coord, 0.0, 0.0, resident.rotation, 8.0, 1.0, -1, 1, 1.0, true, true)
      SetFacialIdleAnimOverride(ped, "mood_sleeping_1", 0)

      SetPedHearingRange(ped, 3.0)
      SetPedSeeingRange(ped, 3.0)
      SetPedAlertness(ped, 1)
  end
end

function RemoveResidents()
  for _,ped in pairs(peds) do
    SetPedAsNoLongerNeeded(ped)
    DeletePed(ped)
  end
  peds = {}
end


function DrawText3D(x, y, z, text, scale)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
  SetTextScale(scale, scale)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextEntry("STRING")
  SetTextCentre(1)
  SetTextColour(255, 255, 255, 255)
  SetTextOutline()
  AddTextComponentString(text)
  DrawText(_x, _y)
  local factor = (string.len(text)) / 270
  DrawRect(_x, _y + 0.015, 0.005 + factor, 0.03, 31, 31, 31, 155)
end

function teleport(confMenu)
  local playerPed = PlayerPedId()
  SetCoords(playerPed, confMenu.pos.x, confMenu.pos.y, confMenu.pos.z - 0.98)
  SetEntityHeading(playerPed, confMenu.pos.h)
  DoingBreak = false
end


RegisterNetEvent('99kr-burglary:Sound')
AddEventHandler('99kr-burglary:Sound', function(sound1, sound2)
  PlaySoundFrontend(-1, sound1, sound2)
end)

--------------  Pawn Shop ---------------------------
function hintToDisplay(text)
  SetTextComponentFormat("STRING")
  AddTextComponentString(text)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
