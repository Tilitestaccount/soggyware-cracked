local HttpService = game:GetService("HttpService")
local tycoon = game:GetService("Workspace").Tycoons[game.Players.LocalPlayer.Name]
local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart

function Deposit()
    for i = 0,1 do
        firetouchinterest(hrp, tycoon.Buttons.Sell, i)
    end
end

function getHoney()
    for i,v in next, tycoon.Honey:GetDescendants() do
        if v:IsA("Part") then
            v.CFrame = hrp.CFrame
        end
    end
end

function mergeBees()
    for i = 0,1 do
        firetouchinterest(hrp, tycoon.Buttons.MergeBees, i)
    end
end

function upgradeRate()
    for i = 0,1 do
        firetouchinterest(hrp, tycoon.Buttons["Faster_Button"], i)
    end
end

function buyBees()
    for i = 0,1 do
        firetouchinterest(hrp, tycoon.Buttons["Purchase_Bee"], i)
    end
end

function doObby()
    task.spawn(function()
        coroutine.wrap(function()
            hrp.CFrame = game:GetService("Workspace").Obbies.Winter["Teleport_To"].CFrame
            task.wait(.4)
            hrp.CFrame = game:GetService("Workspace").Obbies.Winter["Special_Task"].Lever.CFrame
            task.wait(.2)
            fireproximityprompt(game:GetService("Workspace").Obbies.Winter["Special_Task"].Lever.ProximityPrompt)
            task.wait(2)
            for i = 0,1 do
                firetouchinterest(hrp, game:GetService("Workspace").Obbies.Winter["End_Obby"], i)
            end
            print("done")
        end)()
    end)
end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/vozoid/ui-libraries/main/drawing/void/source.lua"))()

local watermarkText = "soggyware | %s fps | v1.00"
local watermark = library:Watermark(watermarkText)

local RunService = game:GetService("RunService")
local FpsLabel = watermark
local TimeFunction = RunService:IsRunning() and time or os.clock
local LastIteration, Start
local FrameUpdateTable = {}
local function HeartbeatUpdate()
	LastIteration = TimeFunction()
	for Index = #FrameUpdateTable, 1, -1 do
		FrameUpdateTable[Index + 1] = FrameUpdateTable[Index] >= LastIteration - 1 and FrameUpdateTable[Index] or nil
	end
	FrameUpdateTable[1] = LastIteration
	FpsLabel:Set(watermarkText:format(tostring(math.floor(TimeFunction() - Start >= 1 and #FrameUpdateTable or #FrameUpdateTable / (TimeFunction() - Start)))))
end

Start = TimeFunction()
RunService.Heartbeat:Connect(HeartbeatUpdate)

local SolarisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stebulous/solaris-ui-lib/main/source.lua"))()

local win = SolarisLib:New({
    Name = "bee power tycoon - soggyware",
    FolderToSave = "bpt_sgwr"
})

local tab = win:Tab("tab one")

local sec = tab:Section("main")

sec:Toggle("deposit honey", false,"deposit honey", function(t)
    getgenv()["deposit honey"] = t

    while getgenv()["deposit honey"] do
        task.wait()
        Deposit()
    end
end)

sec:Toggle("get honey", false,"get honey", function(t)
    getgenv()["get honey"] = t

    while getgenv()["get honey"] do
        task.wait()
        getHoney()
    end
end)

sec:Toggle("merge bees", false,"merge bees", function(t)
    getgenv()["merge bees"] = t

    while getgenv()["merge bees"] do
        task.wait()
        mergeBees()
    end
end)

sec:Toggle("upgrade rate", false,"upgrade rate", function(t)
    getgenv()["upgrade rate"] = t

    while getgenv()["upgrade rate"] do
        task.wait()
        upgradeRate()
    end
end)

sec:Toggle("buy bees", false,"buy bees", function(t)
    getgenv()["buy bees"] = t

    while getgenv()["buy bees"] do
        task.wait()
        buyBees()
    end
end)

local sec = tab:Section("misc")

sec:Button("do obby", function()
    doObby()
end)

sec:Toggle("do obby", false,"do obby", function(t)
    getgenv()["do obby"] = t

    while getgenv()["do obby"] do
        task.wait()
        doObby()
    end
end)

-- for i,v in next, getgc(true) do
--     if typeof(v) == "table" then
--         if rawget(v, "Amount") then
--             if typeof(rawget(v, "Amount")) == "number" then
--                 rawset(v, "Amount", 1)
--             end
--         end
--     end
-- end

-- for i,v in next, getgc(true) do
--     if typeof(v) == "table" then
--         if rawget(v, "ExecuteFunction") then
--             if typeof(rawget(v, "ExecuteFunction")) == "function" then
--                 local constants = getconstants(v.ExecuteFunction)
--                 print("constants")
--                 for i2,v2 in next, constants do
--                     print(i2,v2)
--                 end
--                 if table.find(constants, "Data") and table.find(constants, "PlayerTycoons") and table.find(constants, "SellingHoney") then
--                     v.ExecuteFunction(..., game.Players.LocalPlayer)
--                 end
--             end
--         end
--     end
-- end