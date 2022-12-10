local Util = {}
do
    setmetatable(Util, {
        __call = function(table, service)
            return game:GetService(service)
        end
    })
    Util.Network = {}
    function Util.Network:Call(functionName, ...)
        for i,v in next, Util("ReplicatedStorage"):GetDescendants() do
            if v.Name == functionName and v:IsA("RemoteFunction") then
                v:InvokeServer(...)
            end
        end
    end
    function Util.Network:Fire(remoteName, ...)
        for i,v in next, Util("ReplicatedStorage"):GetDescendants() do
            if v.Name == remoteName and v:IsA("RemoteEvent") then
                v:FireServer(...)
            end
        end
    end
    function Util.Network:Fetch(name, type)
        for i,v in next, Util("ReplicatedStorage"):GetDescendants() do
            if v.Name == name and v:IsA(type) then
                return v
            end
        end
    end
end

local UtilLib = Util
local Utils = {}
local Network = UtilLib.Network
local workspace = UtilLib("Workspace")
local clients = UtilLib("Players")
local client = clients.LocalPlayer
local replicated = UtilLib("ReplicatedStorage")
local _delay1
local _delay2
local _delay3
local _delay4
local _delay5

Utils.Deposit = function()
    for i = 1,50 do
        Network:Fire("DepositDrops", i)
    end
end

Utils.Collect = function()
    table.foreach(workspace.Drops:GetChildren(), function(a,b)
        b:PivotTo(client.Character:GetPivot())
    end)
end

Utils.BuyDropper = function()
    for i = 1,50 do
        Network:Fire("DepositDrops", i)
    end
end

Utils.Merge = function()
    Network:Fire("MergeDroppers")
end

Utils.BuySpeed = function()
    Network:Fire("BuySpeed")
end

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
	Name = "Monkey Tycoon",
	LoadingTitle = "Soggyware",
	LoadingSubtitle = "- 2021-2022 -",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "Soggyware",
		FileName = "Monkey Tycoon"
	},
	Discord = {
		Enabled = true,
		Invite = "bBZxdAhS9J",
		RememberJoins = true
	}
})

local Tab = Window:CreateTab("Home Tab", 11600721595)

Tab:CreateSection("Information")

Tab:CreateLabel("Release")

local Tab = Window:CreateTab("Farming Tab", 11631101054)

Tab:CreateSection("Deposit Bananas")

Tab:CreateToggle({
	Name = "Auto Deposit Bananas",
	CurrentValue = false,
	Flag = "Auto Deposit Bananas",
	Callback = function(x)
		getgenv()["Auto Deposit Monkies"] = x
		while getgenv()["Auto Deposit Monkies"] do
			task.wait(_delay1)
			if getgenv()["Auto Deposit Monkies"] == false then
				return
			end
            if client.PlayerGui.MainUI.DropsInventory.Amount.Amount.Text ~= 0 then
                Utils.Deposit()
            end
		end
	end
})

Tab:CreateSlider({
	Name = "Deposit Delay",
	Range = {
		0,
		60
	},
	Increment = 1,
	Suffix = "Seconds",
	CurrentValue = 30,
	Flag = "Deposit Delay",
	Callback = function(x)
		_delay1 = x
	end
})

Tab:CreateSection("Collect Bananas")

Tab:CreateToggle({
	Name = "Auto Collect Bananas",
	CurrentValue = false,
	Flag = "Auto Collect Monkies",
	Callback = function(x)
		getgenv()["Auto Collect Monkies"] = x
		while getgenv()["Auto Collect Monkies"] do
			task.wait(_delay2)
			if getgenv()["Auto Collect Monkies"] == false then
				return
			end
            Utils.Collect()
		end
	end
})

Tab:CreateSlider({
	Name = "Collect Delay",
	Range = {
		0,
		60
	},
	Increment = 1,
	Suffix = "Seconds",
	CurrentValue = 30,
	Flag = "Collect Delay",
	Callback = function(x)
		_delay2 = x
	end
})

Tab:CreateSection("Merge Monkies")

Tab:CreateToggle({
	Name = "Auto Merge Monkies",
	CurrentValue = false,
	Flag = "Auto Merge Monkies",
	Callback = function(x)
		getgenv()["Auto Merge Monkies"] = x
		while getgenv()["Auto Merge Monkies"] do
			task.wait(_delay3)
			if getgenv()["Auto Merge Monkies"] == false then
				return
			end
            Utils.Merge()
		end
	end
})

Tab:CreateSlider({
	Name = "Merge Delay",
	Range = {
		0,
		60
	},
	Increment = 1,
	Suffix = "Seconds",
	CurrentValue = 30,
	Flag = "Merge Delay",
	Callback = function(x)
		_delay3 = x
	end
})

Tab:CreateSection("Buy Droppers")

Tab:CreateToggle({
	Name = "Auto Buy Droppers",
	CurrentValue = false,
	Flag = "Auto Buy Droppers",
	Callback = function(x)
		getgenv()["Auto Buy Droppers"] = x
		while getgenv()["Auto Buy Droppers"] do
			task.wait(_delay4)
			if getgenv()["Auto Buy Droppers"] == false then
				return
			end
            Utils.BuyDropper()
		end
	end
})

Tab:CreateSlider({
	Name = "Buy Delay",
	Range = {
		0,
		60
	},
	Increment = 1,
	Suffix = "Seconds",
	CurrentValue = 30,
	Flag = "Buy Delay",
	Callback = function(x)
		_delay4 = x
	end
})

Tab:CreateSection("Buy Rate")

Tab:CreateToggle({
	Name = "Auto Buy Rate",
	CurrentValue = false,
	Flag = "Auto Buy Rate",
	Callback = function(x)
		getgenv()["Auto Buy Rate"] = x
		while getgenv()["Auto Buy Rate"] do
			task.wait(_delay5)
			if getgenv()["Auto Buy Rate"] == false then
				return
			end
            Utils.BuySpeed()
		end
	end
})

Tab:CreateSlider({
	Name = "Rate Delay",
	Range = {
		0,
		60
	},
	Increment = 1,
	Suffix = "Seconds",
	CurrentValue = 30,
	Flag = "Rate Delay",
	Callback = function(x)
		_delay5 = x
	end
})

loadstring(game:HttpGet("https://soggyhubv2.vercel.app/Libs/RayfieldTabs.lua"))()(Window)

Rayfield:LoadConfiguration()