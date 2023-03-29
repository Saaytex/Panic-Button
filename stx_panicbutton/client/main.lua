ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

------
local tempsactive = 50000 --- temps que le blips reste sur la map en milliseconde

------ TOUCHES
local activepanicbutton = 74 ------- H
local prendreappel = 246     ------- Y       | Pour changer les touches : https://docs.fivem.net/docs/game-references/controls/
local refuseappel = 73       ------- X


------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------- PANIC BUTTON -----------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------- Activer le Panic Button
Citizen.CreateThread(function()
    local xPlayer = ESX.GetPlayerData()
    if xPlayer.job.name == 'police' then
        while true do
            Citizen.Wait(0)

            if IsControlJustPressed(0, activepanicbutton) then
                TriggerServerEvent("panicbutton:verif")

                RegisterNetEvent('panicbutton:verifretour')
                AddEventHandler('panicbutton:verifretour', function(check)

                    if check == 1 then
                        local coords = GetEntityCoords(PlayerPedId())
                        local playerId = GetPlayerServerId(PlayerId())

                        TriggerServerEvent('panicbutton:sendLocation', coords)
                        ESX.ShowNotification("~g~Vous venez d'utiliser votre Panic Button")
                    else
                        ESX.ShowNotification("~r~Vous devez avoir un panic button en poche !")
                    end
                    
                end)
            end
        end
    end
end)

--------------------------------------- Envoyer les infos aux autres policiers
RegisterNetEvent('panicbutton:showLocation')
AddEventHandler('panicbutton:showLocation', function(coords, playerName)

    local targetPlayerId = GetPlayerServerId(PlayerId())

    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 161)
    SetBlipScale(blip, 1.5)
    SetBlipColour(blip, 3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Panic Button")
    EndTextCommandSetBlipName(blip)

    alerteEnCours = true

    ESX.ShowAdvancedNotification(
        "~r~PANIC BUTTON",
        "Agent : "..playerName.."",
        "Un agent de police est en Danger!\n\n~g~Y~s~ Pour prendre l\'appel\n\n~r~X~s~ Pour Refuser",
        "CHAR_MP_DETONATEPHONE", 0)

    function gps()
        SetNewWaypoint(coords.x, coords.y, coords.z)
    end

    Citizen.Wait(tempsactive)
    alerteEnCours = false
    RemoveBlip(blip)
end)

--------------------------------------- Accepter ou refuser l'appel
Citizen.CreateThread(function()
    local xPlayer = ESX.GetPlayerData()
    if xPlayer.job.name == 'police' then
        while true do
            Citizen.Wait(1)
            if IsControlJustPressed(1, prendreappel) and alerteEnCours == true then
                gps()
                ESX.ShowNotification('~g~Vous avez pris l\'appel')
            elseif IsControlJustPressed(1, refuseappel) and alerteEnCours == true then
                ESX.ShowNotification('~r~Vous avez refusé l\'appel')
            end
        end
    end
end)







---------------------------------------------------------
------------ Créateur : Mehdi - Saaytex#8176 ------------
-------- Discord : https://discord.gg/reJ8V49A4f --------
------------- Par respect ne pas supprimer --------------
---------------------------------------------------------
