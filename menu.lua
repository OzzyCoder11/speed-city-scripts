local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Speed City",
   Icon = 0,
   LoadingTitle = "Speed City Script",
   LoadingSubtitle = "by ozzy0xd",
   Theme = "Default",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

local MapTab = Window:CreateTab("Maps", 4483362458)

local LobbyMapButton = MapTab:CreateButton({
   Name = "Lobby",
   Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 75, 0)
   end,
})

local WinterMapButton = MapTab:CreateButton({
   Name = "Winter",
   Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-4680, 1799, -2812)
   end,
})

local OgMapButton = MapTab:CreateButton({
   Name = "Original Map",
   Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2388, 2742, 390)
   end,
})

local VolcanoMapButton = MapTab:CreateButton({
   Name = "Volcano",
   Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1270, 258, 2022)
   end,
})

local BeachMapButton = MapTab:CreateButton({
   Name = "Beach",
   Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3624, 67, 1018)
   end,
})

local GhostMapButton = MapTab:CreateButton({
   Name = "Ghost City",
   Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3825, -33, 7304)
   end,
})

local InfiniteMapButton = MapTab:CreateButton({
   Name = "Infinite Road",
   Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-22, 1549, -1926)
   end,
})

local EliteMapButton = MapTab:CreateButton({
   Name = "Elite City",
   Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1730, 12, 1745)
   end,
})

local TrillionMapButton = MapTab:CreateButton({
   Name = "Trillioniare City",
   Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1532, 100, 5937)
   end,
})

-------------------------------------------------------

local TradingTab = Window:CreateTab("Trading", 4483362458)

local AcceptRequestButton = TradingTab:CreateButton({
   Name = "Accept Trade Request",
   Callback = function()
		game:GetService("Players").LocalPlayer.PlayerGui.Interactive.Frames.YY.XY.TradeList.Request.Visible = false
		game.ReplicatedStorage.TradeAccept:FireServer()
		game:GetService("Players").LocalPlayer.PlayerGui.Interactive.Buttons.XX.Trading.Notification.Visible = false
   end,
})

local DeclineRequestButton = TradingTab:CreateButton({
   Name = "Decline Trade Request",
   Callback = function()
		game:GetService("Players").LocalPlayer.PlayerGui.Interactive.Frames.YY.XY.TradeList.Request.Visible = false
		game.ReplicatedStorage.TradeDecline:FireServer()
		game:GetService("Players").LocalPlayer.PlayerGui.Interactive.Buttons.XX.Trading.Notification.Visible = false
   end,
})

local Divider1 = TradingTab:CreateDivider()

-------------------------------------------------

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Function to get all player names except the local player
local function getOtherPlayerNames()
	local names = {}
	table.insert(names, "None")
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			table.insert(names, player.Name)
		end
	end
	return names
end

-- Initial dropdown setup
local requestPlayers = TradingTab:CreateDropdown({
	Name = "Request Trade to",
	Options = getOtherPlayerNames(),
	CurrentOption = {"None"},
	MultipleOptions = false,
	Flag = "Dropdown1",
	Callback = function(Options)
		for i, v in ipairs(Options) do
			game:GetService("ReplicatedStorage").TradeRequest:FireServer(game.Players[v])
		end
	end,
})

-- Update dropdown when players join
Players.PlayerAdded:Connect(function()
	requestPlayers:Set(getOtherPlayerNames())
end)

-- Update dropdown when players leave
Players.PlayerRemoving:Connect(function()
	requestPlayers:Set(getOtherPlayerNames())
end)

----------------------------------------

local Divider2 = TradingTab:CreateDivider()

local AcceptTradeButton = TradingTab:CreateButton({
   Name = "Accept Trade Session",
   Callback = function()
		game.ReplicatedStorage.TradeMenuAccept:FireServer()
   end,
})

local CancelTradeButton = TradingTab:CreateButton({
   Name = "Cancel Trade Session",
   Callback = function()
		game.ReplicatedStorage.TradeMenuCancel:FireServer()
		game:GetService("Players").LocalPlayer.PlayerGui.Interactive.Frames.YY.XY.TradeMenu.PlayerName.Text = "TRADE CANCELLED"
		wait(1)
		game:GetService("Players").LocalPlayer.PlayerGui.Interactive.Frames.YY.XY.TradeMenu.Visible = false
   end,
})

local Divider3 = TradingTab:CreateDivider()

local FreezeButton = TradingTab:CreateButton({
   Name = "Delete top trail in trade [FREEZE SCAM]",
   Callback = function()
		local trail = game:GetService("Players").LocalPlayer.PlayerGui.Interactive.Frames.YY.XY.TradeMenu.Your1:GetChildren()[1]
		game:GetService("ReplicatedStorage").DestroyTrail:FireServer(trail.Name)
   end,
})

