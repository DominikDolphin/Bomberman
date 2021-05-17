local dropMelon = game.ReplicatedStorage.Events:WaitForChild("dropMelon")
local gameSettings = game.ReplicatedStorage.gameSettings
local tileSize = gameSettings:GetAttribute("tileSize"); -- constant value
local bomb = game.ServerStorage:WaitForChild("Bomb")
local Debris = game:GetService("Debris")

local neighbours = {}
local power = 3 --Users power

local function testTouch()
    for _,v in pairs (neighbours) do
        local toKill = v:GetAttribute("killOnTouch")
        if toKill then
            for _,p in pairs(v:GetTouchingParts()) do
                
                local player = p.Parent:FindFirstChild("Humanoid")
                if player then
                    player.Health = 0
                end
            end
        end
    end
end

local function createBomb()
    local clone = bomb:Clone()
    clone.Parent = game.Workspace.Bombs
    clone.Rotation = Vector3.new(0,-90,0)
    return clone
end

local function createExplosion(part)
    local exp = Instance.new("Explosion")
    
    exp.DestroyJointRadiusPercent = 0
    exp.BlastPressure = 0
    exp.Position = part.Position
	exp.Parent = part
    return exp;
end

local function filterPlayers()
    local players = {}
    local getPlayers = game.Players:GetPlayers()
    for _,v in pairs (getPlayers) do
        table.insert(players,v.Character)
    end

    return players
end
-- createBombRay(playerBomb, "UpVector", orientation)
local function createBombRay(playerBomb, directionVector, orientationNumber)
    local radius = 1
    local origin = playerBomb.Position
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
        workspace.Tiles:GetChildren()
    }
    local midpoint = origin + direction/2

    local raycastResult = Workspace:Raycast(origin, direction, raycastParams)
    local killRay = Instance.new("Part")
    killRay.Anchored = true
    killRay.Parent = workspace.Rays
    
    --killRay.Size = Vector3.new(tileSize,radius, direction.magnitude)
    
    if raycastResult then
        local hit = raycastResult.Instance
        local hitPos = raycastResult.Position
        if hit and hitPos then
            hit.BrickColor = BrickColor.Red()
            
            local touchPartDirection = playerBomb.CFrame.UpVector * (((playerBomb.Position.Z + hitPos.Z)/2)-hitPos.Z/2)
            local newMid = origin + touchPartDirection/2
            killRay.CFrame = CFrame.new(newMid,origin)
            killRay.Size = Vector3.new(tileSize,radius, touchPartDirection.magnitude )
        end  
    else -- It didnt hit anything
        --print("Didnt detect")
        killRay.CFrame = CFrame.new(midpoint,origin)
        killRay.Size = Vector3.new(tileSize,radius, direction.magnitude)
    end
end


dropMelon.OnServerEvent:connect(function(player,hit) --Params from dropBomb.client.lua
    local x = hit:GetAttribute("x")
    local z = hit:GetAttribute("z")
    
    if x and z then
        hit:SetAttribute("isOccupied",true)
        print(x .." | " ..z)
        local playerBomb = createBomb()
        playerBomb.CFrame = hit.CFrame + Vector3.new(0,4,0)
        playerBomb.Rotation = Vector3.new(-90,0,0)
        --Debris:AddItem(playerBomb,2.1)

        --  p = plus
        --  m = minuse
        local Zp = createBombRay(playerBomb,"UpVector",-1)
        local Zm = createBombRay(playerBomb,"UpVector", 1)

        --Must change inside function from z to x for position/Cframe/size
        -- local Xp = createBombRay(playerBomb,"other", 1)
        -- local Xm = createBombRay(playerBomb,"other", -1)
    end

end)