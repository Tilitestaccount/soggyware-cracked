local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character
local VIM = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")

local PlayersTable = {}

for i,v in next, Players:GetPlayers() do
    if v ~= Player then
        table.insert(PlayersTable, v.Name)
    end
end

shared.SelectedPlayer = nil

local function Respawn()
	VIM:SendKeyEvent(true, "R", false, game)
end

local function GetCar()
	return Workspace.CarCollection[Player.Name]["Car"]
end

local function CrashCar()
	local Car = GetCar()
	Car.PrimaryPart.CFrame = (Car.PrimaryPart.CFrame + Vector3.new(0, 50, 0))
	Car.PrimaryPart.CFrame = Car.PrimaryPart.CFrame:ToWorldSpace(CFrame.Angles(math.rad(90), math.rad(180), 0))
end

local function ItemCarFarm(Item)
	local car = GetCar()
	Character.Humanoid.Jump = true
	if Item == "RPG" then
		for _, v in next, Player.Backpack:GetChildren() do
			if v.Name == "RPG" then
				Character.Humanoid:EquipTool(v)
			end
		end
		if Character.RPG then
			local args = {
				[1] = car.PrimaryPart.CFrame
			}
			Players.LocalPlayer.Character.RPG.Shoot:InvokeServer(unpack(args))
		end
	elseif Item == "Crowbar" then
		for _, v in next, Player.Backpack:GetChildren() do
			if v.Name == "Crowbar" then
				Character.Humanoid:EquipTool(v)
			end
		end
		if Character.Crowbar then
			Character.PrimaryPart.CFrame =
                car.PrimaryPart.CFrame + car.PrimaryPart.CFrame.lookVector * 3.5
			Character.Crowbar:Activate()
		end
	elseif Item == "FreezeRay" then
		for _, v in next, Player.Backpack:GetChildren() do
			if v.Name == "FreezeRay" then
				Character.Humanoid:EquipTool(v)
			end
		end
		if Character.FreezeRay then
			Character.PrimaryPart.CFrame =
                car.PrimaryPart.CFrame + car.PrimaryPart.CFrame.lookVector * 3.5
			Character.FreezeRay:Activate()
		end
	elseif Item == "FlameThrower" then
		for _, v in next, Player.Backpack:GetChildren() do
			if v.Name == "FlameThrower" then
				Character.Humanoid:EquipTool(v)
			end
		end
		if Character.FlameThrower then
			Character.PrimaryPart.CFrame =
                car.PrimaryPart.CFrame + car.PrimaryPart.CFrame.lookVector * 3.5
			Character.FlameThrower:Activate()
		end
	end
end

local function AntiRagdoll()
    for i,v in next, getgc() do
        if typeof(v) == "function" and islclosure(v) and not is_synapse_function(v) then
            if debug.getinfo(v).name == "Constructor" then
                if getfenv(v).script == game:GetService("ReplicatedStorage").ClientModules.System.Ragdoll then
                    hookfunction(v, function()
                        return task.wait(9e9)
                    end)
                end
            end
        end
    end
end

local function GetCarActualName(Car)
    return game:GetService("ReplicatedStorage").VehicleInformation[Car].Name.Value
end

local function GetCarName(Car)
    for i,v in next, game:GetService("ReplicatedStorage").VehicleInformation:GetDescendants() do
        if v.Name == "Name" then
            if v.Value == Car then
                return v.Parent
            end
        end
    end
end

local function HoldKey(Key, Time)
    vim:SendKeyEvent(true, Key, false, game)
    task.wait(Time)
    vim:SendKeyEvent(false, Key, false, game)
end

local function GetBestCar()
    local Price = 0
    local Car = nil
    for i,v in next, game:GetService("ReplicatedStorage").VehicleInformation:GetChildren() do
        if v.VipOnly.Value == false and v.Exclusive.Value == false and v.GroupOnly.Value == false then
            if (v.Price.Value < math.floor(Player.Money.Value) and Price < v.Price.Value) then
                Price = v.Price.Value
                Car = v
            end
        end
    end
    return Car
end

local function GetOwnedCars()
    local count = 0
    for i,v in next, game:GetService("ReplicatedStorage").VehicleInformation:GetChildren() do
        if (v.Price.Value < math.floor(Player.Money.Value)) then
            count = count + 1
        end
    end
    return count
