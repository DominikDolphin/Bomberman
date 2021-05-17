local dropMelon = game.ReplicatedStorage.Events:WaitForChild("dropMelon")
local gameSettings = game.ReplicatedStorage.gameSettings
local tileSize = gameSettings:GetAttribute("tileSize"); -- constant value
local bomb = game.ServerStorage:WaitForChild("Bomb")
local Debris = game:GetService("Debris")


local neighbours = {}
local power = 2 --Users power

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

local function handleNeighbours()
    local getScripts = {}
   -- local originalColor
    for _,v in pairs (neighbours) do
        --originalColor = v.BrickColor
        v.BrickColor = BrickColor.new("Flint")
        --table.insert(getScripts,v.killOnTouch)
    end
    wait (2)

   
    for _,v in pairs (neighbours) do
        v.BrickColor = BrickColor.new("Black")
        v:SetAttribute("killOnTouch", true)
        v.killOnTouch.Disabled = false
    end
    wait(.4)
    for _,v in pairs (neighbours) do
        v:SetAttribute("killOnTouch", false)
        v.BrickColor = BrickColor.Green()
        v.killOnTouch.Disabled = true
    end
    table.clear(neighbours)
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
        
        local radius = 1
        local origin = playerBomb.Position
        local direction = playerBomb.CFrame.UpVector * 100
        local midpoint = origin + direction/2
        local raycastResult = Workspace:Raycast(origin, direction)
        local killRay = Instance.new("Part")
        killRay.Anchored = true
        killRay.Parent = workspace
        killRay.CFrame = CFrame.new(midpoint,origin)
        killRay.Size = Vector3.new(tileSize,radius, direction.magnitude)
    end

end)
--[[
dropMelon.OnServerEvent:connect(function(player,hit) --Params from dropBomb.client.lua
    local x = hit:GetAttribute("x")
    local z = hit:GetAttribute("z")
    
    if x and z then
        hit:SetAttribute("isOccupied",true)
        print(x .." | " ..z)
        local playerBomb = createBomb()
        playerBomb.CFrame = hit.CFrame + Vector3.new(0,4,0)
        Debris:AddItem(playerBomb,2.1)
        
        
        for _,v in pairs(game.Workspace.Tiles:GetChildren()) do
            local vx = v:GetAttribute("x")
            local vz = v:GetAttribute("z")
            if vx and vz then
                
                --Loop that iterates the value of players power and captures
                --the neighbouring cells
                for i = 1,power do
                    if ((vx == x+tileSize*i) and (vz == z)) or
                        ((vx == x-tileSize*i) and (vz == z)) or
                        ((vz == z+tileSize*i) and (vx == x)) or
                        ((vz == z-tileSize*i) and (vx == x))
                    then
                        table.insert(neighbours,v)
                    end
                end
                table.insert(neighbours,hit)
            end
        end

         handleNeighbours()

       -- testTouch() 
        
        hit:SetAttribute("isOccupied",false)
    end
end)
]]
