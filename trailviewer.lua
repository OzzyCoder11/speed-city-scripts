local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "trailviewer"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0, 0, 1, -200) -- bottom-left corner
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
