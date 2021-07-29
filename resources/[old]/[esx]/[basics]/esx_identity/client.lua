--=========================================
--==== ESX_IDENTITY BY ARKSEYONET @Ark ====
--========== MODIFIED BY AvaN0x ===========
--========== github.com/AvaN0x ============
--=========================================

--===============================================
--==                 VARIABLES                 ==
--===============================================
local guiEnabled = false
local myIdentity = {}

--===============================================
--==                 VARIABLES                 ==
--===============================================
function EnableGui(enable)
    SetNuiFocus(enable)
    guiEnabled = enable

    SendNUIMessage({
        type = "enableui",
        enable = enable
    })
end

function openRegistry()
    TriggerEvent('esx_identity:showRegisterIdentity')
end

--===============================================
--==           Show Registration               ==
--===============================================
RegisterNetEvent("esx_identity:showRegisterIdentity")
AddEventHandler("esx_identity:showRegisterIdentity", function()
    EnableGui(true)
end)

--===============================================
--==              Close GUI                    ==
--===============================================
RegisterNUICallback('escape', function(data, cb)
    EnableGui(false)
end)

--===============================================
--==           Register Callback               ==
--===============================================
RegisterNUICallback('register', function(data, cb)
    myIdentity = data
    TriggerServerEvent('esx_identity:setIdentity', data)
    EnableGui(false)
    Wait (500)
    TriggerEvent('esx_skin:openSaveableMenu')
end)



--===============================================
--==                 THREADING                 ==
--===============================================
Citizen.CreateThread(function()
    while true do
        if guiEnabled then
            DisableControlAction(0, 1, guiEnabled) -- LookLeftRight
            DisableControlAction(0, 2, guiEnabled) -- LookUpDown

            DisableControlAction(0, 142, guiEnabled) -- MeleeAttackAlternate
            DisableControlAction(0, 18, guiEnabled) -- Enter
            DisableControlAction(0, 322, guiEnabled) -- ESC
            DisableControlAction(0, 106, guiEnabled) -- VehicleMouseControlOverride

            if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
                SendNUIMessage({
                    type = "click"
                })
            end
        end
        Citizen.Wait(0)
    end
end)
