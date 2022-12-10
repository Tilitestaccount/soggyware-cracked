local Multi = getgenv().Multi or 999

local Values = {
    GearSpeeds = {
        [-1] = -1*Multi,
        [1] = 1*Multi,
        [2] = 2*Multi,
        [3] = 3*Multi,
        [4] = 4*Multi,
        [5] = 5*Multi,
        [6] = 6*Multi,
        [7] = 7*Multi,
        [8] = 8*Multi,
    },
    GearAccels = {
        [-1] = 8*Multi,
        [1] = 7*Multi,
        [2] = 6*Multi,
        [3] = 5*Multi,
        [4] = 4*Multi,
        [5] = 3*Multi,
        [6] = 2*Multi,
        [7] = 1*Multi,
        [8] = 2*Multi,
    },
    GearTorques = {
        [-1] = 8*Multi,
        [1] = 7*Multi,
        [2] = 6*Multi,
        [3] = 5*Multi,
        [4] = 4*Multi,
        [5] = 3*Multi,
        [6] = 2*Multi,
        [7] = 1*Multi,
        [8] = 2*Multi,
    },
}

local SolarisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stebulous/solaris-ui-lib/main/source.lua"))()

local win = SolarisLib:New({
  Name = "Car Dealership Tycoon",
  FolderToSave = "Car Dealership Tycoon"
})

local tab = win:Tab("Tab 1")

local sec = tab:Section("Main")

sec:Button("Set Speed | Be In Car", function()
    for i,v in next, getgc(true) do
        if typeof(v) == "table" then
            for i2,v2 in next, Values do
                if rawget(v, i2) then
                    rawset(v, i2, v2)
                end
            end
        end
    end
  SolarisLib:Notification("Speed", "Changed Speed")
end)

sec:Textbox("Speed", true, function(t)
    Multi = tonumber(t)
    SolarisLib:Notification("Speed", tonumber(t))
end)