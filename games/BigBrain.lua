local plr           = game.Players.LocalPlayer
local character     = plr.Character
local BookRemote    = game:GetService("ReplicatedStorage").Remotes.BookClicked
local BuyBookRemote = game:GetService("ReplicatedStorage").Remotes.BuyBook
local SellPart      = game:GetService("Workspace").SellPart
local Books         = {}
local Gamepasses    = plr.Gamepasses
local Coins         = game:GetService("Workspace").Coins

for i,v in next, game:GetService("ReplicatedStorage").Books:GetChildren() do
    table.insert(Books, v.Name)
end

local function GetTool()
    pcall(function()
        character.Humanoid:EquipTool(plr.Backpack:FindFirstChildOfClass("Tool"))
    end)
    local Tool = character:FindFirstChildOfClass("Tool")
    return Tool
end

local function DoBook()
    BookRemote:FireServer(GetTool().Name)
end

local function Sell()
    character.HumanoidRootPart.CFrame = CFrame.new(-56.2811089, 2.87328005, -45.3561172, 0.997636497, 1.82228757e-08, 0.0687124208, -1.66866272e-08, 1, -2.29316175e-08, -0.0687124208, 2.17308411e-08, 0.997636497)
end

local function Upgrade()
    game:GetService("ReplicatedStorage").Remotes.UpgradeCapacity:FireServer()
end

local function BuyBooks()
    for i,v in next, Books do
        BuyBookRemote:FireServer(v)
    end
end

local function GetGamepasses()
    for i,v in next, Gamepasses:GetChildren() do
        if v.Value == false then
            v.Value = true
        end
    end
end

local function BringCoins()
    for i,v in next, Coins:GetChildren() do
        if v:FindFirstChild("RootPart") then
            v.RootPart.CFrame = character.HumanoidRootPart.CFrame
        end
    end
end

local SolarisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stebulous/solaris-ui-lib/main/source.lua"))()

local win = SolarisLib:New({
  Name = "Soggyware Big Brain Simulator",
  FolderToSave = "BigBS_SGWR"
})

local tab = win:Tab("Tab 1")

local sec = tab:Section("Elements")

sec:Toggle("Auto Do Book", false,"Do Book", function(t)
    getgenv()["Do Book"] = t

    while getgenv()["Do Book"] == true do
        task.wait(0.05)
        pcall(DoBook)
    end
end)

sec:Toggle("Auto Buy Books", false,"BuyBooks", function(t)
    getgenv()["BuyBooks"] = t

    while getgenv()["BuyBooks"] == true do
        task.wait(0.05)
        pcall(BuyBooks)
    end
end)

sec:Toggle("Auto Sell", false,"Auto Sell", function(t)
    getgenv()["Auto Sell"] = t

    while getgenv()["Auto Sell"] == true do
        task.wait(0.05)
        pcall(Sell)
    end
end)

sec:Toggle("Auto Upgrade Capacity", false,"Upgrade Capacity", function(t)
    getgenv()["Upgrade Capacity"] = t

    while getgenv()["Upgrade Capacity"] == true do
        task.wait(0.05)
        pcall(Upgrade)
    end
end)

sec:Toggle("Auto Bring Coins", false,"Bring Coins", function(t)
    getgenv()["Bring Coins"] = t

    while getgenv()["Bring Coins"] == true do
        task.wait(0.05)
        pcall(BringCoins)
    end
end)

local sec = tab:Section("Misc")

sec:Button("Get Gamepasses", function()
    pcall(GetGamepasses)
end)