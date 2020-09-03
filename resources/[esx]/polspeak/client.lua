_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("PolSpeak", "~b~POLICE MEGAPHONE")
_menuPool:Add(mainMenu)

function AddMenuAnotherMenu(menu)
    local submenu = _menuPool:AddSubMenu(menu, "Stop the vehicle »", "Various stop vehicle commands")
    local shout1 = NativeUI.CreateItem("LSPD! Stop...", "LSPD! Stop your vehicle now!")
    local shout2 = NativeUI.CreateItem("Driver! Stop...", "Driver! Stop your vehicle")
    local shout3 = NativeUI.CreateItem("Stop the fucking car...", "This is the LSPD! Stop the fucking car immediately!")
    local shout4 = NativeUI.CreateItem("Stop or executed...", "LSPD! Stop your vehicle now or you'll be executed!")
    local shout5 = NativeUI.CreateItem("Stop or I kill ya...", "Stop your vehicle right fucking now! Or I swear I am going to kill ya!")
	
    submenu:AddItem(shout1)
    submenu:AddItem(shout2)
    submenu:AddItem(shout3)
    submenu:AddItem(shout4)
    submenu:AddItem(shout5)
	
    submenu.OnItemSelect = function(sender, item, index)
    if item == shout1 then
      TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 30.0, "stop_vehicle", 0.6)
    end
    if item == shout2 then
      TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 30.0, "stop_vehicle-2", 0.6)
    end
    if item == shout3 then
      TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 30.0, "stop_the_f_car", 0.6)
    end
    if item == shout4 then
      TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 30.0, "stop_or_executed", 0.6)
    end
    if item == shout5 then
      TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 30.0, "stop_or_i_kill", 0.6)
    end
    end	
end

function Stop(menu)
    local submenu4 = _menuPool:AddSubMenu(menu, "Stop »", "Various stop commands")
    local shout1 = NativeUI.CreateItem("Dont make me...", "Stop! Don't make me shoot ya! Give yourself up!")
    local shout2 = NativeUI.CreateItem("Dont move a muscle...", "Stop and dont move a muscle, or you'll be shot by the LSPD!")
    local shout3 = NativeUI.CreateItem("Give yourself up...", "LSPD! If you give yourself up I'll be a lot nicer shithead!")
    local shout4 = NativeUI.CreateItem("Stay right there...", "LSPD! Stay right there and don't move, fucker!")
    local shout5 = NativeUI.CreateItem("Freeze...", "Freeze! LSPD!")

    submenu4:AddItem(shout1)
    submenu4:AddItem(shout2)
    submenu4:AddItem(shout3)
    submenu4:AddItem(shout4)
    submenu4:AddItem(shout5)

    submenu4.OnItemSelect = function(sender, item, index)
    if item == shout1 then
      TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 30.0, "dont_make_me", 0.6)
    end	
    if item == shout2 then
      TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 30.0, "stop_dont_move", 0.6)
    end
    if item == shout3 then
      TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 30.0, "give_yourself_up", 0.6)
    end	
    if item == shout4 then
      TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 30.0, "stay_right_there", 0.6)
    end	
    if item == shout5 then
      TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 30.0, "freeze_lspd", 0.6)
    end			
    end	
end


function Clear(menu)
    local submenu2 = _menuPool:AddSubMenu(menu, "Clear area »", "Clear the area")
    local shout1 = NativeUI.CreateItem("Clear the area...", "This is the LSPD! Clear the area. Now!")
    local shout2 = NativeUI.CreateItem("Go away now...", "This is the LSPD! Go away now or there will be trouble.")
    local shout3 = NativeUI.CreateItem("Move along people...", "Move along people. We don't want trouble.")
    local shout4 = NativeUI.CreateItem("Get out of here...", "Get out of here now. This is the LSPD.")
    local shout5 = NativeUI.CreateItem("Disperse now...", "This is the LSPD! Disperse, now!")

    submenu2:AddItem(shout1)
    submenu2:AddItem(shout2)
    submenu2:AddItem(shout3)
    submenu2:AddItem(shout4)
    submenu2:AddItem(shout5)

    submenu2.OnItemSelect = function(sender, item, index)
    if item == shout1 then
      TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 30.0, "clear_the_area", 0.6)
    end		
    if item == shout2 then
      TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 30.0, "this_is_the_lspd", 0.6)
    end	
    if item == shout3 then
      TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 30.0, "move_along_people", 0.6)
    end	
    if item == shout4 then
      TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 30.0, "get_out_of_here_now", 0.6)
    end	
    if item == shout5 then
      TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 30.0, "disperse_now", 0.6)
    end	
    end	
end


function Insults(menu)
    local submenu3 = _menuPool:AddSubMenu(menu, "Insults »", "Various insults")
    local shout1 = NativeUI.CreateItem("It's over...", "It's over for you! This is the police!")
    local shout2 = NativeUI.CreateItem("You are finished..", "You are finished dickhead! Stop!")
    local shout3 = NativeUI.CreateItem("You can't hide boy..", "You can't hide boy. We will track you down!")
    local shout4 = NativeUI.CreateItem("Drop a missile..", "Can't we just drop a missile on this moron?!")
    local shout5 = NativeUI.CreateItem("Shoot to kill..", "This is the LSPD! I'm gonna shoot to kill!")

    submenu3:AddItem(shout1)
    submenu3:AddItem(shout2)
    submenu3:AddItem(shout3)
    submenu3:AddItem(shout4)
    submenu3:AddItem(shout5)

    submenu3.OnItemSelect = function(sender, item, index)	
    if item == shout1 then
      TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 30.0, "its_over_for_you", 0.6)
    end	
    if item == shout2 then
      TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 30.0, "you_are_finished_dhead", 0.6)
    end	
    if item == shout3 then
      TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 30.0, "cant_hide_boi", 0.6)
    end	
    if item == shout4 then
      TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 30.0, "drop_a_missile", 0.6)
    end
    if item == shout5 then
      TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 30.0, "shoot_to_kill", 0.6)
    end		
    end	
end

function vehicleType(using)
  local cars = Config.Vehicles
  for i=1, #cars, 1 do
    if IsVehicleModel(using, GetHashKey(cars[i])) then
      return true
    end
  end
end

AddMenuAnotherMenu(mainMenu)
Stop(mainMenu)
Clear(mainMenu)
Insults(mainMenu)

_menuPool:RefreshIndex()
_menuPool:MouseControlsEnabled(false)
_menuPool:ControlDisablingEnabled(false)

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(0)
      _menuPool:ProcessMenus()

        if IsControlJustPressed(1, 288) then
          if vehicleType(GetVehiclePedIsUsing(GetPlayerPed(-1))) then
            mainMenu:Visible(not mainMenu:Visible())
          else
           ShowNotification("You are ~r~not in a vehicle ~w~equipped with a megaphone")
          end
        end
    end
end)


function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end