local RemoveButton = TradingTab:CreateButton({
   Name = "Remove all trails in trade and accept",
   Callback = function()
		local success, trail1 = pcall(function()
			return game:GetService("Players").LocalPlayer.PlayerGui.Interactive.Frames.YY.XY.TradeMenu.Your1:GetChildren()[1]
		end)

		local success2, trail2 = pcall(function()
			return game:GetService("Players").LocalPlayer.PlayerGui.Interactive.Frames.YY.XY.TradeMenu.Your2:GetChildren()[1]
		end)

		local success3, trail3 = pcall(function()
			return game:GetService("Players").LocalPlayer.PlayerGui.Interactive.Frames.YY.XY.TradeMenu.Your3:GetChildren()[1]
		end)

		if success and trail1 then
			pcall(function()
				game:GetService("ReplicatedStorage").TradeTrailPutBack:FireServer(trail1.Name)
			end)
		else
			warn("Failed to get trail1")
		end

		if success2 and trail2 then
			pcall(function()
				game:GetService("ReplicatedStorage").TradeTrailPutBack:FireServer(trail2.Name)
			end)
		else
			warn("Failed to get trail2")
		end

		if success3 and trail3 then
			pcall(function()
				game:GetService("ReplicatedStorage").TradeTrailPutBack:FireServer(trail3.Name)
			end)
		else
			warn("Failed to get trail3")
		end

		pcall(function()
			game:GetService("ReplicatedStorage").TradeMenuAccept:FireServer()
		end)

   end,
})

-----------------------------------------

local CrateTab = Window:CreateTab("Crates", 4483362458)

local CrateButton = CrateTab:CreateButton({
   Name = "Buy Blue Crate",
   Callback = function()
		game:GetService("ReplicatedStorage").BuyCrate:FireServer("Blue Crate")
   end,
})

local CrateButton = CrateTab:CreateButton({
   Name = "Buy Purple Crate",
   Callback = function()
		game:GetService("ReplicatedStorage").BuyCrate:FireServer("Purple Crate")
   end,
})

local CrateButton = CrateTab:CreateButton({
   Name = "Buy Green Crate",
   Callback = function()
		game:GetService("ReplicatedStorage").BuyCrate:FireServer("Green Crate")
   end,
})

local CrateButton = CrateTab:CreateButton({
   Name = "Buy Red Crate",
   Callback = function()
		game:GetService("ReplicatedStorage").BuyCrate:FireServer("Red Crate")
   end,
})

local CrateButton = CrateTab:CreateButton({
   Name = "Buy Elf Crate",
   Callback = function()
		game:GetService("ReplicatedStorage").BuyCrate:FireServer("Elf Crate")
   end,
})

local CrateButton = CrateTab:CreateButton({
   Name = "Buy Christmas Crate",
   Callback = function()
		game:GetService("ReplicatedStorage").BuyCrate:FireServer("Christmas Crate")
   end,
})

local CrateButton = CrateTab:CreateButton({
   Name = "Buy Legendary Crate",
   Callback = function()
		game:GetService("ReplicatedStorage").BuyCrate:FireServer("Legendary Crate")
   end,
})

local CrateButton = CrateTab:CreateButton({
   Name = "Buy Dark Crate",
   Callback = function()
		game:GetService("ReplicatedStorage").BuyCrate:FireServer("Dark Crate")
   end,
})

local CrateButton = CrateTab:CreateButton({
   Name = "Buy Beach Crate",
   Callback = function()
		game:GetService("ReplicatedStorage").BuyCrate:FireServer("Beach Crate")
   end,
})

local CrateButton = CrateTab:CreateButton({
   Name = "Buy Cloud Crate",
   Callback = function()
		game:GetService("ReplicatedStorage").BuyCrate:FireServer("Cloud Crate")
   end,
})

local CrateButton = CrateTab:CreateButton({
   Name = "Buy Anti Crate",
   Callback = function()
		game:GetService("ReplicatedStorage").BuyCrate:FireServer("Anti Crate")
   end,
})

local CrateButton = CrateTab:CreateButton({
   Name = "Buy Golden Unstable",
   Callback = function()
		game:GetService("ReplicatedStorage").BuyCrate:FireServer("Golden Unstable")
   end,
})

local CrateButton = CrateTab:CreateButton({
   Name = "Buy Ocean Crate",
   Callback = function()
		game:GetService("ReplicatedStorage").BuyCrate:FireServer("Ocean Crate")
   end,
})

local CrateButton = CrateTab:CreateButton({
   Name = "Buy Best Crate",
   Callback = function()
		game:GetService("ReplicatedStorage").BuyCrate:FireServer("Best Crate")
   end,
})
