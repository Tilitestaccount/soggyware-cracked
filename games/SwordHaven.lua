local a = game.Players.LocalPlayer
local b = a.Character
local c = b.HumanoidRootPart
local Attack = game:GetService("ReplicatedStorage").Remote.Combat.Server.RequestAttack
local Tokens = game:GetService("Workspace").Tokens
local ZoneContainer = game:GetService("Workspace").Instance.Regular["1"].Zones
local Zones = {}
local Codes = {}
local SecretCodes = game:GetService("Workspace").Instance.Regular["1"].Interactive.SecretCodes
local SelectedZone = "1"
local PetIds = (function()
	local tab = {}
	for i, v in next, getgc(true) do
		if typeof(v) == "table" then
			if rawget(v, game:GetService("Workspace").PlayerData[tostring(game.Players.LocalPlayer.UserId)].Swords:FindFirstChildOfClass("Model").Name) then
				tab = v
			end
		end
	end
	return tab
end)()
local Enchants = game:GetService("Players").LocalPlayer.PlayerGui.Main.Center.Inventory.Background.Tabs.Enchants.List

local function GetEnchants()
	local b = {}
	for i, v in next, Enchants:GetChildren() do
		if v:IsA("ImageButton") then
			if v.Name ~= "Unoccupied" then
				table.insert(b, v.Name)
			end
		end
	end
	return b
end

local function EnchantPets()
	local enchanted = {}
	for i,v in next, PetIds do
		if not table.find(enchanted, i) then
			local encahtns = GetEnchants()
			local args = {[1]=encahtns[math.random(1,#encahtns)],[2]=i}
			game:GetService("ReplicatedStorage").Remote.Enchant.Server.ApplyEnchant:InvokeServer(unpack(args))
			table.insert(enchanted, i)
		end
	end
end

for i, v in next, SecretCodes:GetDescendants() do
	if v:IsA("TextLabel") and v.Name == "Code" then
		table.insert(Codes, v.Text)
	end
end

for i, v in next, ZoneContainer:GetChildren() do
	table.insert(Zones, v.Name)
end

local function getClosest()
	local closestDistance, closestObject = math.huge, nil
	for _, v in ipairs(ZoneContainer[SelectedZone].Mobs:GetChildren()) do
		if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
			local distance = game:GetService("Players").LocalPlayer:DistanceFromCharacter(v.HumanoidRootPart.Position)
			if distance < closestDistance then
				closestDistance = distance
				closestObject = v
			end
		end
	end
	return closestObject
end

local _speed = 500
function tp(...)
	local plr = game.Players.LocalPlayer
	local args = {
		...
	}
	if typeof(args[1]) == "number" and args[2] and args[3] then
		args = Vector3.new(args[1], args[2], args[3])
	elseif typeof(args[1]) == "Vector3" then
		args = args[1]
	elseif typeof(args[1]) == "CFrame" then
		args = args[1].Position
	end
	local dist = (plr.Character.HumanoidRootPart.Position - args).Magnitude
	game:GetService("TweenService"):Create(
        plr.Character.HumanoidRootPart,
        TweenInfo.new(dist / _speed, Enum.EasingStyle.Linear),
        {
		CFrame = CFrame.new(args)
	}
    ):Play()
end

local function GetTokens()
	for i, v in next, Tokens:GetChildren() do
		v.Root.Position = c.Position
	end
end

local Achievements = {}

for i, v in next, getgc(true) do 
	if typeof(v) == "table" then
		if rawget(v, "EnemiesSlain") then
			for i2, v2 in next, v do
				table.insert(Achievements, tostring(i2))
			end
			break
		end
	end
end

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
	Name = "Sword Haven",
	LoadingTitle = "Soggyware",
	LoadingSubtitle = "- 2021-2022 -",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "Soggyware",
		FileName = "Sword Haven"
	},
	Discord = {
		Enabled = true,
		Invite = "bBZxdAhS9J",
		RememberJoins = true
	}
})

local Tab = Window:CreateTab("Main Tab", 4483362458)

local Section = Tab:CreateSection("Farming")

Tab:CreateToggle({
	Name = "Kill Aura",
	CurrentValue = false,
	Flag = "Kill Aura",
	Callback = function(x)
		getgenv()["Kill Aura"] = x
		while getgenv()["Kill Aura"] do
			task.wait()
			task.wait(0.5)
			pcall(function()
				if getgenv()["Kill Aura"] == false then
					return
				end
				Attack:FireServer()
			end)
		end
	end
})

local Target = nil
local SelectedChest = "1"
local TripleHatch = false

