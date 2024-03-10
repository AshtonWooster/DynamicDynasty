-- Client Mouse Controller
-- Ashton

--Objects--
local mouseController = {}
local map = workspace:WaitForChild("Map")
local buildings = map:WaitForChild("Buildings")
local userIS = game:GetService("UserInputService")
local guiService = game:GetService("GuiService")
local repStorage = game:GetService("ReplicatedStorage")
local imageFolder = repStorage:WaitForChild("Images")
local componentsFolder = repStorage:WaitForChild("GUIComponents")
local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")
local shopFolder = gui:WaitForChild("Shop")
local shopTile = shopFolder:WaitForChild("Tile")
local shopBuilding = shopFolder:WaitForChild("Building")
local shop = shopFolder:WaitForChild("Shop")
local itemFrame = shopFolder:WaitForChild("Item")
local shopClose = shop:WaitForChild("Close")
local sellFrame = shopFolder:WaitForChild("Sell")
local tweenService = game:GetService("TweenService")
local effectsFolder= workspace:WaitForChild("Effects")
local inputService = game:GetService("UserInputService")
local soundService = game:GetService("SoundService")
local clickSound = soundService:WaitForChild("Click")
local placeSound = soundService:WaitForChild("Place")

--Variables--
local images = imageFolder:GetChildren()
local effects = componentsFolder:GetChildren()
local clickInfo = TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
local clickProp = {Size = UDim2.fromOffset(60, 60), ImageTransparency = 1}
local hoverFunction = nil
local clickFunction = nil
local hoverColors = {
	Lake = Color3.fromRGB(0, 255, 255),
	Grass = Color3.fromRGB(55, 255, 0), 
	Sell = Color3.fromRGB(255, 0, 0)
}
local isInteracting = false

--Selection Box
local selectionBox = Instance.new("SelectionBox", player.PlayerGui.ScreenGui)
selectionBox.LineThickness = 0.08
selectionBox.Adornee = nil

--Map images--
local map = {} do 
	for _, image in pairs(images) do
		map[image.Name] = image
	end
	
	images = map
end

--Map effects--
local map = {} do
	for _, effect in pairs(effects) do
		map[effect.Name] = effect
	end
	
	effects = map
end

--Set Mouse Icon--
function mouseController.setIcon(icon)
	local toIcon = images[icon]
	if toIcon then
		userIS.MouseIcon = toIcon.Texture
	else
		userIS.MouseIcon = ""
	end
end

--Click Effect--
function mouseController.click(color)
	color = color or Color3.fromRGB(255,255,255)
	local mouse = player:GetMouse()
	local clickEffect = effects["ClickEffect"]:Clone()
	clickEffect.ImageColor3 = color
	clickEffect.Parent = gui
	clickEffect.Position = UDim2.fromOffset(mouse.X, mouse.Y + guiService:GetGuiInset().Y)
	clickSound:Play()
	
	coroutine.wrap(function()
		local clickTween = tweenService:Create(clickEffect, clickInfo, clickProp)
		clickTween:Play()
		
		clickTween.Completed:Wait()
		clickEffect:Destroy()
	end)()
end

--Connect Click--
local function connectClick()
	clickFunction = inputService.InputEnded:Connect(function(input, processed)
		if isInteracting or processed then return end
		local mouse = player:GetMouse()

		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			mouse.TargetFilter = buildings
			local target = mouse.Target
			if target:FindFirstAncestor("Tiles") then
				local model = target:FindFirstAncestorWhichIsA("Model")
				local objectValue = model:WaitForChild("Object")
				
				placeSound:Play()
				isInteracting = true
				if not objectValue.Value then
					shopTile.Value = model
					shop.Visible = true
					clickFunction:Disconnect()
				else
					shopTile.Value = model
					sellFrame.Visible = true
					clickFunction:Disconnect()
				end	
			end
		end
	end)
end

--Hover Effect--
function mouseController.Hover()
	local mouse = player:GetMouse()
	hoverFunction = mouse.Move:Connect(function()
		if isInteracting then return end
		
		mouse.TargetFilter = buildings
		local target = mouse.Target
		if not target or not target:FindFirstAncestor("Map") then
			selectionBox.Adornee = nil
		elseif target:FindFirstAncestor("Tiles") then
			local model = target:FindFirstAncestorWhichIsA("Model")
			selectionBox.Adornee = target:FindFirstAncestorWhichIsA("Model").PrimaryPart
			selectionBox.Color3 = model:WaitForChild("Object").Value and hoverColors["Sell"] or hoverColors[model.Name]
		end
	end)
	
	connectClick()
end

--Close shop--
function mouseController.CloseShop()
	shop.Visible = false
	itemFrame.Visible = false
	isInteracting = false
	if shopBuilding.Value then
		shopBuilding.Value:Destroy()
		shopBuilding.Value = nil
	end
	wait()
	connectClick()
end

--Close Sell--
function mouseController.CloseSell()
	sellFrame.Visible = false
	isInteracting = false
	shopBuilding.Value = nil
	wait()
	connectClick()
end

--Stop Hover--
function mouseController.StopHover()
	if hoverFunction then
		hoverFunction:Disconnect()
	end
	if clickFunction then
		clickFunction:Disconnect()
	end
end

return mouseController
