-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

function IsVehicleElectric(vehicle)
    return not not AVAConfig.ElectricCars[GetEntityModel(vehicle)]
end

exports("IsVehicleElectric", IsVehicleElectric)
