local currentVeh = nil
local currentCam = nil
RegisterNetEvent('exios-vehicleshop:client:handler:startFotobook')
AddEventHandler('exios-vehicleshop:client:handler:startFotobook', function(group)
    -- if group == 'admin' or group == 'superadmin' then
        for vehicleId = 1, #Shared.Fotobook.Vehicles do
            local vehName = Shared.Fotobook.Vehicles[vehicleId].model
            local vehBrand = Shared.Fotobook.Vehicles[vehicleId].merk
            local done = false

            local vehicleLoaded = false
            local timer = GetGameTimer()

            ESX.Streaming.RequestModel(GetHashKey(vehName), function()
                vehicleLoaded = true
            end)

            while not vehicleLoaded and (GetGameTimer() - timer) < 5000 do
                Wait(0)
            end

            if vehicleLoaded then
                ESX.Game.SpawnVehicle(vehName, Shared.Fotobook.CarSettings['coords'], Shared.Fotobook.CarSettings['heading'], function(veh) 
                    Wait(1000)
                    FreezeEntityPosition(veh, true)
                    SetVehicleDirtLevel(veh, 0)
                    SetVehicleNumberPlateText(veh, 'FutureRP')
                    for cameraId = 1, #Shared.Fotobook.Cameras do
                        local camCoord = Shared.Fotobook.Cameras[cameraId].coords
                        local camAimCoord = Shared.Fotobook.Cameras[cameraId].aimAt
                        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true, 2)
                        SetCamParams(cam, camCoord.x, camCoord.y, camCoord.z - 1.0, false, false, false, GetGameplayCamFov())
                        PointCamAtCoord(cam, camAimCoord.x, camAimCoord.y, camAimCoord.z - 1.0)
                        SetCamActive(cam, true)
                        RenderScriptCams(1, 1, 1, 0, 0)

                        for k,v in pairs(Shared.Fotobook.Colors) do
                            ESX.Game.SetVehicleProperties(veh, {color1 = v.index})
                            TriggerServerEvent('exios-vehicleshop:server:handler:requestscreenshot', vehName, cameraId, vehBrand, k)
                            Wait(375)
                        end

                        DestroyCam(cam)
                    end

                    ESX.Game.DeleteVehicle(veh)
                    done = true
                end)
            else
                print('Vehicle not loaded within 5 seconds: ' .. vehName)
            end

            while not done do Wait(0) end
        end

        SetCamActive(cam, false)
        RenderScriptCams(0, 0, 0, 0, 0)
        ESX.ShowNotification("Foto's zijn succesvol geupload naar een development folder.", 'success')
    -- else
    --     -- Mogelijke hacker
    -- end
end)
