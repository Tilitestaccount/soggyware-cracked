function Punch(plr)
    local args = {[1]=plr,[2]=plr.Character.HumanoidRootPart.Position}
    game:GetService("ReplicatedStorage").RemoteEvents.PlayerImpactRemote:FireServer(unpack(args))
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local function GetClosest()
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    if not (Character or HumanoidRootPart) then return end

    local TargetDistance = math.huge
    local Target

    for i,v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local TargetHRP = v.Character.HumanoidRootPart
            local mag = (HumanoidRootPart.Position - TargetHRP.Position).magnitude
            if mag < TargetDistance then
                TargetDistance = mag
                Target = v
            end
        end
    end

    return Target
end

local Library = loadstring(game:HttpGet("https://rentry.co/4z4q4/raw"))()
local Flags = Library.Flags

local Window = Library:Window({
    Text = "Driving Empire | Soggyware | Sunken#8620"
})

local Tab = Window:Tab({
    Text = "Main"
})

local Section = Tab:Section({
    Text = "Blatant",
    Side = "Left"
})

Section:Toggle({
    Text = "Punch Aura",
    Callback = function(x)
        getgenv()["Punch Aura"] = x

        while getgenv()["Punch Aura"] do task.wait()
            Punch(GetClosest())
        end
    end
})

Section:Toggle({
    Text = "Heavy Attack",
    Callback = function(x)
        getgenv()["Heavy Attack"] = x

        while getgenv()["Heavy Attack"] do task.wait()
            keypress(0x52) task.wait() keyrelease(0x52)
        end
    end
})

Section:Toggle({
    Text = "Teleport Behind",
    Callback = function(x)
        getgenv()["Teleport Behind Closest Player"] = x

        while getgenv()["Teleport Behind Closest Player"] do task.wait()
            Players.LocalPlayer.Character.HumanoidRootPart.CFrame = GetClosest().Character.HumanoidRootPart.CFrame + GetClosest().Character.HumanoidRootPart.CFrame.LookVector * -3.5
        end
    end
})

local Section = Tab:Section({
    Text = "Misc",
    Side = "Left"
})

local Gloves = {}

for i,v in next, require(game:GetService("ReplicatedStorage").ClientTemplates.GloveTypes.GloveTypesHandler) do
    table.insert(Gloves, i)
end

Section:Button({
    Text = "Get Gloves | LAGS GAME",
    Callback = function()
        for i,v in next, Gloves do
            local NewGlove = Instance.new("StringValue")
            NewGlove.Name = tostring(v)
            NewGlove.Parent = Players.LocalPlayer.OWNED_GLOVES
            task.wait(0.1)
        end
    end
})

Section:Dropdown({
    Text = "Get Glove | DONT LAG",
    List = Gloves,
    Flag = "Equip Glove",
    Callback = function(v)
        local NewGlove = Instance.new("StringValue")
        NewGlove.Name = tostring(v)
        NewGlove.Parent = Players.LocalPlayer.OWNED_GLOVES
    end
})

Section:Input({
    Placeholder = "Cash",
    Tooltip = "Visual",
    Flag = "Cash",
    Callback = function(text)
        Players.LocalPlayer.CashCurrency.Value = tonumber(text)
    end
})

Section:Input({
    Placeholder = "Gems",
    Tooltip = "Visual",
    Flag = "Gems",
    Callback = function(text)
        Players.LocalPlayer.GemCurrency.Value = tonumber(text)
    end
})

local Section = Tab:Section({
    Text = "Mods",
    Side = "Right"
})

Section:Input({
    Placeholder = "Stamina Cooldown",
    Tooltip = "Lower = Better",
    Flag = "Stamina Cooldown",
    Callback = function(text)
        ReplicatedStorage["STAMINA_COOLDOWN"].Value = tonumber(text)
    end
})

Section:Input({
    Placeholder = "PunchForce",
    Tooltip = "Higher = Better",
    Flag = "PunchForce",
    Callback = function(text)
        ReplicatedStorage["PunchForce"].Value = tonumber(text)
    end
})

Section:Input({
    Placeholder = "Boxing Walkspeed",
    Tooltip = "Higher = Better",
    Flag = "Boxing State Walkspeed",
    Callback = function(text)
        ReplicatedStorage["BOXING_STATE_WALKSPEED"].Value = tonumber(text)
    end
})

Section:Input({
    Placeholder = "Punching Cooldown",
    Tooltip = "Lower = Better",
    Flag = "Punching Cooldown",
    Callback = function(text)
        ReplicatedStorage["PUNCHING_COOLDOWN"].Value = tonumber(text)
    end
})

Section:Input({
    Placeholder = "Block WalkSpeed",
    Tooltip = "Higher = Better",
    Flag = "Block WalkSpeed",
    Callback = function(text)
        ReplicatedStorage["BOXING_BLOCK_STATE_WALKSPEED"].Value = tonumber(text)
    end
})

Section:Input({
    Placeholder = "Dodging Duration",
    Tooltip = "Lower = Better",
    Flag = "Dodging Duration",
    Callback = function(text)
        ReplicatedStorage["DODGING_DURATION"].Value = tonumber(text)
    end
})

Section:Input({
    Placeholder = "Dodging Cooldown",
    Tooltip = "Lower = Better",
    Flag = "Dodging Cooldown",
    Callback = function(text)
        ReplicatedStorage["DODGING_COOLDOWN"].Value = tonumber(text)
    end
})

Tab:Select()