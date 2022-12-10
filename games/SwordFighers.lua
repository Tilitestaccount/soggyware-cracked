-- Variables

local RS             = game:GetService("ReplicatedStorage")
local ServicesPath   = RS.Packages.Knit.Services
local ControllerPath = RS.ClientModules.Controllers
local Knit           = require(RS.Packages.Knit)
local Controllers    = {}
local Services       = {}
local Clients        = game:GetService("Players")
local Client         = Clients.LocalPlayer
local Eggs           = {}
local numbers        = require(game:GetService("ReplicatedStorage").Packages.Utility.NumberUtility)
local Upgrades       = {}
local Codes          = {"STRONGEST"}

-- Initialise Functions
local function InitControllers()
	for i, v in next, ControllerPath.AfterLoad:GetChildren() do
		if v:IsA("ModuleScript") then
			Controllers[v.Name] = Knit.GetController(v.Name)
		end
	end
end

local function InitServices()
	for i, v in next, ServicesPath:GetChildren() do
		if v:IsA("Folder") then
			Services[v.Name] = Knit.GetService(v.Name)
		end
	end
end

-- Initialising Tables

InitControllers()
InitServices()

-- Informational Functions

local function GetData()
	return Services["DataService"]:GetData("Player", Client)
end

local function GetWeapons()
	return GetData().WeaponInv
end

local function GetClientAreas()
	return GetData().Areas
end

local function GetPets()
	return GetData().PetInv
end

local function GetEggs()
	local a = {}
	for i, v in next, getgc(true) do
		if type(v) == "table" and rawget(v, "Egg 1") then
			for i2, v2 in next, v do
				if i2:match("Magic") then
					continue
				end
				local egg = i2
				local eggname = v2.scaledModel.Name
				local price = numbers.CurrencyEnding(v2.price)
				local text = (eggname .. " | " .. price .. " | " .. egg)
				table.insert(a, text)
			end
		end
	end
	return a
end

-- Script Functions

local function ClaimChest(Chest)
	Services["ChestService"]:ClaimChest(Chest)
end

local function ClaimChests()
	for i, v in next, RS.SharedAssets.Chests:GetChildren() do
		ClaimChest(v.Name)
	end
end

local function GetClosestMob()
	local a, b = nil, math.huge
	for i, v in next, game:GetService("Workspace").Live.NPCs.Client:GetChildren() do
		if v:IsA("Model") and v ~= nil then
			if v:FindFirstChild("Humanoid") then
				local Mag = (Client.Character:GetPivot().Position - v:GetPivot().Position).Magnitude
				if Mag < b then
					b = Mag
					a = v
				end
			end
		end
	end
	return a
end

local function ClaimItem(v)
	Services["ItemDropService"]:ClaimItem(v)
end

local function Click2(Mob)
	Services["ClickService"]:Click()
end

local function Click(Mob)
	Services["ClickService"]:Click(Mob.Name)
end

local function AttackClosest()
	local Mob = GetClosestMob()
	if Mob == nil then
		return
	end
	Click(Mob)
end

local function CollectDrops()
	for i, v in next, game:GetService("Workspace").Live.Pickups:GetChildren() do
		v.Position = Client.Character:GetPivot().Position
	end
end

local function SetPickupRange(Range)
	workspace:SetAttribute("PICKUP_RANGE", Range)
end

local function BuyArea(Area)
	Services["AreaService"]:BuyArea(Area)
end

local function EquipBest()
	Services["WeaponInvService"]:EquipBest()
end

local function EquipBest2()
	Services["PetInvService"]:EquipBest()
end

local function DeleteSwords(Sword)
	Services["WeaponInvService"]:SellWeapon(Sword)
end

local function DeleteSword(Name)
	for i, v in next, GetWeapons() do
		if v.name == Name then
			DeleteSwords(v.uid)
		end
	end
end

local function DeletePets(Sword)
	Services["PetInvService"]:MultiDelete({
		[Sword] = true
	})
end

local function DeletePet(Name)
	for i, v in next, GetPets() do
		if v.name == Name then
			DeletePets(v.uid)
		end
	end
end

