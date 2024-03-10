-- Client Shop Script
-- Ashton

--Modules--
local utilities = require(script.Parent:WaitForChild("Utilities"))
local guiManip = require(script.Parent:WaitForChild("GuiManip"))
local mouseController = require(script.Parent:WaitForChild("Mouse"))
local soundController = require(script.Parent:WaitForChild("SoundManip"))

--Objects--
local player = game.Players.LocalPlayer
local map = workspace:WaitForChild("Map")
local buildingsModel = map:WaitForChild("Buildings")
local inputService = game:GetService("UserInputService")
local repStorage = game:GetService("ReplicatedStorage")
local placements = repStorage:WaitForChild("Placements")
local screen = player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")
local shopFolder = screen:WaitForChild("Shop")
local shopTile = shopFolder:WaitForChild("Tile")
local shopBuilidng = shopFolder:WaitForChild("Building")
local effectsFolder = workspace:WaitForChild("Effects")
local shop = shopFolder:WaitForChild("Shop")
local move = shop:WaitForChild("Move")
local close = shop:WaitForChild("Close")
local shopFrame = shop:WaitForChild("Frame")
local template = shop:WaitForChild("Object")
local itemFrame = shopFolder:WaitForChild("Item")
local purchaseButton = itemFrame:WaitForChild("Purchase")
local itemClose = itemFrame:WaitForChild("Close")
local itemMove = itemFrame:WaitForChild("Move")
local itemImage = itemFrame:WaitForChild("Image")
local itemTitle = itemFrame:WaitForChild("Title")
local itemCost = itemFrame:WaitForChild("Cost")
local sellFrame = shopFolder:WaitForChild("Sell")
local sellButton = sellFrame:WaitForChild("Sell")
local sellClose = sellFrame:WaitForChild("Close")
local sellMove = sellFrame:WaitForChild("Move")
local sellImage = sellFrame:WaitForChild("Image")
local sellTitle = sellFrame:WaitForChild("Title")
local sellPrice = sellFrame:WaitForChild("Price")

--Constants--
local MAX_IN_ROW = 3

--Variables--
local buttons = {}
local buttonFunctions = {}
local buildings = {}
local marginX = (1-template.Size.X.Scale*MAX_IN_ROW-(shopFrame.ScrollBarThickness/shopFrame.AbsoluteSize.X))/(MAX_IN_ROW+1)
local marginY = (marginX * shopFrame.AbsoluteSize.X) / (shopFrame.AbsoluteSize.Y) / 2

--Set Up Buildings--
for _, set in pairs(placements:GetChildren()) do
	buildings[set.Name] = {}
	for _, building in pairs(set:GetChildren()) do
		buildings[set.Name][building.Name] = building
	end
end

--Set Up Move--
guiManip.ConnectMove(move)
guiManip.ConnectMove(itemMove)
guiManip.ConnectMove(sellMove)

--Make Building--
local function makeBuilding(building)
	local newBuilding = building:Clone()
	newBuilding.Parent = buildingsModel
	newBuilding:PivotTo(shopTile.Value.PrimaryPart.CFrame)
	shopBuilidng.Value = newBuilding
end

--Connect button--
local function connectButton(button, building)
	local buttonConnect
	buttonConnect = button.InputEnded:Connect(function(input, processed)
		if processed then return end
		
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			mouseController.click()
			itemCost.Text = tostring(building:WaitForChild("Price").Value)
			itemTitle.Text = building.Name
			itemImage.Image = building:WaitForChild("Image").Value
			itemFrame.Visible = true
			if shopBuilidng.Value then
				shopBuilidng.Value:Destroy()
				shopBuilidng.Value = nil
			end
			makeBuilding(building)
		end
	end)
	
	return buttonConnect
end

--Rotate buildings--
inputService.InputEnded:Connect(function(input, processed)
	if processed then return end
	
	if input.KeyCode == Enum.KeyCode.R and shopBuilidng.Value then
		shopBuilidng.Value:PivotTo(shopBuilidng.Value.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(90), 0))
		soundController["Rotate"]:Play()
	end
end)

--Connect ItemFrame Close--
itemClose.InputEnded:Connect(function(input, processed)
	if processed then return end
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		itemFrame.Visible = false
		mouseController.click()
	end
end)

--Set Up Shop--
shop:GetPropertyChangedSignal("Visible"):Connect(function()
	if shop.Visible and shopTile.Value then
		local x = 0
		local y = 0
		for name, building in pairs(buildings[shopTile.Value.Name]) do
			local newDisplay = template:Clone()
			newDisplay.Parent = shopFrame
			newDisplay.Visible = true
			newDisplay.Position = UDim2.fromScale(marginX*(x+1) + newDisplay.Size.X.Scale*x, marginY*(y+0.8) + newDisplay.Size.Y.Scale*y)
			newDisplay:WaitForChild("Image").Image = building:WaitForChild("Image").Value
			newDisplay:WaitForChild("Title").Text = building.Name
			table.insert(buttons, newDisplay)
			table.insert(buttonFunctions, connectButton(newDisplay:WaitForChild("Image"), building))
			
			x = x + 1
			y = y + math.floor(x/MAX_IN_ROW)
			x = x % MAX_IN_ROW
		end
	elseif shop.Visible == false then
		for i=#buttons, 1, -1 do
			local button = buttons[i]
			if button then
				button:Destroy()
				table.remove(buttons,i)
			end
		end
		for i=#buttonFunctions, 1, -1 do
			buttonFunctions[i]:Disconnect()
			table.remove(buttonFunctions,i)
		end
	end
end)

--Set Up Sell--
sellFrame:GetPropertyChangedSignal("Visible"):Connect(function()
	if sellFrame.Visible and shopTile.Value then
		local building = shopTile.Value:WaitForChild("Object").Value
		sellTitle.Text = building.Name
		sellPrice.Text = tostring(math.floor(building:WaitForChild("Price").Value*0.8))
		sellImage.Image = building:WaitForChild("Image").Value
	end
end)
