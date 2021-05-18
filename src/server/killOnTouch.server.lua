script.Parent.Touched:Connect(function(hit)
    
    local h = hit.Parent:FindFirstChild("Humanoid")
    if h then
        h.Health = 0
    end
    if hit.Parent == "availablePowerUps" then
        hit:Destroy()
    end
end)