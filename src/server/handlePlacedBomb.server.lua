local dropMelon = game.ReplicatedStorage.Events:WaitForChild("dropMelon")
local gameSettings = game.ReplicatedStorage.gameSettings
local tileSize = gameSettings:GetAttribute("tileSize"); -- constant value

local neighbours = {}
local power = 2 --Users power

local function handleNeighbours()
    local originalColor
    for _,v in pairs (neighbours) do
        originalColor = v.BrickColor
        v.BrickColor = BrickColor.new("Flint")
    end
    wait (2)
    for _,v in pairs (neighbours) do
        v.BrickColor = BrickColor.new("Black")
        v:SetAttribute("killOnTouch", true)
        v.killOnTouch.Disabled = false
    end
    wait(.2)
    for _,v in pairs (neighbours) do
        v:SetAttribute("killOnTouch", false)
        v.BrickColor = originalColor
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
                    -- v.BrickColor = BrickColor.new("Black")
                    -- v:SetAttribute("killOnTouch", true)
                    --handleNeighbours()
                end
            end
            end
        end
        handleNeighbours()
        
    end
end)