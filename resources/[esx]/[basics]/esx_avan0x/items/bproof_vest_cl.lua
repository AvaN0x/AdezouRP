-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

local bproofOn = false

RegisterNetEvent('esx_avan0x:bproof_vest')
AddEventHandler('esx_avan0x:bproof_vest', function()
    local playerPed = PlayerPedId()
    if not bproofOn then
        bproofOn = true

        if not IsEntityPlayingAnim(playerPed, 'mini@repair', 'fixing_a_player', 3) then
            ESX.Streaming.RequestAnimDict('mini@repair', function()
                TaskPlayAnim(playerPed, 'mini@repair', 'fixing_a_player', 8.0, -8, -1, 49, 0, 0, 0, 0)
            end)
        end

        exports['progressBars']:startUI((2000), "Mets le gilet")
        Citizen.Wait(2000)
        ClearPedSecondaryTask(playerPed)

        SetPedArmour(playerPed, 100)
        TriggerEvent('skinchanger:getSkin', function(skin)
            if skin.sex == 0 then -- male
                TriggerEvent('skinchanger:loadClothes', skin, {['bproof_1'] = 12,  ['bproof_2'] = 3})
            else
                TriggerEvent('skinchanger:loadClothes', skin, {['bproof_1'] = 11,  ['bproof_2'] = 3})
            end
        end)

        ESX.ShowNotification("Vous avez équipé un gilet")

        Citizen.CreateThread(function()
            while bproofOn do
                Citizen.Wait(500)
                if GetPedArmour(playerPed) == 0 then
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        TriggerEvent('skinchanger:loadClothes', skin, {['bproof_1'] = 0,  ['bproof_2'] = 0})
                    end)
                    TriggerServerEvent("esx_avan0x:removeBProofVest")
                    bproofOn = false
                end
            end
        end)
    else
        bproofOn = false

        if not IsEntityPlayingAnim(playerPed, 'mini@repair', 'fixing_a_player', 3) then
            ESX.Streaming.RequestAnimDict('mini@repair', function()
                TaskPlayAnim(playerPed, 'mini@repair', 'fixing_a_player', 8.0, -8, -1, 49, 0, 0, 0, 0)
            end)
        end

        exports['progressBars']:startUI((2000), "Enlève le gilet")
        Citizen.Wait(2000)
        ClearPedSecondaryTask(playerPed)

        SetPedArmour(playerPed, 0)
        TriggerEvent('skinchanger:getSkin', function(skin)
            TriggerEvent('skinchanger:loadClothes', skin, {['bproof_1'] = 0,  ['bproof_2'] = 0})
        end)

        ESX.ShowNotification("Vous avez enlevé un gilet")

    end
end)





-- elseif action == "kevlar_add" then

--     if not IsEntityPlayingAnim(GetPlayerPed(-1), 'mini@repair', 'fixing_a_player', 3) then
--         ESX.Streaming.RequestAnimDict('mini@repair', function()
--             TaskPlayAnim(GetPlayerPed(-1), 'mini@repair', 'fixing_a_player', 8.0, -8, -1, 49, 0, 0, 0, 0)
--         end)
--     end
--     exports['progressBars']:startUI((2000), "Mets le gilet")
--     Citizen.Wait(2000)
--     ClearPedSecondaryTask(GetPlayerPed(-1))

--     SetPedArmour(GetPlayerPed(-1), 100)
--     TriggerEvent('skinchanger:getSkin', function(skin)
--         if skin.sex == 0 then -- male
--             TriggerEvent('skinchanger:loadClothes', skin, {['bproof_1'] = 12,  ['bproof_2'] = 3})
--         else
--             TriggerEvent('skinchanger:loadClothes', skin, {['bproof_1'] = 11,  ['bproof_2'] = 3})
--         end
--     end)

--     ESX.ShowNotification("Vous avez équipé un gilet")


-- elseif action == "kevlar_supp" then

--     if not IsEntityPlayingAnim(GetPlayerPed(-1), 'mini@repair', 'fixing_a_player', 3) then
--         ESX.Streaming.RequestAnimDict('mini@repair', function()
--             TaskPlayAnim(GetPlayerPed(-1), 'mini@repair', 'fixing_a_player', 8.0, -8, -1, 49, 0, 0, 0, 0)
--         end)
--     end		
--     exports['progressBars']:startUI((2000), "Enlève le gilet")
--     Citizen.Wait(2000)
--     ClearPedSecondaryTask(GetPlayerPed(-1))
    
--     SetPedArmour(GetPlayerPed(-1), 0)
--     TriggerEvent('skinchanger:getSkin', function(skin)
--         TriggerEvent('skinchanger:loadClothes', skin, {['bproof_1'] = 0,  ['bproof_2'] = 0})
--     end)
--     ESX.ShowNotification("Vous avez enlevé un gilet")