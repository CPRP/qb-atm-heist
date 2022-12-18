local QBCore = exports['qb-core']:GetCoreObject()

ActiveCooldowns = {}

local function StartCooldown(src)
    if src then
        ActiveCooldowns[src] = 'active'   
        Citizen.Wait(Config.CooldownWait)
        ActiveCooldowns[src] = false
    end
end

RegisterNetEvent('atmheist:server:StartCooldown', function()
    local src = source
    StartCooldown(src)
end)

QBCore.Functions.CreateCallback('atmheist:server:notOnCooldown', function(source, cb)
    local src = source
    if ActiveCooldowns[src] == 'active' then
        cb(false)
    else
        cb(true)
    end
end)

RegisterNetEvent('atmheist:server:awarditems', function()
    local src = source
    
    if ActiveCooldowns[src] then QBCore.Functions.Notify(src, 'Systems are shut down due to a recent security breach.', 'error') return end
     
    local ply = QBCore.Functions.GetPlayer(src)
    -- ply.Functions.RemoveItem(Config.HackItem, 1)
    QBCore.Functions.Notify(src, 'Its open!', 'success') 
    if not Config.PhysicalItem and not Config.MoneyReward then print("No rewards given because both Config.PhysicalItem and Config.Money are false.")  end
    if Config.PhysicalItem then
        ply.Functions.AddItem(Config.RewardItem, Config.RewardItemAmount)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.RewardItem], "add")
    end
    if Config.MoneyReward then
        ply.Functions.AddMoney("cash", math.ceil(Config.RewardCashAmount))
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.RewardItem], "add")
    end
        
    StartCooldown(src)
end)

RegisterNetEvent('atmheist:server:failure', function()
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)
    QBCore.Functions.Notify(src, 'You failed!', 'error')
    if Config.RemoveItemOnFailure then
        ply.Functions.RemoveItem(Config.HackItem, 1)
    end
end)

RegisterNetEvent('atmheist:callcops', function(coords)
    TriggerClientEvent('atmheist:cl:callcops', -1, coords)
end)
