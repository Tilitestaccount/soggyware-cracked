-- no skid plspls
repeat
	task.wait()
until game:IsLoaded()
print("Game Loaded")
game.Players.LocalPlayer.PlayerGui:WaitForChild("Client")
print("Client Loaded")
local function GetService(Name)
	return game:GetService(Name)
end
local Players = GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = GetService("RunService")
local BodyPart = nil
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local function WTS(Object)
	local ObjectVector = Camera:WorldToScreenPoint(Object.Position)
	return Vector2.new(ObjectVector.X, ObjectVector.Y)
end
local function PositionToRay(Origin, Target)
	return Ray.new(Origin, (Target - Origin).Unit * 600)
end
local function Filter(Object)
	if string.find(Object.Name, "Gun") then
		return
	end
	if Object:IsA("Part") or Object:IsA("MeshPart") then
		return true
	end
end
local function MousePositionToVector2()
	return Vector2.new(Mouse.X, Mouse.Y)
end
local Mouse = game.Players.LocalPlayer:GetMouse()
local Client = getsenv(game.Players.LocalPlayer.PlayerGui.Client)
getgenv().TriggerBotDelay = 0
local function IsOnScreen(Object)
	local IsOnScreen = Camera:WorldToScreenPoint(Object.Position)
	return IsOnScreen
end
local function GetClosestBodyPartFromCursor()
	local ClosestDistance = math.huge
	for i,  v in next, Players:GetPlayers() do
		if v ~= LocalPlayer and v.Team ~= LocalPlayer.Team and v.Character and v.Character:FindFirstChild("Humanoid") then
			for k,  x in next, v.Character:GetChildren() do
				if Filter(x) and IsOnScreen(x) then
					local Distance = (WTS(x) - MousePositionToVector2()).Magnitude
					if Distance < ClosestDistance then
						ClosestDistance = Distance
						BodyPart = x
					end
				end
			end
		end
	end
end
getgenv().SilentAim = false
local OldNameCall; -- works on most games, took from my old arsenal script source
OldNameCall = hookmetamethod(game, "__namecall", function(Self, ...)
	local Method = getnamecallmethod()
	local Args = {
		...
	}
	if Method == "FindPartOnRayWithIgnoreList" and BodyPart ~= nil then
		if getgenv().SilentAim == true then
			Args[1] = PositionToRay(Camera.CFrame.Position, BodyPart.Position)
			return OldNameCall(Self, unpack(Args))
		end
	end
	return OldNameCall(Self, ...)
end)
local espLib =
	loadstring(game:HttpGet(("https://raw.githubusercontent.com/shlexware/Sirius/request/library/esp/esp.lua"), true))()
