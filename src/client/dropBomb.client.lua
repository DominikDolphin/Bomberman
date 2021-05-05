local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local dropMelon = ReplicatedStorage.Events:WaitForChild("dropMelon")
local player = game.Players.LocalPlayer


game:GetService("UserInputService").InputBegan:connect(function(input, Processed)
	if not Processed then
		if input.KeyCode == Enum.KeyCode.F then --a PC key was pressed
			local playerHead = player.Character:WaitForChild("Head")
			if playerHead then
				
				local upVect = playerHead.CFrame.upVector
				local ray = Ray.new(playerHead.Position, (upVect*(-1)).unit*500,100,false)
				local hit,position = game.Workspace:FindPartOnRay(ray, player.Character, false)
				local distance = (player.Character.Head.Position - position).magnitude

				if hit ~= nil then
					local x = hit:GetAttribute("x")
					local y = hit:GetAttribute("z")
					local occupied = hit:GetAttribute("isOccupied")
					if not occupied then						
						dropMelon:FireServer(hit)
					end 
				end
			end
		elseif input.UserInputType == Enum.UserInputType.Touch then
			--something was touched on a touchscreen, but how do I get the button
		end
	end
end)