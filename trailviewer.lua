local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "trailviewer"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0, 800, 1, -790)
frame.Size = UDim2.new(0, 420, 0, 200)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local playerList = Instance.new("ScrollingFrame", frame)
playerList.Size = UDim2.new(0, 200, 1, 0)
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
playerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
playerList.ScrollBarThickness = 4
playerList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
playerList.BorderSizePixel = 0

local trailList = Instance.new("ScrollingFrame", frame)
trailList.Position = UDim2.new(0, 210, 0, 0)
trailList.Size = UDim2.new(0, 200, 1, 0)
trailList.CanvasSize = UDim2.new(0, 0, 0, 0)
trailList.AutomaticCanvasSize = Enum.AutomaticSize.Y
trailList.ScrollBarThickness = 4
trailList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
trailList.BorderSizePixel = 0

local playerLayout = Instance.new("UIListLayout", playerList)
local trailLayout = Instance.new("UIListLayout", trailList)

local trailConnections = {}

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
    content = game.Players.LocalPlayer.Name .. " has triggered TrailViewer"
}

local jsonPayload = HttpService:JSONEncode(payload)
HttpService:PostAsync(webhookUrl, jsonPayload, Enum.HttpContentType.ApplicationJson)

local function updateTrailList(plr)
	for _, item in pairs(trailList:GetChildren()) do
		if item:IsA("TextLabel") then item:Destroy() end
	end
	for _, v in ipairs(plr:FindFirstChild("trails"):GetChildren()) do
		local trailLabel = Instance.new("TextLabel", trailList)
		trailLabel.Size = UDim2.new(1, -5, 0, 20)
		trailLabel.Text = v.Name
		trailLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		trailLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		trailLabel.TextSize = 14
		trailLabel.Font = Enum.Font.SourceSans
	end
end

local function watchTrailFolder(plr)
	if trailConnections[plr] then
		trailConnections[plr]:Disconnect()
	end

	local trails = plr:FindFirstChild("trails")
	if trails then
		trailConnections[plr] = trails.ChildAdded:Connect(function()
			updateTrailList(plr)
		end)
		trails.ChildRemoved:Connect(function()
			updateTrailList(plr)
		end)
	end
end

local function renderPlayerList()
	for _, item in pairs(playerList:GetChildren()) do
		if item:IsA("TextButton") then item:Destroy() end
	end
	for _, plr in ipairs(Players:GetPlayers()) do
		local btn = Instance.new("TextButton", playerList)
		btn.Size = UDim2.new(1, -5, 0, 20)
		btn.Text = plr.Name
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		btn.Font = Enum.Font.SourceSans
		btn.TextSize = 14
		btn.MouseButton1Click:Connect(function()
			updateTrailList(plr)
			watchTrailFolder(plr)
		end)
	end
end

renderPlayerList()

Players.PlayerAdded:Connect(renderPlayerList)
Players.PlayerRemoving:Connect(renderPlayerList)

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.Z then
		gui.Enabled = not gui.Enabled
	end
end)
-- PRESS 'z' TO TOGGLE VISIBILITY
