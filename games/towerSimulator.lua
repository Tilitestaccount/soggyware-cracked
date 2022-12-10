local function GetPlot()
    for i,v in next, workspace:GetChildren() do
        if v.Name == "Tower" then
            if v:FindFirstChild("Owner") then
                if v.Owner.Value == game.Players.LocalPlayer then
                    return v
                end
            end
        end
    end
end

local Plot = GetPlot()

if Plot == nil then
    for i,v in next, workspace:GetChildren() do
        if v.Name == "Tower" then
            if v:FindFirstChild("Owner") then
                if v.Owner.Value == nil then
                    Plot = v
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Origin.CFrame
                    task.wait(1)
                    fireclickdetector(v.ClickDetector)
                    break
                end
            end
        end
    end
end

local function Click()
    fireclickdetector(Plot.ClickDetector)
end

local SolarisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stebulous/solaris-ui-lib/main/source.lua"))()

local win = SolarisLib:New({
    Name = "Tower Simulator",
    FolderToSave = "Tower Simulator"
})

local tab = win:Tab("Tab 1")

local sec = tab:Section("Main")

sec:Toggle("Click", false,"Click", function(t)
    getgenv()["Click"] = t

    while getgenv()["Click"] == true do
        task.wait()
        Click()
    end
end)