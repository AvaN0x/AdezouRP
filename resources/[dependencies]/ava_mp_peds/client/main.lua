-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local localSkin = {}
local localPlayerSkinSave = nil
local NumHairColors<const> = GetNumHairColors()

local Categories = {
    gender = {
        components = {"gender"},
        setPed = function(ped)
            local model<const> = localSkin.gender == 0 and GetHashKey("mp_m_freemode_01") or GetHashKey("mp_f_freemode_01")

            if model ~= GetEntityModel(ped) and IsModelValid(model) and IsModelInCdimage(model) then
                local p = promise.new()
                Citizen.CreateThread(function()
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Wait(0)
                    end

                    SetPlayerModel(PlayerId(), model)
                    ped = PlayerPedId()

                    SetModelAsNoLongerNeeded(model)

                    p:resolve()
                end)
                Citizen.Await(p)
            end
            SetPedDefaultComponentVariation(ped)
            ClearPedProp(ped, 0)
        end,
        -- updateMax = function()

        -- end,
    },
}

-- Init local skin to default values
for element, value in pairs(AVAConfig.skinComponents) do
    localSkin[element] = value.default or value.min
end