end

local function SpawnCar(Car)
    game:GetService("ReplicatedStorage").rF.SpawnVehicle:InvokeServer(Car)
end

local function GoToHelicopter()
    for i, v in next, Workspace["EnergyCore_Session"].Helicopter:GetDescendants() do
        if v.Name == "Seat" then
            Character.PrimaryPart.CFrame = v.CFrame
            task.wait(0.1)
            HoldKey(Enum.KeyCode.E, 2)
        end
    end
end

local function GetGamepasses()
    for i, v in next, Players.LocalPlayer.Passes:GetChildren() do
        if v.ClassName == "BoolValue" then
            if v.Value == false then
                v.Value = true
            end
        end
    end
end

local function GetShell()
    Character.PrimaryPart.CFrame = game:GetService("Workspace").Shell.CFrame
end

local function BreakChest()
    GetCar().PrimaryPart.CFrame = game:GetService("Workspace").Chest.Bounds.CFrame
end

local function BecomeGod()
    Player.Character.Invincibility.Value = true
end

local StatFormats = {"k", "m", "b", "t", "q"}
local function formatNumber(int)
	local formatted = math.max(int, 0)
	for i, v in next, StatFormats do
		local power = 10 ^ (i * 3)
		if int >= power then
			formatted = string.format("%.1f".. string.upper(v), int / power)
		end
	end
	return formatted
end

shared.selectedItem = nil

shared.VehicleOptions = {
    Handling = 0,
    TopSpeed = 0,
    PeakRPM = 0,
    Redline = 0,
    Horsepower = 0,
    Acceleration = 0,
    BrakeForce = 0,
    FinalDrive = 0,
    Ratios = {1,0,1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40}
}

shared.CustomRatios = false

local Cash = Player.Money.Value
local Parts = Player.Parts.Value

local SolarisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stebulous/solaris-ui-lib/main/source.lua"))()

local win = SolarisLib:New({
	Name = "Car Crushers 2 - Re-Write - Sunken",
	FolderToSave = "CC2_SGWR"
})

local tab = win:Tab("Tab 1")

local sec = tab:Section("Player Information")

local TotalCars = GetOwnedCars()
local MoneyMade = sec:Label("Money Made: 0")
local PartsMade = sec:Label("Parts Made: 0")
local CarsGained = sec:Label("Cars Unlocked: 0")

print(TotalCars)

task.spawn(function()
    while task.wait() do
        MoneyMade:Set("Money Made: " .. formatNumber(math.floor(Player.Money.Value - Cash)))
        PartsMade:Set("Parts Made: " .. formatNumber(math.floor(Player.Parts.Value - Parts)))
        CarsGained:Set("Cars Unlocked: " .. GetOwnedCars() - TotalCars)
    end
end)

local sec = tab:Section("Farming Options")

sec:Toggle("Auto Crash Car", false, "Crash Car", function(t)
	getgenv()["Crash Car"] = t
	while getgenv()["Crash Car"] == true do
		pcall(CrashCar)
		task.wait(1)
	end
end)

sec:Toggle("Auto Destroy Car With Weapon", false, "Destroy Car With Weapon", function(t)
	getgenv()["Destroy Car With Weapon"] = t
	while getgenv()["Destroy Car With Weapon"] == true do
		pcall(function()
            ItemCarFarm(shared.selectedItem)
        end)
		task.wait(0.5)
	end
end)

sec:Dropdown("Select Weapon", {"RPG", "Crowbar", "FreezeRay", "FlameThrower"},"RPG","Select Weapon", function(t)
    shared.selectedItem = t
end)

sec:Toggle("Auto Go To Energy Core Helicopter", false, "Go To Energy Core Helicopter", function(t)
	getgenv()["Go To Energy Core Helicopter"] = t
	while getgenv()["Go To Energy Core Helicopter"] == true do
		pcall(GoToHelicopter)
		task.wait(0.5)
	end
end)

local sec = tab:Section("Respawn Options")

sec:Toggle("Auto Respawn", false, "Respawn", function(t)
	getgenv()["Respawn"] = t
	while getgenv()["Respawn"] == true do
		if Player.PlayerGui.VehicleMenu.Menu.Background.Background.Respawn.ImageColor3 == Color3.fromRGB(210, 210, 49) then
			pcall(Respawn)
		end
		task.wait()
	end
end)

