--[[
	Codebot
	9/12/2020

	Creates leaderstats for Players and also checks for when
	Stats are upgraded server side to update on the client
]]

local utilities = require(game.ReplicatedStorage.Common.Utilities);

--Parallel Array of Stat name and value
local statNames = {"Power", "Speed", "Melons", "MelonsPlaced"};
local statValues = {2,1,2,0};

--Create a Storage
local statsStorage = utilities.createFolder("StatsCloud", game.ServerStorage);
local colors = {"Really red", "Bright blue", "Bright green", "Bright yellow"}
game.Players.PlayerAdded:connect(function(player)
	--Create Leaderstats on local player
	local leaderstats = utilities.createInt("leaderstats", player, 0)

	--Creates a folder to store on the server's player stats
	local serverStatsFolder = utilities.createFolder(player.Name,statsStorage);
	
	--Create all stats locally
	for i = 1,#statNames do
		utilities.createInt(statNames[i], leaderstats, statValues[i]);
		utilities.createInt(statNames[i], serverStatsFolder, statValues[i]);
	end
	
	--Upgrade client's value when server value changes
	local checkServerStats = serverStatsFolder:GetChildren();
	for i,v in pairs(checkServerStats) do
		v.Changed:connect(function()
			local findPlayer = game.Players:FindFirstChild(v.Parent.Name)
			if findPlayer then
				local findLeaderstat = findPlayer:FindFirstChild("leaderstats")
				if findLeaderstat then
					local getStat = findLeaderstat:FindFirstChild(v.Name)
					if getStat then
						getStat.Value = v.Value;
					end
				end
			end
		end)
	end
	
	--Give player random color
	wait(1)
	local char = utilities.find(game.Workspace,player.Name)
	if char then
		local bodColor = utilities.find(char,"Body Colors")
		if bodColor then
			bodColor.TorsoColor = BrickColor.new(math.random(1,#colors))
		end
	end
end)