wait(.01)
script.Parent.Touched:Connect(function(player)
    
    local h = player.Parent:FindFirstChild("Humanoid")
    if h then
        h.Health = 0
    end
end)