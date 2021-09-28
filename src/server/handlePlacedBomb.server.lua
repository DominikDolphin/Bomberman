local dropMelon = game.ReplicatedStorage.Events:WaitForChild("dropMelon")
local bomb = game.ServerStorage:WaitForChild("Bomb")
local Debris = game:GetService("Debris")
local power = 0 
local StatsCloud = game.ServerStorage:WaitForChild("StatsCloud")

local function createBomb()
    local clone = bomb:Clone()
    clone.Parent = game.Workspace.Bombs
    clone.Rotation = Vector3.new(0,-90,0)
    return clone
end

local function explodeIfNotAlready(playerBomb)
    if playerBomb:GetAttribute("explode") == false then
        playerBomb:SetAttribute("explode",true)
    end
end

dropMelon.OnServerEvent:connect(function(player,hit) --Params from dropBomb.client.lua

	local findPlayerStats = StatsCloud:FindFirstChild(player.Name)
	if findPlayerStats then
		local melons  = findPlayerStats:FindFirstChild("Melons")
		local melonsPlaced  = findPlayerStats:FindFirstChild("MelonsPlaced")
        local powerStat = findPlayerStats:FindFirstChild("Power")
		if melons and melonsPlaced and power then
			if melonsPlaced.Value < melons.Value then
				melonsPlaced.Value = melonsPlaced.Value + 1
                power = powerStat.Value
				local x = hit:GetAttribute("x")
				local z = hit:GetAttribute("z")

				if x and z then
					hit:SetAttribute("isOccupied",true)
					local playerBomb = createBomb()
                    playerBomb:SetAttribute("originalOwner" ,player.Name)
                    playerBomb:SetAttribute("newOwner" ,player.Name)
                    playerBomb:SetAttribute("power" ,power)
					playerBomb.CFrame = hit.CFrame + Vector3.new(0,4,0)
					playerBomb.Rotation = Vector3.new(-90,0,0)
					playerBomb.CanCollide = false
					playerBomb.moveUp.Disabled = false

					wait(2)
                    explodeIfNotAlready(playerBomb)
                    
                    hit:SetAttribute("isOccupied",false)
				end
                melonsPlaced.Value = melonsPlaced.Value - 1
			end
		end
	end 
end)