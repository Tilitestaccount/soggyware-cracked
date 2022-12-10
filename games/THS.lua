local Util = {}
do
    setmetatable(Util, {
        __call = function(table, service)
            return game:GetService(service)
        end
    })
    Util.Network = {}
    function Util.Network:Call(functionName, ...)
        for i,v in next, Util("ReplicatedStorage"):GetDescendants() do
            if v.Name == functionName and v:IsA("RemoteFunction") then
                v:InvokeServer(...)
            end
        end
    end
    function Util.Network:Fire(remoteName, ...)
        for i,v in next, Util("ReplicatedStorage"):GetDescendants() do
            if v.Name == remoteName and v:IsA("RemoteEvent") then
                v:FireServer(...)
            end
        end
    end
    function Util.Network:Fetch(name, type)
        for i,v in next, Util("ReplicatedStorage"):GetDescendants() do
            if v.Name == name and v:IsA(type) then
                return v
            end
        end
    end
end

local UtilLib = Util
local Utils = {}
local Network = UtilLib.Network
local workspace = UtilLib("Workspace")
local clients = UtilLib("Players")
local client = clients.LocalPlayer
local replicated = UtilLib("ReplicatedStorage")
local locationModule = replicated.Modules.Location
local areaContainer = workspace.BlockTerrain
local gameItems = replicated.Modules.GameItems
local petItems = replicated.Modules.PetItems
local islandInfo = require(game:GetService("ReplicatedStorage").Modules.IslandInfo)
local Params = RaycastParams.new()
Params.FilterType = Enum.RaycastFilterType.Whitelist
Params.FilterDescendantsInstances = {(workspace:WaitForChild("BlockTerrain"))}
Params.IgnoreWater = true
getgenv()["Select Egg"] = ""
getgenv()["Select Amount"] = 3
local Eggs = {}
table.foreach(require(petItems).Eggs, function(a,b)
    table.insert(Eggs, a)
end)

Utils.HatchEgg = function()
    local egg = getgenv()["Select Egg"]
    local amount = getgenv()["Select Amount"]
    Network:Fire("RequestEggHatch", egg, amount)
end

Utils.Spin = function()
    for i = 1,12 do
        Network:Call("ClaimDailyReward", i)
    end
end

Utils.GetIsland = function()
    return require(locationModule).GetClosestIslandName({}, client)
end

Utils.GetBlockBeneath = function()
    local ray = workspace:Raycast(client.Character:GetPivot().Position, Vector3.new(0,-50,0), Params)
    local hit = ray.Instance
    return hit:GetPivot().Position
end

Utils.Mine = function(Where)
    Network:Call("TerrainToolRequest", Utils.GetIsland(), Where)
end

Utils.MineBlockBeneath = function()
    Utils.Mine(Utils.GetBlockBeneath())
end

Utils.GetChest = function()
    local target, dist = nil, math.huge
    for i,v in next, areaContainer[Utils.GetIsland()]:GetDescendants() do
        if v:IsA("Part") then
            if v.Name:find("Chest") then
                local mag = (client.Character:GetPivot().Position - v:GetPivot().Position).Magnitude
                if mag < dist then
                    dist = mag
                    target = v
                end
            end
        end
    end
    return target
end

Utils.MineAura = function()
    for i,v in next, areaContainer[Utils.GetIsland()]:GetDescendants() do
        if v:IsA("Part") and not v.Name:find("Chest") then
            local pos = v:GetPivot().Position
            local mag = (client.Character:GetPivot().Position - pos).Magnitude
            if mag <= 10 then
                Utils.Mine(pos)
            end
        end
    end
end

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
	Name = "Treasure Hunt Islands",
	LoadingTitle = "Soggyware",
	LoadingSubtitle = "- 2021-2022 -",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "Soggyware",
		FileName = "Treasure Hunt Islands"
	},
	Discord = {
		Enabled = true,
		Invite = "bBZxdAhS9J",
		RememberJoins = true
	}
})

local Tab = Window:CreateTab("Home Tab", 11600721595)

Tab:CreateSection("Information")

Tab:CreateLabel("Release")

Tab:CreateSection("Discord")

Tab:CreateButton({
    Name = "Join Discord",
    Callback = function()
        (syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or getgenv().request or request)({
            Url = 'http://127.0.0.1:6463/rpc?v=1',
            Method = 'POST',
            Headers = {
                ['Content-Type'] = 'application/json',
                Origin = 'https://discord.com'
            },
            Body = game:GetService("HttpService"):JSONEncode({
                cmd = 'INVITE_BROWSER',
                nonce = game:GetService("HttpService"):GenerateGUID(false),
                args = {code = 'bBZxdAhS9J'}
            })
        })
    end
})

local Tab = Window:CreateTab("Farming Tab", 11630855296)

Tab:CreateSection("Mining")

Tab:CreateToggle({
	Name = "Auto Mine Block Beneath",
	CurrentValue = false,
	Flag = "Auto Mine Block Beneath",
	Callback = function(x)
		getgenv()["Auto Mine Block Beneath"] = x
		while getgenv()["Auto Mine Block Beneath"] do
			task.wait()
			if getgenv()["Auto Mine Block Beneath"] == false then
				return
			end
            local Backpack = client.PlayerGui.Gui.Currency.Backpack.Amount.Text:gsub(" ", ""):split("/")
            if getgenv()["Auto Sell"] == true and Backpack[1] == Backpack[2] then
                local oldPos = client.Character:GetPivot()
                task.wait(0.25)
                require(locationModule).ToSell({}, client, Utils.GetIsland())
                task.wait(0.25)
                Network:Fire("RequestSell", Utils.GetIsland())
                task.wait(0.5)
                client.Character:PivotTo(oldPos)
            else
                pcall(Utils.MineBlockBeneath)
            end
		end
	end
})

