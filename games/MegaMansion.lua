local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character
local HumanoidRootPart = Character.HumanoidRootPart

local function GetTycoon()
    for i,v in next, game:GetService("Workspace")["Zednov's Tycoon Kit"].Tycoons:GetChildren() do
        if v.Owner then
            if v.Owner.Value == Player then
                return v
            end
        end
    end
end

local Tycoon = GetTycoon()

local function BuyButtons()
    for i,v in next, Tycoon.Buttons.Level1:GetChildren() do
        if v:FindFirstChild("Price") then
            if v.BillboardGui.Enabled == true then
                if v.Price.Value <= Player.leaderstats.Cash.Value then
                    if v:FindFirstChild("Head") then
                        for x = 0, 1 do
                            firetouchinterest(HumanoidRootPart, v.Head, x)
                        end
                        return false
                    end
                end
            end
        end
    end
    return true
end

local function GetCash()
    for i = 0, 1 do
        firetouchinterest(HumanoidRootPart, Tycoon.Essentials.Giver, i)
    end
end

-- local function Farm()
--     local a = BuyButtons()
--     if a == true then
--         GetCash()
--     end
-- end

local SolarisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stebulous/solaris-ui-lib/main/source.lua"))()

local win = SolarisLib:New({
  Name = "Truck Factory Tycoon",
  FolderToSave = "Truck Factory Tycoon"
})

local tab = win:Tab("Tab 1")

local sec = tab:Section("Main")

local ButtonsCallback = false

sec:Toggle("Buy Buttons", false,"Buy Buttons", function(t)
    getgenv()["Buy Buttons"] = t

    while getgenv()["Buy Buttons"] == true do
        task.wait()
        ButtonsCallback = BuyButtons()
    end
end)

sec:Toggle("Collect Cash", false,"Collect Cash", function(t)
    getgenv()["Collect Cash"] = t

    while getgenv()["Collect Cash"] == true do
        task.wait()
        if ButtonsCallback == true then
            GetCash()
        end
    end
end)

local Speed=50;loadstring(game:HttpGet("https://raw.githubusercontent.com/LegitH3x0R/Roblox-Scripts/main/AEBypassing/RootAnchor.lua"))()local UIS=game:GetService("UserInputService")local OnRender=game:GetService("RunService").RenderStepped;local Player=game:GetService("Players").LocalPlayer;local Character=Player.Character or Player.CharacterAdded:Wait()local Camera=workspace.CurrentCamera;local Root=Character:WaitForChild("HumanoidRootPart")local C1,C2,C3;local Nav={Flying=false,Forward=false,Backward=false,Left=false,Right=false}C1=UIS.InputBegan:Connect(function(Input)if getgenv()["Fly | E"] then if Input.UserInputType==Enum.UserInputType.Keyboard then if Input.KeyCode==Enum.KeyCode.E then Nav.Flying=not Nav.Flying;Root.Anchored=Nav.Flying elseif Input.KeyCode==Enum.KeyCode.W then Nav.Forward=true elseif Input.KeyCode==Enum.KeyCode.S then Nav.Backward=true elseif Input.KeyCode==Enum.KeyCode.A then Nav.Left=true elseif Input.KeyCode==Enum.KeyCode.D then Nav.Right=true end end end end)C2=UIS.InputEnded:Connect(function(Input)if Input.UserInputType==Enum.UserInputType.Keyboard then if Input.KeyCode==Enum.KeyCode.W then Nav.Forward=false elseif Input.KeyCode==Enum.KeyCode.S then Nav.Backward=false elseif Input.KeyCode==Enum.KeyCode.A then Nav.Left=false elseif Input.KeyCode==Enum.KeyCode.D then Nav.Right=false end end end)C3=Camera:GetPropertyChangedSignal("CFrame"):Connect(function()if Nav.Flying then Root.CFrame=CFrame.new(Root.CFrame.Position,Root.CFrame.Position+Camera.CFrame.LookVector)end end)task.spawn(function()while true do local Delta=OnRender:Wait()if Nav.Flying then if Nav.Forward then Root.CFrame=Root.CFrame+(Camera.CFrame.LookVector*(Delta*Speed))end;if Nav.Backward then Root.CFrame=Root.CFrame+(-Camera.CFrame.LookVector*(Delta*Speed))end;if Nav.Left then Root.CFrame=Root.CFrame+(-Camera.CFrame.RightVector*(Delta*Speed))end;if Nav.Right then Root.CFrame=Root.CFrame+(Camera.CFrame.RightVector*(Delta*Speed))end end end end)

local sec = tab:Section("Player")

sec:Toggle("Fly | E", false,"Fly | E", function(t)
    getgenv()["Fly | E"] = t
    if t == false then
        for i,v in next, Nav do
            v = false
        end
        Root.Anchored = false
    end
end)

sec:Slider("Fly Speed", 0, 1000, 16, 1, "Fly Speed", function(t)
    Speed = t
end)

sec:Slider("Walk Speed", 0, 1000, 16, 1, "Walkspped", function(t)
    Character.Humanoid.WalkSpeed = t
end)

sec:Slider("Jump Power", 0, 1000, 16, 1, "Jumpower", function(t)
    Character.Humanoid.UseJumpPower = true
    Character.Humanoid.JumpPower = t
end)