local ESX = nil
if Config.Framework == "esx" then
    ESX = exports["es_extended"]:getSharedObject()
end

local QBCore = nil
if Config.Framework == "qbcore" then
    QBCore = exports['qb-core']:GetCoreObject()
end

local NDCore = nil
if Config.Framework == "ndcore" then
    NDCore = exports["ND_Core"]:GetCoreObject()
end

RegisterServerEvent('hookers:moneyCheck')
AddEventHandler('hookers:moneyCheck', function(service)
    local cost = Config.Prices[service]
    local src = source

    if Config.Framework == "esx" then
        local xPlayer = ESX.GetPlayerFromId(src)
        local cash = xPlayer.getMoney()

        if cash >= cost then
            xPlayer.removeMoney(cost)
            TriggerClientEvent('hookser:paymentReturn', src, true)
        else
            TriggerClientEvent('hookser:paymentReturn', src, false)
        end
    elseif Config.Framework == "qbcore" then
        local Player = QBCore.Functions.GetPlayer(src)
        local cash = Player.Functions.GetMoney('cash')

        if cash >= cost then
            Player.Functions.RemoveMoney('cash', cost, "Hooker")
            TriggerClientEvent('hookser:paymentReturn', src, true)
        else
            TriggerClientEvent('hookser:paymentReturn', src, false)
        end
    elseif Config.Framework == "ndcore" then
        local character = NDCore.Functions.GetPlayer(src)

        if character.cash >= cost then
            NDCore.Functions.DeductMoney(cost, src, "cash", "Hooker")
            TriggerClientEvent('hookser:paymentReturn', src, true)
        else
            TriggerClientEvent('hookser:paymentReturn', src, false)
        end
    elseif Config.Framework == "standalone" then
        -- Your code here
        TriggerClientEvent('hookser:paymentReturn', src, true)
    else
        TriggerClientEvent('hookser:paymentReturn', src, true)
    end
end)
