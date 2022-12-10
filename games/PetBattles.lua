-- Variables
local Players       = game:GetService("Players")
local Workspace     = game:GetService("Workspace")
local RS            = game:GetService("ReplicatedStorage")
local Player_Attack = RS.RemoteEvents.PlayerAttack
local Pet_Attack    = RS.RemoteEvents.PetAttack
local Player        = Players.LocalPlayer
local Character     = Player.Character
local HRP           = Character.HumanoidRootPart
local Rebirth       = RS.RemoteFunctions.Rebirth
local Upgrade_Pet   = RS.RemoteFunctions.Upgrade
local Hatch_Egg     = RS.RemoteFunctions.Hatch
local Set_Pet       = RS.RemoteEvents.SetAttacking
local Codes         = require(RS.ReplicatedVariables).codes
local Redeem_Code   = RS.RemoteFunctions.RedeemCode
local Abbreviations = require(Player.PlayerScripts.ClientManager.Variables).numAbbreviations
-- Toggles
shared.Bring_Coins  = false
shared.Triple_Hatch = false
shared.Selected_Egg = "Basic Egg"
shared.Eggs = {}
shared.PseudoEggs   = nil
-- Functions

local StatFormats   = {}

for i,v in next, Abbreviations do
    table.insert(StatFormats , v)
end

local formatNumber  = function(int)
	local formatted = math.max(int, 0)
	for i, v in next, StatFormats do
		local power = 10 ^ (i * 3)
		if int >= power then
			formatted = string.format("%.1f".. (v), int / power)
		end
	end
	return formatted
end

(function() -- Setting Egg Table Up
    for i,v in next, getgc(true) do
        if typeof(v) == "table" then if rawget(v, "Basic Egg") then shared.PseudoEggs = v end end
    end
    for i,v in next, shared.PseudoEggs do
        table.insert(shared.Eggs, i.." | " .. tostring(formatNumber(v.Price)))
    end
    table.sort(shared.PseudoEggs, function(a,b)
        return a < b
    end)
end)();

(function() -- Redeeming Codes
    for i,v in next, Codes do
        Redeem_Code:InvokeServer(v)
    end
end)();

Workspace.ChildAdded:Connect(function(child)
    if shared.Bring_Coins == true then
        if child.Name == "Coin" then
            child.CFrame = HRP.CFrame
        end
    end
end)

Workspace.ChildAdded:Connect(function(child)
    if shared.Bring_Gems == true then
        if child.Name == "Gem" then
            child.CFrame = HRP.CFrame
        end
    end
end)

local Get_Pets     = function()
    local pets = {}
    for i,v in next, Workspace:GetChildren() do
        if v.Name:find("%d+") and v:FindFirstChild("Level") then
            table.insert(pets, v)
        end
    end
    return pets
end

local Get_Mob      = function()
    return Player.PlayerGui:WaitForChild("HP", 30).Adornee.Parent
end

local Get_Coins    = function()
    for i,v in next, Workspace:GetChildren() do
        if v.Name == "Coin" then
            v.CFrame = HRP.CFrame
        end
    end
end

local Get_Gems     = function()
    for i,v in next, Workspace:GetChildren() do
        if v.Name == "Gem" then
            v.CFrame = HRP.CFrame
        end
    end
end

local Attack_Mob   = function()
    local pets = Get_Pets()
    for i,v in next, pets do
        Set_Pet:FireServer(v, true)
        Pet_Attack:FireServer(v, Get_Mob())
    end
    Player_Attack:FireServer(Get_Mob())
end

local Upgrade_Pets = function()
    local pets = Get_Pets()
    for i,v in next, pets do
        Upgrade_Pet:InvokeServer(tonumber(v.Name:sub(v.Name:find("_")+1, v.Name:len())))
    end
end

local Hatch_Egg    = function(egg, amount)
    Hatch_Egg:InvokeServer(egg, amount == true and 3 or 1)
end
-- Graphical User Interface
local SolarisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stebulous/solaris-ui-lib/main/source.lua"))()

local win = SolarisLib:New({
    Name = "Idle Pet Battles Simulator",
    FolderToSave = "BigBS_SGWR"
})

local tab = win:Tab("Tab 1")

local sec = tab:Section("Farming")

sec:Toggle("Auto Attack Mob", false,"Attack Mob", function(t)
    getgenv()["Attack Mob"] = t

    while getgenv()["Attack Mob"] == true do
        task.wait(0.05)
        pcall(Attack_Mob)
    end
end)

sec:Toggle("Auto Pick Up Coins", false,"Pick Up Coins", function(t)
    Get_Coins()
    shared.Bring_Coins = t
end)

sec:Toggle("Auto Pick Up Gems", false,"Pick Up Gems", function(t)
    Get_Gems()
    shared.Bring_Gems = t
end)

local sec = tab:Section("Hatching")

sec:Toggle("Auto Hatch Egg", false,"Auto Hatch Egg", function(t)
    getgenv()["Auto Hatch Egg"] = t

    while getgenv()["Auto Hatch Egg"] == true do
        task.wait(0.05)
        Hatch_Egg(shared.Selected_Egg, shared.Triple_Hatch)
    end
end)

sec:Toggle("Triple Hatch", false,"Triple Hatch", function(t)
    shared.Triple_Hatch = t
end)

sec:Dropdown("Select Egg", shared.Eggs,"Basic Egg | 50","Select Egg", function(t)
    print(t:gsub(" | %d+", ""))
end)

local sec = tab:Section("Misc")

sec:Toggle("Auto Rebirth", false,"Rebirth", function(t)
    getgenv()["Rebirth"] = t

    while getgenv()["Rebirth"] == true do
        task.wait(0.05)
        pcall(Rebirth)
    end
end)

sec:Toggle("Auto Upgrade Pets", false,"Upgrade Pets", function(t)
    getgenv()["Upgrade Pets"] = t

    while getgenv()["Upgrade Pets"] == true do
        task.wait(0.05)
        Upgrade_Pets()
    end
end)