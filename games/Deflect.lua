local Defelct = function()
	if (game:GetService("Workspace").Ball.Main.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 16 then --DONT CHANGE MAYBE CHANGE TO 15 IFYW BUT ITS GOOD DONT GO OVER 16
		mouse1click()
	end
end

local rawmetmeta = getrawmetatable(game)

local oldfthing = rawmetmeta.__index
setreadonly(rawmetmeta, false)
rawmetmeta.__index = newcclosure(function(a, b)
	if b == 'WalkSpeed' then
		return 16
	end
	if b == 'JumpPower' then
		return 50
	end
	return oldfthing(a, b)
end)
setreadonly(rawmetmeta, true)

local SolarisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stebulous/solaris-ui-lib/main/source.lua"))()

local win = SolarisLib:New({
	Name = "DEFLECT",
	FolderToSave = "DEFLECT"
})

local tab = win:Tab("Tab 1")

local sec = tab:Section("Main")

sec:Toggle("Auto Deflect", false, "Auto Deflect", function(t)
	getgenv()["Auto Deflect"] = t
	while getgenv()["Auto Deflect"] == true do
		task.wait()
		pcall(Defelct)
	end
end)

sec:Toggle("Stare", false, "Stare", function(t)
	getgenv()["Stare"] = t
	while getgenv()["Stare"] == true do
		task.wait()
        pcall(function()
            local ballthing = game:GetService("Workspace").Ball.Main
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.lookAt(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, ballthing.Position)
        end)
    end
end)

local anchored

sec:Toggle("Freeze Player", false, "Freeze Player", function(t)
	anchored = t
end)

task.spawn(function()
    while task.wait() do
        pcall(function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = anchored
        end)
    end
end)

local sec = tab:Section("Players")

sec:Slider("Walk Speed", 16, 100, 16, 1, "Walk Speed", function(t)
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = t
end)