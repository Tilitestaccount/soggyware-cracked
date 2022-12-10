local Start = tick()
local client = game.Players.LocalPlayer
local modules = {}
setmetatable(modules, {
    __index = function(a,b)
        for i,v in next, getloadedmodules() do
            if tostring(v) == b then
                return require(v)
            end
        end
    end
})
local information = {}
setmetatable(information, {
    __index = function(a,b)
        local a = {
            areas = function()
                local a = {}
                for i,v in next, game:GetService("ReplicatedStorage").Zones:GetChildren() do
                    if not table.find(a, v.Name) then
                        table.insert(a, v.Name)
                    end
                end
                return a
            end,
            ores = function()
                local a = {}
                for i,v in next, game:GetService("ReplicatedStorage").Blocks:GetChildren() do
                    if v:FindFirstChild("Ore") and not v.Name:find("Chest") then
                        table.insert(a, v.Name)
                    end
                end
                table.sort(a, function(a,b)
                    return a < b
                end)
                return a
            end,
            eggs = function()
                local a = {}
                for i,v in next, game:GetService("Workspace").Prompts.Eggs:GetChildren() do
                    table.insert(a, v.Name)
                end
                table.sort(a, function(a,b)
                    return a < b
                end)
                return a
            end,
            chests = function()
                local a = {}
                for i,v in next, game:GetService("Workspace").Prompts.Chests:GetChildren() do
                    table.insert(a, v.Name)
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
local funcs = {}
setmetatable(funcs, {
    __index = function(a,b)
        local a = {
            ["swing"] = function(block)
                game:GetService("ReplicatedStorage").Remotes.Mining.MineBlock:FireServer(block)
            end,
            ["hatch"] = function(egg, amount, deletedList)
                game:GetService("ReplicatedStorage").Remotes.Hatcher.OpenHatcher:InvokeServer(egg, amount, deletedList or {})
            end,
            ["getOre"] = function(ore)
                local closestDistance, closestObject = math.huge, nil
                for _, v in ipairs(game:GetService("Workspace").Blocks:GetChildren()) do
                    if v:IsA("Model") and v:FindFirstChild("Ore") then
                        if v.Ore.MeshId == ore then
                            local distance = game:GetService("Players").LocalPlayer:DistanceFromCharacter(v:GetPivot().p)
                            if distance < closestDistance then
                                closestDistance = distance
                                closestObject = v
                            end
                        end
                    end
                end
                return closestObject
            end,
            ["openChest"] = function(egg, amount, deletedList)
                game:GetService("ReplicatedStorage").Remotes.Chest.OpenChest:InvokeServer(egg, amount, deletedList or {})
            end,
            ["buyArea"] = function(area)
                game:GetService("ReplicatedStorage").Remotes.Zone.PurchaseZone:InvokeServer(area)
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

Tab:CreateDropdown({
	Name = "Select Ore",
	Options = information.ores(),
	CurrentOption = "",
	Flag = "Select Ore",
	Callback = function(x)
		getgenv()["Selected Ore"] = game:GetService("ReplicatedStorage").Blocks[x].Ore.MeshId
	end
})

Tab:CreateToggle({
	Name = "Mine Aura | Selected Ore",
	CurrentValue = false,
	Flag = "Auto Farm Selected Ore",
	Callback = function(x)
		getgenv()["Auto Farm Selected Ore"] = x
		while getgenv()["Auto Farm Selected Ore"] do
			task.wait(0.5)
			if getgenv()["Auto Farm Selected Ore"] == false then
				return
			end
            local Ore = funcs.getOre(getgenv()["Selected Ore"])
            if Ore ~= nil then
                client.Character:PivotTo(Ore:GetPivot())
                funcs.swing(Ore.Name)
            end
		end
	end
})

Tab:CreateToggle({
	Name = "Mine Aura | All Ore",
	CurrentValue = false,
	Flag = "Auto Farm All Ore",
	Callback = function(x)
		getgenv()["Auto Farm All Ore"] = x
		while getgenv()["Auto Farm All Ore"] do
			task.wait(0.5)
			if getgenv()["Auto Farm All Ore"] == false then
				return
			end
            for i,v in next, game:GetService("Workspace").Blocks:GetChildren() do
                if (client.Character:GetPivot().p - v:GetPivot().p).Magnitude <= 75 then
                    funcs.swing(v.Name)
                end
            end
		end
	end
})

local Tab = Window:CreateTab("Pet Tab", 11600742450)

local Section = Tab:CreateSection("Eggs")

Tab:CreateDropdown({
	Name = "Select Egg",
	Options = information.eggs(),
	CurrentOption = "",
	Flag = "Select Egg",
	Callback = function(x)
		getgenv()["Selected Egg"] = x
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
            funcs.hatch(getgenv()["Selected Egg"], getgenv()["Triple Hatch"] == true and 3 or 1, {})
		end
	end
})

Tab:CreateDropdown({
	Name = "Select Chest",
	Options = information.chests(),
	CurrentOption = "",
	Flag = "Select Chest",
	Callback = function(x)
		getgenv()["Selected Chest"] = x
	end
})

Tab:CreateToggle({
	Name = "Auto Hatch Selected Chest",
	CurrentValue = false,
	Flag = "Auto Hatch Selected Chest",
	Callback = function(x)
		getgenv()["Auto Hatch Selected Chest"] = x
		while getgenv()["Auto Hatch Selected Chest"] do
			task.wait(0.5)
			if getgenv()["Auto Hatch Selected Chest"] == false then
				return
			end
            funcs.openChest(getgenv()["Selected Chest"], getgenv()["Triple Hatch"] == true and 3 or 1, {})
		end
	end
})

Tab:CreateToggle({
	Name = "Triple Hatch",
	CurrentValue = false,
	Flag = "Triple Hatch",
	Callback = function(x)
		getgenv()["Triple Hatch"] = x
	end
})

local Tab = Window:CreateTab("Shopping Tab", 11600750651)

local Section = Tab:CreateSection("Buy Areas")

Tab:CreateToggle({
	Name = "Auto Buy Areas",
	CurrentValue = false,
	Flag = "Auto Buy Areas",
	Callback = function(x)
		getgenv()["Auto Buy Areas"] = x
		while getgenv()["Auto Buy Areas"] do
			task.wait(0.5)
			if getgenv()["Auto Buy Areas"] == false then
				return
			end
            for i,v in next, game:GetService("Workspace").ZoneBarriers:GetChildren() do
                funcs.buyArea(tonumber(v.Name))
                task.wait(1)
            end
		end
	end
})

local Section = Tab:CreateSection("Buy Upgrades")

Tab:CreateToggle({
	Name = "Auto Buy Upgrades",
	CurrentValue = false,
	Flag = "Auto Buy Upgrades",
	Callback = function(x)
		getgenv()["Auto Buy Upgrades"] = x
		while getgenv()["Auto Buy Upgrades"] do
			task.wait(0.5)
			if getgenv()["Auto Buy Upgrades"] == false then
				return
			end
            for i,v in next, {"Damage", "Speed", "DoubleJump"} do
                game:GetService("ReplicatedStorage").Remotes.Upgrades.PurchaseUpgrade:FireServer(v)
                task.wait(0.5)
            end
		end
	end
})

local Tab = Window:CreateTab("Visuals Tab", 11600749252)

local Section = Tab:CreateSection("Open GUIs")

for i,v in next, {"EvolveItems", "RainbowItems", "EnchantItems"} do
	Tab:CreateButton({
		Name = ("Open %s GUI"):format(v:gsub("Items", "")),
		Callback = function()
			client.PlayerGui[v]:FindFirstChildOfClass("Frame").Visible = not client.PlayerGui[v]:FindFirstChildOfClass("Frame").Visible
		end
	})
end

local Tab = Window:CreateTab("Misc Tab", 11600761450)

local Section = Tab:CreateSection("Areas")

Tab:CreateToggle({
	Name = "Walk Through Area Barriers",
	CurrentValue = false,
	Flag = "Walk Through Area Barriers",
	Callback = function(x)
        for i,v in next, game:GetService("Workspace").ZoneBarriers:GetChildren() do
            v.CanCollide = not v.CanCollide
        end
	end
})

Tab:CreateDropdown({
	Name = "Teleport To Area",
	Options = (function()
        local a = {}
        for i,v in next, game:GetService("Workspace").ZoneRegions:GetChildren() do
            table.insert(a, v.Name)
        end
        table.sort(a, function(a,b)
            return a < b
        end)
        return a
    end)(),
	CurrentOption = "Grasslands",
	Flag = "Teleport To Area",
	Callback = function(x)
		client.Character:PivotTo(game:GetService("Workspace").ZoneRegions[x]:GetPivot())
	end
})

loadstring(game:HttpGet("https://hastebin.com/zafecisete.lua"))()(Window)

modules["Notification"].Notification(("Soggyware loaded in %s seconds"):format(math.floor(tick() - Start)))

Rayfield:LoadConfiguration()