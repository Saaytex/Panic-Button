ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--------------------------------------- Envoie aux autres policiers
RegisterNetEvent('panicbutton:sendLocation')
AddEventHandler('panicbutton:sendLocation', function(coords)
    local src = source
    local playerName = GetPlayerName(source)
    local police = {}
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.job.name == 'police' then
        for k, v in ipairs(GetPlayers()) do
            local player = ESX.GetPlayerFromId(v)
            if player.job.name == 'police' then
                table.insert(police, v)
            end
        end

        for i = 1, #police, 1 do
            TriggerClientEvent('panicbutton:showLocation', police[i], coords, playerName)
        end
    end
end)

--------------------------------------- Vérifie si le joueur a un panic button sur lui
RegisterServerEvent('panicbutton:verif')
AddEventHandler('panicbutton:verif', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local item = xPlayer.getInventoryItem("panicbutton").count
	
	if item > 0 then
        check = 1
		TriggerClientEvent("panicbutton:verifretour", source, check)	
	else
        check = 0
		TriggerClientEvent("panicbutton:verifretour", source, check)	
	end
	
end)
