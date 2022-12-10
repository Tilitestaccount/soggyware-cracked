local client = game.Players.LocalPlayer
local funcs = {getGamepasses = nil, getEggs = nil}
local remotes = {Mine = nil}
local Remotes = game:GetService("ReplicatedStorage").Remotes
setmetatable(remotes, {
    __index = function(a,b)
        if b == "Mine" then
            return Remotes["mineEvent"]
        end
        if b == "Egg" then
            return Remotes["requestEgg"]
        end
    end
})
setmetatable(funcs, {
    __index = function(a,b)
        local a = {
            getGamepasses = function()
                require(game:GetService("ReplicatedStorage").Modules.Functions).ownsGamepass = function() return true end
            end,
            getEggs = function()
                local a = {}
                for i,v in next, game:GetService("Workspace").Eggs:GetChildren() do
                    if not v.Name:find("%p") then
                        table.insert(a, v.Name)
                    end
                end
                table.sort(a, function(a,b)
                    return a < b
                end)
                return a
            end
        }
        return a[b]
    end
})


local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local Window = Rayfield:CreateWindow({
    Name = "Pickaxe Simulator",
    LoadingTitle = "Soggyware",
    LoadingSubtitle = "- 2021-2022 -",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "Soggyware",
        FileName = "Pickaxe Simulator"
    },
    Discord = {
        Enabled = true,
        Invite = "bBZxdAhS9J",
        RememberJoins = true
    }
})

local Tab = Window:CreateTab("Home Tab", 11600721595)

local Section = Tab:CreateSection("Information")

Tab:CreateLabel("Release | V1.0")

local Tab = Window:CreateTab("Farming Tab", 11600741115)

local Section = Tab:CreateSection("Farming")

Tab:CreateToggle({
	Name = "Auto Mine",
	CurrentValue = false,
	Flag = "Auto Mine",
	Callback = function(x)
		getgenv()["Auto Mine"] = x
		while getgenv()["Auto Mine"] do
			task.wait(0.1)
			if getgenv()["Auto Mine"] == false then
				return
			end
            remotes.Mine:FireServer("Mine")
            client.Debounces.Mine.Value = false
		end
	end
})

local Tab = Window:CreateTab("Pet Tab", 11600742450)

local Section = Tab:CreateSection("Eggs")

Tab:CreateDropdown({
	Name = "Select Egg",
	Options = funcs.getEggs(),
	CurrentOption = "",
	Flag = "Select Egg",
	Callback = function(x)
		getgenv()["Selected Egg"] = game:GetService("Workspace").Eggs[x]
	end
})

Tab:CreateToggle({
	Name = "Auto Hatch Selected Egg",
	CurrentValue = false,
	Flag = "Auto Hatch Selected Egg",
	Callback = function(x)
		getgenv()["Auto Hatch Selected Egg"] = x
		while getgenv()["Auto Hatch Selected Egg"] do
			task.wait(0.5)
			if getgenv()["Auto Hatch Selected Egg"] == false then
				return
			end
            remotes.Egg:FireServer("Open", getgenv()["Selected Egg"])
		end
	end
})

local Tab = Window:CreateTab("Misc Tab", 11600761450)

local Section = Tab:CreateSection("Gamepasses")

Tab:CreateButton({
    Name = "Get Gamepasses",
    Callback = funcs.getGamepasses
})

loadstring(game:HttpGet("https://hastebin.com/zafecisete.lua"))()(Window)