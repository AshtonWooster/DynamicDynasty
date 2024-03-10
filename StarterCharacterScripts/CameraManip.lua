-- Client Camera Module
-- Ashton

--Objects--
local cameraManip = {}
local tweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local inputService = game:GetService("UserInputService")
local cameraBounds = workspace:WaitForChild("CameraBounds")
local bottomBound = cameraBounds:WaitForChild("BOTTOM").Position
local topBound = cameraBounds:WaitForChild("TOP").Position

--Variables--
local offset = 15
local zoomSens = 1
local maxX = topBound.X
local minX = bottomBound.X
local maxZ = bottomBound.Z
local minZ = topBound.Z
local runFloat = false
local floatTween = nil

--Constants--
local FLOAT_INFO = TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local MAX_ZOOM = 50
local MIN_ZOOM = 5
local CAMERA_SPEED = 0.5
local ROTATE_SPEED = 1.3

function cameraManip.CameraTo(toCFrame, tInfo, duration)
	tInfo = tInfo or TweenInfo.new(duration, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
	local camera = workspace.CurrentCamera
	local tween = tweenService:Create(camera, tInfo, {CFrame = toCFrame})
	tween:Play()
	return tween
end

function cameraManip.PlaceCamera(toCFrame)
	local camera = workspace.CurrentCamera
	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame = toCFrame
end

function cameraManip.TopDown()
	local mouse = player:GetMouse()
	local origin = (bottomBound + topBound)/2
	local angle = 0
	local zoom = (MAX_ZOOM - MIN_ZOOM)/2
	local camera = workspace.CurrentCamera
	camera.CameraType = Enum.CameraType.Scriptable

	local keyDirections = {
		w = Vector3.new(CAMERA_SPEED, 0, 0),
		d = Vector3.new(0, 0, CAMERA_SPEED),
		a = Vector3.new(0, 0, -CAMERA_SPEED),
		s = Vector3.new(-CAMERA_SPEED, 0, 0),
	}
	local keyRotations = {
		e = ROTATE_SPEED,
		q = -ROTATE_SPEED
	}
	local heldDirections = {
		w = false,
		d = false,
		a = false,
		s = false,
		e = false,
		q = false
	}
	-- Update the camera
	runService.RenderStepped:Connect(function()
		-- Calculate Movement and rotation
		local move = Vector3.new(0,0,0)
		local rotate = 0
		for key, val in heldDirections do
			if not val then continue end			
			if keyDirections[key] then
				move = move + keyDirections[key]
			else
				angle = angle + keyRotations[key]
			end
		end
		
		angle = (angle + rotate) % 360
		local cos = math.cos(math.rad(angle))
		local sin = math.sin(math.rad(angle))
		move = Vector3.new(move.X*cos - move.Z*sin, 0, move.X*sin + move.Z*cos)
		
		origin = Vector3.new(math.clamp(origin.X + move.X, minX, maxX), origin.Y, math.clamp(origin.Z + move.Z, minZ, maxZ))
		local cameraPos = origin + Vector3.new(cos*(-offset - zoom), offset + zoom, sin*(-offset - zoom))
		camera.CFrame = CFrame.new(cameraPos, origin)
	end)
	
	-- Detect when the player moves camera
	inputService.InputBegan:Connect(function(input, processed)
		if processed then return end
		if input.KeyCode.Value < 97 or input.KeyCode.Value > 122 then return end
		
		local key = string.char(input.KeyCode.Value)
		if keyDirections[key] or keyRotations[key] then
			heldDirections[key] = true
		end
	end)
	inputService.InputEnded:Connect(function(input, processed)
		if processed then return end
		if input.KeyCode.Value < 97 or input.KeyCode.Value > 122 then return end
		
		local key = string.char(input.KeyCode.Value)
		if keyDirections[key] or keyRotations[key] then
			heldDirections[key] = false
		end
	end)
	
	mouse.WheelForward:Connect(function()
		zoom = zoom - zoomSens > MIN_ZOOM and zoom - zoomSens or MIN_ZOOM
	end)
	
	mouse.WheelBackward:Connect(function()
		zoom = zoom + zoomSens < MAX_ZOOM and zoom + zoomSens or MAX_ZOOM
	end)
end

--Freeze camera--
function cameraManip.FreezeCamera(pos, lookPos) 
	local plrCamera = workspace.CurrentCamera
	plrCamera.CameraType = Enum.CameraType.Scriptable

	pos = pos or plrCamera.Position
	if lookPos then
		plrCamera.CFrame = CFrame.new(pos, lookPos)
	else
		plrCamera.CFrame = CFrame.new(pos)
	end
end

--Tween Camera between a list of given points--
function cameraManip.Float(folder, tweenInfo)
	tweenInfo = tweenInfo or FLOAT_INFO
	local plrCamera = workspace.CurrentCamera
	plrCamera.CameraType = Enum.CameraType.Scriptable
	
	--Construct CFrames--
	local points = {}
	for i, point in pairs(folder:GetChildren()) do
		points[i] = CFrame.new(point:WaitForChild("Pos").Position, point:WaitForChild("LookTo").Position)
	end
	
	runFloat = true
	plrCamera.CFrame = points[#points]
	coroutine.wrap(function()
		while runFloat and plrCamera.Parent do
			for i, point in pairs(points) do
				if runFloat == false or not plrCamera.Parent then break end

				local tweenProps = {CFrame = point}
				floatTween = tweenService:Create(plrCamera, tweenInfo, tweenProps)
				floatTween:Play()
				floatTween.Completed:Wait()
			end
		end
	end)()
end

--Stop Float--
function cameraManip.StopFloat()
	runFloat = false

	if floatTween then
		floatTween:Cancel()
		floatTween:Destroy()
	end
end

return cameraManip
