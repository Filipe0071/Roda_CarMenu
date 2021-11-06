local isOpened = false

RegisterCommand(Config.Command, function()
  if not isOpened then
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		SetNuiFocus(true, true)
		SendNUIMessage({
		  action = "open",
		  engine = GetVehicleBodyHealth(vehicle)/10,
		  fuel = GetVehicleFuelLevel(vehicle),
		  carname = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)),
		  plate = GetVehicleNumberPlateText(vehicle)
		})
		isOpened = true
	else
        SetNuiFocus(false, false)
        SendNUIMessage({
          action = "error",
          msg = Config.MessageError
        })
	end
  else
    SetNuiFocus(false, false)
    SendNUIMessage({
      action = "close"
    })
    isOpened = false
  end
end)

if Config.UseKey then 
    RegisterKeyMapping(Config.Command, 'Open Car Menu', 'keyboard', Config.KeyBind)
end


-----------------------------------------------------------------------------
-- CALLBACKS
-----------------------------------------------------------------------------

RegisterNUICallback("exit" , function()
  	SetNuiFocus(false, false)
  	isOpened = false
end)

RegisterNUICallback('motor', function(data, cb)
	EngineControl()
end)

RegisterNUICallback('openDoor', function(data, cb)
    doorIndex = tonumber(data['doorIndex'])
    player = PlayerPedId()
    veh = GetVehiclePedIsIn(player, false)

    if veh ~= 0 then
        local lockStatus = GetVehicleDoorLockStatus(veh)
        if lockStatus == 1 or lockStatus == 0 then
            if (GetVehicleDoorAngleRatio(veh, doorIndex) == 0) then
                SetVehicleDoorOpen(veh, doorIndex, false, false)
            else
                SetVehicleDoorShut(veh, doorIndex, false)
            end
        end
    end
    cb('ok')
end)


RegisterNUICallback('togglewindow', function(data, cb)
    windowIndex = tonumber(data['windowIndex'])
    player = PlayerPedId()
    veh = GetVehiclePedIsIn(player, false)
    if veh ~= 0 then
        if not IsVehicleWindowIntact(veh, windowIndex) then
            RollUpWindow(veh, windowIndex)
            if not IsVehicleWindowIntact(veh, windowIndex) then
                RollDownWindow(veh, windowIndex)
            end
        else
            RollDownWindow(veh, windowIndex)
        end
    end
    cb('ok')
end)


RegisterNUICallback('switchSeat', function(data, cb)
    seatIndex = tonumber(data['seatIndex'])
    player = PlayerPedId()
    veh = GetVehiclePedIsIn(player, false)
    if veh ~= 0 then
        SetPedIntoVehicle(player, veh, seatIndex)
    end
    cb('ok')
end)


RegisterNUICallback("vehdoorlock" , function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

	if GetVehicleDoorLockStatus(vehicle) == 1 then --*Kilitleme  
		SetVehicleDoorsLocked(vehicle, 2)
		PlayVehicleDoorCloseSound(vehicle, 1)
		SetVehicleDoorShut(vehicle, 0, false)
		SetVehicleDoorShut(vehicle, 1, false)
		SetVehicleDoorShut(vehicle, 2, false)
		SetVehicleDoorShut(vehicle, 3, false)
		SetVehicleLights(vehicle, 2)
		Citizen.Wait(150)
		SetVehicleLights(vehicle, 0)
		Citizen.Wait(150)
		SetVehicleLights(vehicle, 2)
		Citizen.Wait(150)
		SetVehicleLights(vehicle, 0)
	elseif GetVehicleDoorLockStatus(vehicle) == 2 then --*Acma
		SetVehicleDoorsLocked(vehicle, 1)
		PlayVehicleDoorOpenSound(vehicle, 0)
		SetVehicleLights(vehicle, 2)
		Citizen.Wait(150)
		SetVehicleLights(vehicle, 0)
		Citizen.Wait(150)
		SetVehicleLights(vehicle, 2)
		Citizen.Wait(150)
		SetVehicleLights(vehicle, 0)
	end
end)

--------------
-- FUNCTIONS--
--------------

function EngineControl()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh ~= nil and veh ~= 0 and GetPedInVehicleSeat(veh, 0) then
        SetVehicleEngineOn(veh, (not GetIsVehicleEngineRunning(veh)), false, true)
    end
end
