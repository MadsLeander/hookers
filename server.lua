local ESX = nil
if Config.Framework == "esx" then
    TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
end

local QBCore = nil
if Config.Framework == "qbcore" then
    QBCore = exports['qb-core']:GetCoreObject()
end

RegisterServerEvent('hookers:moneyCheck')
AddEventHandler('hookers:moneyCheck', function(service)
    if Config.Framework == "esx" then
        local xPlayer = ESX.GetPlayerFromId(source)
        local cost = Config.Prices[service]
        local cash = 49--xPlayer.getMoney()

        if cash >= cost then
            xPlayer.removeMoney(cost)
            TriggerClientEvent('hookser:paymentReturn', source, true)
        else
            TriggerClientEvent('hookser:paymentReturn', source, false)
        end
    elseif Config.Framework == "qbcore" then
        local Player = QBCore.Functions.GetPlayer(source)
        local cost = Config.Prices[service]
        local cash = Player.Functions.GetMoney('cash')

        if cash >= cost then
            Player.Functions.RemoveMoney('cash', cost, "Hooker")
            TriggerClientEvent('hookser:paymentReturn', source, true)
        else
            TriggerClientEvent('hookser:paymentReturn', source, false)
        end
    elseif Config.Framework == "standalone" then
        -- Your code here
        TriggerClientEvent('hookser:paymentReturn', source, true)
    else
        TriggerClientEvent('hookser:paymentReturn', source, true)
    end
end)
