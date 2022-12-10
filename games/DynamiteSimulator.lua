local Network = require(game:GetService("ReplicatedStorage").Modules.Network)
local Drops = game:GetService("Workspace").Dependencies.Drops
local Area = game:GetService("Workspace").Dependencies.TeleportPoints
local Chests = game:GetService("Workspace").Dependencies.Chests
local Areas = {}
local Dynamites = {}
local Eggs = {}
local Boosts = {}
local Codes = {
    "HALLOWEEN2022",
    "UPDATE2"
}

local function RedeemCodes()
    for i,v in next, Codes do
        Network:FireServer("RedeemCode", v)
    end
end

for i, v in next, getgc(true) do
	if typeof(v) == "table" then
		if rawget(v, "Quadruple Dynamite") then
			for i2, v2 in next, v  do
				table.insert(Dynamites, tostring(i2))
			end
		elseif rawget(v, "Common Egg") then
			for i2, v2 in next, v do
				table.insert(Eggs, tostring(i2))
			end
        elseif rawget(v, "CoinBoost") then
            for i2, v2 in next, v do
                table.insert(Boosts, tostring(i2))
            end
		end
	end
end

for i, v in next, Area:GetChildren() do
	table.insert(Areas, v.Name)
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

local function GrabDrops()
	for i, v in next, Drops:GetChildren() do
		v.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
	end
end

local function GrabChests()
	for i, v in next, Chests:GetChildren() do
		if v:FindFirstChild("Touch") then
			tp(v.Touch.Position)
		end
	end
end

local function getClosest()
	local closestDistance, closestObject = math.huge, nil
	for _, v in ipairs(game:GetService("Workspace").Dependencies.CollectablesSpawn:GetDescendants()) do
		if v:IsA("Model") then
			local distance = game:GetService("Players").LocalPlayer:DistanceFromCharacter(v.Primary.Position)
			if distance < closestDistance then
				closestDistance = distance
				closestObject = v
			end
		end
	end
	return closestObject
end

local function Attack(instance)
	Network:FireServer("AttackEvent", instance.Name)
end

local function BuyDynamite(dynamite)
	Network:InvokeServer("BuyDynamite", dynamite)
end

local function BuyDynamites()
	for i, v in next, Dynamites do
		BuyDynamite(v)
	end
end

local selectedEgg = "Common Egg"
local TripleHatch = false

local function OpenEgg(egg, amount)
	amount = amount == true and 3 or amount == false and 1
    Network:FireServer("OpenEgg", egg, amount)
end

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
	Name = "Dynamite Simulator",
	LoadingTitle = "Soggyware",
	LoadingSubtitle = "- 2021-2022 -",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "Soggyware",
		FileName = "Dynamite Simulator"
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
	Name = "Auto Attack Closest Things",
	CurrentValue = false,
	Flag = "Auto Attack Closest Things",
	Callback = function(x)
		getgenv()["Auto Attack Closest Things"] = x
		while getgenv()["Auto Attack Closest Things"] do
			task.wait()
            if getgenv()["Auto Attack Closest Things"] == false then
                return
            end
            pcall(function()
                local Target = getClosest()
                tp(Target.Primary.Position)
                Attack(Target)
            end)
		end
	end
})

Tab:CreateToggle({
	Name = "Auto Collect Drops",
	CurrentValue = false,
	Flag = "Auto Collect Drops",
	Callback = function(x)
		getgenv()["Auto Collect Drops"] = x
		while getgenv()["Auto Collect Drops"] do
			task.wait()
			pcall(function()
				if getgenv()["Auto Collect Drops"] == false then
					return
				end
				GrabDrops()
			end)
		end
	end
})

local Section = Tab:CreateSection("Halloween Event")

Tab:CreateToggle({
	Name = "Auto Knock On Halloween Houses",
	CurrentValue = false,
	Flag = "Auto Knock On Halloween Houses",
	Callback = function(x)
		getgenv()["Auto Knock On Halloween Houses"] = x
		while getgenv()["Auto Knock On Halloween Houses"] do
			task.wait()
			pcall(function()
				if getgenv()["Auto Knock On Halloween Houses"] == false then
					return
				end
				for i, v in next, game:GetService("Workspace").GameAssets.Halloween.TrickOrTreatHouses:GetDescendants() do
					if v.Name == "TouchInterest" and v.Parent then
						if v.Parent.Parent.Gradient.BillboardGui.BottomLabel.Text == "Knock!" then
							for x = 0, 1 do
                                firetouchinterest(game.Players.LocalPlayer.Character.Head, v.Parent, x)
                            end
						end
					end
				end
			end)
		end
	end
})

