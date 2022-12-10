local function UseTool()
    game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):Activate()
end

local function RemoveCooldown()
    for i,v in next, getgc() do
        if typeof(v) == "function" and getfenv(v).script == game.Players.LocalPlayer.Character.Weight.weightClientScript then
            local consts = getconstants(v)
            local upvals = getupvalues(v)
            if table.find(consts, "isSpecial") and table.find(consts, "isOnMachine") then
                setconstant(v, 16, 0)
                setconstant(v, 17, 0)
            end
        end
    end
end

local function ClaimGift(x)
    local args = {[1]=x}
    game:GetService("ReplicatedStorage").Remotes.claimGift:InvokeServer(unpack(args))
end

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
	Name = "Fitness Simulator / Training Simulator",
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
	Name = "Auto Swing",
	CurrentValue = false,
	Flag = "Auto Swing",
	Callback = function(x)
		getgenv()["Auto Swing"] = x
		while getgenv()["Auto Swing"] do
			task.wait()
			pcall(function()
				if getgenv()["Auto Swing"] == false then
					return
				end
				pcall(UseTool)
			end)
		end
	end
})

local Section = Tab:CreateSection("Modifications")

Tab:CreateButton({
    Name = "Remove Swing Cooldown",
    Callback = RemoveCooldown
})

local Tab = Window:CreateTab("Misc Tab", 4483362458)

local Section = Tab:CreateSection("Gifts")

Tab:CreateToggle({
	Name = "Auto Claim Gifts",
	CurrentValue = false,
	Flag = "Auto Claim Gifts",
	Callback = function(x)
		getgenv()["Auto Claim Gifts"] = x
		while getgenv()["Auto Claim Gifts"] do
			task.wait()
			pcall(function()
				if getgenv()["Auto Claim Gifts"] == false then
					return
				end
				for i = 1,12 do
                    ClaimGift(i)
                end
			end)
		end
	end
})

local Tab = Window:CreateTab("Player Tab", 4483362458)

local Section = Tab:CreateSection("Select Player")

local selectedPlayer

Tab:CreateDropdown({
	Name = "Select Player",
	Options = (
        function() 
            local a = {}
            for i,v in next, game.Players:GetPlayers() do
                if v~=game.Players.LocalPlayer then
                    table.insert(a, v.Name)
                end
            end
            return a 
        end
    )(),
	CurrentOption = "",
	Flag = "Select Player",
	Callback = function(x)
		selectedPlayer = x
	end,
})

Tab:CreateToggle({
	Name = "Auto Teleport To Selected Player",
	CurrentValue = false,
	Flag = "Auto Teleport To Selected Player",
	Callback = function(x)
		getgenv()["Auto Teleport To Selected Player"] = x
		while getgenv()["Auto Teleport To Selected Player"] do
			task.wait()
			pcall(function()
				if getgenv()["Auto Teleport To Selected Player"] == false then
					return
				end
				game.Players.LocalPlayer.Character:PivotTo(game.Players[selectedPlayer].Character.HumanoidRootPart.CFrame)
			end)
		end
	end
})