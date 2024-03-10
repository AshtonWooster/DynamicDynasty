-- Client Main Menu
-- Ashton

--Modules--
local utilities = require(script.Parent:WaitForChild("Utilities"))
local guiManip = require(script.Parent:WaitForChild("GuiManip"))
local cameraManip = require(script.Parent:WaitForChild("CameraManip"))
local mouseController = require(script.Parent:WaitForChild("Mouse"))

--Objects--
local player = game.Players.LocalPlayer
local screen = player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")
local menuFolder = screen:WaitForChild("Menu")
local menu = menuFolder:WaitForChild("Menu")
menu.Visible = true
local playButton = menu:WaitForChild("Play")
local cameraPositions = workspace:WaitForChild("CameraPositions"):WaitForChild("Menu")
local hud = screen:WaitForChild("HUD")

--Objects--
local repStorage = game:GetService("ReplicatedStorage")

--Variables--
local inMenu = true

-- Hide Backpack --
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

--Camera Loop--
cameraManip.Float(cameraPositions)

--Play Button--
playButton.Activated:Connect(function()
	--Exit Menu--
	inMenu = false
	cameraManip.StopFloat()
	local camera = workspace.CurrentCamera
	camera.CameraType = Enum.CameraType.Custom
	menu.Visible = false
	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
	mouseController.click()
	guiManip.ShowAll(hud)
	utilities["Play"]:FireServer()
end)
