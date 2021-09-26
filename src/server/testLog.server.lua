 local ReplicatedStorage = game:GetService("ReplicatedStorage")
 local killfeedEvent = ReplicatedStorage:WaitForChild("KillfeedEvent")

-- game.Players.PlayerAdded(function(player)
--     print("player joined")
--     --killfeedEvent:FireAllClients(player.Name .. " joined!")
-- end)

game.Players.PlayerAdded:Connect(function(player)
	killfeedEvent:FireAllClients(player.Name .. " joined!")
end)