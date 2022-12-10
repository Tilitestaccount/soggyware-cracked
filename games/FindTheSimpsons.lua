local plr = game.Players.LocalPlayer
local chr = plr.Character

local function FindSimpsons()
    for i,v in next, game:GetService("Workspace").Creatures:GetChildren() do
        if v:FindFirstChild("Check") then
            if v.Check then
                if v.Check:FindFirstChild("ImageLabel") then
                    if v.Check.Enabled == false then
                        chr.HumanoidRootPart.CFrame = v.CFrame
                    end
                end
            end
        end
    end
end

local SolarisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stebulous/solaris-ui-lib/main/source.lua"))()

local win = SolarisLib:New({
  Name = "Find The Simpsons",
  FolderToSave = "Find The Simpsons"
})

local tab = win:Tab("Tab 1")

local sec = tab:Section("Auto Farm")

sec:Toggle("Find Simpsons", false,"Find Simpsons", function(t)
    getgenv()["Find Simpsons"] = t

    while getgenv()["Find Simpsons"] == true do
        task.wait()
        coroutine.wrap(FindSimpsons)()
    end
end)