-- // [VARIABLES] \\ --

local Exios = { ['Functions'] = {}, ['Vehicles'] = {}, ['Peds'] = {} }
local inCardealer = false
local countdown = 0

-- // [ESX EVENTS] \\ --

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(PlayerData)
    ESX.PlayerData = PlayerData
    ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
    ESX.PlayerLoaded = false
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(Job)
    ESX.PlayerData.job = Job
end)

-- // [THREADS] \\ --

CreateThread(function()
    while not ESX.PlayerLoaded do Wait(0) end

    ESX.TriggerServerCallback('exios-vehicleshop:server:cb:get:shared', function(data)
        Shared = data
    end)
    while not Shared do Wait(0) end

    Exios.Functions.SpawnShowroomBlips()
    Exios.Functions.SpawnPeds()
    Exios.Functions.SpawnShowroomVehicles()

    while true do
        local sleep = 750

         if IsPedInAnyVehicle(PlayerPedId(), false) then
             local coords = GetEntityCoords(PlayerPedId())
             local dist = #(coords - Shared.QuickSell.coords)

            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
             local props = ESX.Game.GetVehicleProperties(vehicle)
             local vehLabel = nil
             local model = type(props.model) == 'number' and props.model or joaat(props.model)
             local sellPercentage = Shared.QuickSell.sellPercentage
             local sellPrice = 0

             if dist <= 20.0 then
                 sleep = 0
                ESX.Game.Utils.DrawMarker(Shared.QuickSell.coords, 130, 23, 23)
                 if dist <= 2.5 then
                     for k, v in pairs(Shared.Vehicles) do
                         for i = 1, #Shared.Vehicles[k] do
                            if joaat(Shared.Vehicles[k][i].model) == model then
                                 vehLabel = Shared.Vehicles[k][i].label
                                 sellPrice = (Shared.Vehicles[k][i].price * sellPercentage)
                            end
                         end
                    end
                     exports['frp-interaction']:Interaction({ r = 130, g = 23, b = 23 },
                         '[E] - ' .. vehLabel .. ' verkopen voor €' .. ESX.Math.Round(sellPrice), Shared.QuickSell.coords,
                         2.5, GetCurrentResourceName() .. '-action-quicksell')

                     if IsControlJustReleased(0, 38) then
                         Exios.Functions.ConfirmQuickSellMenu(vehicle, vehLabel, sellPrice)
                    end
              end
             end
         end

        Wait(sleep)
    end
end)

-- // [FIVEM EVENTS] \\ --

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    if Exios.Vehicles then
        for _, v in pairs(Exios.Vehicles) do
            DeleteVehicle(v)
        end
    end

    if Exios.Peds then
        for _, v in pairs(Exios.Peds) do
            DeletePed(v)
        end
    end
end)

-- // [EVENTS] \\ --

RegisterNetEvent('exios-vehicleshop:client:open:catalogus')
AddEventHandler('exios-vehicleshop:client:open:catalogus', function()
  --  ESX.TriggerServerCallback('frp-cardealer:server:voorraden', function(voorraden)
        local vehicles = {}
        for k, voertuigen in pairs(Shared.Vehicles) do
            vehicles[k] = {}

            for i = 1, #voertuigen do
                local vehicle = voertuigen[i]
                local maxSpeed = exports['osk-speedometer']:getMaxSpeed(vehicle.model)
                table.insert(vehicles[k], {
                    price = vehicle.price,
                    model = vehicle.model,
                    label = vehicle.label,

                    vehicleConfig = {
                        maxSpeed = maxSpeed and maxSpeed or 'N.v.t.',
                        seats = GetVehicleModelNumberOfSeats(GetHashKey(vehicle.model)),
                        trunkSpace = trunk,
                        horsePower = vehicle.horsePower,
                    }
                })
            end
        end

        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'openDealer',
            vehicles = vehicles,
        })
   -- end)
end)

-- // [NUI CALLBACKS] \\ --

RegisterNUICallback('buyVehicle', function(data, cb)
    local modelId = data.vehicleData.model
    local modelClass = data.vehicleData.class

    ESX.TriggerServerCallback('exios-vehicleshop:server:cb:buyVehicle', function(buyCallback, plateText)
        if not buyCallback then return end

        local vehicle = Shared.Vehicles[modelClass][modelId]
        local spawnPlace
        for i = 1, #Shared.SpawnPlaces do
            if not ESX.Game.IsSpawnPointClear(Shared.SpawnPlaces[i].coords, 1.5) then
                Wait(5000)
                spawnPlace = i
            else
                spawnPlace = i
            end
            ESX.Game.SpawnVehicle(vehicle.model, Shared.SpawnPlaces[spawnPlace].coords,
                Shared.SpawnPlaces[spawnPlace].heading, function(veh)
                Exios.Functions.HandleCamera(Shared.SpawnPlaces[spawnPlace].coords,
                    Shared.SpawnPlaces[spawnPlace].heading, veh)
                ESX.Game.SetVehicleProperties(veh, buyCallback)

                SendNUIMessage({
                    action = 'closeDealer'
                })

                SetVehicleNumberPlateText(veh, plateText)
                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                ESX.TriggerServerCallback('exios-vehicleshop:server:saveVehicle', function(isDone)
                    if not isDone then return end
                end, ESX.Math.Trim(ESX.Game.GetVehicleProperties(veh).plate), ESX.Game.GetVehicleProperties(veh),
                    vehicle.model)
            end)
            return
        end
    end, modelClass, modelId, data.colour)
end)

