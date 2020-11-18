local gloveBoxSecondaryInventory = {
    type = 'glovebox',
    owner = 'XYZ123'
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = GetPlayerPed(-1)
        local ped = PlayerPedId()
        if IsControlJustReleased(0, Config.TrunkOpenControl) and IsPedInAnyVehicle(playerPed) then
            local vehicle = GetVehiclePedIsIn(playerPed)
            if ((GetPedInVehicleSeat(vehicle, -1) == ped) or (GetPedInVehicleSeat(vehicle, 0) == ped)) then
                if DoesEntityExist(vehicle) then
                    gloveBoxSecondaryInventory.owner = GetVehicleNumberPlateText(vehicle)
                    openInventory(gloveBoxSecondaryInventory)
                end
            end
        end
    end
end)