local function farm(world)
    game:GetService("ReplicatedStorage").Remotes.Game.ClientMowGrass:FireServer(world)
end

function gifts()
    for i = 1,6 do
        game:GetService("ReplicatedStorage").Remotes.Shop.ClientClaimPlaytimeGift:FireServer(i)
    end
end

local worlds = {}
local sworld

local _speed = 150
function tp(...)
    local plr = game.Players.LocalPlayer
    local args = {...}
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
        {CFrame = CFrame.new(args)}
    ):Play()
end

for i,v in next, game:GetService("Workspace").Map.Zones["2"]:GetChildren() do
    table.insert(worlds, v.Name)
end

local lib = loadstring(game:HttpGet "https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/Vape.txt")()

local win = lib:Window("Soggyware V1.8", Color3.fromRGB(44, 120, 224), Enum.KeyCode.PageDown)

local tab = win:Tab("World 1 Farm")

local a = 0

task.spawn(function()
    while wait(5) do
        a = 0
    end
end)

task.spawn(function()
    while wait(1) do
        for i,v in next, require(game:GetService("ReplicatedStorage").Modules.Bins.Game.WorldDataBin.Sets["WorldData_Set1"]) do
            if v.RequiredUnlockGrassMowed <= game:GetService("Players").LocalPlayer.leaderstats.Grass.Value then
                if v.Order > a then
                    a = v.Order
                end
            end
        end
    end
end)

local function farmObjs()
    for i,v in next, game:GetService("Workspace").Map.Zones:GetDescendants() do
        if v.Parent.Name == "Obstacles" and v:IsA("Model") and v.Parent.Parent.Name == tostring(a) then
            tp(v:FindFirstChild("BoundingBox").CFrame + v:FindFirstChild("BoundingBox").CFrame.LookVector * -3.5)
        end
    end
end

local function farmObjs2(b)
    for i,v in next, game:GetService("Workspace").Map.Zones:GetDescendants() do
        if v.Parent.Name == "Obstacles" and v:IsA("Model") and v.Parent.Parent.Name == b then
            tp(v:FindFirstChild("BoundingBox").CFrame + v:FindFirstChild("BoundingBox").CFrame.LookVector * -3.5)
        end
    end
end

tab:Toggle(
    "Mow Grass",
    false,
    function(t)
        getgenv()["Mow Grass"] = t

        while getgenv()["Mow Grass"] do
            task.wait()
            if getgenv()["Mow Grass"] then
                pcall(function()
                    farm(tostring(a))
                end)
            else
                break
            end
        end
    end
)

tab:Toggle(
    "Farm Objects",
    false,
    function(t)
        getgenv()["Farm Objects"] = t

        while getgenv()["Farm Objects"] do
            task.wait()
            if getgenv()["Farm Objects"] then
                pcall(function()
                    farmObjs()
                end)
            else
                break
            end
        end
    end
)

tab:Toggle(
    "Unlimited Gifts",
    false,
    function(t)
        getgenv()["Unlimited Gifts"] = t

        while getgenv()["Unlimited Gifts"] do
            task.wait()
            if getgenv()["Unlimited Gifts"] then
                pcall(function()
                    gifts()
                end)
            else
                break
            end
        end
    end
)

tab:Toggle(
    "Rebirth",
    false,
    function(t)
        getgenv()["Rebirth"] = t

        while getgenv()["Rebirth"] do
            task.wait()
            if getgenv()["Rebirth"] then
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.Data.RequestRebirth:FireServer()
                end)
            else
                break
            end
        end
    end
)

tab:Label("Automatically Get's Best World You Can Afford")

local tab = win:Tab("World 2 Farm")

local selWorld

tab:Toggle(
    "Mow Grass | World 2",
    false,
    function(t)
        getgenv()["Mow Grass | World 2"] = t

        while getgenv()["Mow Grass | World 2"] do
            task.wait()
            if getgenv()["Mow Grass | World 2"] then
                pcall(function()
                    farm(selWorld)
                end)
            else
                break
            end
        end
    end
)

tab:Toggle(
    "Farm Objects | World 2",
    false,
    function(t)
        getgenv()["Farm Objects | World 2"] = t

        while getgenv()["Farm Objects | World 2"] do
            task.wait()
            if getgenv()["Farm Objects | World 2"] then
                pcall(function()
                    farmObjs2(selWorld)
                end)
            else
                break
            end
        end
    end
)

tab:Dropdown("Select World",worlds, function(t)
    selWorld = t
end)

local tab = win:Tab("Settings")

tab:Bind(
    "Toggle UI",
    Enum.KeyCode.RightShift,
    function()
        if game:GetService("CoreGui"):FindFirstChild("ui").Enabled then
            game:GetService("CoreGui"):FindFirstChild("ui").Enabled = false
        else
            game:GetService("CoreGui"):FindFirstChild("ui").Enabled = true
        end
    end
)

tab:Colorpicker(
    "Change UI Color",
    Color3.fromRGB(44, 120, 224),
    function(t)
        lib:ChangePresetColor(Color3.fromRGB(t.R * 255, t.G * 255, t.B * 255))
    end
)

tab:Label("Exploit: " .. loadstring(game:HttpGet("https://rentry.co/GetExploit/raw"))()())
tab:Label("~ Sunken")

while wait(5) do
    for i,v in next, game:GetService("Players").LocalPlayer.Character:GetDescendants() do
        if v:IsA("TextLabel") then
            if string.match(v.Text, game:GetService("Players").LocalPlayer.Name) or string.match(v.Text, game:GetService("Players").LocalPlayer.DisplayName) then
                v.Text = "John"
            end
        end
    end
end