espLib:Unload()
espLib.options.chamsFillColor = Color3.fromRGB(13, 126, 207)
espLib.options.tracerColor = Color3.fromRGB(13, 126, 207)
espLib.options.boxesColor = Color3.fromRGB(13, 126, 207)
espLib.options.outOfViewArrowsColor = Color3.fromRGB(13, 126, 207)
espLib.options.outOfViewArrowsOutlineColor = Color3.fromRGB(13, 171, 207)
espLib.options.teamColor = true
espLib.options.enabled = false
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
game:GetService("RunService").RenderStepped:Connect(function()
	GetClosestBodyPartFromCursor()
end)
local library = loadstring(game:HttpGet("https://soggyhubv2.vercel.app/Roblox/UI/CSGO-UI.lua"))()
local main =
	library:Load {
	Name = "ROBLOX CS:GO Soggyware | Public",
	SizeX = 500,
	SizeY = 500,
	Theme = "Midnight",
	Extension = "json", -- config file extension
	Folder = "CSGO" -- config folder name
}
local tab = main:Tab("Main")
local section =
	tab:Section {
	Name = "Main",
	Side = "Left"
}
section:Toggle {
	Name = "Silent Aim",
	Flag = "Silent Aim 1",
	Callback = function(bool)
		getgenv().SilentAim = bool
	end
}
section:Toggle {
	Name = "Extend Knife Range",
	Flag = "Extend Knife Range 1",
	Callback = function(bool)
		getgenv()["Extend Knife Range"] = bool
	end
}
section:Toggle {
	Name = "Trigger Bot",
	Flag = "Trigger Bot 1",
	Callback = function(bool)
		getgenv().TriggerBot = bool
		while getgenv().TriggerBot == true do
			task.wait()
			pcall(function()
				for i, v in next, (game.Players:GetPlayers()) do
					if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild('Humanoid') and v.Character:FindFirstChild('Humanoid').Health >= 1 and v.Team ~= game.Players.LocalPlayer.Team then
						if Mouse.Target:IsDescendantOf(v.Character) then
							task.wait(getgenv().TriggerBotDelay)
							Client.firebullet()
						end
					end
				end
			end)
		end
	end
}
local CaseFunc
for i, v in next, getgc() do
	if typeof(v) == "function" then
		if not is_synapse_function(v) then
			if getfenv(v).script == game:GetService("Players").LocalPlayer.PlayerGui.Crates.CaseClient then
				local Constants = getconstants(v)

				-- print("Function: " .. tostring(v))
				-- print(unpack(Constants))
				-- print("Length Of Constants: " .. #Constants)
				-- print("\n")
				if (#Constants == 45) then
					CaseFunc = v
				end
			end
		end
	end
end
local selectedGun
local selectedSkin
local Guns = {}
local GunSkins = {}
for i, v in next, game:GetService("ReplicatedStorage").Skins:GetChildren() do
	table.insert(Guns, v.Name)
end
local JustBoxed = ""

-- Was using this to see what arguments were being passed through from the game
local OldCaseFunc;
OldCaseFunc = hookfunction(CaseFunc, function(...)
	local args = {
		...
	}
	-- for i,v in next, args do
	--     print("IDX: " .. i .. " | VALUE: " .. tostring(v))
	-- end
	-- print("Length Of Args: " .. tostring(#args))
	JustBoxed = args[1] .. " | " .. args[2]
	return OldCaseFunc(args[1], args[2])
end)
section:Slider {
	Name = "Trigger Bot Delay",
	Text = "[value]/1",
	Default = 0,
	Min = 0,
	Max = 1,
	Float = 0.05,
	Flag = "Trigger Bot Delay 1",
	Callback = function(value)
		getgenv().TriggerBotDelay = value
	end
}
setting = settings().Network
section:Toggle {
	Name = "Lag Switch",
	Flag = "Lag Switch 1",
	Callback = function(bool)
		getgenv().LagSwitch = bool
		if getgenv().LagSwitch == true then
			setting.IncomingReplicationLag = 1000
		else
			setting.IncomingReplicationLag = 0
		end
	end
}
section:Label("Misc")

local VoteKickString = "has voted to kick " .. game.Players.LocalPlayer.Name .. ". 0 more votes to kick " .. game.Players.LocalPlayer.Name

section:Toggle {
	Name = "Spam Chat",
	Flag = "Spam 1",
	Callback = function(bool)
		getgenv().SpamChat = bool
		while getgenv().SpamChat == true do
			task.wait()
			local args = {
				[1] = "Soggyware = W",
				[2] = false,
				[3] = "Spectator",
				[4] = true,
				[5] = true
			}
			game:GetService("ReplicatedStorage").Events.PlayerChatted:FireServer(unpack(args))
		end
	end
}
getgenv().BHOP = false
getgenv().Speed = 30
local LocalPlayer = game:GetService("Players").LocalPlayer
local cbClient = getsenv(LocalPlayer.PlayerGui:WaitForChild("Client"))
local isBhopping, EdgeJump, JumpBug, curVel = true, false, false, 50
local oldNewIndex;
oldNewIndex = hookmetamethod(LocalPlayer.PlayerGui.Client, "__newindex", function(self, idx, val)
	if not checkcaller() then
		if getgenv().BHOP == true then
			if self.Name == "Humanoid" and idx == "WalkSpeed" and val ~= 0 and isBhopping == true then
				val = curVel
			elseif self.Name == "Humanoid" and idx == "JumpPower" and val ~= 0 and JumpBug == true then
				task.spawn(function()
					cbClient.UnCrouch()
				end)
				val = val * 1.25
			elseif self.Name == "Crosshair" and idx == "Visible" and val == false and LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Visible == false then
				val = true
			end
		end
	end
	return oldNewIndex(self, idx, val)
end)
section:Toggle {
	Name = "Anti Aim",
	Callback = function(bool)
		getgenv().AntiAim = bool
		while getgenv().AntiAim == true do
			task.wait()
			pcall(function()
				if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Head") and game:GetService("Players").LocalPlayer.Character.Head.Transparency ~= 0 then
					game:GetService("Players").LocalPlayer.Character.Head.Transparency = 0
				end
				if game:GetService("Players").LocalPlayer.Character:FindFirstChild("FakeHead") then
					game:GetService("Players").LocalPlayer.Character.FakeHead:Destroy()
				end
				if game:GetService("Players").LocalPlayer.Character:FindFirstChild("HeadHB") then
					game:GetService("Players").LocalPlayer.Character.HeadHB:Destroy()
				end
			end)
		end
	end
}
section:Toggle {
	Name = "Bunny Hop",
	Callback = function(bool)
		getgenv().BHOP = bool
		local suc, ass = pcall(function()
			game.Players.LocalPlayer.Character.jumpcd.Disabled = getgenv().BHOP
		end)
	end
}
section:Slider {
	Name = "Speed",
	Text = "[value]/50",
	Default = 25,
	Min = 10,
	Max = 50,
	Float = 1,
	Flag = "Speed 1",
	Callback = function(value)
		getgenv().Speed = value
	end
}
local CashHook
section:Toggle {
	Name = "Infinite Cash",
	Callback = function(bool)
		getgenv().InfiniteCash = bool
		if getgenv().InfiniteCash == true then
			CashHook = game.Players.LocalPlayer.Cash:GetPropertyChangedSignal("Value"):Connect(function()
				task.wait()
				game.Players.LocalPlayer.Cash.Value = 16000
			end)
		elseif getgenv().InfiniteCash and CashHook then
			CashHook:Disconnect()
		end
	end
}
local section =
tab:Section {
	Name = "Rejoin",
	Side = "Left"
}
section:Toggle {
	Name = "Rejoin When Kicked",
	Flag = "Rejoin When Kicked 1",
	Callback = function(bool)
		getgenv().JoinBackAfterKick = bool
		while getgenv().JoinBackAfterKick == true do
			task.wait()
			for i, v in next, game:GetService("Players").LocalPlayer.PlayerGui.GUI.Main.Chats:GetChildren() do
				if v:IsA("TextLabel") then
					if v.Text:match(VoteKickString) then
						game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
					end
				end
			end
		end
	end
}
section:Button {
	Name = "Rejoin",
	Callback = function()
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
	end
}

local section =
	tab:Section {
	Name = "FOV",
	Side = "Left"
}

getgenv().fov = 150
getgenv().fovvisible = false
getgenv().fovTransparency = 1
getgenv().fovThickness = 2
getgenv().fovColour = Color3.fromRGB(0, 76, 255)
local FOVring = Drawing.new("Circle")
task.spawn(
	function()
	while task.wait() do
		FOVring.Visible = getgenv().fovvisible
		FOVring.Radius = getgenv().fov
		FOVring.Transparency = getgenv().fovTransparency
		FOVring.Thickness = getgenv().fovThickness
		FOVring.Color = getgenv().fovColour
	end
end
)
FOVring.Thickness = getgenv().fovThickness
FOVring.Transparency = getgenv().fovTransparency
FOVring.Color = getgenv().fovColour
FOVring.Position = workspace.CurrentCamera.ViewportSize / 2
section:Toggle {
	Name = "FOV",
	Flag = "FOV 1",
	Callback = function(bool)
		getgenv().fovvisible = bool
	end
}
section:Slider {
	Name = "FOV Radius",
	Text = "[value]/250",
	Default = 100,
	Min = 50,
	Max = 250,
	Float = 1,
	Flag = "FOV Radius 1",
	Callback = function(value)
		getgenv().fov = value
	end
}
section:Slider {
	Name = "FOV Transparency",
	Text = "[value]/1",
	Default = 1,
	Min = 0,
	Max = 1,
	Float = 0.1,
	Flag = "FOV Transparency 1",
	Callback = function(value)
		getgenv().fovTransparency = value
	end
}
section:Slider {
	Name = "FOV Thickness",
	Text = "[value]/5",
	Default = 1,
	Min = 0,
	Max = 5,
	Float = 0.5,
	Flag = "FOV Thickness 1",
	Callback = function(value)
		getgenv().fovThickness = value
	end
}
section:ColorPicker{
	Name = "FOV Colour",
	Default = Color3.fromRGB(0, 76, 255),
	Flag = "FOV Colour 1",
	Callback = function(color)
		getgenv().fovColour = color
	end
}
local section =
	tab:Section {
	Name = "ESP",
	Side = "Right"
}
local KiriotESPLIB = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kiriot22/ESP-Lib/main/ESP.lua"))()
KiriotESPLIB.Players = false
KiriotESPLIB.Boxes = false
KiriotESPLIB:AddObjectListener(game:GetService("Workspace").Debris, {
	Type = "Part",
	CustomName = function(v)
		return v.Name
	end,
	Color = Color3.fromRGB(5, 132, 252),
	IsEnabled = "DroppedGun"
})
local firstTime = true
section:Toggle {
	Name = "ESP Switch",
	Flag = "ESP Switch 1",
	Callback = function(bool)
		if firstTime == true then
			espLib:Load()
			firstTime = false
		end
		KiriotESPLIB:Toggle(bool)
		espLib.options.enabled = bool
	end
}
section:Toggle {
	Name = "ESP Use Team Colours",
	Flag = "ESP Team Colours 1",
	Callback = function(bool)
		espLib.options.teamColor = bool
	end
}
section:Toggle {
	Name = "ESP Team Check",
	Flag = "ESP Team Check 1",
	Callback = function(bool)
		espLib.options.teamCheck = bool
	end
}
section:Toggle {
	Name = "ESP Visible Only",
	Flag = "ESP Visible Only 1",
	Callback = function(bool)
		espLib.options.visibleOnly = bool
	end
}
section:Toggle {
	Name = "ESP Names",
	Flag = "ESP Names 1",
	Callback = function(bool)
		espLib.options.names = bool
	end
}
section:Toggle {
	Name = "ESP Health Bars",
	Flag = "ESP Health Bars 1",
	Callback = function(bool)
		espLib.options.healthBars = bool
	end
}
section:Toggle {
	Name = "ESP Boxes",
	Flag = "ESP Boxes1",
	Callback = function(bool)
		espLib.options.boxes = bool
	end
}
section:Toggle {
	Name = "ESP Chams",
	Flag = "ESP Chams 1",
	Callback = function(bool)
		espLib.options.chams = bool
	end
}
section:Toggle {
	Name = "ESP Health Text",
	Flag = "ESP Health Text 1",
	Callback = function(bool)
		espLib.options.healthText = bool
	end
}
section:Toggle {
	Name = "ESP Distance",
	Flag = "ESP Distance 1",
	Callback = function(bool)
		espLib.options.distance = bool
	end
}
section:Toggle {
	Name = "ESP Arrows",
	Flag = "ESP Arrows 1",
	Callback = function(bool)
		espLib.options.outOfViewArrows = bool
	end
}
section:Toggle {
	Name = "ESP Arrows Outline",
	Flag = "ESP Arrows Outline 1",
	Callback = function(bool)
		espLib.options.outOfViewArrowsOutline = bool
	end
}
section:Toggle {
	Name = "ESP Tracers",
	Flag = "ESP Tracers 1",
	Callback = function(bool)
		espLib.options.tracers = bool
	end
}
section:Dropdown{
	Name = "ESP Tracers Origin",
	Content = {
		"Bottom",
		"Mouse",
		"Top"
	},
	Default = "Bottom",
	Flag = "Tracers Origin 1",
	Callback = function(option)
		espLib.options.tracerOrigin = option
	end
}
section:Toggle {
	Name = "Dropped Gun ESP",
	Callback = function(bool)
		KiriotESPLIB.DroppedGun = bool
	end
}
local section =
	tab:Section {
	Name = "Gun Models",
	Side = "Right"
}
getgenv().vmTransparency = 0.5
getgenv().vmMaterial = Enum.Material.Plastic
getgenv().vmColour = Color3.fromRGB(255, 255, 255)
section:Toggle{
	Name = "Assign Customizations",
	Callback = function(bool)
		getgenv().AssignCustomidsations = bool
		while getgenv().AssignCustomidsations == true do
			task.wait()
			for i, v in next, game:GetService("ReplicatedStorage").Viewmodels:GetDescendants() do
				if v:IsA('BasePart') then
					if not v.Name:match("Flash") then
						v.Transparency = getgenv().vmTransparency
						v.Color = getgenv().vmColour
						v.Material = getgenv().vmMaterial
					end
				end
			end
		end
	end
}
section:Dropdown{
	Name = "Gun Material",
	Content = {
		"Plastic",
		"Neon",
		"Glass",
		"ForceField",
		"SmoothPlastic",
		"Water"
	},
	Default = "ForceField",
	Flag = "Material 1",
	Callback = function(option)
		getgenv().vmMaterial = Enum.Material[option]
	end
}
section:ColorPicker{
	Name = "Gun Colour",
	Default = Color3.fromRGB(0, 76, 255),
	Flag = "VM Colour 1",
	Callback = function(color)
		getgenv().vmColour = color
	end
}
local Tab = main:Tab("Skins")
local section = Tab:Section{
	Name = "Open Cases",
	Side = "Left"
}
local Case = ""
local Cases = {}
for i, v in next, game:GetService("ReplicatedStorage").Cases:GetChildren() do
	table.insert(Cases, v.Name)
end
table.sort(GunSkins, function(a, b)
	return a < b
end)
table.sort(Guns, function(a, b)
	return a < b
end)
section:Dropdown{
	Name = "Select Case",
	Content = Cases or {},
	Default = "Golden Case",
	Flag = "Select Case 1",
	Callback = function(option)
		Case = option
	end
}
section:Toggle {
	Name = "Open Selected Case",
	Callback = function(bool)
		getgenv().OpenSelectedCase = bool
		while getgenv().OpenSelectedCase == true do
			task.wait()
			local args = {
				[1] = {
					[1] = "BuyCase",
					[2] = Case
				}
			}
			game:GetService("ReplicatedStorage").Events.DataEvent:FireServer(unpack(args))
		end
	end
}
section:Toggle {
	Name = "Go Back",
	Callback = function(bool)
		getgenv().GoBack = bool
		while getgenv().GoBack == true do
			task.wait()
			pcall(function()
				task.wait()
				for i, v in next, {
					"MouseButton1Down",
					"MouseButton1Up",
					"MouseButton1Click",
					"Activated"
				} do
					firesignal(game:GetService("Players").LocalPlayer.PlayerGui.Crates.Back[v])
				end
			end)
		end
	end
}
local section = Tab:Section{
	Name = "Case Info",
	Side = "Right"
}
local JustBoxedLabel = section:Label("Just Boxed: " .. JustBoxed)
task.spawn(function()
	while task.wait() do
		local thingAlonging = "Just Boxed: " .. JustBoxed
		JustBoxedLabel:Set(string.sub(thingAlonging, 1, 31))
	end
end)
local section = Tab:Section{
	Name = "Skins",
	Side = "Left"
}
local GunSkinDropdown = section:Dropdown{
	Name = "Gun Skins",
	Content = GunSkins or {},
	Default = GunSkins[1],
	Flag = "gun skins 1",
	Callback = function(option)
		selectedSkin = option
	end
}
section:Dropdown{
	Name = "Select Gun",
	Content = Guns or {},
	Default = Guns[1],
	Flag = "select gun 1",
	Callback = function(option)
		selectedGun = option
		GunSkins = {}
		for i, v in next, game:GetService("ReplicatedStorage").Skins[option]:GetChildren() do
			table.insert(GunSkins, v.Name)
		end
		table.sort(GunSkins, function(a, b)
			return a < b
		end)
		GunSkinDropdown:Refresh(GunSkins)
		GunSkinDropdown:Set(GunSkins[1])
	end
}
section:Button{
	Name = "Open Skin",
	Callback = function()
		CaseFunc(selectedGun, selectedSkin)
	end
}
local configs = main:Tab("Settings")
local configsection = configs:Section{
	Name = "Configurations",
	Side = "Left"
}
local configlist = configsection:Dropdown{
	Name = "Configs",
	Content = library:GetConfigs(),
	Flag = "Config Dropdown"
}
library:ConfigIgnore("Config Dropdown")
local loadconfig = configsection:Button{
	Name = "Load Config",
	Callback = function()
		library:LoadConfig(library.flags["Config Dropdown"])
	end
}
local delconfig = configsection:Button{
	Name = "Delete Config",
	Callback = function()
		library:DeleteConfig(library.flags["Config Dropdown"])
	end
}
local configbox = configsection:Box{
	Name = "Config Name",
	Placeholder = "Config Name",
	Flag = "Config Name"
}
library:ConfigIgnore("Config Name")
local save = configsection:Button{
	Name = "Save Config",
	Callback = function()
		library:SaveConfig(library.flags["Config Name"])
		configlist:Refresh(library:GetConfigs())
	end
}
configsection:Button {
	Name = "Refresh Config List",
	Callback = function()
		configlist:Refresh(library:GetConfigs())
	end
}
configsection:Label("Configs Are Slightly Buggy")

local section = configs:Section{
	Name = "Settings",
	Side = "Right"
}
section:Button{
	Name = "Unload GUI",
	Callback = function()
		library:Close()
	end
}
section:Label("Credits 2 Hexagon 4 Some Stuff")
section:Label("Credits 2 Kiriot ESP")
section:Label("Credits 2 Sirius ESP")
local section = configs:Section{
	Name = "More",
	Side = "Right"
}
section:Button{
	Name = "Discord",
	Callback = function()
		loadstring(game:HttpGet("https://soggyhubv2.vercel.app/Discord.lua"))()
	end
}
section:Button{
	Name = "Sunken#8620",
	Callback = function()
		setclipboard("Sunken#8620")
	end
}

local queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport) -- ty iy
game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(State)
	if State == Enum.TeleportState.Started then
		queueteleport("loadstring(game:HttpGet('https://soggyhubv2.vercel.app/Roblox/CB.lua'))()")
	end
end)