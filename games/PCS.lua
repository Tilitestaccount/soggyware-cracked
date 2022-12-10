local Player = game.Players.LocalPlayer
local Name = Player.Name
local Plot = workspace.Plots[Player.Name]

local function PickUp(pet)
    local args = {[1]=pet}
    game:GetService("ReplicatedStorage").Functions.TakeBlock:FireServer(unpack(args))
end

local function Drop()
    game:GetService("ReplicatedStorage").Functions.DropBlock:FireServer()
end

local function UpgradeTier()
    local args = {[1]="SpawnTier"}
    game:GetService("ReplicatedStorage").Functions.BuyUpgrade:FireServer(unpack(args))    
end

local function UpgradeBlocks()
    local args = {[1]="MaxBlocks"}
    game:GetService("ReplicatedStorage").Functions.BuyUpgrade:FireServer(unpack(args))    
end

local function UpgradeSpawnRate()
    local args = {[1]="Cooldown"}
    game:GetService("ReplicatedStorage").Functions.BuyUpgrade:FireServer(unpack(args))    
end

local function MergePets()
    for i,v in next, Plot.Blocks:GetChildren() do
        for i2,v2 in next, Plot.Blocks:GetChildren() do
            if (v2~=v and v.BillboardGui.Number.Text == v2.BillboardGui.Number.Text) then
                PickUp(v)
                Player.Character.HumanoidRootPart.CFrame = v2.CFrame + v2.CFrame.LookVector * -3.5
                task.wait(0.2)
                task.delay(0.2, Drop)
            end
        end
        task.wait(0.2)
    end
end

local function Rebirth()
    game:GetService("ReplicatedStorage").Functions.Rebirth:InvokeServer()
end

local Toggles = setmetatable({},{
    AutoMerge = false,
    AutoSpawnRate = false,
    AutoTier = false,
    AutoBlocks = false,
    AutoRebirth = false
})

local Toggles = getrawmetatable(Toggles)

task.spawn(function()
    while task.wait() do
        if Toggles.AutoMerge then
            pcall(function()
                MergePets()
            end)      
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if Toggles.AutoSpawnRate then
            pcall(function()
                UpgradeSpawnRate()
            end)     
        end
    end
end)
task.spawn(function()
    while task.wait()  do
        if Toggles.AutoTier then
            pcall(function()
                UpgradeTier()
            end)
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if Toggles.AutoBlocks then
            pcall(function()
                UpgradeBlocks()
            end) 
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if Toggles.AutoRebirth then
            pcall(function()
                Rebirth()
            end) 
        end
    end
end)

local SolarisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stebulous/solaris-ui-lib/main/source.lua"))()

local win = SolarisLib:New({
  Name = "Pet Crafting Simulator",
  FolderToSave = "Pet Crafting Simulator"
})

local tab = win:Tab("Tab 1")

local sec = tab:Section("Main")

sec:Toggle("Auto Merge", false, "Auto Merge", function(x)
    pcall(function()
        Toggles.AutoMerge = SolarisLib.Flags["Auto Merge"].Value
    end)
end)

sec:Toggle("Auto Rebirth", false, "Auto Rebirth", function(x)
    pcall(function()
        Toggles.AutoRebirth = SolarisLib.Flags["Auto Rebirth"].Value
    end)
end)

local sec = tab:Section("Upgrades")

sec:Toggle("Auto Upgrade Spawn Rate", false, "Auto Upgrade Spawn Rate", function(x)
    pcall(function()
        Toggles.AutoSpawnRate = SolarisLib.Flags["Auto Upgrade Spawn Rate"].Value
    end)
end)

sec:Toggle("Auto Upgrade Tier", false, "Auto Upgrade Tier", function(x)
    pcall(function()
        Toggles.AutoTier = SolarisLib.Flags["Auto Upgrade Tier"].Value
    end)
end)

sec:Toggle("Auto Upgrade Blocks", false, "Auto Upgrade Blocks", function(x)
    pcall(function()
        Toggles.AutoBlocks = SolarisLib.Flags["Auto Upgrade Blocks"].Value
    end)
end)