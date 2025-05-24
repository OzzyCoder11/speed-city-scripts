local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TrailOfferGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Draggable Frame
local frame = Instance.new("Frame")
frame.AnchorPoint = Vector2.new(0, 1)
frame.Position = UDim2.new(0, 10, 1, -10) -- Bottom-left
frame.Size = UDim2.new(0, 270, 0, 140)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- TextBox
local textBox = Instance.new("TextBox")
textBox.Text = ""
textBox.PlaceholderText = "Trail to offer"
textBox.Size = UDim2.new(1, -20, 0, 30)
textBox.Position = UDim2.new(0, 10, 0, 10)
textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.BorderSizePixel = 0
textBox.Parent = frame

-- Offer Button
local offerButton = Instance.new("TextButton")
offerButton.Text = "Offer"
offerButton.Size = UDim2.new(0.5, -15, 0, 25)
offerButton.Position = UDim2.new(0, 10, 0, 50)
offerButton.BackgroundColor3 = Color3.fromRGB(60, 130, 200)
offerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
offerButton.BorderSizePixel = 0
offerButton.Parent = frame

-- De-offer Button
local deofferButton = Instance.new("TextButton")
deofferButton.Text = "De-offer"
deofferButton.Size = UDim2.new(0.5, -15, 0, 25)
deofferButton.Position = UDim2.new(0.5, 5, 0, 50)
deofferButton.BackgroundColor3 = Color3.fromRGB(200, 100, 80)
deofferButton.TextColor3 = Color3.fromRGB(255, 255, 255)
deofferButton.BorderSizePixel = 0
deofferButton.Parent = frame

-- Accept Button
local acceptButton = Instance.new("TextButton")
acceptButton.Text = "Accept"
acceptButton.Size = UDim2.new(0.5, -15, 0, 25)
acceptButton.Position = UDim2.new(0, 10, 0, 85)
acceptButton.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
acceptButton.TextColor3 = Color3.fromRGB(255, 255, 255)
acceptButton.BorderSizePixel = 0
acceptButton.Parent = frame

-- Cancel Button
local cancelButton = Instance.new("TextButton")
cancelButton.Text = "Cancel"
cancelButton.Size = UDim2.new(0.5, -15, 0, 25)
cancelButton.Position = UDim2.new(0.5, 5, 0, 85)
cancelButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
cancelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
cancelButton.BorderSizePixel = 0
cancelButton.Parent = frame

-- Functionality
offerButton.MouseButton1Click:Connect(function()
	local trailName = textBox.Text
	if trailName ~= "" then
		ReplicatedStorage:WaitForChild("TradeTrailAdd"):FireServer(trailName)
	end
end)

deofferButton.MouseButton1Click:Connect(function()
	local trailName = textBox.Text
	if trailName ~= "" then
		ReplicatedStorage:WaitForChild("TradeTrailPutBack"):FireServer(trailName)
	end
end)

acceptButton.MouseButton1Click:Connect(function()
	ReplicatedStorage:WaitForChild("TradeMenuAccept"):FireServer()
end)

cancelButton.MouseButton1Click:Connect(function()
	ReplicatedStorage:WaitForChild("TradeMenuCancel"):FireServer()
end)
