local Players = game:GetService("Players")

local SolarisLib =
loadstring(game:HttpGet("https://raw.githubusercontent.com/Stebulous/solaris-ui-lib/main/source.lua"))()
local win =
SolarisLib:New(
{
    Name = "Soggyware",
    FolderToSave = "Soggyware"
}
)
local tab = win:Tab("Main")

local sec = tab:Section("Functions")

sec:Toggle("Kill All | Have Gun Equipped", false,"Kill All", function(t)
    getgenv().KillAll = t

    while KillAll do task.wait()
        pcall(function()
            for i,v in next, Players:GetPlayers() do
                if v ~= Players.LocalPlayer then
                    if v.Character then
                        local args = {
                            [1] = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool"),
                            [2] = {
                                ["p"] = Vector3.new(119.07585906982422, 14.475720405578613, 7.286960601806641),
                                ["pid"] = 1,
                                ["part"] = v.Character.Head,
                                ["d"] = 47.71980667114258,
                                ["maxDist"] = 47.6925163269043,
                                ["h"] = v.Character.Humanoid,
                                ["m"] = Enum.Material.SmoothPlastic,
                                ["sid"] = 10,
                                ["t"] = 0.1341280924078226,
                                ["n"] = Vector3.new(-0.1858132779598236, -0.952629566192627, 0.24077072739601135)
                            }
                        }
                        game:GetService("ReplicatedStorage").WeaponsSystem.Network.WeaponHit:FireServer(unpack(args)) 
                    end
                end
            end
        end)
    end
end)