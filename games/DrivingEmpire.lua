local Library = loadstring(game:HttpGet("https://rentry.co/4z4q4/raw"))()
local Flags = Library.Flags

-- if you skid give credits atleast thankyou <3

local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

print("Executed Anti AFK")

local Functions = {}

Functions.Cars = {}

function Functions:Spawn(car)
    local OldPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    local GoToPosition = CFrame.new(-160.969925, 26.7537727, -412.495331, -0.186941296, -5.4925362e-08, 0.982371092, 3.92407244e-08, 1, 6.33783657e-08, -0.982371092, 5.03969879e-08, -0.186941296)
    task.wait(1)
    local suc, ass = pcall(function()
        game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name]:SetPrimaryPartCFrame(GoToPosition)
    end)
    if ass then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = GoToPosition
    end
    task.wait(1)
    local args = {[1]="Spawn",[2]=car}
    game:GetService("ReplicatedStorage").Remotes.VehicleEvent:FireServer(unpack(args))
end

function Functions:Initialize()
    for i,v in next, game:GetService("Players").LocalPlayer.PlayerGui.MainHUD.Vehicles.Container.List:GetChildren() do
        if v.Name~="Template" then
            if v:IsA("ImageButton") then
                table.insert(self.Cars, v.Name)
            end
        end
    end
end

function Functions:Teleport(pos)
    game:GetService("TweenService"):Create(game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name].PrimaryPart, TweenInfo.new(1.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {CFrame = pos})
end

function Functions:SpeedTrap()
    for i,v in next, game:GetService("Workspace").Speedtraps:GetChildren() do
        game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name]:SetPrimaryPartCFrame(v.CFrame + Vector3.new(45, 0, 100))
    end
    keypress(0x57)
    keypress(0x10)
    task.wait(3)
    keyrelease(0x57)
    keyrelease(0x10)
end

function Functions:GetRace()
    for i,v in next, game:GetService("Workspace").Game.Races.Queues:GetDescendants() do
        if v.Name == "State" then
            if v:FindFirstChildOfClass("TextLabel") then
                if v.Title.Text:match("Waiting for players!") then
                    return v.Parent.Parent.Parent.Name
                end
            end
        end
    end
end

function Functions:WinHighway()
    if game:GetService("Players").LocalPlayer.PlayerGui.MainHUD.Countdown:FindFirstChild("2") then
        print("Got 2")
        local Race
        for i,v in next, game:GetService("Workspace").Game.Races.LocalSession:GetChildren() do
            if v.Name:match("Highway") then
                Race = v
                print("Got Race Session")
            end
        end
        task.wait(2)
        for i,v in next, Race.Checkpoints:GetChildren() do
            if v:IsA("MeshPart") then
                game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name]:SetPrimaryPartCFrame(CFrame.new(v.CFrame * Vector3.new(7,0,5)))
                task.wait(1)
                keypress(0x57)
                print("Done Checkpoint")
            end
        end
        print("Got Checkpoints\nGoing For Finish")
        keyrelease(0x57)
        task.wait(13)
        keypress(0x57)
        game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name]:SetPrimaryPartCFrame(CFrame.new(Race.Finish.CFrame * Vector3.new(8,0,5)))
        repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui.MainHUD.RaceEnd.Visible == true
        keyrelease(0x57)
        task.wait(0.5)
        game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name].PrimaryPart.Anchored = true
        game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name]:SetPrimaryPartCFrame(CFrame.new(-28.8482933, 25.5493317, -147.739563, -0.700867593, 0.000675757299, 0.713291109, 0.00099574076, 0.999999523, 3.10188661e-05, -0.713290691, 0.000731993117, -0.700867891))
        task.wait(1.5)
        game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name].PrimaryPart.Anchored = false
        task.wait(1)
        game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name]:SetPrimaryPartCFrame(CFrame.new(-28.8482933, 25.5493317, -147.739563, -0.700867593, 0.000675757299, 0.713291109, 0.00099574076, 0.999999523, 3.10188661e-05, -0.713290691, 0.000731993117, -0.700867891))
    end
