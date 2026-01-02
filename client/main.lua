local npc = nil
local npcCoords = vector3(94.0, 285.50, 110.21)
local acceptedJob = false
local markerVehicle = vector3(106.36, 301.69, 110.02)

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
    if acceptedJob then
      local distance = #(GetEntityCoords(PlayerPedId()) - markerVehicle)
      if distance < 5.0 then
        DrawText3D(markerVehicle.x, markerVehicle.y, markerVehicle.z + 1.0, "E Veiculo")
      end
      DrawMarker(36, markerVehicle.x, markerVehicle.y, markerVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255,
        0, 0, 150, true, true, 2, true, nil, nil, false)
    end
  end
end)

RegisterNuiCallback("closeUI", function(data, cb)
  SetNuiFocus(false, false)
  cb("ok")
end)

RegisterNuiCallback("acceptedJob", function(data, cb)
  SetNuiFocus(false, false)
  acceptedJob = data.accepted

  print("Aceitou o Emprego")
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
