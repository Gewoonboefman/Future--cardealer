RegisterCommand('cardealer_testconfig', function(source, args, rawCommand)
    for vehicleId = 1, #Shared.Fotobook.Vehicles do
        local vehName = Shared.Fotobook.Vehicles[vehicleId].model
        local vehBrand = Shared.Fotobook.Vehicles[vehicleId].merk

        if not IsModelValid(vehName) then 
            print('[exios-vehicleshop] ' .. vehName .. ' is not valid!')
        end
    end
end)