Tab:CreateToggle({
	Name = "Go To Closest Mob In Selected Area",
	CurrentValue = false,
	Flag = "Go To Closest Mob In Selected Area",
	Callback = function(x)
		getgenv()["Go To Closest Mob In Selected Area"] = x
		while getgenv()["Go To Closest Mob In Selected Area"] do
			task.wait(0.5) 
			pcall(function()
				if getgenv()["Go To Closest Mob In Selected Area"] == false then
					return
				end
				Target = getClosest()
				tp(Target.HumanoidRootPart.Position)
			end)
		end
	end
})

Tab:CreateDropdown({
	Name = "Select Zone",
	Options = Zones,
	CurrentOption = "1",
	Flag = "Select Zone",
	Callback = function(x)
		SelectedZone = x
	end,
})

local Section = Tab:CreateSection("Tokens")

Tab:CreateToggle({
	Name = "Bring / Collect Tokens",
	CurrentValue = false,
	Flag = "Bring / Collect Tokens",
	Callback = function(x)
		getgenv()["Bring / Collect Tokens"] = x
		while getgenv()["Bring / Collect Tokens"] do
			task.wait(0.5) 
			pcall(function()
				if getgenv()["Bring / Collect Tokens"] == false then
					return
				end
				GetTokens()
			end)
		end
	end
})

local Section = Tab:CreateSection("Player")

Tab:CreateSlider({
	Name = "Walk Speed",
	Range = {0, 1000},
	Increment = 1,
	Suffix = "Walkspeed",
	CurrentValue = 25,
	Flag = "Walk Speed",
	Callback = function(x)
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = x
	end,
})

Tab:CreateSlider({
	Name = "Jump Power",
	Range = {0, 1000},
	Increment = 1,
	Suffix = "Jump Power",
	CurrentValue = 50,
	Flag = "Jump Power",
	Callback = function(x)
		game.Players.LocalPlayer.Character.Humanoid.JumpPower = x
	end,
})

local Tab = Window:CreateTab("Pets", 4483362458)

local Section = Tab:CreateSection("Eggs / Chests")

Tab:CreateToggle({
	Name = "Auto Open Chest / Egg",
	CurrentValue = false,
	Flag = "Auto Open Chest / Egg",
	Callback = function(x)
		getgenv()["Auto Open Chest / Egg"] = x
		while getgenv()["Auto Open Chest / Egg"] do
			task.wait()
			task.wait(1)
			pcall(function()
				if getgenv()["Auto Open Chest / Egg"] == false then
					return
				end
				game:GetService("ReplicatedStorage").Remote.Player.Server.OpenChest:InvokeServer(TripleHatch == true and 3 or TripleHatch == false and 1 or 1, SelectedChest)		
			end)
		end
	end
})

Tab:CreateToggle({
	Name = "Triple Open / Hatch",
	CurrentValue = false,
	Flag = "Triple Open / Hatch",
	Callback = function(x)
		TripleHatch = x
	end
})

Tab:CreateDropdown({
	Name = "Select Chest / Egg",
	Options = Zones,
	CurrentOption = "1",
	Flag = "Select Chest / Egg",
	Callback = function(x)
		SelectedChest = x
	end,
})

Tab:CreateButton({
	Name = "Go To Selected Chest / Egg",
	Callback = function()
		tp(game:GetService("Workspace").Instance.Regular["1"].Chests[SelectedChest].SwordListUI.Position)
	end
})

local Section = Tab:CreateSection("Enchants")

Tab:CreateToggle({
	Name = "Auto Enchant Swords",
	CurrentValue = false,
	Flag = "Auto Enchant Swords",
	Callback = function(x)
		getgenv()["Auto Enchant Swords"] = x
		while getgenv()["Auto Enchant Swords"] do
			task.wait()
			task.wait(1)
			pcall(function()
				if getgenv()["Auto Enchant Swords"] == false then
					return
				end
				EnchantPets()		
			end)
		end
	end
})

local Tab = Window:CreateTab("Packs Tab", 4483362458)

local Section = Tab:CreateSection("Packs")

local SelectedPack = "A"

Tab:CreateDropdown({
	Name = "Select Pack",
	Options = {
		"Rare Pack",
		"Epic Pack",
		"Legendary Pack",
		"Mythic Pack"
	},
	CurrentOption = "1",
	Flag = "Select Pack",
	Callback = function(x)
		local b = x == "Rare Pack" and "1" or x == "Epic Pack" and x == "2" or x == "Legendary Pack" and "3" or x == "Mythic Pack" and "4"
		SelectedPack = b
	end,
})

Tab:CreateToggle({
	Name = "Auto Open Pack",
	CurrentValue = false,
	Flag = "Auto Open Pack",
	Callback = function(x)
		getgenv()["Auto Open Pack"] = x
		while getgenv()["Auto Open Pack"] do
			task.wait()
			task.wait(1)
			pcall(function()
				if getgenv()["Auto Open Pack"] == false then
					return
				end
				game:GetService("ReplicatedStorage").Remote.Mount.Server.OpenPack:InvokeServer(SelectedPack)					
			end)
		end
	end
})