RegisterNUICallback('closeDealer', function(data, cb)
    SetNuiFocus(false, false)
end)

RegisterNUICallback('testDriveVehicle', function(data, cb)
    startTestDrive(data.vehicleData)
end)

-- // [FUNCTIONS] \\ --

local cachedData = {}
Exios.Functions.HandleCamera = function(garagePos, heading, vehicle, toggle)
    if not garagePos then return end

    if cachedData['cam'] then
        DestroyCam(cachedData['cam'])
    end
    cachedData['cam'] = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

    SetCamCoord(cachedData['cam'], garagePos.x, garagePos.y, garagePos.z + 2)
    SetCamRot(cachedData['cam'], 0, 0, heading)
    SetCamNearDof(cachedData['cam'], 0)
    SetCamActive(cachedData['cam'], true)

    RenderScriptCams(1, 1, 750, 1, 1)

    Citizen.SetTimeout(500, function()
        SetGameplayCamRelativeHeading(0.0)
        RenderScriptCams(0, 1, 250, 1, 1)
    end)
end

Exios.Functions.ConfirmQuickSellMenu = function(vehicle, vehLabel, sellPrice)
    local plate = GetVehicleNumberPlateText(vehicle)

    lib.registerContext({
        id = 'exios-vehicleshop:client:confirm:quickSell',
        title = 'Weet je zeker dat je je ' .. vehLabel .. ' wilt verkopen voor €' .. sellPrice .. '?',
        options = {
            {
                title = 'Ja, ik weet het zeker',
                onSelect = function()
                    if countdown <= 0 then
                        lib.hideContext(false)
                        Exios.Functions.StartCountingDown()
                        Exios.Functions.ConfirmedQuickSell(sellPrice)
                    else
                        lib.hideContext(false)
                        ESX.ShowNotification('error',
                            'Wacht nog ' .. countdown .. ' seconden voordat je weer een voertuig kan verkopen..')
                    end
                end
            },
            {
                title = 'Nee, alsjeblieft niet!',
                onSelect = function()
                    lib.hideContext(false)
                end
            }
        }
    })

    lib.showContext('exios-vehicleshop:client:confirm:quickSell')
end

-- // Confirm Quick Sell Menu Function \\ --
Exios.Functions.ConfirmQuickSellMenu = function(vehicle, vehLabel, sellPrice)
    local plate = GetVehicleNumberPlateText(vehicle)

    lib.registerContext({
        id = 'exios-vehicleshop:client:confirm:quickSell',
        title = 'Weet je zeker dat je je ' .. vehLabel .. ' wilt verkopen voor �' .. sellPrice .. '?',
        options = {
            {
                title = 'Ja, ik weet het zeker',
                onSelect = function()
                    if countdown <= 0 then
                        lib.hideContext(false)
                        Exios.Functions.StartCountingDown()  -- Start cooldown countdown
                        Exios.Functions.ConfirmedQuickSell(vehLabel, sellPrice)  -- Pass vehLabel here
                    else
                        lib.hideContext(false)
                        ESX.ShowNotification('error', 'Wacht nog ' .. countdown .. ' seconden voordat je weer een voertuig kan verkopen..')
                    end
                end
            },
            {
                title = 'Nee, alsjeblieft niet!',
                onSelect = function()
                    lib.hideContext(false)
                end
            }
        }
    })

    lib.showContext('exios-vehicleshop:client:confirm:quickSell')
end