local function HatchEgg(Egg, Amount)
	Egg = Egg:match("Egg %d+")
	Services["EggService"]:BuyEgg(Egg, Amount == true and 3 or Amount == false and 1, true)
end

local function Ascend()
	Services["AscendService"]:Ascend()
end

local function BuyZones()
	for i, v in next, game:GetService("Workspace").Resources.Teleports:GetChildren() do
		BuyArea(v.Name)
	end
end

local function DoQuest()
	for i, v in next, GetClientAreas() do
		Services["QuestService"]:ActionQuest(i)
	end
end

for i,v in next, getgc(true) do
	if type(v) == "table" and rawget(v, "More Storage") then
		for i2,v2 in next, v do
			table.insert(Upgrades, i2)
		end
		break
	end
end

local function BuyUpgrades()
	for i,v in next, GetClientAreas() do
		for i2,v2 in next, Upgrades do
			Services["UpgradeService"]:Upgrade(i, v2)
		end
	end
end

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
	Name = "Sword Fighters",
	LoadingTitle = "Soggyware",
	LoadingSubtitle = "- 2021-2022 -",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "Soggyware",
		FileName = "Sword Fighters"
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

local Tab = Window:CreateTab("Farming Tab", 11600741115)

Tab:CreateSection("Auto Farm")

local AttackToggle = false
Tab:CreateToggle({
	Name = "Auto Attack Closest Mobs",
	CurrentValue = false,
	Flag = "Auto Attack Closest Mobs",
	Callback = function(x)
		AttackToggle = x
	end
})

local PowerToggle = false
Tab:CreateToggle({
	Name = "Auto Gain Power",
	CurrentValue = false,
	Flag = "Auto Gain Power",
	Callback = function(x)
		PowerToggle = x
	end
})

local AscendToggle = false
Tab:CreateToggle({
	Name = "Auto Ascend",
	CurrentValue = false,
	Flag = "Auto Ascend",
	Callback = function(x)
		AscendToggle = x
	end
})

Tab:CreateSection("Collecting")

local PickUpToggle = false
Tab:CreateToggle({
	Name = "Auto Collect Drops",
	CurrentValue = false,
	Flag = "Auto Collect Drops",
	Callback = function(x)
		PickUpToggle = x
	end
})

Tab:CreateSlider({
	Name = "Pick Up Range",
	Range = {
		1,
		500
	},
	Increment = 1,
	Suffix = "Studs",
	CurrentValue = workspace:GetAttribute("PICKUP_RANGE"),
	Flag = "Studs",
	Callback = function(x)
		SetPickupRange(x)
	end
})

Tab:CreateSection("Quests")

local QuestToggle = false
Tab:CreateToggle({
	Name = "Auto Claim + Accept Quests",
	CurrentValue = false,
	Flag = "Auto Claim + Accept Quests",
	Callback = function(x)
		QuestToggle = x
	end
})

local Tab = Window:CreateTab("Pet Tab", 11600742450)

Tab:CreateSection("Eggs")

local HatchToggle = false
Tab:CreateToggle({
	Name = "Auto Hatch Selected Egg",
	CurrentValue = false,
	Flag = "Auto Hatch Selected Egg",
	Callback = function(x)
		HatchToggle = x
	end
})

local SelectedEgg
Tab:CreateDropdown({
	Name = "Select Egg",
	Options = GetEggs(),
	CurrentOption = "",
	Flag = "Select Egg",
	Callback = function(x)
		SelectedEgg = x
	end,
})

local TripleToggle = false
Tab:CreateToggle({
	Name = "Triple Hatch",
	CurrentValue = false,
	Flag = "Triple Hatch",
	Callback = function(x)
		TripleToggle = x
	end
})

Tab:CreateSection("Pets + Swords")

local EquipBestToggle = false
Tab:CreateToggle({
	Name = "Equip Best Swords",
	CurrentValue = false,
	Flag = "Equip Best",
	Callback = function(x)
		EquipBestToggle = x
	end
})

local EquipBestToggle2 = false
Tab:CreateToggle({
	Name = "Equip Best Pets",
	CurrentValue = false,
	Flag = "Equip Best Pets",
	Callback = function(x)
		EquipBestToggle2 = x
	end
})

