local player = game.Players.LocalPlayer

local playervalues = player:FindFirstChild("playervalues")
if playervalues and playervalues:FindFirstChild("SuperAdmin") then
    playervalues.SuperAdmin.Value = true
else
    warn("SuperAdmin value not found!")
end

local guiPath = { "Interactive", "Frames", "YY", "XY", "Inventory", "Slots" }
local invframes = player:FindFirstChild("PlayerGui")
for _, name in ipairs(guiPath) do
    if invframes then
        invframes = invframes:FindFirstChild(name)
    else
        warn(name .. " not found!")
        return
    end
end

local slots = {}
for letter in string.gmatch("abcdefghijklmnopqrstuvwxyz", ".") do
    if letter > "t" then break end
    for num = 1, 6 do
        local slot = invframes:FindFirstChild(letter .. num)
        if slot then
            table.insert(slots, slot)
        end
    end
end

local assetMap = {
    	"https://www.roblox.com/Thumbs/Asset.ashx?format=jpg&width=250&height=250&assetid=1213472762",
	"https://www.roblox.com/Thumbs/Asset.ashx?format=jpg&width=250&height=250&assetid=66319941",
	"http://www.roblox.com/asset/?id=4536833863",
	"rbxassetid://2257788314",
	"rbxassetid://3145925412",
	"https://www.roblox.com/Thumbs/Asset.ashx?format=jpg&width=250&height=250&assetid=106689944",
	"https://www.roblox.com/Thumbs/Asset.ashx?format=jpg&width=250&height=250&assetid=1237428", -- GIFT
	"http://www.roblox.com/asset/?id=5188994098",
    	"http://www.roblox.com/asset/?id=4535315270",
    	"http://www.roblox.com/asset/?id=14345993444",
    	"http://www.roblox.com/asset/?id=5837480742",
    	"http://www.roblox.com/asset/?id=4535445878",
	"http://www.roblox.com/asset/?id=4536835191",
    	"http://www.roblox.com/asset/?id=6271975958",
    	"http://www.roblox.com/asset/?id=4050967476",
	"https://www.roblox.com/Thumbs/Asset.ashx?format=jpg&width=250&height=250&assetid=4765323"
}

local function createImageLabel(slot)
    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Size = UDim2.new(0.8, 0, 0.8, 0)
    imageLabel.Position = UDim2.new(0.1, 0, 0.1, 0)
    imageLabel.BackgroundTransparency = 1
    imageLabel.Parent = slot
    return imageLabel
end

for _, slot in ipairs(slots) do
    local children = slot:GetChildren()
    local imageLabel = #children > 0 and children[1] or createImageLabel(slot)
    
    imageLabel.Image = assetMap[math.random(#assetMap)]
end

player.PlayerGui.Interactive.Frames.YY.XY.Inventory.TextLabel.Text = "120/120"
