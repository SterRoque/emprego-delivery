local npc = nil
local npcCoords = vector3(94.0, 285.50, 110.21)
local inService = false
local markerVehicle = vector3(106.36, 301.69, 110.02)
local vehicle = nil
local prop = nil

CreateThread(function()
  local npcModel = GetHashKey("a_m_y_smartcaspat_01")

  RequestModel(npcModel)
  while not HasModelLoaded(npcModel) do
    Wait(0)
  end

  npc = CreatePed(4, npcModel, npcCoords.x, npcCoords.y, npcCoords.z - 1.0, -105.0, true, true)

  SetEntityInvincible(npc, true)
  SetBlockingOfNonTemporaryEvents(npc, true)
  FreezeEntityPosition(npc, true)

  SetPedRandomComponentVariation(npc, 0)

  SetPedComponentVariation(npc, 0, 0, 0, 2)
  SetPedComponentVariation(npc, 2, 0, 0, 2)
  SetPedComponentVariation(npc, 3, 0, 0, 2)
  SetPedComponentVariation(npc, 4, 0, 0, 2)
  SetPedComponentVariation(npc, 6, 0, 0, 2)

  SetModelAsNoLongerNeeded(npcModel)
end)

CreateThread(function()
  while true do
    local sleep = 1000
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    local distance = #(playerCoords - npcCoords)

    if distance < 5.0 then
      sleep = 0

      DrawText3D(npcCoords.x, npcCoords.y, npcCoords.z + 1.0, "E Emprego")

      if IsControlJustPressed(0, 38) then
        SetNuiFocus(true, true)
        SendNUIMessage({
          action = "openUI"
        })
      end
    end
    Wait(sleep)
  end
end)

CreateThread(function()
  while true do
    Wait(0)
    if inService then
      local distance = #(GetEntityCoords(PlayerPedId()) - markerVehicle)
      if distance < 5.0 then
        DrawText3D(markerVehicle.x, markerVehicle.y, markerVehicle.z + 1.0, "E Veiculo")
      end
      DrawMarker(36, markerVehicle.x, markerVehicle.y, markerVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255,
        0, 0, 150, true, true, 2, true, nil, nil, false)
    end
  end
end)

RegisterKeyMapping('spawnDeliveryVehicle', 'Spawnar Veiculo Delivery', 'keyboard', 'E')
RegisterCommand('spawnDeliveryVehicle', function()
  if inService then
    local distance = #(GetEntityCoords(PlayerPedId()) - markerVehicle)
    if distance < 5.0 and not DoesEntityExist(vehicle) then
      local vehicleModel = GetHashKey("faggio")
      local propBag = GetHashKey("v_club_vu_djbag")

      RequestModel(vehicleModel)
      while not HasModelLoaded(vehicleModel) do
        Wait(0)
      end

      prop = CreateObject(propBag, 0.0, 0.0, 0.0, true, true, true)
      vehicle = CreateVehicle(vehicleModel, markerVehicle.x, markerVehicle.y, markerVehicle.z, 0.0, true, false)
      SetVehicleNumberPlateText(vehicle, "DELIVERY")

      AttachEntityToEntity(prop, vehicle, GetEntityBoneIndexByName(vehicle, "boot"), 0.0, -0.75, 0.25, 0.0, 0.0,
        0.0, false, false, false, false, 2, true)

      SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
    end
  end
end, false)


CreateThread(function()
  while true do
    Wait(0)
    local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle))

    if distance < 3.0 then
      if DoesEntityExist(vehicle) and not IsPedInVehicle(PlayerPedId(), vehicle) then
        if IsControlJustPressed(0, 23) then
          TaskEnterVehicle(PlayerPedId(), vehicle, 2000, -1, 2.0, 1, 0)
        end
      end
    end
  end
end)

RegisterNuiCallback("closeUI", function(data, cb)
  SetNuiFocus(false, false)
  cb("ok")
end)

RegisterNuiCallback("acceptedJob", function(data, cb)
  SetNuiFocus(false, false)

  if inService and not data.accepted then
    if DoesEntityExist(vehicle) then 
      DeleteEntity(vehicle)
      DeleteEntity(prop)
      prop = nil
      vehicle = nil
    end
  end

  inService = data.accepted

  cb("ok")
end)


function DrawText3D(x, y, z, text)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  local key, value = text:match("^(%S+)%s*(.*)$")
  if onScreen then
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(
      "[~r~" .. key:gsub("[%[%]]", "") .. "~s~] " .. value
    )
    DrawText(_x, _y)
  end
end
