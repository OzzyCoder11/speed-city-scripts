local player = game.Players.LocalPlayer

-- Ensure playervalues exists before modifying
local playervalues = player:FindFirstChild("playervalues")
if playervalues and playervalues:FindFirstChild("SuperAdmin") then
    playervalues.SuperAdmin.Value = true
else
    warn("SuperAdmin value not found!")
end

-- Ensure PlayerGui exists and navigate through GUI safely
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

-- Collect all inventory slots dynamically (from "a" to "t")
local slots = {}
for letter in string.gmatch("abcdefghijklmnopqrstuvwxyz", ".") do
    if letter > "t" then break end -- Limit to "t"
    for num = 1, 6 do
        local slot = invframes:FindFirstChild(letter .. num)
        if slot then
            table.insert(slots, slot)
        end
    end
end

-- Asset pool (randomized selection)
local assetMap = {
    "https://www.roblox.com/Thumbs/Asset.ashx?format=jpg&width=250&height=250&assetid=1213472762",
	"https://www.roblox.com/Thumbs/Asset.ashx?format=jpg&width=250&height=250&assetid=66319941",
	"http://www.roblox.com/asset/?id=4536833863",
	"rbxassetid://2257788314",
    "http://www.roblox.com/asset/?id=4535315270",
    "http://www.roblox.com/asset/?id=14345993444",
    "http://www.roblox.com/asset/?id=5837480742",
    "http://www.roblox.com/asset/?id=4535445878",
	"http://www.roblox.com/asset/?id=4536835191",
    "http://www.roblox.com/asset/?id=6271975958",
    "http://www.roblox.com/asset/?id=4050967476"
}

-- Function to create a new ImageLabel with the correct settings
local function createImageLabel(slot)
    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Size = UDim2.new(0.8, 0, 0.8, 0)  -- Set Size to match the image
    imageLabel.Position = UDim2.new(0.1, 0, 0.1, 0)  -- Align correctly
    imageLabel.BackgroundTransparency = 1  -- Keep it transparent
    imageLabel.Parent = slot
    return imageLabel
end

-- Assign random images to slots (create child if missing)
for _, slot in ipairs(slots) do
    local children = slot:GetChildren()
    local imageLabel = #children > 0 and children[1] or createImageLabel(slot) -- Use existing or create new
    
    imageLabel.Image = assetMap[math.random(#assetMap)] -- Assign a random asset
end

player.PlayerGui.Interactive.Frames.YY.XY.Inventory.TextLabel.Text = "120/120"
