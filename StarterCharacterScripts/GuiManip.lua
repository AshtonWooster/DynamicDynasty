-- Client GUI Manipulator module
-- Ashton

--Modules--
local mouseController = require(script.Parent:WaitForChild("Mouse"))

--Objects--
local guiManip = {}
local userIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

--Hide all children--
function guiManip.HideAll(folder)
	for _,gui in pairs(folder:GetChildren()) do
		if gui:IsA("Frame") then
			gui.Visible = false
		end
	end
end

--Show all children--
function guiManip.ShowAll(folder)
	for _,gui in pairs(folder:GetChildren()) do
		if gui:IsA("Frame") then
			gui.Visible = true
		end
	end
end


--Move Gui Button--
function guiManip.ConnectMove(button)
	local menu = button.Parent
	button.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local newMove
			local discon
			local mouse = player:GetMouse()
			local viewSize = workspace.CurrentCamera.ViewportSize
			local offset = menu.Position - UDim2.fromScale(mouse.X/viewSize.X, mouse.Y/viewSize.Y)
			mouseController.setIcon("Move")
			newMove = mouse.Move:Connect(function()
				menu.Position = UDim2.fromScale(mouse.X/viewSize.X, mouse.Y/viewSize.Y) + offset
			end)

			--Disconnect on mouse lift--
			discon = userIS.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					mouseController.setIcon()
					newMove:Disconnect()
					discon:Disconnect()
				end
			end)
		end
	end)
end

return guiManip