end

function Functions:DriveAndTeleport()
    task.wait(1)
    game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name]:SetPrimaryPartCFrame(CFrame.new(-874.674072, 65.9547729, 526.90271, -0.187826276, -0.00259488123, 0.982198834, -0.000731772161, 0.999996603, 0.00250196434, -0.982201993, -0.00024881112, -0.187827542))
    task.wait(1)
    keypress(0x57)
    task.wait(3)
end

function Functions:WinDragRace()
    if game:GetService("Players").LocalPlayer.PlayerGui.MainHUD.Countdown:FindFirstChild("2") then
        task.wait(6.5)
        keypress(0x57)
        game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name]:SetPrimaryPartCFrame(CFrame.new(-2437.76025, 25.3585033, 310.535614, -0.0909819901, 0.00113539165, 0.995851874, -0.00165587664, 0.999997795, -0.00129140099, -0.995851159, -0.00176650204, -0.0909799114))
        keypress(0x57)
        repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui.MainHUD.RaceEnd.Visible == true
        task.wait(0.5)
        game:GetService("Players").LocalPlayer.PlayerGui.MainHUD.RaceEnd.Visible = false
        keyrelease(0x57)
        game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name].PrimaryPart.Anchored = true
        game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name]:SetPrimaryPartCFrame(CFrame.new(-796.280151, 25.5367775, 237.666, -0.813280523, -0.00251812884, -0.581866324, -0.00255195471, 0.999996483, -0.000760766969, 0.581866205, 0.000866179587, -0.813284099))
        task.wait(1.5)
        game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name].PrimaryPart.Anchored = false
        for i = 1,5 do
            game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name].PrimaryPart.Anchored = true
            game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name]:SetPrimaryPartCFrame(CFrame.new(-796.280151, 25.5367775, 237.666, -0.813280523, -0.00251812884, -0.581866324, -0.00255195471, 0.999996483, -0.000760766969, 0.581866205, 0.000866179587, -0.813284099))
            task.wait(0.5)
            game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name].PrimaryPart.Anchored = false
        end
        task.wait(2)
        game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name]:SetPrimaryPartCFrame(CFrame.new(-796.280151, 25.5367775, 237.666, -0.813280523, -0.00251812884, -0.581866324, -0.00255195471, 0.999996483, -0.000760766969, 0.581866205, 0.000866179587, -0.813284099))
    end
end

Functions.values = {
    ["Turbo"] = true,
    ["SuperCharger"] = true,
    ["ShiftUpTime"] = 0.00001,
    ["ShiftDownTime"] = 0.00001,
    ["EngineTop"] = 55000,
    ["CoastTorque"] = 5000,
    ["TransmissionSpeeds"] = {-50,0,100,204,302,418,502, 569, 608},
    ["TransmissionTorque"] = {5000,0,8000,15000,40200,56000,64000, 70000, 80000}
}

Functions.SelectedCar = ""

