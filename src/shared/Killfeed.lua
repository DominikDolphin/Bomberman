local killfeed = {}

killfeed.__index = killfeed

killfeed.Entries = {}
killfeed.MaxEntries = 3
killfeed.Lifetime = 5

function killfeed:New(template)
    local newKillfeed = setmetatable({},self)
    newKillfeed.__index = newKillfeed
    newKillfeed.Template = template

    return newKillfeed
end

function killfeed.__add(addingKillfeed,value)
    addingKillfeed:CreateEntry(value)
    addingKillfeed:Cycle()

    return addingKillfeed
end

function killfeed:CreateEntry(str)
    local entry = self.Template:Clone()
    entry.Text = str
    entry.Parent = self.Tempalte.Parent
    entry.Visible = true

    table.insert(self.Entries,1,entry)

    delay(self.Lifetime, function()
        if entry then
            entry:Destroy()
        end
    end)
end

function killfeed:Cycle()
    for i,entry in ipairs(self.Entries) do
        entry.LayoutOrder = i

        if i > self.MaxEntries then
            entry:Destroy()
        end
    end
end

return killfeed