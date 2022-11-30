local QBCore = exports['qb-core']:GetCoreObject()
local onCooldown = false
-- Create Target for ATMS --

CreateThread(function()
    if not Config.BankingTarget then
        exports['qb-target']:AddTargetModel(Config.ATMModels, {
            options = {
                {
                    num = 1,
                    event = 'atmheist:hackatm',
                    type = 'client',
                    icon = "fas fa-laptop",
                    label = "Tamper with ATM",
                    -- item = Config.HackItem, -- Only allow target if they have they have the Config.HackItem
                },

            },
            distance = 1.5,
        })
    else
        exports['qb-target']:AddTargetModel(Config.ATMModels, {
            options = {
                {
                    num = 1,
                    event = 'qb-atms:server:enteratm',
                    type = 'server',
                    icon = "fas fa-credit-card",
                    label = "Use ATM",
                },
                {
                    num = 2,
                    event = 'atmheist:hackatm',
                    type = 'client',
                    icon = "fas fa-laptop",
                    label = "Tamper with ATM",
                    -- item = Config.HackItem, -- Only allow target if they have they have the Config.HackItem
                },

            },
            distance = 1.5,
        })
    end
end)

local function Cooldown(type)
    if type == 'fail' and not Config.FailCooldown then return end
    onCooldown = true
    Wait(Config.CooldownWait)
    onCooldown = false
end

local function CallPolice(coords)
	local chance = math.random(1, 100)
	if chance < Config.PoliceChance then
		if Config.Dispatch == "ps-dispatch" then
			exports['ps-dispatch']:SuspiciousActivity()
		elseif Config.Dispatch == "qb-dispatch" then
			TriggerServerEvent('qb-dispatch:911call', coords)
		elseif Config.Dispatch == "qb-default" then
			TriggerServerEvent('atmheist:callcops', coords)
		elseif Config.Dispatch == "custom" then
			-- Put your own dispatch system here
		else
			-- Add your own!
            print("This dispatch: "..Config.Dispatch.." is not supported. Add your own in client.lua @ Line 30 & Change Config.Dispatch to custom.")
        end
	end
end

-- Hack Anim!
local function HackAnimation()
    local animDict = "anim@heists@ornate_bank@hack"
    RequestAnimDict(animDict)
    RequestModel("hei_prop_hst_laptop")
    RequestModel("hei_p_m_bag_var22_arm_s")
    while not HasAnimDictLoaded(animDict)
        or not HasModelLoaded("hei_prop_hst_laptop")
        or not HasModelLoaded("hei_p_m_bag_var22_arm_s")  do
        Wait(100)
    end
    local ped = PlayerPedId()
    local targetPosition, targetRotation = (vec3(GetEntityCoords(ped))), vec3(GetEntityRotation(ped))
    local hackCoord = GetEntityCoords(ped)

    SetEntityHeading(ped, hackCoord.h)
    local animPos = GetAnimInitialOffsetPosition(animDict, "hack_enter", hackCoord.x, hackCoord.y, hackCoord.z+0.80, hackCoord.x, hackCoord.y, hackCoord.z+0.85, 0, 2)
    local animPos2 = GetAnimInitialOffsetPosition(animDict, "hack_loop", hackCoord.x, hackCoord.y, hackCoord.z+0.80, hackCoord.x, hackCoord.y, hackCoord.z+0.85, 0, 2)
    local animPos3 = GetAnimInitialOffsetPosition(animDict, "hack_exit", hackCoord.x, hackCoord.y, hackCoord.z+0.80, hackCoord.x, hackCoord.y, hackCoord.z+0.85, 0, 2)

    netScene = NetworkCreateSynchronisedScene(animPos, targetRotation, 2, false, false, 1065353216, 0, 1.3)
    bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), targetPosition, 1, 1, 0)
    laptop = CreateObject(GetHashKey("hei_prop_hst_laptop"), targetPosition, 1, 1, 0)

    NetworkAddPedToSynchronisedScene(ped, netScene, animDict, "hack_enter", 1.2, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene, animDict, "hack_enter_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene, animDict, "hack_enter_laptop", 4.0, -8.0, 1)

    netScene2 = NetworkCreateSynchronisedScene(animPos2, targetRotation, 2, false, true, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene2, animDict, "hack_loop", 1.2, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene2, animDict, "hack_loop_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene2, animDict, "hack_loop_laptop", 4.0, -8.0, 1)

    netScene3 = NetworkCreateSynchronisedScene(animPos3, targetRotation, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene3, animDict, "hack_exit", 1.2, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene3, animDict, "hack_exit_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene3, animDict, "hack_exit_laptop", 4.0, -8.0, 1)

    SetPedComponentVariation(ped, 5, 0, 0, 0)
    Wait(200)
    NetworkStartSynchronisedScene(netScene)
    Wait(6300)
    NetworkStartSynchronisedScene(netScene2)
end

local function FinishAnimation()
    NetworkStartSynchronisedScene(netScene3)
    Wait(2500)
    NetworkStopSynchronisedScene(netScene3)
    DeleteObject(laptop)
    DeleteObject(bag)
    DeleteObject(card)    
end

RegisterNetEvent('atmheist:hackatm', function()
    if onCooldown then QBCore.Functions.Notify('Systems are shut down due to a recent security breach.', 'error') return end
    local ped = PlayerPedId()
    HackAnimation()
    QBCore.Functions.Progressbar('atm_hack', 'Waiting for connection...', 3500, false, false, { -- Name | Label | Time | useWhileDead | canCancel
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Play When Done
        exports['ps-ui']:VarHack(function(success)
            if success then
                FinishAnimation()
                CallPolice(GetEntityCoords(ped))
                TriggerServerEvent('atmheist:server:awarditems')
                Cooldown("success")
            else
                FinishAnimation()
                CallPolice(GetEntityCoords(ped))
                TriggerServerEvent('atmheist:server:failure')
                Cooldown("fail")
            end
         end, 4, 6) -- Number of Blocks, Time (seconds)
    end, function() end)
end)

RegisterNetEvent('atmheist:cl:callcops', function(coords)
	local PlayerJob = QBCore.Functions.GetPlayerData().job
	if PlayerJob.name ~= "police" or not PlayerJob.onduty then return end
	local transG = 250
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip, 648)
	SetBlipColour(blip, 17)
	SetBlipDisplay(blip, 4)
	SetBlipAlpha(blip, transG)
	SetBlipScale(blip, 1.2)
	SetBlipFlashes(blip, true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString("(10-90) - ATM Alarm")
	EndTextCommandSetBlipName(blip)
	while transG ~= 0 do
		Wait(180 * 4)
		transG = transG - 1
		SetBlipAlpha(blip, transG)
		if transG == 0 then
			SetBlipSprite(blip, 2)
			RemoveBlip(blip)
			return
		end
	end
end)