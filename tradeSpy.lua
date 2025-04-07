local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TradeSessions = workspace:WaitForChild("TradeSessions")

local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "TradeSpy"
screenGui.ResetOnSpawn = false

local function addCorner(ui, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 10)
	corner.Parent = ui
end

local function addShadow(ui)
	local shadow = Instance.new("ImageLabel")
	shadow.Name = "Shadow"
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.Position = UDim2.new(0.5, 0, 0.5, 5)
	shadow.Size = UDim2.new(1, 20, 1, 20)
	shadow.Image = "rbxassetid://1316045217"
	shadow.ImageTransparency = 0.8
	shadow.BackgroundTransparency = 1
	shadow.ZIndex = 0
	shadow.Parent = ui
end

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(1, -400, 1, -300) -- bottom right corner
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ZIndex = 1
addCorner(mainFrame, 12)
addShadow(mainFrame)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "Speed City | TradeSpy V2"
title.TextColor3 = Color3.fromRGB(240, 240, 240)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.BorderSizePixel = 0
addCorner(title, 12)

local scrollFrame = Instance.new("ScrollingFrame", mainFrame)
scrollFrame.Position = UDim2.new(0, 0, 0, 45)
scrollFrame.Size = UDim2.new(1, 0, 1, -45)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 0
scrollFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
scrollFrame.BorderSizePixel = 0
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ZIndex = 1
addCorner(scrollFrame, 12)

local layout = Instance.new("UIListLayout", scrollFrame)
layout.Padding = UDim.new(0, 6)

local sessionTimers = {}

local function renderSessions()
	for _, child in ipairs(scrollFrame:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end

	for _, session in ipairs(TradeSessions:GetChildren()) do
		local player1 = session:FindFirstChild("Player1")
		local player2 = session:FindFirstChild("Player2")
		local p1Accept = session:FindFirstChild("Player1Accept")
		local p2Accept = session:FindFirstChild("Player2Accept")

		if player1 and player2 and p1Accept and p2Accept then
			local count = (p1Accept.Value and 1 or 0) + (p2Accept.Value and 1 or 0)

			local row = Instance.new("Frame", scrollFrame)
			row.Size = UDim2.new(1, -12, 0, 38)
			row.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			row.BorderSizePixel = 0
			row.ZIndex = 2
			addCorner(row, 10)

			local nameLabel = Instance.new("TextLabel", row)
			nameLabel.Size = UDim2.new(1, -90, 1, 0)
			nameLabel.Position = UDim2.new(0, 10, 0, 0)
			nameLabel.Text = player1.Value .. " ⇄ " .. player2.Value
			nameLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
			nameLabel.BackgroundTransparency = 1
			nameLabel.Font = Enum.Font.Gotham
			nameLabel.TextSize = 17
			nameLabel.TextXAlignment = Enum.TextXAlignment.Center
			nameLabel.ZIndex = 2

			local statusLabel = Instance.new("TextLabel", row)
			statusLabel.Size = UDim2.new(0, 70, 1, 0)
			statusLabel.Position = UDim2.new(1, -75, 0, 0)
			statusLabel.Text = count .. "/2"
			statusLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
			statusLabel.BackgroundTransparency = 1
			statusLabel.Font = Enum.Font.GothamSemibold
			statusLabel.TextSize = 17
			statusLabel.TextXAlignment = Enum.TextXAlignment.Right
			statusLabel.ZIndex = 2

			if count == 2 and not sessionTimers[session] then
				sessionTimers[session] = true
				task.delay(10, function()
					if session and session.Parent == TradeSessions then
						local p1 = session:FindFirstChild("Player1Accept")
						local p2 = session:FindFirstChild("Player2Accept")
						if p1 and p2 and p1.Value and p2.Value then
							session:Destroy()
						end
					end
				end)
			end
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

TradeSessions.ChildRemoved:Connect(function(session)
	sessionTimers[session] = nil
	renderSessions()
end)

for _, session in ipairs(TradeSessions:GetChildren()) do
	connectSession(session)
end

renderSessions()
