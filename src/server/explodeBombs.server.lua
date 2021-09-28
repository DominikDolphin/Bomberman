local Debris = game:GetService("Debris")
local bombFolder = game.Workspace:WaitForChild("Bombs")
local avPowerUps = game.Workspace:WaitForChild("availablePowerUps")
local StatsCloud = game.ServerStorage:WaitForChild("StatsCloud")
local gameSettings = game.ReplicatedStorage.gameSettings
local tileSize = gameSettings:GetAttribute("tileSize"); -- constant value

function placePowerUp(name, parent, cf)
	local find = game.ServerStorage:FindFirstChild(name);
	if find then
		local copy = find:Clone()
		copy.Parent = parent
		copy.CFrame = cf.CFrame - Vector3.new(0,0.6,0)
	end

end

local function filterPlayers()
    local players = {}
    local getPlayers = game.Players:GetPlayers()
    for _,v in pairs (getPlayers) do
        table.insert(players,v.Character)
    end

    return players
end

function dropRandomPowerUp(box)
	local ran = math.random(1,4);
    print(ran)
	if (ran == 1 or ran == 2 or ran == 3) then
		if avPowerUps then
			if     ran == 1 then local copy = placePowerUp("PowerUp",avPowerUps, box)
			elseif ran == 2 then local copy = placePowerUp("MelonUp",avPowerUps, box) 
			elseif ran == 3 then local copy = placePowerUp("SpeedUp",avPowerUps, box)
			end
		end
	end

end

local function createBombRay(playerBomb, directionVector, orientationNumber)
    local radius = 1
    local origin = playerBomb.Position
    local power = playerBomb:GetAttribute("power")
    local powerRange = ((power * tileSize) + tileSize/2)
    local orientation = orientationNumber or 1
    
    local direction
    if directionVector == "UpVector" then
        direction = playerBomb.CFrame.UpVector * powerRange * orientation
    else
        direction =  playerBomb.CFrame.RightVector * powerRange * orientation
    end
   -- local direction = playerBomb.CFrame.UpVector * 100

    --Ray will go through players
    local playerCharacters = filterPlayers()

    --List of things to filter out
   local raycastParams = RaycastParams.new()
   raycastParams.FilterDescendantsInstances = {
        playerBomb, 
        playerCharacters,
        workspace.Rays:GetChildren(),
        workspace.Tiles:GetChildren(),
        workspace.availablePowerUps:GetChildren()
    }
    local midpoint = origin + direction/2
    local raycastResult = Workspace:Raycast(origin, direction, raycastParams)
    local killRay = Instance.new("Part")
    killRay.Anchored = true
    killRay.Parent = workspace.Rays
    killRay.CanCollide = false
    killRay.Transparency = 0.4
    killRay.BrickColor = BrickColor.Red()
    killRay:SetAttribute("originalOwner", playerBomb:GetAttribute("originalOwner"))
    killRay:SetAttribute("newOwner", playerBomb:GetAttribute("newOwner"))
    --killRay.Size = Vector3.new(tileSize,radius, direction.magnitude)
    
    if raycastResult then
        local hit = raycastResult.Instance
        local hitPos = raycastResult.Position
        if hit and hitPos then
            print(hit.Name)
            local touchPartDirection
            if directionVector == "UpVector" then
                touchPartDirection = playerBomb.CFrame.UpVector * -(hit.Position.Z - playerBomb.Position.Z)/2
            else
                touchPartDirection = playerBomb.CFrame.RightVector * (hit.Position.X - playerBomb.Position.X)/2 
            end
            local newMid = origin + touchPartDirection
            killRay.CFrame = CFrame.new(newMid,origin)
            killRay.Size = Vector3.new(tileSize-2,radius, touchPartDirection.magnitude )
            killRay.CFrame = killRay.CFrame + Vector3.new(0,1,0)
            if hit.Name == "Bomb" then
                hit:SetAttribute("explode",true)
                hit:SetAttribute("newOwner", playerBomb:GetAttribute("originalOwner"))
                --print(hit:GetAttribute("newOwner"))

                --print("========================================")
            end
            if hit.Name == "Crate" or hit.Parent == "Crates" then
                dropRandomPowerUp(hit)
                hit:Destroy()
            end
            if  hit.Name == "PowerUp" or 
                hit.Name == "SpeedUp" or 
                hit.Name == "MelonUp" 
            then hit:Destroy() end
            
        end  
    else -- It didnt hit anything
        killRay.CFrame = CFrame.new(midpoint,origin)
        killRay.CFrame = killRay.CFrame + Vector3.new(0,1,0)
        killRay.Size = Vector3.new(tileSize,radius, direction.magnitude)
    end
    
    local killScript = script.Parent:FindFirstChild("killOnTouch"):Clone()
    killScript.Parent = killRay
    return killRay
end

local function explode(playerBomb)
    --  p = plus | m = minus
    local Zp = createBombRay(playerBomb,"UpVector",-1)
    local Zm = createBombRay(playerBomb,"UpVector", 1)

    --Must change inside function from z to x for position/Cframe/size
    local Xp = createBombRay(playerBomb,"other", 1)
    local Xm = createBombRay(playerBomb,"other", -1)

    local activeRays = {}
    table.insert(activeRays, Zp)
    table.insert(activeRays, Zm)
    table.insert(activeRays, Xp)
    table.insert(activeRays, Xm)
    table.insert(activeRays,playerBomb)

    spawn(function()
        for _,v in pairs (activeRays) do
            Debris:AddItem(v,0.1)
        end
    end)
end

bombFolder.ChildAdded:Connect(function()
    if bombFolder then
        local allBombs = bombFolder:GetChildren()
        for i,bomb in pairs(allBombs) do
            bomb:GetAttributeChangedSignal("explode"):Connect(function()
                explode(bomb)
                print("YES DOMINIK IT WORKS")
            end)
        end
    end
end)