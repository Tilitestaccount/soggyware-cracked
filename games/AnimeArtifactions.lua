repeat
	task.wait()
until game:IsLoaded() == true

local var = loadstring(game:HttpGet("https://soggyhubv2.vercel.app/Libs/Variables.lua"))()

local Helpers = {}

Helpers.Zones = {}

for i, v in next, game:GetService("Workspace").Monsters:GetChildren() do
	if v:IsA("Folder") then
		table.insert(Helpers.Zones, v.Name)
	end
end

local function getClosest()
	local closestDistance, closestObject = math.huge, nil
	for _, v in ipairs(game:GetService("Workspace").Monsters:GetDescendants()) do
		if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health ~= 0 then
			local distance = game:GetService("Players").LocalPlayer:DistanceFromCharacter(v.HumanoidRootPart.Position)
			if distance < closestDistance then
				closestDistance = distance
				closestObject = v
			end
		end
	end
	return closestObject
end

Helpers.AttackFunctionHolder = nil

local Modules = {}

for i, v in next, getloadedmodules() do
	if tostring(v) == "AttackManager" then
		Modules["AttackManager"] = v
	elseif tostring(v) == "AttackHandle" then
		Modules["AttackHandle"] = v
	end
end

for i, v in next, getgc(true) do
	if typeof(v) == "table" then
		if rawget(v, "WayAttack") then
			Helpers.AttackFunctionHolder = v
		end
	end
end

Helpers.Chests = {}
Helpers.Achievements = {}
Helpers.Boosts = {}

for i, v in next,  getgc(true) do
	if typeof(v) == "table" then
		if rawget(v, "draw001") then
			for i2, v2 in next, v do
				table.insert(Helpers.Chests, tostring(i2))
			end
		elseif rawget(v, "achievement001") then
			for i2, v2 in next, v do
				table.insert(Helpers.Achievements, tostring(i2))
			end
		elseif rawget(v, "boost001") then
			for i2, v2 in next, v do
				table.insert(Helpers.Boosts, tostring(i2))
			end
		end
	end
end

local _speed = 25
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

local selectedDraw = "draw001"

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
	Name = "Anime Artifacts Simulator 2",
	LoadingTitle = "Soggyware",
	LoadingSubtitle = "- 2021-2022 -",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "Soggyware",
		FileName = "AnimeArtifications"
	},
	Discord = {
		Enabled = true,
		Invite = "bBZxdAhS9J",
		RememberJoins = true
	}
})

local Tab = Window:CreateTab("Main Tab", 4483362458)

local Section = Tab:CreateSection("Farming")

local Target
local _delay = 0

Tab:CreateToggle({
	Name = "Auto Attack Closest Enemies",
	CurrentValue = false,
	Flag = "Auto Attack Closest Enemies",
	Callback = function(x)
		getgenv()["Auto Attack Closest Enemies"] = x
		while getgenv()["Auto Attack Closest Enemies"] do
			task.wait(_delay)
			pcall(function()
                if getgenv()["Auto Attack Closest Enemies"] == false then return end
				Target = getClosest()
				Helpers.AttackFunctionHolder.EnemyTarget = Target
				Helpers.AttackFunctionHolder.AttackEnemy()
			end)
		end
	end
})

Tab:CreateToggle({
	Name = "Auto Teleport To Closest Enemies",
	CurrentValue = false,
	Flag = "Auto Teleport To Closest Enemies",
	Callback = function(x)
		getgenv()["Auto Teleport To Closest Enemies"] = x
		while getgenv()["Auto Teleport To Closest Enemies"] do
			task.wait()
			pcall(function()
                if getgenv()["Auto Teleport To Closest Enemies"] == false then return end
				tp(Target.Head.Position)
			end)
		end
	end
})

local Section = Tab:CreateSection("Configuration")

Tab:CreateSlider({
	Name = "Tween Speed",
	Range = {
		0,
		500
	},
	Increment = 2,
	Suffix = "Studs Per Second",
	CurrentValue = 100,
	Flag = "Tween Speed",
	Callback = function(x)
		_speed = x
	end,
})