local Tab = Window:CreateTab("Purchasing Tab", 4483362458)

local Section = Tab:CreateSection("Dynamites")

Tab:CreateToggle({
	Name = "Auto Buy All Dynamites",
	CurrentValue = false,
	Flag = "Auto Buy All Dynamites",
	Callback = function(x)
		getgenv()["Auto Buy All Dynamites"] = x
		while getgenv()["Auto Buy All Dynamites"] do
			task.wait()
			pcall(function()
				if getgenv()["Auto Buy All Dynamites"] == false then
					return
				end
				BuyDynamites()
			end)
		end
	end
})

local Section = Tab:CreateSection("Hatching")

Tab:CreateToggle({
	Name = "Auto Hatch Selected Egg",
	CurrentValue = false,
	Flag = "Auto Hatch Selected Egg",
	Callback = function(x)
		getgenv()["Auto Hatch Selected Egg"] = x
		while getgenv()["Auto Hatch Selected Egg"] do
			task.wait()
			pcall(function()
				if getgenv()["Auto Hatch Selected Egg"] == false then
					return
				end
				OpenEgg(selectedEgg, TripleHatch)
			end)
		end
	end
})

Tab:CreateToggle({
	Name = "Triple Hatch",
	CurrentValue = false,
	Flag = "Triple Hatch",
	Callback = function(x)
		TripleHatch = x
	end
})

Tab:CreateDropdown({
	Name = "Select Egg To Hatch",
	Options = Eggs,
	CurrentOption = "Common Egg",
	Flag = "Select Egg To Hatch",
	Callback = function(x)
		selectedEgg = x
	end,
})

local Section = Tab:CreateSection("Pets")

Tab:CreateToggle({
	Name = "Auto Equip Best Pet",
	CurrentValue = false,
	Flag = "Auto Equip Best Pet",
	Callback = function(x)
		getgenv()["Auto Equip Best Pet"] = x
		while getgenv()["Auto Equip Best Pet"] do
			task.wait()
			pcall(function()
				if getgenv()["Auto Equip Best Pet"] == false then
					return
				end
				Network:FireServer("EquipBestPets")
			end)
		end
	end
})

local Tab = Window:CreateTab("Misc Tab", 4483362458)

local Section = Tab:CreateSection("Wheel")

Tab:CreateToggle({
	Name = "Auto Spin Wheel",
	CurrentValue = false,
	Flag = "Auto Spin Wheel",
	Callback = function(x)
		getgenv()["Auto Spin Wheel"] = x
		while getgenv()["Auto Spin Wheel"] do
			task.wait()
			pcall(function()
				if getgenv()["Auto Spin Wheel"] == false then
					return
				end
				Network:InvokeServer("SpinWheel")
			end)
		end
	end
})

local Section = Tab:CreateSection("Playtime Rewards")

Tab:CreateToggle({
	Name = "Auto Claim Playtime Rewards",
	CurrentValue = false,
	Flag = "Auto Claim Playtime Rewards",
	Callback = function(x)
		getgenv()["Auto Claim Playtime Rewards"] = x
		while getgenv()["Auto Claim Playtime Rewards"] do
			task.wait()
			pcall(function()
				if getgenv()["Auto Claim Playtime Rewards"] == false then
					return
				end
				for i = 1,9 do
                    Network:FireServer("ClaimPlaytimeReward", ("Gift%i"):format(i))
                    task.wait(0.05)
                end
			end)
		end
	end
})

local Section = Tab:CreateSection("Teleports")

Tab:CreateDropdown({
	Name = "Teleport To Selected World",
	Options = Areas,
	CurrentOption = "Spawn",
	Flag = "Teleport To Selected World",
	Callback = function(x)
		tp(Area[x].CFrame)
	end,
})

local Section = Tab:CreateSection("Boosts")

Tab:CreateToggle({
	Name = "Auto Use Boosts",
	CurrentValue = false,
	Flag = "Auto Use Boosts",
	Callback = function(x)
		getgenv()["Auto Use Boosts"] = x
		while getgenv()["Auto Use Boosts"] do
			task.wait()
			pcall(function()
				if getgenv()["Auto Use Boosts"] == false then
					return
				end
				for i,v in next, Boosts do
                    Network:FireServer("UseBoost", v)
                end
			end)
		end
	end
})

local Section = Tab:CreateSection("Codes")

Tab:CreateButton({
    Name = "Redeem Codes",
    Callback = function()
        RedeemCodes()
    end
})