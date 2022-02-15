-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
-- #region sell vehicle
function OpenSellZoneMenu()
    local sellZone = Config.Stores[CurrentZoneName]
    print("sellZone")
    -- TODO open confirmation message with price
    -- exports.ava_core:ShowConfirmationMessage -- "Do you want to sell this vehicle for X$?"
    -- exports.ava_core:ShowConfirmationMessage -- "Are you sure you want to sell this vehicle for X$?"
end
-- #endregion sell vehicle

-- #region vehicleshop
function OpenVehicleShopMenu()
    local shop = Config.Stores[CurrentZoneName]
    print("shop")

end
-- #endregion vehicleshop
