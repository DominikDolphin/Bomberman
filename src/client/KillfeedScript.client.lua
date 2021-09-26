local ReplicatedStorage = game:GetService("ReplicatedStorage")
local killfeedEvent = ReplicatedStorage.KillfeedEvent

local killfeedModule = require(ReplicatedStorage.Common.Killfeed)

local gui = game.Players.LocalPlayer.PlayerGui:WaitForChild("MelonBomber")
local logs = gui:WaitForChild("Logs")
local template = logs:WaitForChild("Template")

local killfeed = killfeedModule:New(template)

killfeedEvent.OnClientEvent:Connect(function(str)
    killfeed = killfeed + str
end)