Tab:CreateToggle({
	Name = "Auto Buy Pack",
	CurrentValue = false,
	Flag = "Auto Buy Pack",
	Callback = function(x)
		getgenv()["Auto Buy Pack"] = x
		while getgenv()["Auto Buy Pack"] do
			task.wait()
			task.wait(1)
			pcall(function()
				if getgenv()["Auto Buy Pack"] == false then
					return
				end
				game:GetService("ReplicatedStorage").Get.Client.UI.Store.Products:FireServer(SelectedPack)				
			end)
		end
	end
})

Tab:CreateToggle({
	Name = "Auto Claim Rewards From Pack",
	CurrentValue = false,
	Flag = "Auto Claim Rewards From Pack",
	Callback = function(x)
		getgenv()["Auto Claim Rewards From Pack"] = x
		while getgenv()["Auto Claim Rewards From Pack"] do
			task.wait()
			task.wait(1)
			pcall(function()
				if getgenv()["Auto Claim Rewards From Pack"] == false then
					return
				end
				for i, v in next, game:GetService("Players").LocalPlayer.PlayerGui.Main.Full.CardOpening.Center:GetDescendants() do
					if v:IsA("ImageButton") then
						for i2, v2 in next, {
							"MouseButton1Click",
							"Activated",
							"MouseButton1Down",
							"MouseButton1Up"
						} do
							firesignal(v[v2])
						end
					end
				end
			end)
		end
	end
})

local Tab = Window:CreateTab("Misc Tab", 4483362458)

local Section = Tab:CreateSection("Codes")

Tab:CreateButton({
	Name = "Redeem Secret Codes",
	Callback = function()
		for i, v in next, Codes do
			task.wait(1)
			game:GetService("ReplicatedStorage").Remote.Player.Server.RedeemCode:InvokeServer(v)	
		end
	end
})

local Section = Tab:CreateSection("Claimables")

Tab:CreateToggle({
	Name = "Auto Collect Gifts",
	CurrentValue = false,
	Flag = "Auto Collect Gifts",
	Callback = function(x)
		getgenv()["Auto Collect Gifts"] = x
		while getgenv()["Auto Collect Gifts"] do
			task.wait(1)
			task.wait()
			pcall(function()
				if getgenv()["Auto Collect Gifts"] == false then
					return
				end
				for i = 1, 12 do
					task.wait(1)
					game:GetService("ReplicatedStorage").Remote.Reward.Server.Claim:InvokeServer(2, i)
				end
			end)
		end
	end
})

Tab:CreateToggle({
	Name = "Auto Collect Achievements",
	CurrentValue = false,
	Flag = "Auto Collect Achievements",
	Callback = function(x)
		getgenv()["Auto Collect Achievements"] = x
		while getgenv()["Auto Collect Achievements"] do
			task.wait(0.5)
			task.wait()
			pcall(function()
				if getgenv()["Auto Collect Achievements"] == false then
					return
				end
				for i, v in next, Achievements do
					task.wait(0.5)
					game:GetService("ReplicatedStorage").Remote.Player.Server.ClaimAchievement:InvokeServer(v)
				end
			end)
		end
	end
})

local Section = Tab:CreateSection("Boosts")

Tab:CreateToggle({
	Name = "Auto Use Boosts",
	CurrentValue = false,
	Flag = "Auto Use Boosts",
	Callback = function(x)
		getgenv()["Auto Use Boosts"] = x
		while getgenv()["Auto Use Boosts"] do
			task.wait(1)
			task.wait(1)
			pcall(function()
				if getgenv()["Auto Use Boosts"] == false then
					return
				end
				for i = 1, 4 do
					game:GetService("ReplicatedStorage").Remote.Potion.Server.ActivatePotion:InvokeServer(i)
				end
			end)
		end
	end
})

local Section = Tab:CreateSection("Worlds")

Tab:CreateToggle({
	Name = "Auto Buy Worlds",
	CurrentValue = false,
	Flag = "Auto Buy Worlds",
	Callback = function(x)
		getgenv()["Auto Buy Worlds"] = x
		while getgenv()["Auto Buy Worlds"] do
			task.wait(1)
			task.wait(1)
			pcall(function()
				if getgenv()["Auto Buy Worlds"] == false then
					return
				end
				for i = 1, 12 do
					local args = {
						[1] = {
							["World"] = 1,
							["Zone"] = i
						}
					}
					game:GetService("ReplicatedStorage").Remote.World.Server.PurchaseZone:InvokeServer(unpack(args))
				end
			end)
		end
	end
})

local Section = Tab:CreateSection("Teleports")

Tab:CreateDropdown({
	Name = "Teleport To World / Zone",
	Options = Zones,
	CurrentOption = "1",
	Flag = "Teleport To World / Zone",
	Callback = function(x)
		tp(ZoneContainer[x].TeleportPosition.Position)
	end,
})