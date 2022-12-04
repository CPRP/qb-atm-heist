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
Config.Dispatch = 'ps-dispatch' -- qb-dispatch, qb-default, ps-dispatch or "custom" @ 
Config.PoliceChance = 100 -- % Chance for Police to be called.
Config.FailCooldown = true -- If false, failure will not trigger cooldown.


Config.PhysicalItem = true
Config.MoneyReward = false
Config.RewardCashAmount = 5000

-- Added for new adding marked bills
Config.MinAmount = 1 -- 1 bag
Config.MaxAmount = 3 -- 5 bags
Config.MinWorth = 500 -- $500 minimum
Config.MaxWorth = 2000 -- $2000 maximum
