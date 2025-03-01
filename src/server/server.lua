-- // [VARIABLES] \\ --

local Exios = { Functions = {}}

-- // [CALLBACKS] \\ --

ESX.RegisterServerCallback('exios-vehicleshop:server:cb:get:shared', function(source, cb)
    cb(Shared)
end)

ESX.RegisterServerCallback('exios-vehicleshop:server:cb:quickSell', function(source, cb, plate, props, vehInfo)
    if not Shared.QuickSellEnabled then
        TriggerClientEvent("frp-notifications:client:notify", source, 'error', 'Quick selling is currently disabled.')
        cb(false)
        return
    end

    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.query('SELECT * FROM owned_vehicles WHERE plate = ? AND owner = ?', {plate, xPlayer.identifier}, function(result)
        if result[1] then
            local vehicleData = result[1]
            local vehicleProps = json.decode(vehicleData.vehicle)
            local originalPrice = 0

            for _, category in pairs(Shared.Vehicles) do
                for _, vehicle in ipairs(category) do
                    if vehicle.model == vehicleProps.model then
                        originalPrice = vehicle.price
                        break
                    end
                end
                if originalPrice > 0 then break end
            end

            local sellPrice = calculateSellPrice()

            MySQL.update('DELETE FROM owned_vehicles WHERE plate = ?', {plate}, function(affectedRows)
                if affectedRows > 0 then
                    xPlayer.addInventoryItem('cash', sellPrice)
                    TriggerEvent('exios-logging:server:log', source, 'quicksell', 'green',
                        '*Speler heeft een voertuig verkocht.*\n\n**Voertuigmodel:** ' ..
                        vehInfo.vehiclename ..
                        '\n**Verkoopprijs:** €' .. sellPrice .. '\n**Voertuigkenteken:** ' .. plate)
                    TriggerClientEvent('exios-vehicleshop:client:removeVehicle', source, plate)
                    TriggerClientEvent("frp-notifications:client:notify", source, 'info', 
                        'Je voertuig is verwijderd uit je garage.')

                    cb(true)
                else
                    TriggerClientEvent("frp-notifications:client:notify", source, 'error', 'Er is een fout opgetreden bij het verkopen van het voertuig.')
                    cb(false)
                end
            end)
        else
            TriggerClientEvent("frp-notifications:client:notify", source, 'error', 'Dit voertuig is niet in je bezit.')
            cb(false)
        end
    end)
end)

function calculateSellPrice()
    local randomChance = math.random(1, 1000)
    if randomChance <= 5 then  
        return math.random(120000, 130000)
    elseif randomChance <= 400 then  
        return math.random(45000, 55000)
    else  
        return math.random(25000, 35000)
    end
end



ESX.RegisterServerCallback('exios-vehicleshop:server:cb:buyVehicle', function(source, cb, class, id, colour)
    local xPlayer = ESX.GetPlayerFromId(source)
    local veh = Shared.Vehicles[class][id]['model']

    if xPlayer.getAccount('bank').money <= Shared.Vehicles[class][id]['price'] then
        TriggerClientEvent("frp-notifications:client:notify", source, 'error', 'Je hebt hier niet genoeg geld voor!')
        return
    end

    local plate = Exios.Functions.GeneratePlate()

    TriggerEvent('exios-logging:server:log', source, 'cardealer', 'green',
        '*Speler heeft een nieuw voertuig gekocht.*\n\n**Voertuigmodel:** ' ..
        Shared.Vehicles[class][id]['model'] ..
        '\n**Voertuigprijs:** ' .. Shared.Vehicles[class][id]['price'] .. '\n**Voertuigkenteken:** ' .. plate)

    TriggerClientEvent("frp-notifications:client:notify", source, 'success',
        'Je hebt een ' .. Shared.Vehicles[class][id]['label'] ..
        ' gekocht voor â‚¬' .. Shared.Vehicles[class][id]['price'] .. '')
    xPlayer.removeAccountMoney('bank', Shared.Vehicles[class][id]['price'])
    cb({ color1 = Shared.Fotobook.Colors[colour]['index'] }, plate)
end)

ESX.RegisterServerCallback('exios-vehicleshop:server:saveVehicle', function(source, cb, plate, props, model)
    local xPlayer = ESX.GetPlayerFromId(source)

    exports['oxmysql']:query(
    'INSERT INTO `owned_vehicles` (owner, plate, vehicle, stored, type, vinnummer) VALUES (?, ?, ?, ?, ?, ?)',
        { xPlayer.identifier, plate, json.encode(props), 0, 'car', ESX.GetRandomString(8) })
    TriggerClientEvent("frp-notifications:client:notify", source, 'success',
        'je hebt de sleutels ontvangen, je nieuwe voertuig staat achteraan klaar!')
    cb(true)
end)

-- // [EVENTS] \\ --

RegisterNetEvent('exios-vehicleshop:server:handler:requestscreenshot')
AddEventHandler('exios-vehicleshop:server:handler:requestscreenshot', function(vehName, cameraId, vehBrand, label)
    local src = source

    exports['screenshot-basic']:requestClientScreenshot(src, {
        fileName = 'resources/[locked]/frp-vehicleshop/images/' ..
        vehBrand .. '_' .. vehName .. '_' .. cameraId .. '_' .. label .. '.png'
    }, function(err, data)
        print(data)
    end)
end)

-- // [COMMANDS] \\ --

ESX.RegisterCommand('cardealer_fotos', 'admin', function(xPlayer, args, showError)
    xPlayer.triggerEvent('exios-vehicleshop:client:handler:startFotobook', xPlayer.getGroup())
end, false, { help = 'Maak fotos voor de cardealer' })

-- // [FUNCTIONS] \\ --

Exios.Functions.GeneratePlate = function()
    local str = nil
    repeat
        str = string.upper(GetRandomLetter(3) .. ' ' .. GetRandomNumber(3))
        local alreadyExists = MySQL.single.await('SELECT owner FROM owned_vehicles WHERE plate = ?', { str })
    until not alreadyExists?.owner
    return string.upper(str)
end

local NumberCharset = {}
local Charset = {}

for i = 48, 57 do table.insert(NumberCharset, string.char(i)) end

for i = 65, 90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end



-- mixing async with sync tasks

function GetRandomNumber(length)
    Wait(0)
    if length > 0 then
        return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
    else
        return ''
    end
end

function GetRandomLetter(length)
    Wait(0)
    if length > 0 then
        return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
    else
        return ''
    end
end


