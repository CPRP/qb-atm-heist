Config = {}

Config.CooldownMinutes = 10 -- Ten minutes
Config.CooldownWait = Config.CooldownMinutes * 60000

Config.ATMModels = {
    "prop_atm_01",
    "prop_atm_02",
    "prop_atm_03",
    "prop_fleeca_atm"
}

Config.BankingTarget = true -- Set to true if you want qb-atms to have its option on the atm as well.
Config.RemoveItemOnFailure = true
Config.HackItem = "trojan_usb"
Config.Dispatch = 'qb-dispatch' -- qb-dispatch, qb-default, ps-dispatch or "custom" @ 
Config.PoliceChance = 75 -- % Chance for Police to be called.
Config.FailCooldown = true -- If false, failure will not trigger cooldown.


Config.PhysicalItem = false
Config.MoneyReward = true
Config.RewardCashAmount = 5000