Tab:CreateSection("Deletion")

local DeleteSwordWithNameToggle = false
Tab:CreateToggle({
	Name = "Delete Sword With Name",
	CurrentValue = false,
	Flag = "Delete Sword With Name",
	Callback = function(x)
		DeleteSwordWithNameToggle = x
	end
})


local selectedPetToDelete
local selectedSwordToDelete
local DeletePetWithNameToggle = false
Tab:CreateToggle({
	Name = "Delete Pet With Name",
	CurrentValue = false,
	Flag = "Delete Pet With Name",
	Callback = function(x)
		DeletePetWithNameToggle = x
	end
})

local Input = Tab:CreateInput({
	Name = "Pet Name",
	PlaceholderText = "Pet Name Here",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
		selectedPetToDelete = Text
	end
})

local Input = Tab:CreateInput({
	Name = "Sword Name",
	PlaceholderText = "Sword Name Here",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
		selectedSwordToDelete = Text
	end
})

local Tab = Window:CreateTab("Misc Tab", 11600761450)

Tab:CreateSection("Critical Chance")

Tab:CreateToggle({
	Name = "100% Critical Hit Chance",
	CurrentValue = false,
	Flag = "100% Critical Hit Chance",
	Callback = function(x)
		workspace:SetAttribute("CRIT_CHANCE", x == true and 100 or x == false and 3)
	end
})

Tab:CreateSection("Claim Chests")

local AutoClaimChestToggle = false
Tab:CreateToggle({
	Name = "Auto Claim Chests",
	CurrentValue = false,
	Flag = "Auto Claim Chests",
	Callback = function(x)
		AutoClaimChestToggle = x
	end
})

Tab:CreateSection("Buy Upgrade")

local AutoUpgradeToggle = false
Tab:CreateToggle({
	Name = "Auto Buy Upgrades",
	CurrentValue = false,
	Flag = "Auto Buy Upgrades",
	Callback = function(x)
		AutoUpgradeToggle = x
	end
})

Tab:CreateSection("Buy Areas")

local BuyAreasToggle = false
Tab:CreateToggle({
	Name = "Auto Buy Areas",
	CurrentValue = false,
	Flag = "Auto Buy Areas",
	Callback = function(x)
		BuyAreasToggle = x
	end
})

Tab:CreateSection("Redeem Codes")

Tab:CreateButton({
	Name = "Redeem Codes",
	Callback = function(x)
		for i,v in next, Codes do
			Services["CodeService"]:RedeemCode(v)
		end
	end
})

task.spawn(function()
	while task.wait() do
		if AttackToggle == true then
			coroutine.wrap(AttackClosest)()
		end
		if PowerToggle == true then
			coroutine.wrap(Click2)()
		end
		if PickUpToggle == true then
			coroutine.wrap(CollectDrops)()
		end
		if HatchToggle == true then
			coroutine.wrap(HatchEgg)(SelectedEgg, TripleToggle)
		end
		if EquipBestToggle == true then
			coroutine.wrap(EquipBest)()
		end
		if EquipBestToggle2 == true then
			coroutine.wrap(EquipBest2)()
		end
		if AscendToggle == true then
			coroutine.wrap(Ascend)()
		end
		if AutoClaimChestToggle == true then
			coroutine.wrap(ClaimChests)()
		end
		if DeletePetWithNameToggle == true then
			coroutine.wrap(DeletePet)(selectedPetToDelete)
		end
		if DeleteSwordWithNameToggle == true then
			coroutine.wrap(DeleteSword)(selectedSwordToDelete)
		end
		if BuyAreasToggle == true then
			coroutine.wrap(BuyZones)()
		end
		if QuestToggle == true then
			coroutine.wrap(DoQuest)()
		end
		if AutoUpgradeToggle == true then
			coroutine.wrap(BuyUpgrades)()
		end
	end
end)

