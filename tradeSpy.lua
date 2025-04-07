local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TradeSessions = workspace:WaitForChild("TradeSessions")

local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "TradeSessionGui"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0, 100, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Trade Sessions"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24

local scrollFrame = Instance.new("ScrollingFrame", mainFrame)
scrollFrame.Position = UDim2.new(0, 0, 0, 40)
scrollFrame.Size = UDim2.new(1, 0, 1, -40)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 8
scrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scrollFrame.BorderSizePixel = 0
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local layout = Instance.new("UIListLayout", scrollFrame)
layout.Padding = UDim.new(0, 6)

local function renderSessions()
	for _, child in ipairs(scrollFrame:GetChildren()) do
		if child:IsA("TextLabel") then child:Destroy() end
	end

	for _, session in ipairs(TradeSessions:GetChildren()) do
		local player1 = session:FindFirstChild("Player1")
		local player2 = session:FindFirstChild("Player2")
		local p1Accept = session:FindFirstChild("Player1Accept")
		local p2Accept = session:FindFirstChild("Player2Accept")

		if player1 and player2 and p1Accept and p2Accept then
			local state = (p1Accept.Value and p2Accept.Value) and "COMPLETED" or "OUTGOING"
			local label = Instance.new("TextLabel", scrollFrame)
			label.Size = UDim2.new(1, -10, 0, 35)
			label.Text = player1.Value .. " [1] AND " .. player2.Value .. " [2] (" .. state .. ")"
			label.TextColor3 = Color3.fromRGB(255, 255, 255)
			label.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			label.Font = Enum.Font.SourceSans
			label.TextSize = 18
			label.TextXAlignment = Enum.TextXAlignment.Left
		end
	end
end

local function connectSession(session)
	local function update() task.defer(renderSessions) end
	local p1Accept = session:FindFirstChild("Player1Accept")
	local p2Accept = session:FindFirstChild("Player2Accept")
	if p1Accept then p1Accept:GetPropertyChangedSignal("Value"):Connect(update) end
	if p2Accept then p2Accept:GetPropertyChangedSignal("Value"):Connect(update) end
end

TradeSessions.ChildAdded:Connect(function(child)
	child.AncestryChanged:Wait()
	task.wait(0.1)
	connectSession(child)
	renderSessions()
end)

TradeSessions.ChildRemoved:Connect(renderSessions)

for _, session in ipairs(TradeSessions:GetChildren()) do
	connectSession(session)
end

renderSessions()
