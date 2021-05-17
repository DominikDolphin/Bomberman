local Array = require(game.ReplicatedStorage.Common.Array2D)
local gameSettings = game.ReplicatedStorage.gameSettings
local tileSize = gameSettings:GetAttribute("tileSize"); -- constant value
local tileFolder = game.Workspace.Tiles
local grid = Array.new(11,11) --Array Size
local Pos = CFrame.new(0,5,0); --Starting Position
local ColorPos = 0; --Used for tile colours

local function addKillScript(part)
	local killScript = script.Parent.killOnTouch:Clone()
	killScript.Parent = part
	killScript.Disabled = true
end

local function createPart(parent)
	local part = Instance.new("Part")
	part.Parent = parent or tileFolder
	part.Anchored = true
	part.Size = Vector3.new(tileSize,5,tileSize)
	part.TopSurface = Enum.SurfaceType.Smooth
	part.Material = "Grass"
	addKillScript(part)
	return part;
end

local function addAttributes(part,x,z)
	part:SetAttribute("x",x);
	part:SetAttribute("z",z);
	part:SetAttribute("isOccupied",false)
	part:SetAttribute("killOnTouch", false)
end

local function addWalls(x,z)
	if x == tileSize --First Column
		or z == tileSize --First Row
		or x == grid:GetColumnLength()*tileSize --Last Column
		or z == grid:GetRowLength()*tileSize -- Last Row
	then 
		local wall = createPart(game.Workspace.Walls)
		wall.CFrame = Pos + Vector3.new(x,5,z)
		wall.BrickColor = BrickColor.Black()
	end
end

local function gridColorPattern(part)
	if ColorPos % 2 == 0 then
		part.BrickColor = BrickColor.Green() 
	else 
		part.BrickColor = BrickColor.new(0,176,0) end
end

local function createGameBoard()
	for z = tileSize,grid:GetRowLength()*tileSize,tileSize do
		for x = tileSize,grid:GetColumnLength()*tileSize,tileSize do
			local part = createPart();
			part.CFrame = Pos + Vector3.new(x,0,z)
			addAttributes(part,x,z);
			gridColorPattern(part)
			addWalls(x,z)
			ColorPos = ColorPos + 1
		end
	end
end

createGameBoard()