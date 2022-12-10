local espLib =
    loadstring(game:HttpGet(("https://raw.githubusercontent.com/shlexware/Sirius/request/library/esp/esp.lua"), true))()
espLib:Unload()
espLib:Load()

local mt = getrawmetatable(game)

local oldindex = mt.__index
setreadonly(mt, false)
mt.__index =
    newcclosure(
    function(self, method)
        if method == "WalkSpeed" then
            return 16
        end

        if method == "JumpPower" then
            return 50
        end

        return oldindex(self, method)
    end
)
setreadonly(mt, true)

local mt = getrawmetatable(game)
local old = mt.__namecall
local protect = newcclosure or protect_function

if not protect then
    protect = function(f)
        return f
    end
end

setreadonly(mt, false)
mt.__namecall =
    protect(
    function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" then
            wait(9e9)
            return
        end
        return old(self, ...)
    end
)
hookfunction(
    game:GetService("Players").LocalPlayer.Kick,
    protect(
        function()
            wait(9e9)
        end
    )
)

espLib.options.chamsFillColor = Color3.fromRGB(13, 126, 207)
espLib.options.tracerColor = Color3.fromRGB(13, 126, 207)
espLib.options.boxesColor = Color3.fromRGB(13, 126, 207)
espLib.options.outOfViewArrowsColor = Color3.fromRGB(13, 126, 207)
espLib.options.outOfViewArrowsOutlineColor = Color3.fromRGB(13, 171, 207)

function espLib.getTeam(player)
    local team = player.Team
    return team, player.TeamColor.Color
end

function espLib.getCharacter(player)
    local character = player.Character
    return character, character and character:FindFirstChild("HumanoidRootPart")
end

function espLib.getHealth(player, character)
    local humanoid = character:FindFirstChild("Humanoid")

    if (humanoid) then
        return humanoid.Health, humanoid.MaxHealth
    end

    return 100, 100
end

for i, v in next, game:GetService("Players"):GetPlayers() do
    if v.Character and v ~= game.Players.LocalPlayer then
        espLib.getHealth(v, v.Character)
        espLib.getCharacter(v)
        espLib.getTeam(v)
    end
end

getgenv().fov = 150
getgenv().fovvisible = false
local teamCheck = false
local smoothing = 0.5

local RunService = game:GetService("RunService")

local FOVring = Drawing.new("Circle")
task.spawn(
    function()
        while task.wait() do
            FOVring.Visible = getgenv().fovvisible
            FOVring.Radius = getgenv().fov
        end
    end
)

FOVring.Thickness = 2
FOVring.Transparency = 1
FOVring.Color = Color3.fromRGB(13, 126, 207)
FOVring.Position = workspace.CurrentCamera.ViewportSize / 2

local function getClosest(cframe)
    local ray = Ray.new(cframe.Position, cframe.LookVector).Unit

    local target = nil
    local mag = math.huge

    for i, v in pairs(game.Players:GetPlayers()) do
        if
            v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and
                v.Character:FindFirstChild("HumanoidRootPart") and
                v ~= game.Players.LocalPlayer and
                (v.Team ~= game.Players.LocalPlayer.Team or (not teamCheck))
         then
            local magBuf = (v.Character.Head.Position - ray:ClosestPoint(v.Character.Head.Position)).Magnitude

            if magBuf < mag then
                mag = magBuf
                target = v
            end
        end
    end

    return target
end

getgenv().Aimbot = false

RunService.RenderStepped:Connect(
    function()
        local UserInputService = game:GetService("UserInputService")
        local pressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        local localPlay = game.Players.LocalPlayer.Character
        local cam = workspace.CurrentCamera
        local vpss = workspace.CurrentCamera.ViewportSize / 2

        if pressed and getgenv().Aimbot == true then
            local curTar = getClosest(cam.CFrame)
            local ssHeadPoint = cam:WorldToScreenPoint(curTar.Character.Head.Position)
            ssHeadPoint = Vector2.new(ssHeadPoint.X, ssHeadPoint.Y)
            if (ssHeadPoint - vpss).Magnitude < getgenv().fov then
                workspace.CurrentCamera.CFrame =
                    workspace.CurrentCamera.CFrame:Lerp(
                    CFrame.new(cam.CFrame.Position, curTar.Character.Head.Position),
                    smoothing
                )
            end
        end
    end
)

local library = loadstring(game:HttpGet("https://hastebin.com/ogehoqohik.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local main =
    library:Load {
    Name = "NS ARCADE | Public",
    SizeX = 400,
    SizeY = 400,
    Theme = "Midnight",
    Extension = "json", -- config file extension
    Folder = "NS ARCADE" -- config folder name
}

local tab = main:Tab("Tab")

local section =
    tab:Section {
    Name = "Main",
    Side = "Left"
}

section:Label("Blatant")

section:Toggle {
    Name = "Aimbot",
    Flag = "Aimbot 1",
    Callback = function(bool)
        getgenv().Aimbot = bool
    end
}

section:Toggle {
    Name = "Triggerbot",
    Flag = "Triggerbot 1",
    Callback = function(bool)
        getgenv().TriggerBot = bool

        while getgenv().TriggerBot == true do task.wait()
            if Mouse.Target and Players:FindFirstChild(Mouse.Target.Parent.Name) then
                local HitPlayer = Players:FindFirstChild(Mouse.Target.Parent.Name)
                mouse1press(); task.wait(); mouse1release()
            end
        end
    end
}

local guns = {}

for i,v in next, game:GetService("ReplicatedStorage").GunSystem.GlobalModels:GetChildren() do
    table.insert(guns, v.Name)
end

function killAllll()
    pcall(function()
        for i,v in next, game:GetService("Players"):GetPlayers() do
            if v~= game.Players.LocalPlayer then
                if v.Character then
                    if v.Character.Humanoid.Health ~= 0 then
                        for i2,v2 in next, guns do
                            if v.Character:FindFirstChild(v2) and not v.Character:FindFirstChild("ForceField") then
                                v.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector * 3.5
                                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Anchored = true
                            end
                        end
                    end
                end
            end
        end
    end)
end

local _speed = 30
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

local firstTime = true

local killAllToggleThing = section:Toggle {
    Name = "Kill All",
    Flag = "Kill All 1",
    Callback = function(bool)
        getgenv().KillAll = bool
        while getgenv().KillAll == true do task.wait()
            if firstTime == true then
                task.wait(3)
                firstTime = false
            end
            killAllll()
            keypress(0x33) task.wait() keyrelease(0x33)
            mouse1press() task.wait() mouse1release()
        end
    end
}

section:Label("Visuals")

section:Toggle {
    Name = "ESP",
    Flag = "ESP 1",
    Callback = function(bool)
        espLib.options.enabled = bool
    end
}

section:Toggle {
    Name = "FOV",
    Flag = "FOV 1",
    Callback = function(bool)
        getgenv().fovvisible = bool
    end
}

section:Slider {
    Name = "FOV Radius",
    Text = "[value]/1",
    Default = 100,
    Min = 100,
    Max = 250,
    Float = 0.1,
    Flag = "FOV Radius 1",
    Callback = function(value)
        getgenv().fov = value
    end
}

local section =
    tab:Section {
    Name = "Misc",
    Side = "Right"
}

section:Label("Player")

section:Slider {
    Name = "Jump Power",
    Text = "[value]/1",
    Default = 50,
    Min = 50,
    Max = 100,
    Float = 0.1,
    Flag = "Jump Power 1",
    Callback = function(value)
        game:GetService("Players").LocalPlayer.Character.Humanoid.UseJumpPower = true
        game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = value
    end
}