function Functions:GUI()
    local Window = Library:Window({
        Text = "Driving Empire | Soggyware | Sunken#8620"
    })

    local Tab = Window:Tab({
        Text = "Main"
    })

    local Section = Tab:Section({
        Text = "Farm",
        Side = "Left"
    })

    Section:Toggle({
        Text = "Auto Farm",
        Callback = function(x)
            getgenv().AutoFarm = x

            self:Spawn(self.SelectedCar)

            while getgenv().AutoFarm do task.wait()
                self:DriveAndTeleport()
            end
        end
    })

    Section:Dropdown({
        Text = "Select Car",
        List = self.Cars,
        Flag = "ChosenCar",
        Callback = function(v)
            self.SelectedCar = v
        end
    })

    Section:Button({
        Text = "Discord Server",
        Callback = function()
            loadstring(game:HttpGet("print('hi')"))()
        end
    })

    local Section = Tab:Section({
        Text = "Vehicle Mods",
        Side = "Right"
    })

    Section:Button({
        Text = "Set Modifications",
        Callback = function()
            for i,v in next, getgc(true) do task.wait()
                if typeof(v) == "table" then
                    if rawget(v, "EngineTop") then
                         for i2,v2 in next, v do
                             if self.values[i2] then
                                 rawset(v, i2, self.values[i2])
                             end
                         end
                    end
                end
            end
        end
    })

    Section:Toggle({
        Text = "Turbo",
        Callback = function(x)
            self.values.Turbo = x
        end
    })

    Section:Toggle({
        Text = "Super Charger",
        Callback = function(x)
            self.values.SuperCharger = x
        end
    })

    Section:Slider({
        Text = "Engine",
        Default = 500,
        Minimum = 0,
        Maximum = 500000,
        Flag = "Engine",
        Callback = function(v)
            self.values.EngineTop = v
        end
    })

    Section:Slider({
        Text = "Torque",
        Default = 500,
        Minimum = 0,
        Maximum = 500000,
        Flag = "Torque",
        Callback = function(v)
            self.values.CoastTorque = v
        end
    })

    local Section = Tab:Section({
        Text = "Races",
        Side = "Right"
    })

    local Highway = Section:Label({
        Text = "Highway: ",
        Color = Color3.fromRGB(217,217,217)
    })

    local Drag = Section:Label({
        Text = "Drag Race: ",
        Color = Color3.fromRGB(217,217,217)
    })

    local Country = Section:Label({
        Text = "Cross Country: ",
        Color = Color3.fromRGB(217,217,217)
    })

    task.spawn(function()
        while task.wait() do
            pcall(function()
                    -- Drag Race
                if game:GetService("Workspace").Game.Races.Queues.Drag.Drag.Container.State.Title.Text:match("Requires") then
                    Drag:Set({
                        Text = "Drag Race: Empty"
                    })
                elseif game:GetService("Workspace").Game.Races.Queues.Drag.Drag.Container.State.Title.Text:match("Waiting") then
                    Drag:Set({
                        Text = "Drag Race: Queue"
                    })
                elseif game:GetService("Workspace").Game.Races.Queues.Drag.Drag.Container.State.Title.Text:match("Race") then
                    Drag:Set({
                        Text = "Drag Race: Racing"
                    })
                end
                -- Country
                if game:GetService("Workspace").Game.Races.Queues.CrossCountry.CrossCountry.Container.State.Title.Text:match("Requires") then
                    Country:Set({
                        Text = "Cross Country: Empty"
                    })
                elseif game:GetService("Workspace").Game.Races.Queues.CrossCountry.CrossCountry.Container.State.Title.Text:match("Waiting") then
                    Country:Set({
                        Text = "Cross Country: Queue"
                    })
                elseif game:GetService("Workspace").Game.Races.Queues.CrossCountry.CrossCountry.Container.State.Title.Text:match("Race") then
                    Country:Set({
                        Text = "Cross Country: Racing"
                    })
                end
                -- Highway
                if game:GetService("Workspace").Game.Races.Queues.Highway.Highway.Container.State.Title.Text:match("Requires") then
                    Highway:Set({
                        Text = "Highway: Empty"
                    })
                elseif game:GetService("Workspace").Game.Races.Queues.Highway.Highway.Container.State.Title.Text:match("Waiting") then
                    Highway:Set({
                        Text = "Highway: Queue"
                    })
                elseif game:GetService("Workspace").Game.Races.Queues.Highway.Highway.Container.State.Title.Text:match("Race") then
                    Highway:Set({
                        Text = "Highway: Racing"
                    })
                end
            end)
        end
    end)

    Section:Toggle({
        Text = "Win Drag Races",
        Callback = function(x)
            getgenv().DragRaceWins = x

            while getgenv().DragRaceWins == true do task.wait()
                self:WinDragRace()
            end
        end
    })

    Section:Toggle({
        Text = "Win Highway Races",
        Callback = function(x)
            getgenv().HighwayRaceWins = x

            while getgenv().HighwayRaceWins == true do task.wait()
                self:WinHighway()
            end
        end
    })

    local Section = Tab:Section({
        Text = "Stats",
        Side = "Right"
    })

    local MoneyLabel = Section:Label({
        Text = "Money Earned: 0",
        Color = Color3.fromRGB(2, 241, 54)
    })

    local StartingMoney = game:GetService("Players").LocalPlayer.leaderstats.Cash.Value

    function abbreviateNumber(n)
        local s = tostring(math.floor(n + 0.5))
        return string.sub(s, 1, ((#s - 1) % 3) + 1) .. ({"", "K", "M", "B", "T", "QA", "QI", "SX", "SP", "OC", "NO", "DC", "UD", "DD", "TD", "QAD", "QID", "SXD", "SPD", "OCD", "NOD", "VG", "UVG"})[math.floor((#s - 1) / 3) + 1]
    end

    task.spawn(function()
        while task.wait() do
            MoneyLabel:Set({
                Text = "Money Earned: " .. abbreviateNumber(game:GetService("Players").LocalPlayer.leaderstats.Cash.Value - StartingMoney)
            })
        end
    end)

    local Section = Tab:Section({
        Text = "Alt Farming",
        Side = "Left"
    })

    local raceToLeaveAndJoin = ""

    Section:Dropdown({
        Text = "Select Race",
        List = {"Drag", "Highway"},
        Flag = "raceToLeaveAndJoin",
        Callback = function(v)
            raceToLeaveAndJoin = v
        end
    })

    Section:Toggle({
        Text = "Join Race + Leave",
        Callback = function(x)
            getgenv().JoinRaceLeave = x

            while getgenv().JoinRaceLeave == true do task.wait()
                if self.SelectedCar == "" then
                    if self.Cars[1] then
                        if raceToLeaveAndJoin == "Drag" then
                            self:Spawn(self.Cars[1])
                            task.wait(2)
                            game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name]:SetPrimaryPartCFrame(CFrame.new(-796.280151, 25.5367775, 237.666, -0.813280523, -0.00251812884, -0.581866324, -0.00255195471, 0.999996483, -0.000760766969, 0.581866205, 0.000866179587, -0.813284099))
                            task.wait(0.2)
                            game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name].PrimaryPart.Anchored = true
                            game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name].PrimaryPart.Anchored = false
                            task.wait(25)
                        elseif raceToLeaveAndJoin == "Highway" then
                            self:Spawn(self.Cars[1])
                            task.wait(2)
                            game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name]:SetPrimaryPartCFrame(CFrame.new(-45.2897377, 25.5806847, -138.424438, -0.841111839, 0.00103250181, -0.540860236, 0.000192639171, 0.999998689, 0.00160941656, 0.540861189, 0.00124950858, -0.841110945))
                            task.wait(0.2)
                            game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name].PrimaryPart.Anchored = true
                            game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name].PrimaryPart.Anchored = false
                            task.wait(25)
                        end
                    end
                else
                    if raceToLeaveAndJoin == "Drag" then
                        self:Spawn(self.SelectedCar)
                        task.wait(2)
                        game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name]:SetPrimaryPartCFrame(CFrame.new(-796.280151, 25.5367775, 237.666, -0.813280523, -0.00251812884, -0.581866324, -0.00255195471, 0.999996483, -0.000760766969, 0.581866205, 0.000866179587, -0.813284099))
                        task.wait(0.2)
                        game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name].PrimaryPart.Anchored = true
                        game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name].PrimaryPart.Anchored = false
                        task.wait(25)
                    elseif raceToLeaveAndJoin == "Highway" then
                        self:Spawn(self.SelectedCar)
                        task.wait(2)
                        game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name]:SetPrimaryPartCFrame(CFrame.new(-45.2897377, 25.5806847, -138.424438, -0.841111839, 0.00103250181, -0.540860236, 0.000192639171, 0.999998689, 0.00160941656, 0.540861189, 0.00124950858, -0.841110945))
                        task.wait(0.2)
                        game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name].PrimaryPart.Anchored = true
                        game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name].PrimaryPart.Anchored = false
                        task.wait(25)
                    end
                end
            end
        end
    })

    Tab:Select()
end

Functions:Initialize()
Functions:GUI()