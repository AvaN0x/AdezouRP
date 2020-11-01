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
    pos = {x = 87.046157836914, y = -834.94946289063, z = 31.049072265625, h = 69.448822021484},
    locked = true, doorTime = {}
  },
  {
      pos = {x = 92.637367248535, y = -819.78460693359, z = 31.285034179688, h = 66.614181518555},
      locked = true, doorTime = {}
  },
  {
      pos = {x = 109.4373626709, y = -1090.6021728516, z = 29.296752929688, h = 341.57479858398},
      locked = true, doorTime = {}
  },
  {
      pos = {x = 291.53405761719, y = -1078.6417236328, z = 29.397827148438, h = 273.54330444336},
      locked = true, doorTime = {}
  },
  {
      pos = {x = 996.90991210938, y = -729.62634277344, z = 57.806640625, h = 307.55905151367},
      locked = true, doorTime = {}
  },
  {
      pos = {x = 979.23956298828, y = -716.20220947266, z = 58.2109375, h = 304.72439575195},
      locked = true, doorTime = {}
  },
  {
      pos = {x = 970.87915039063, y = -701.48571777344, z = 58.480590820313, h = 350.07873535156},
      locked = true, doorTime = {}
  },
  {
      pos = {x = 959.80218505859, y = -669.79779052734, z = 58.446899414063, h = 299.0551071167},
      locked = true, doorTime = {}
  },
  {
      pos = {x = 943.25274658203, y = -653.34063720703, z = 58.463745117188, h = 219.68503570557},
      locked = true, doorTime = {}
  },
  {
      pos = {x = 928.68133544922, y = -639.70550537109, z = 58.227783203125, h = 316.06298828125},
      locked = true, doorTime = {}
  },
  {
      pos = {x = 902.99340820313, y = -615.53405761719, z = 58.446899414063, h = 225.35432815552},
      locked = true, doorTime = {}
  },
  {
      pos = {x = 886.82635498047, y = -608.26812744141, z = 58.430053710938, h = 313.22833251953},
      locked = true, doorTime = {}
  },
  {
      pos = {x = 861.58679199219, y = -583.56921386719, z = 58.1435546875, h = 341.57479858398},
      locked = true, doorTime = {}
  },
  {
      pos = {x = 843.9560546875, y = -562.66815185547, z = 57.991943359375, h = 185.66929101944},
      locked = true, doorTime = {}
  },
  {
      pos = {x = 850.27252197266, y = -532.61535644531, z = 57.924560546875, h = 262.20472717285},
      locked = true, doorTime = {}
  },
  {
      pos = {x = 861.49450683594, y = -509.06372070313, z = 57.705444335938, h = 225.35432815552},
      locked = true, doorTime = {}
  },
  {
      pos = {x = 878.29449462891, y = -498.03955078125, z = 58.076171875, h = 225.35432815552},
      locked = true, doorTime = {}
  },
  {
      pos = {x = 906.13189697266, y = -489.46813964844, z = 59.424194335938, h = 199.84251785278},
      locked = true, doorTime = {}
  },
  {
      pos = {x = 921.876953125, y = -477.75823974609, z = 61.075439453125, h = 197.00787353516},
      locked = true, doorTime = {}
  },
  {
      pos = {x = 944.43957519531, y = -463.21319580078, z = 61.547241210938, h = 128.97637939453},
      locked = true, doorTime = {}
  },
  {
      pos = {x = 967.22637939453, y = -451.51647949219, z = 62.77734375, h = 208.34645462036},
      locked = true, doorTime = {}
  },
  {
      pos = {x = 987.58679199219, y = -433.02856445313, z = 64.00732421875, h = 199.84251785278},
      locked = true, doorTime = {}
  },
  {
      pos = {x = 1010.5054931641, y = -423.57363891602, z = 65.338500976563, h = 301.88976287842},
      locked = true, doorTime = {}
  },
  {
      pos = {x = 1028.7561035156, y = -408.38241577148, z = 66.332641601563, h = 216.85039138794},
      locked = true, doorTime = {}
  },
  {
      pos = {x = 1060.4439697266, y = -378.27691650391, z = 68.2197265625, h = 205.51181030273},
      locked = true, doorTime = {}
  },
  {
    pos = {x = 1056.2637939453, y = -448.93185424805, z = 66.248291015625, h = 344.4094543457},
    locked = true, doorTime = {}
  },
  {
      pos = {x = 1098.5802001953, y = -464.47912597656, z = 67.309936523438, h = 168.6614074707},
      locked = true, doorTime = {}
  },
  {
      pos = {x = 1090.4571533203, y = -484.24615478516, z = 65.658569335938, h = 63.779525756836},
      locked = true, doorTime = {}
  },
  {
      pos = {x = 1046.2550048828, y = -498.15823364258, z = 64.276977539063, h = 341.57479858398},
      locked = true, doorTime = {}
  },
  {
      pos = {x = -3089.2746582031, y = 221.06373596191, z = 14.114990234375, h = 321.7322845459},
      locked = true, doorTime = {}
  },
  {
      pos = {x = -3105.3098144531, y = 246.46154785156, z = 12.480590820313, h = 282.04724121094},
      locked = true, doorTime = {}
  },
  {
      pos = {x = -3093.71875, y = 349.60879516602, z = 7.5435791015625, h = 256.5354309082},
      locked = true, doorTime = {}
  },
  {
      pos = {x = -3091.4504394531, y = 379.39779663086, z = 7.10546875, h = 253.70078277588},
      locked = true, doorTime = {}
  },
  {
      pos = {x = -3039.560546875, y = 493.06814575195, z = 6.7685546875, h = 276.37794494629},
      locked = true, doorTime = {}
  },
  {
      pos = {x = -3029.9604492188, y = 568.61535644531, z = 7.813232421875, h = 259.37007141113},
      locked = true, doorTime = {}
  },
  {
      pos = {x = -2977.0153808594, y = 609.25714111328, z = 20.2314453125, h = 103.4645690918},
      locked = true, doorTime = {}
  },
  {
      pos = {x = -2972.6506347656, y = 642.72528076172, z = 25.977294921875, h = 103.4645690918},
      locked = true, doorTime = {}
  },
  {
      pos = {x = -2994.6066894531, y = 683.03735351563, z = 25.03369140625, h = 106.29922485352},
      locked = true, doorTime = {}
  },
  {
      pos = {x = -2993.1428222656, y = 707.49890136719, z = 28.673217773438, h = 199.84251785278},
      locked = true, doorTime = {}
  },
  {
      pos = {x = -3017.1823730469, y = 746.58459472656, z = 27.695922851563, h = 106.29922485352},
      locked = true, doorTime = {}
  },
  {
      pos = {x = -3229.0417480469, y = 927.30987548828, z = 13.96337890625, h = 296.22047424316},
      locked = true, doorTime = {}
  },
  {
      pos = {x = -3238.3647460938, y = 952.60217285156, z = 13.323120117188, h = 273.54330444336},
      locked = true, doorTime = {}
  },
  {
      pos = {x = -3251.2614746094, y = 1027.3582763672, z = 11.756103515625, h = 262.20472717285},
      locked = true, doorTime = {}
  },
  {
      pos = {x = -3232.8527832031, y = 1068.1450195313, z = 11.031494140625, h = 253.70078277588},
      locked = true, doorTime = {}
  },
  {
      pos = {x = -3232.2065429688, y = 1081.4769287109, z = 10.795654296875, h = 214.01574707031},
      locked = true, doorTime = {}
  },
  {
      pos = {x = -3200.2548828125, y = 1165.859375, z = 9.6497802734375, h = 253.70078277588},
      locked = true, doorTime = {}
  },
  {
      pos = {x = -3190.9846191406, y = 1297.75390625, z = 19.06884765625, h = 245.1968536377},
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