Tab:CreateToggle({
	Name = "Auto Mine Aura",
	CurrentValue = false,
	Flag = "Auto Mine Aura",
	Callback = function(x)
		getgenv()["Auto Mine Aura"] = x
		while getgenv()["Auto Mine Aura"] do
			task.wait()
			if getgenv()["Auto Mine Aura"] == false then
				return
			end
            local Backpack = client.PlayerGui.Gui.Currency.Backpack.Amount.Text:gsub(" ", ""):split("/")
            if getgenv()["Auto Sell"] == true and Backpack[1] == Backpack[2] then
                local oldPos = client.Character:GetPivot()
                task.wait(0.25)
                require(locationModule).ToSell({}, client, Utils.GetIsland())
                task.wait(0.25)
                Network:Fire("RequestSell", Utils.GetIsland())
                task.wait(0.5)
                client.Character:PivotTo(oldPos)
            else
                pcall(Utils.MineAura)
            end
		end
	end
})

Tab:CreateSection("Sell")

Tab:CreateToggle({
	Name = "Auto Sell",
	CurrentValue = false,
	Flag = "Auto Mine Aura",
	Callback = function(x)
		getgenv()["Auto Sell"] = x
	end
})

local Tab = Window:CreateTab("Pet Tab", 11600742450)

Tab:CreateSection("Eggs")

Tab:CreateToggle({
	Name = "Auto Hatch Egg",
	CurrentValue = false,
	Flag = "Auto Hatch Egg",
	Callback = function(x)
		getgenv()["Auto Hatch Egg"] = x
		while getgenv()["Auto Hatch Egg"] do
			task.wait()
			if getgenv()["Auto Hatch Egg"] == false then
				return
			end
            Utils.HatchEgg()
		end
	end
})

Tab:CreateDropdown({
	Name = "Select Egg",
	Options = Eggs,
	CurrentOption = "",
	Flag = "Select Egg",
	Callback = function(x)
		getgenv()["Select Egg"] = x
	end
})


Tab:CreateToggle({
	Name = "Triple",
	CurrentValue = false,
	Flag = "Triple",
	Callback = function(x)
        local amt = (x == true and 3 or x == false and 1)
		getgenv()["Select Amount"] = amt
	end
})

local Tab = Window:CreateTab("Shopping Tab", 11600750651)

local Section = Tab:CreateSection("Buy Island Items")

Tab:CreateToggle({
	Name = "Auto Buy Island Tools",
	CurrentValue = false,
	Flag = "Auto Buy Island Tools",
	Callback = function(x)
		getgenv()["Auto Buy Island Tools"] = x
		while getgenv()["Auto Buy Island Tools"] do
			task.wait()
			if getgenv()["Auto Buy Island Tools"] == false then
				return
			end
            local Island = Utils.GetIsland()
            table.foreach(islandInfo.UpgradeShopItems[Island].Tools, function(a,b)
                Network:Fire("UIAction", "Tools", a, Island)
            end)
		end
	end
})

Tab:CreateToggle({
	Name = "Auto Buy Island Backpacks",
	CurrentValue = false,
	Flag = "Auto Buy Island Backpacks",
	Callback = function(x)
		getgenv()["Auto Buy Island Backpacks"] = x
		while getgenv()["Auto Buy Island Backpacks"] do
			task.wait()
			if getgenv()["Auto Buy Island Backpacks"] == false then
				return
			end
            local Island = Utils.GetIsland()
            table.foreach(islandInfo.UpgradeShopItems[Island].Backpacks, function(a,b)
                Network:Fire("UIAction", "Backpacks", a, Island)
            end)
		end
	end
})

Tab:CreateToggle({
	Name = "Auto Buy Island Crates",
	CurrentValue = false,
	Flag = "Auto Buy Island Crates",
	Callback = function(x)
		getgenv()["Auto Buy Island Crates"] = x
		while getgenv()["Auto Buy Island Crates"] do
			task.wait()
			if getgenv()["Auto Buy Island Crates"] == false then
				return
			end
            local Island = Utils.GetIsland()
            table.foreach(islandInfo.UpgradeShopItems[Island].Crates, function(a,b)
                Network:Fire("UIAction", "Crates", a, Island)
            end)
		end
	end
})

local Tab = Window:CreateTab("Misc Tab", 11600761450)

Tab:CreateSection("Spins")

Tab:CreateToggle({
	Name = "Auto Spin Wheel",
	CurrentValue = false,
	Flag = "Auto Spin Wheel",
	Callback = function(x)
		getgenv()["Auto Spin Wheel"] = x
		while getgenv()["Auto Spin Wheel"] do
			task.wait()
			if getgenv()["Auto Spin Wheel"] == false then
				return
			end
            Utils.Spin()
		end
	end
})

loadstring(game:HttpGet("https://soggyhubv2.vercel.app/Libs/RayfieldTabs.lua"))()(Window)

Rayfield:LoadConfiguration()