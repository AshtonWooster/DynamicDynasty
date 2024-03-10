-- Mouse Handler
-- Derek

--Modules--
local utilities = require(script.Parent:WaitForChild("Utilities"))
local mouseController = require(script.Parent:WaitForChild("Mouse"))
local soundController = require(script.Parent:WaitForChild("SoundManip"))

--Objects--
local effectsFolder = workspace:WaitForChild("Effects")
local repStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")
local shopFolder = gui:WaitForChild("Shop")
local shopTile = shopFolder:WaitForChild("Tile")
local shopBuilding = shopFolder:WaitForChild("Building")
local shop = shopFolder:WaitForChild("Shop")
local shopClose = shop:WaitForChild("Close")
local sellFrame = shopFolder:WaitForChild("Sell")
local sellButton = sellFrame:WaitForChild("Sell")
local sellClose = sellFrame:WaitForChild("Close")
local purchaseButton = shopFolder:WaitForChild("Item"):WaitForChild("Purchase")
local money = player:WaitForChild("stats"):WaitForChild("money")

shopClose.InputEnded:Connect(function(input, processed)
	if processed then return end
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		mouseController.CloseShop()
		mouseController.click()
	end
end)

sellClose.InputEnded:Connect(function(input, processed)
	if processed then return end
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		mouseController.CloseSell()
		mouseController.click()
	end
end)

--Connect Purchase--
purchaseButton.InputEnded:Connect(function(input, processed)
	if processed then return end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if money.Value < shopBuilding.Value:WaitForChild("Price").Value then
			soundController["NoMoney"]:Play()
			return
		end
		
		
		mouseController.click()
		utilities["PlaceItem"]:FireServer(shopTile.Value, purchaseButton.Parent:WaitForChild("Title").Text, shopBuilding.Value.PrimaryPart.Orientation.Y)
		mouseController.CloseShop()
	end
end)

--Connect Sell--
sellButton.InputEnded:Connect(function(input, processed)
	if processed then return end
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		mouseController.click()
		utilities["SellItem"]:FireServer(shopTile.Value)
		mouseController.CloseSell()
	end
end)

mouseController.Hover()
