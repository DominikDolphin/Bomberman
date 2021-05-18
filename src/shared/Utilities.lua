--[[
List of functions
1. crateInt(name,parent,val)
2. createFolder(name,parent)
3. add(val) works like +=
4. find(location,what)
5. isInArray(what, array)
]]

local utils = {}

local avPowerUps = game.Workspace:FindFirstChild("availablePowerUps")

--Create Int Value
function utils.createInt(name,parent,val)
		local thisInt = Instance.new("IntValue")
		thisInt.Parent = parent
		thisInt.Name = name or "No_given_name"
		thisInt.Value = val or 0

		return thisInt;
end

--create Folder
function utils.createFolder(name,parent)
	local newFolder = Instance.new("Folder");
	newFolder.Name = name;
	newFolder.Parent = parent;
	
	return newFolder;
end

-- +=
function utils.add(object,val)
	object.Value = object.Value + val
end

--FindFirstChild
function utils.find(from, whatToFind)
	return from:FindFirstChild(whatToFind)
end

--Checks if the value of what is in given array
function utils.isInArray(what, array)
	local found = false
	for i,v in ipairs (array) do
		if v == what then
			found = true
			break;
		end
	end
	return found
end

return utils
