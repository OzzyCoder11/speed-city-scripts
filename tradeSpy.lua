local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local TradeSessions = workspace:WaitForChild("TradeSessions")

local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "TradeSpyV3"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(1, -400, 1, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true

local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Speed City | TradeSpy V3"
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

local function createSessionLabel(session)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -10, 0, 35)
	label.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.Gotham
	label.TextSize = 18
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = scrollFrame

	local stateLabel = Instance.new("TextLabel", label)
	stateLabel.Size = UDim2.new(0, 80, 1, 0)
	stateLabel.Position = UDim2.new(1, -80, 0, 0)
	stateLabel.BackgroundTransparency = 1
	stateLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	stateLabel.Font = Enum.Font.GothamSemibold
	stateLabel.TextSize = 18
	stateLabel.TextXAlignment = Enum.TextXAlignment.Right

	local player1 = session:FindFirstChild("Player1")
	local player2 = session:FindFirstChild("Player2")
	local p1Accept = session:FindFirstChild("Player1Accept")
	local p2Accept = session:FindFirstChild("Player2Accept")

	if not (player1 and player2 and p1Accept and p2Accept) then
		label:Destroy()
		return
	end

	label.Text = player1.Value .. " ⇄ " .. player2.Value

	local function updateState()
		local a = (p1Accept.Value and 1 or 0) + (p2Accept.Value and 1 or 0)
		if a == 2 then
			stateLabel.Text = "ACCEPTED"
			stateLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
			task.delay(2.5, function()
				if label and label.Parent then label:Destroy() end
			end)
		else
			stateLabel.Text = a .. "/2"
			stateLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		end
	end

	local accepted = false
	local stop = false

	updateState()

	local p1Conn = p1Accept:GetPropertyChangedSignal("Value"):Connect(updateState)
	local p2Conn = p2Accept:GetPropertyChangedSignal("Value"):Connect(updateState)

	local ancestryConn
	ancestryConn = session.AncestryChanged:Connect(function(_, parent)
		if stop then return end
		if not parent then
			local a = (p1Accept.Value and 1 or 0) + (p2Accept.Value and 1 or 0)
			if a == 2 then
				-- already handled above
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

	local function monitorAcceptance()
		while not stop do
			if p1Accept.Value and p2Accept.Value then
				stop = true
				stateLabel.Text = "ACCEPTED"
				stateLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
				task.delay(2, function()
					if label and label.Parent then label:Destroy() end
				end)
				break
			end
			task.wait(0.25)
		end
	end

	task.spawn(monitorAcceptance)
end

TradeSessions.ChildAdded:Connect(function(child)
	child.AncestryChanged:Wait()
	task.wait(0.1)
	createSessionLabel(child)
end)

for _, session in ipairs(TradeSessions:GetChildren()) do
	createSessionLabel(session)
end