-- // Confirmed Quick Sell Function \\ --
Exios.Functions.ConfirmedQuickSell = function(vehLabel, sellPrice)
    local pedInVehicle = GetVehiclePedIsIn(PlayerPedId(), true)
    local plate = GetVehicleNumberPlateText(pedInVehicle)
    local currentVehicle = GetEntityModel(pedInVehicle)

    -- Loop through the Shared Vehicles to find the current vehicle
    for k, v in pairs(Shared.Vehicles) do
        for i = 1, #v do
            local veh = v[i]
            local model = veh.model
            if GetHashKey(model) == currentVehicle then
                local vehicleInfo = {
                    vehiclename = veh.name or "Onbekend Voertuig", 
                    sell_price = veh.sell_price or 0 
                }

                -- Call the server to execute the quick sell
                ESX.TriggerServerCallback('exios-vehicleshop:server:cb:quickSell', function(success)
                    if success then
                        ESX.ShowNotification('success', 'Je hebt succesvol je ' .. vehLabel .. ' voor �' .. math.floor(vehicleInfo.sell_price * 0.5) .. ' verkocht!')
                    else
                        ESX.ShowNotification('error', 'Er is iets fouts gegaan, probeer het opnieuw!')
                    end
                end, ESX.Math.Trim(plate), ESX.Game.GetVehicleProperties(pedInVehicle), vehicleInfo)

                -- Delete the vehicle from the game world
                DeleteVehicle(pedInVehicle)
            end
        end
    end
end

-- // Delete Vehicle Function \\ --
function DeleteVehicle(vehicle)
    if DoesEntityExist(vehicle) then
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteEntity(vehicle)  -- Corrected from DeleteVehicle to DeleteEntity
    end
end

-- // Start Countdown Function \\ --
-- // Start Countdown Function \\ --
Exios.Functions.StartCountingDown = function()
    running = true
    countdown = 3600  -- Countdown time in seconds (1 hour)
    CreateThread(function()
        while countdown > 0 do
            Wait(1000)  -- Wait 1 second
            countdown = countdown - 1  -- Decrease countdown
        end
        running = false  -- Countdown finished
    end)
end

Exios.Functions.LoadModel = function(model)
    if not IsModelValid(model) then return end

    RequestModel(joaat(model))
    while not HasModelLoaded(joaat(model)) do
        Wait(5)
    end
end

Exios.Functions.SpawnShowroomBlips = function()
    for i = 1, #Shared.Locations do
        if Shared.Locations[i]['blip'] then
            local blip = AddBlipForCoord(Shared.Locations[i]['coords'])

            SetBlipSprite(blip, 225)
            SetBlipScale(blip, 0.6)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName('Autohandelaar')
            EndTextCommandSetBlipName(blip)
        end
    end
end

Exios.Functions.SpawnPeds = function()
    Exios.Functions.LoadModel(`a_m_y_smartcaspat_01`)
    for i = 1, #Shared.Locations do
        Shared.Locations[i]['ped'] = ESX.Game.SpawnPed(GetHashKey("a_m_y_smartcaspat_01"),
            { ['x'] = Shared.Locations[i]['coords']['x'], ['y'] = Shared.Locations[i]['coords']['y'], ['z'] = Shared
            .Locations[i]['coords']['z'] - 1.0 }, Shared.Locations[i]['coords']['w'])

        SetPedDiesWhenInjured(Shared.Locations[i]['ped'], true)
        SetEntityInvincible(Shared.Locations[i]['ped'], true)
        FreezeEntityPosition(Shared.Locations[i]['ped'], true)
        SetPedRelationshipGroupHash(Shared.Locations[i]['ped'], 'MISSION8')
        SetRelationshipBetweenGroups(0, 'MISSION8', 'PLExiosER')
        SetBlockingOfNonTemporaryEvents(ped, true)

        Exios.Peds[#Exios.Peds + 1] = Shared.Locations[i]['ped']

        exports.ox_target:addLocalEntity(Shared.Locations[i]['ped'], {
            {
                event = 'exios-vehicleshop:client:open:catalogus',
                label = 'Catalogus openen',
                icon = 'fas fa-car',
                distance = 2.5
            }
        })
    end
end

Exios.Functions.SpawnShowroomVehicles = function()
    for i = 1, #Shared.Showroom do
        ESX.Game.SpawnLocalVehicle(Shared.Showroom[i]['model'], Shared.Showroom[i]['coords'],
            Shared.Showroom[i]['heading'], function(veh)
            Shared.Showroom[i]['vehicle'] = veh

            SetVehicleDirtLevel(Shared.Showroom[i]['vehicle'], 0)
            SetVehicleDoorsLockedForAllPlayers(Shared.Showroom[i]['vehicle'], true)
            SetVehicleDoorsLocked(Shared.Showroom[i]['vehicle'], 2)
            SetVehicleDoorOpen(Shared.Showroom[i]['vehicle'], 2, false, false)
            SetEntityInvincible(Shared.Showroom[i]['vehicle'], true)
            SetVehicleModColor_1(Shared.Showroom[i]['vehicle'], 2, 0, 0)
            SetVehicleLivery(Shared.Showroom[i]['vehicle'], 0)

            Wait(1000)
            FreezeEntityPosition(Shared.Showroom[i]['vehicle'], true)

            Exios.Vehicles[#Exios.Vehicles + 1] = Shared.Showroom[i]['vehicle']
        end)
    end
end
