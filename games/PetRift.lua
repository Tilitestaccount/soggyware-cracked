repeat
	task.wait()
until game:IsLoaded()

coroutine.wrap(require(game:GetService("ReplicatedStorage").src.Announce).announce)("ty 4 using soggyware <3", 2)

local _speed = 250
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

local args = {
	[1] = "ChoosePet",
	[2] = "Bat"
}
game:GetService("ReplicatedStorage").Remotes.Client:FireServer(unpack(args))

local function GetPetIds()
	local PetIds = {}
	for i, v in next, game:GetService("Players").LocalPlayer.Pets:GetDescendants() do
		if v.Name == "PetID" then
			table.insert(PetIds, v.Value)
		end
	end
	return PetIds
end

local function GetGamepasses()
	for i, v in next, game:GetService("Players").LocalPlayer.Gamepass:GetChildren() do
		if v.Value == false then
			v.Value = true
		end
	end
end

local Areas = {}

for i, v in next, game:GetService("Workspace").SpawnObjectFolder:GetChildren() do
	table.insert(Areas, v.Name)
end

local selectedArea = "SPAWN"

local function getClosest(x)
	local closestDistance, closestObject = math.huge, nil
	for _, v in ipairs(game:GetService("Workspace").SpawnObjectFolder[x]:GetDescendants()) do
		if v:IsA("BasePart") and not v:FindFirstChild("Folder") then
			local distance = game:GetService("Players").LocalPlayer:DistanceFromCharacter(v.Position)
			if distance < closestDistance then
				closestDistance = distance
				closestObject = v
			end
		end
	end
	return closestObject
end

local Eggs = {}

for i, v in next, game:GetService("Workspace").Eggs:GetChildren() do
	table.insert(Eggs, v.Name)
end

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
	Name = "Pet Rifts",
	LoadingTitle = "Soggyware",
	LoadingSubtitle = "- 2021-2022 -",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "Soggyware",
		FileName = "Pet Rifts"
	},
	Discord = {
		Enabled = true,
		Invite = "bBZxdAhS9J",
		RememberJoins = true
	}
})

local Tab = Window:CreateTab("Farming Tab", 4483362458)

local Section = Tab:CreateSection("Farming")

local FarmingMethod = "Normal"

local Positions = {
    ["Under"] = -Vector3.new(0,10,0),
    ["Normal"] = Vector3.new(0,0,0),
    ["Above"] = Vector3.new(0,10,0)
}

Tab:CreateToggle({
	Name = "Auto Break Coins",
	CurrentValue = false,
	Flag = "Auto Break Coins",
	Callback = function(x)
		getgenv()["Auto Break Coins"] = x
		while getgenv()["Auto Break Coins"] do
			task.wait()
			pcall(function()
				if getgenv()["Auto Break Coins"] == false then
					return
				end
				local Target = getClosest(selectedArea)
                tp(Target.Position + Positions[FarmingMethod])
				game:GetService("ReplicatedStorage").Remotes.Client:FireServer("AllPetsAttack", Target)
				game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
                repeat
					task.wait()
				until Target.Parent ~= game:GetService("Workspace").SpawnObjectFolder[selectedArea]
                game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
			end)
		end
	end
})

Tab:CreateDropdown({
	Name = "Select Area",
	Options = Areas,
	CurrentOption = "SPAWN",
	Flag = "Select Area",
	Callback = function(x)
		selectedArea = x
	end,
})

Tab:CreateDropdown({
	Name = "Select Farming Method",
	Options = {
		"Under",
		"Normal",
		"Above"
	},
	CurrentOption = "Normal",
	Flag = "Select Farming Method",
	Callback = function(x)
		FarmingMethod = x
	end,
})

local Section = Tab:CreateSection("Collection")

Tab:CreateToggle({
	Name = "Auto Collect Coins",
	CurrentValue = false,
	Flag = "Auto Collect Coins",
	Callback = function(x)
        getgenv()["Auto Collect Coins"] = x
		while getgenv()["Auto Collect Coins"] do
			task.wait()
			pcall(function()
				if getgenv()["Auto Collect Coins"] == false then
					return
				end
				for i,v in next, workspace:GetChildren() do
                    if  v.Name == "Coins" then
                        v.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
                    end
                end
			end)
		end
	end
})

local Tab = Window:CreateTab("Pet Tab", 4483362458)

local Section = Tab:CreateSection("Eggs")

local SelectedEgg = "Spawn"
local TripleEgg = false

Tab:CreateToggle({
	Name = "Auto Hatch",
	CurrentValue = false,
	Flag = "Auto Hatch",
	Callback = function(x)
		getgenv()["Auto Hatch"] = x
		while getgenv()["Auto Hatch"] do
			task.wait()
			pcall(function()
				if getgenv()["Auto Hatch"] == false then
					return
				end
				local args = {
					[1] = SelectedEgg,
					[2] = TripleEgg == true and "Triple" or TripleEgg == false and "Single"
				}
				game:GetService("ReplicatedStorage").Remotes.EggOpened:InvokeServer(unpack(args))
			end)
		end
	end
})

Tab:CreateToggle({
	Name = "Triple Hatch",
	CurrentValue = false,
	Flag = "Triple Hatch",
	Callback = function(x)
		TripleEgg = x
	end
})

Tab:CreateDropdown({
	Name = "Select Egg",
	Options = Eggs,
	CurrentOption = "Spawn",
	Flag = "Select Egg",
	Callback = function(x)
		SelectedEgg = x
	end,
})

local Tab = Window:CreateTab("Misc Tab", 4483362458)

local Section = Tab:CreateSection("Teleports")

Tab:CreateDropdown({
	Name = "Teleport To Area",
	Options = (function()
		local a = {}
		for i, v in next, game:GetService("Workspace").MAP.Teleporter:GetChildren() do
			if v:IsA("BasePart") then
                table.insert(a, v.Name)
            end
		end
		return a
	end)(),
	CurrentOption = "Spawn",
	Flag = "Teleport To Area",
	Callback = function(x)
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").MAP.Teleporter[x].CFrame
	end,
})

local Section = Tab:CreateSection("Hoverboards")

Tab:CreateDropdown({
	Name = "Equip Hoverboard",
	Options = (function()
		local a = {}
		for i, v in next, game:GetService("ReplicatedStorage").Hoverboards:GetChildren() do
			table.insert(a, v.Name)
		end
		return a
	end)(),
	CurrentOption = "Circle",
	Flag = "Equip Hoverboard",
	Callback = function(x)
		local args = {
			[1] = "ChangeHoverboard",
			[2] = x
		}
		game:GetService("ReplicatedStorage").Remotes.Client:FireServer(unpack(args))
	end,
})

local Section = Tab:CreateSection("Gamepasses")

Tab:CreateButton({
	Name = "Get Gamepasses",
	Callback = function()
		GetGamepasses()
	end,
})

local Section = Tab:CreateSection("Dupe")

Tab:CreateButton({
	Name = "Fake Dupe",
	Callback = function()
		for i, v in next, game:GetService("Players").LocalPlayer.PlayerGui.MainGui.PetInventory.MainFrame.Inventory:GetChildren() do
            if v:IsA("Frame") then
                v:Clone().Parent = v.Parent
            end
        end
	end,
})