Tab:CreateSlider({
	Name = "Hit Delay",
	Range = {
		0,
		5
	},
	Increment = 0.01,
	Suffix = "Second Hit Delay",
	CurrentValue = 1,
	Flag = "Hit Delay",
	Callback = function(x)
		_delay = x
	end,
})

local Section = Tab:CreateSection("Chests")

Tab:CreateDropdown({
	Name = "Select Chest To Draw From",
	Options = Helpers.Chests,
	CurrentOption = selectedDraw,
	Flag = "Select Draw",
	Callback = function(x)
		selectedDraw = x
	end,
})

local firstTime = true

Tab:CreateToggle({
	Name = "Auto Draw Selected Chest",
	CurrentValue = false,
	Flag = "Auto Draw Selected Chest",
	Callback = function(x)
		if firstTime == true then
			Rayfield:Notify("Information - Soggyware", "Make sure you are close to the Chest", 4483362458)
			firstTime = false
		end

		getgenv()["Auto Draw Selected Chest"] = x
		while getgenv()["Auto Draw Selected Chest"] do
			task.wait()
			local args = {
				[1] = selectedDraw,
				[2] = "E"
			}
			game:GetService("ReplicatedStorage").Events.UIEvents.DrawWeapon:FireServer(unpack(args))
		end
	end
})

local Tab = Window:CreateTab("Misc Tab", 4483362458)

local Section = Tab:CreateSection("Boosts")

Tab:CreateToggle({
	Name = "Auto Use Boosts",
	CurrentValue = false,
	Flag = "Auto Use Boosts",
	Callback = function(x)
		getgenv()["Auto Use Boosts"] = x
		while getgenv()["Auto Use Boosts"] do
			task.wait()
			for i, v in next, Helpers.Boosts do
				local args = {
					[1] = v
				}
				game:GetService("ReplicatedStorage").Events.RF_BoostsUse:FireServer(unpack(args))
			end
		end
	end
})

local Section = Tab:CreateSection("Teleports")

Tab:CreateDropdown({
	Name = "Teleport To Zone",
	Options = (function()
		local a = {}
		for i, v in next, game:GetService("Workspace").Spawns.Teleport:GetChildren() do
			table.insert(a, v.Name)
		end
		return a
	end)(),
	CurrentOption = "stage001",
	Flag = "Select Draw",
	Callback = function(x)
		local old = _speed
		_speed = 1000
		tp(game:GetService("Workspace").Spawns.Teleport[x].CFrame)
		_speed = old
	end,
})

local Section = Tab:CreateSection("Drops")

Tab:CreateToggle({
	Name = "Auto Collect Drops",
	CurrentValue = false,
	Flag = "Auto Collect Drops",
	Callback = function(x)
		getgenv()["Auto Collect Drops"] = x
		while getgenv()["Auto Collect Drops"] do
			task.wait()
			for i, v in next, game:GetService("Workspace").Monsters:GetChildren() do
				if v:IsA("Part") then
					if v:FindFirstChild("SkillballGui") then
						if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude <= 50 then
							v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
							v:FindFirstChildOfClass("RemoteEvent"):FireServer()
						end
					end
				end
			end
		end
	end
})

local Section = Tab:CreateSection("Achievements")

Tab:CreateToggle({
	Name = "Auto Claim Achievements",
	CurrentValue = false,
	Flag = "Auto Claim Achievements",
	Callback = function(x)
		getgenv()["Auto Claim Achievements"] = x
		while getgenv()["Auto Claim Achievements"] do
			task.wait(0.05)
			for i, v in next, Helpers.Achievements do
				local args = {
					[1] = v
				}
				game:GetService("ReplicatedStorage").Events.RE_AchievementsClaim:FireServer(unpack(args))
			end
		end
	end
})

local Section = Tab:CreateSection("Spins")

Tab:CreateToggle({
	Name = "Auto Spin Online Reward",
	CurrentValue = false,
	Flag = "Auto Spin Online Reward",
	Callback = function(x)
		getgenv()["Auto Spin Online Reward"] = x
		while getgenv()["Auto Spin Online Reward"] do
			task.wait(0.05)
			game:GetService("ReplicatedStorage").Events.RF_Online:InvokeServer()
		end
	end
})

Rayfield:LoadConfiguration()