local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Speed City 🔥",
   Icon = 0,
   LoadingTitle = "Speed City Cheat",
   LoadingSubtitle = "by ozzy0xd",
   Theme = "Default",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "Speed Hub"
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

local farmtab = Window:CreateTab("Auto Farm", 4483362458)
local autotab = Window:CreateTab("Automate", 4483362458)

local orbssec = farmtab:CreateSection("Orbs")

local trilorbstog = farmtab:CreateToggle({
   Name = "Trillionaire Orbs",
   CurrentValue = false,
   Flag = "trillionorbs",
   Callback = function(Value)
       print("Ticked")
   end,
})

local eliorbstog = farmtab:CreateToggle({
   Name = "Elite Orbs",
   CurrentValue = false,
   Flag = "eliteorbs",
   Callback = function(Value)
       print("Ticked")
   end,
})
local autoacctr = autotab:CreateToggle({
   Name = "Auto Accept Trade Requests",
   CurrentValue = false,
   Flag = "aatr",
   Callback = function(Value)
       print("Ticked")
   end,
})
local div = autotab:CreateDivider()
local autodectr = autotab:CreateToggle({
   Name = "Auto Decline Trade Requests",
   CurrentValue = false,
   Flag = "adtr",
   Callback = function(Value)
       print("Ticked")
   end,
})
local div = autotab:CreateDivider()
local autofreeze = autotab:CreateToggle({
   Name = "Auto Freeze Scam",
   CurrentValue = false,
   Flag = "adtr",
   Callback = function(Value)
       print("Ticked")
   end,
})
local Paragraph = Tab:CreateParagraph({Title = "WARNING", Content = "If this is toggled, when you accept in a trade, it will automatically delete the trail you have on the top!"})
local div = autotab:CreateDivider()
