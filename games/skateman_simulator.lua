local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
local plr = game.Players.LocalPlayer
local teleport_path = game:GetService("Workspace").Teleports

function getMushrooms()
    pcall(function()
        for i,v in next, game:GetService("Workspace")["AUTUMN EVENT (IMPORTANT"].Map.Mushrooms:GetChildren() do
            game:GetService("ReplicatedStorage").Events.pickupmushroom:InvokeServer(v)
        end
    end)
end

local skateboard_value = 0
local skateboard_instance = nil
function getBestSkateboard()
    for i,v in next, game:GetService("Workspace").Skateboards:GetDescendants() do
        if v.Name == "Wheels" then
            if v:IsA("NumberValue") then
                if v.Value > skateboard_value and plr.leaderstats.Wheels.Value >= v.Value then
                    skateboard_value = v.Value
                    skateboard_instance = v.Parent
                end
            end
        end
    end
end

function farmSkateboard()
    getBestSkateboard()
    hrp.CFrame = skateboard_instance.CFrame
    fireproximityprompt(skateboard_instance.Prompt)
end

local teleports = {}

for i,v in next, teleport_path:GetChildren() do 
    table.insert(teleports, v.Name)
end

local eggs = {}
local segg = nil

for i,v in next, game:GetService("Workspace").Eggs:GetChildren() do
    table.insert(eggs, v.Name)
end

function open_egg(egg, triple)
    local ohInstance1 = egg
    local ohNumber2 = (triple == true and 3 or 1)
    game:GetService("ReplicatedStorage").Pets.Events.HatchEgg:InvokeServer(ohInstance1, ohNumber2)
end

local ramps = game:GetService("Workspace").Ramps

function get_closest_ramp()
    local closestDistance, closestObject = math.huge, nil
    for _, v in ipairs(ramps:GetDescendants()) do
        if v.Name ~= game.Players.LocalPlayer.Name and v:IsA("BasePart") and v.Name:match("Ramp") then
            local distance = game:GetService("Players").LocalPlayer:DistanceFromCharacter(v.Position)
            if distance < closestDistance then
                closestDistance = distance
                closestObject = v
            end
        end
    end
    return closestObject
end

function auto_ramp()
    local closest_ramp = get_closest_ramp()
    print(tostring(closest_ramp))
    hrp.CFrame = closest_ramp.CFrame
    fireproximityprompt(closest_ramp.Attachment.Prompt)
end

local SolarisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stebulous/solaris-ui-lib/main/source.lua"))()

local win = SolarisLib:New({
    Name = "skate man simulator - soggyware",
    FolderToSave = "sms_sgwr"
})

local tab = win:Tab("tab one")

local sec = tab:Section("main")

sec:Toggle("auto farm", false,"auto farm", function(t)
    getgenv()["auto farm"] = t

    while getgenv()["auto farm"] do
        task.wait()
        farmSkateboard()
    end
end)

sec:Toggle("auto ramp", false,"auto ramp", function(t)
    getgenv()["auto ramp"] = t

    while getgenv()["auto ramp"] do
        task.wait()
        auto_ramp()
    end
end)

local triple_hatch = false

local sec = tab:Section("eggs")

sec:Toggle("open egg", false,"open egg", function(t)
    getgenv()["open egg"] = t

    while getgenv()["open egg"] do
        task.wait()
        open_egg(segg, triple_hatch)
    end
end)

sec:Toggle("triple hatch", false,"triple hatch", function(t)
    triple_hatch = t
end)

sec:Dropdown("select egg", eggs,"Basic","select egg", function(t)
    segg = t
end)

local sec = tab:Section("teleports")

sec:Dropdown("teleport to world", teleports,"Spawn","teleport to world", function(t)
    hrp.CFrame = teleport_path[t].CFrame
end)