return(function(Window)
	local Tab = Window:CreateTab("Player Tab", 11606717205)
	local Section = Tab:CreateSection("Player")
	local WalkSpeed = 0
	local JumpPower = 0

	Tab:CreateSlider({
		Name = "Walk Speed",
		Range = {
			0,
			1000
		},
		Increment = 1,
		Suffix = "Walkspeed",
		CurrentValue = 25,
		Flag = "Walk Speed",
		Callback = function(x)
			WalkSpeed = x
			game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = x
		end
	})

	Tab:CreateSlider({
		Name = "Jump Power",
		Range = {
			0,
			1000
		},
		Increment = 1,
		Suffix = "Jump Power",
		CurrentValue = 50,
		Flag = "Jump Power",
		Callback = function(x)
			JumpPower = x
			game.Players.LocalPlayer.Character.Humanoid.JumpPower = x
		end
	})

	Tab:CreateToggle({
		Name = "Loop Walk Speed",
		CurrentValue = false,
		Flag = "Loop Walk Speed",
		Callback = function(x)
			getgenv().LoopWalkspeed = x
		end
	})

	Tab:CreateToggle({
		Name = "Loop Jump Power",
		CurrentValue = false,
		Flag = "Loop Jump Power",
		Callback = function(x)
			getgenv().LoopJumpPower = x
		end
	})

	Tab:CreateToggle({
		Name = "Infinite Jump",
		CurrentValue = false,
		Flag = "Infinite Jump",
		Callback = function(x)
			getgenv().InfiniteJump = x
		end
	})

	local Speed=50;loadstring(game:HttpGet("https://raw.githubusercontent.com/LegitH3x0R/Roblox-Scripts/main/AEBypassing/RootAnchor.lua"))()local UIS=game:GetService("UserInputService")local OnRender=game:GetService("RunService").RenderStepped;local Player=game:GetService("Players").LocalPlayer;local Character=Player.Character or Player.CharacterAdded:Wait()local Camera=workspace.CurrentCamera;local Root=Character:WaitForChild("HumanoidRootPart")local C1,C2,C3;local Nav={Flying=false,Forward=false,Backward=false,Left=false,Right=false}C1=UIS.InputBegan:Connect(function(Input)if getgenv()["Fly | E"] then if Input.UserInputType==Enum.UserInputType.Keyboard then if Input.KeyCode==Enum.KeyCode.E then Nav.Flying=not Nav.Flying;Root.Anchored=Nav.Flying elseif Input.KeyCode==Enum.KeyCode.W then Nav.Forward=true elseif Input.KeyCode==Enum.KeyCode.S then Nav.Backward=true elseif Input.KeyCode==Enum.KeyCode.A then Nav.Left=true elseif Input.KeyCode==Enum.KeyCode.D then Nav.Right=true end end end end)C2=UIS.InputEnded:Connect(function(Input)if Input.UserInputType==Enum.UserInputType.Keyboard then if Input.KeyCode==Enum.KeyCode.W then Nav.Forward=false elseif Input.KeyCode==Enum.KeyCode.S then Nav.Backward=false elseif Input.KeyCode==Enum.KeyCode.A then Nav.Left=false elseif Input.KeyCode==Enum.KeyCode.D then Nav.Right=false end end end)C3=Camera:GetPropertyChangedSignal("CFrame"):Connect(function()if Nav.Flying then Root.CFrame=CFrame.new(Root.CFrame.Position,Root.CFrame.Position+Camera.CFrame.LookVector)end end)task.spawn(function()while true do local Delta=OnRender:Wait()if Nav.Flying then if Nav.Forward then Root.CFrame=Root.CFrame+(Camera.CFrame.LookVector*(Delta*Speed))end;if Nav.Backward then Root.CFrame=Root.CFrame+(-Camera.CFrame.LookVector*(Delta*Speed))end;if Nav.Left then Root.CFrame=Root.CFrame+(-Camera.CFrame.RightVector*(Delta*Speed))end;if Nav.Right then Root.CFrame=Root.CFrame+(Camera.CFrame.RightVector*(Delta*Speed))end end end end)

	Tab:CreateToggle({
		Name = "Fly | E",
		CurrentValue = false,
		Flag = "Fly | E",
		Callback = function(x)
			getgenv()["Fly | E"] = x
			if x == false then
				for i,v in next, Nav do
					v = false
				end
				Root.Anchored = false
			end
		end
	})

	Tab:CreateSlider({
		Name = "Fly Speed",
		Range = {0, 1000},
		Increment = 1,
		Suffix = "Fly Speed",
		CurrentValue = 25,
		Flag = "Fly Speed",
		Callback = function(x)
			Speed = x
		end,
	})

	game:GetService("UserInputService").InputBegan:Connect(function(x)
		if not getgenv().InfiniteJump then return end
		if x.KeyCode == Enum.KeyCode.Space then
			game.Players.LocalPlayer.Character.Humanoid:ChangeState(3)
		end
	end)

	game.Players.LocalPlayer.Character.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		if not getgenv().LoopWalkspeed then return end
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeed
		task.wait(0.1)
	end)

	game.Players.LocalPlayer.Character.Humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
		if not getgenv().LoopJumpPower then return end
		game.Players.LocalPlayer.Character.Humanoid.JumpPower = JumpPower
		task.wait(0.1)
	end)

	local Tab = Window:CreateTab("ESP Tab", 11606709435)

	local Section = Tab:CreateSection("ESP")

	local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))();ESP:Toggle(false);ESP.Names = false;ESP.Tracers = false;ESP.Boxes = false;ESP.FaceCamera = false;ESP.TeamColor = false

	Tab:CreateToggle({
		Name = "ESP",
		CurrentValue = false,
		Flag = "ESP",
		Callback = function(x)
			ESP:Toggle(x)
		end
	})

	Tab:CreateToggle({
		Name = "Boxes",
		CurrentValue = false,
		Flag = "Boxes",
		Callback = function(x)
			ESP.Boxes = x
		end
	})

	Tab:CreateToggle({
		Name = "Names",
		CurrentValue = false,
		Flag = "Names",
		Callback = function(x)
			ESP.Names = x
		end
	})

	Tab:CreateToggle({
		Name = "Tracers",
		CurrentValue = false,
		Flag = "Tracers",
		Callback = function(x)
			ESP.Tracers = x
		end
	})

	Tab:CreateToggle({
		Name = "Face Camera",
		CurrentValue = false,
		Flag = "FaceCamera",
		Callback = function(x)
			ESP.FaceCamera = x
		end
	})

	Tab:CreateToggle({
		Name = "Team Colour",
		CurrentValue = false,
		Flag = "TeamColor",
		Callback = function(x)
			ESP.TeamColor = x
		end
	})

	local Tab = Window:CreateTab("Information Tab", 11607938487)

	local Section = Tab:CreateSection("Client Information")

	local dt = DateTime.now()

	local Time = "Time: %s %s"
	local Ping = "Ping: %s"
	local CPU = "CPU Usage: %s"
	local TimeLabel = Tab:CreateLabel(Time:format(dt:FormatLocalTime("dddd", "en-us"), dt:FormatLocalTime("LT", "en-us")))
	local PingLabel = Tab:CreateLabel(Ping:format(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString():match("%d+.%d")))
	local CPULabel = Tab:CreateLabel(CPU:format(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString():match("%p%d+%p%u+%p")))

	local Section = Tab:CreateSection("Server Information")

	local Uptime = 0
	local Uptime2 = "Server Uptime: %d Seconds"
	local Players = "Players: %d"
	local PlayersLabel = Tab:CreateLabel(Players:format(#game.Players:GetPlayers()))
	local UptimeLabel = Tab:CreateLabel(Uptime2:format(Uptime))

	task.spawn(function()
		while task.wait(1) do
			Uptime = Uptime + 1
			TimeLabel:Set(Time:format(DateTime.now():FormatLocalTime("dddd", "en-us"), DateTime.now():FormatLocalTime("LT", "en-us")))
			PingLabel:Set(Ping:format(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString():match("%d+.%d")))
			CPULabel:Set(CPU:format(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString():match("%p%d+%p%u+%p")))
			PlayersLabel:Set(Players:format(#game.Players:GetPlayers()))
			UptimeLabel:Set(Uptime2:format(Uptime))
		end
	end)
end)

Rayfield:LoadConfiguration()