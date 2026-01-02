local npc = nil
local npcCoords = vector3(94.0, 285.50, 110.21)

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