sec:Toggle("Auto Respawn With Best Car You Own", false, "Respawn2", function(t)
	getgenv()["Respawn2"] = t
	while getgenv()["Respawn2"] == true do
		if Player.PlayerGui.VehicleMenu.Menu.Background.Background.Respawn.ImageColor3 == Color3.fromRGB(210, 210, 49) then
			SpawnCar(tostring(GetBestCar()))
		end
		task.wait()
	end
end)

local sec = tab:Section("Miscellaneous Options")

sec:Button("Get Gamepasses", function()
    pcall(GetGamepasses)
end)

sec:Button("Become God Mode", function()
    pcall(BecomeGod)
end)

sec:Button("Anti Ragdoll", function()
    pcall(AntiRagdoll)
end)

sec:Button("Get Shell", function()
    pcall(GetShell)
end)

local sec = tab:Section("Vehicle Options")

for i,v in next, shared.VehicleOptions do
    if typeof(v) == "number" then
        sec:Slider(i, 0,500000,0,2.5,i, function(t)
            shared.VehicleOptions[i] = t
        end)
    end
end

sec:Toggle("Custom Gear Ratios", false, "Custom Gear Ratios", function(t)
    shared.CustomRatios = t
end)

sec:Button("Assign Modifications", function()
    repeat task.wait() until GetCar().Body.Configuration~=nil
    for i,v in next, getgc(true) do
        if typeof(v) == "table" then
            if rawget(v, "TopSpeed") then
                for i2,v2 in next, shared.VehicleOptions do
                    if tostring(i2) ~= "Ratios" then
                        rawset(v, i2, v2)
                    elseif tostring(i2) == "Ratios" then
                        if shared.CustomRatios == true then
                            rawset(v,i2,v2)
                        end
                    end
                end
            end
        end
    end
end)

local sec = tab:Section("Event Options")

sec:Toggle("Chest Event | Break Chest", false, "Break Chest", function(t)
    getgenv()["Chest Event"] = t

    while getgenv()["Chest Event"] == true do
        task.wait()
        pcall(BreakChest)
    end
end)

local sec = tab:Section("Player Options")

local TeleportToPlayer = sec:Dropdown("Teleport To Player", PlayersTable,Player.Name,"Teleport To Player", function(t)
    Character.PrimaryPart.CFrame = Players[t].Character.PrimaryPart.CFrame + Players[t].Character.PrimaryPart.CFrame.LookVector * -3.5
    shared.SelectedPlayer = t
end)

sec:Toggle("Loop Teleport To Player", false, "Loop Teleport To Player", function(t)
    getgenv()["Loop Teleport To Player"] = t

    while getgenv()["Loop Teleport To Player"] == true do
        task.wait()
        pcall(function()
            Character.PrimaryPart.CFrame = Players[shared.SelectedPlayer].Character.PrimaryPart.CFrame + Players[shared.SelectedPlayer].Character.PrimaryPart.CFrame.LookVector * -3.5
        end)
    end
end)

sec:Button("Teleport Car To Player", function()
    local Car = GetCar()
    Car.PrimaryPart.CFrame = Players[shared.SelectedPlayer].Character.PrimaryPart.CFrame + Players[shared.SelectedPlayer].Character.PrimaryPart.CFrame.LookVector * -3.5
end)

sec:Toggle("Loop Teleport Car To Player", false, "Loop Teleport Car To Player", function(t)
    getgenv()["Loop Teleport Car To Player"] = t

    while getgenv()["Loop Teleport Car To Player"] == true do
        task.wait()
        pcall(function()
            local Car = GetCar()
            Car.PrimaryPart.CFrame = Players[shared.SelectedPlayer].Character.PrimaryPart.CFrame + Players[shared.SelectedPlayer].Character.PrimaryPart.CFrame.LookVector * -3.5
        end)
    end
end)

sec:Button("Refresh Player Dropdown", function()
    PlayersTable = {}
    for i,v in next, Players:GetPlayers() do
        if v ~= Player then
            table.insert(PlayersTable, v.Name)
        end
    end
    TeleportToPlayer:Refresh(PlayersTable, true)
end)

local sec = tab:Section("Coming Soon")

sec:Button("Suggest Me Features To Added", function()
    loadstring(game:HttpGet("print('hi')"))()
end)