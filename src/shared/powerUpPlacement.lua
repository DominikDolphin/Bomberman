local powerUp = {}
local avPowerUps = game.Workspace:WaitForChild("availablePowerUps")


local function placePowerUp(name, parent, cf)
	local find = game.ServerStorage:FindFirstChild(name);
	if find then
		local copy = find:Clone()
		copy.Parent = parent
		copy.CFrame = cf.CFrame - Vector3.new(0,0.6,0)
	end
end

function powerUp.dropRandomPowerUp(box)
	local ran = math.random(1,4);
    --print(ran)
	if (ran == 1 or ran == 2 or ran == 3) then
		if avPowerUps then
			if     ran == 1 then local copy = placePowerUp("PowerUp",avPowerUps, box)
			elseif ran == 2 then local copy = placePowerUp("MelonUp",avPowerUps, box) 
			elseif ran == 3 then local copy = placePowerUp("SpeedUp",avPowerUps, box)
			end
		end
	end
end

return powerUp