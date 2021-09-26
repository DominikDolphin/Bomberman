local this = script.Parent
local killer = this:GetAttribute("newOwner")

local touchingPart = (game.Workspace:GetPartsInPart(this))
for i,v in pairs(touchingPart) do
	if v.Name == "HumanoidRootPart" then
        local hum = v.Parent:FindFirstChild("Humanoid")
        if hum then
            hum.Health = 0;
            print(killer .. " killed " .. v.Parent.Name .. " ganggg")
        end
    end
end