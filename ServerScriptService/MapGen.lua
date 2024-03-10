-- Server Map Generation Module
-- Ashton

--Objects--
local mapGen = {}
local repStorage = game:GetService("ReplicatedStorage")
local tileFolder = repStorage:WaitForChild("Tiles")

--Variables--
local tiles = {}

--Set up tiles--
for _, tile in pairs(tileFolder:GetChildren()) do
	tiles[tile.Name] = tile
end
local tileSize = tiles["Sand"].Size.X
local tileHeight = tiles["Grass"].PrimaryPart.Size.Y

--Place Beach--
local function makeBeach(parent, pos, rotation)
	local newBeach = tiles["Beach"]:Clone()
	newBeach.Parent = parent
	local radius = tileSize/2 - newBeach.Size.Z/2
	local offsetX = radius*math.cos(math.rad(rotation))
	local offsetZ = radius*math.sin(math.rad(rotation))
	newBeach.Position = pos + Vector3.new(offsetX, 0, offsetZ)
	newBeach.Orientation = Vector3.new(0, -rotation + 90, 0)
end

--Place Corner Beach--
local function makeCorner(parent, pos, rotation)
	local newCorner = tiles["CornerBeach"]:Clone()
	newCorner.Parent = parent
	local radius = tileSize/2 - newCorner.Size.X/2
	local offsetX = radius*(rotation > 90 and rotation < 270 and -1 or 1)
	local offsetZ = radius*(rotation > 180 and -1 or 1)
	newCorner.Position = pos + Vector3.new(offsetX, 0, offsetZ)
	newCorner.Orientation = Vector3.new(0, -rotation + 315, 0)
end

--Create Grid--
function mapGen.CreateGrid(origin, size)
	local grid = {}
	local rand = Random.new()
	local seed = rand.NextNumber(rand)*100000
	
	--CONFIG--
	--local resolution = 35
	--local frequency = 7
	--local waterThreshold = 40
	local amplitude = 100
	
	local resolution = 5
	local frequency = 1
	local waterThreshold = 35
	local swampThreshold = 10
	
	local model = Instance.new("Model")
	local tilesModel = Instance.new("Model")
	local beachParts = Instance.new("Model")
	local buildingsModel = Instance.new("Model")
	model.Parent = workspace
	model.Name = "Map"
	tilesModel.Parent = model
	tilesModel.Name = "Tiles"
	beachParts.Parent = model
	beachParts.Name = "BeachParts"
	buildingsModel.Parent = model
	buildingsModel.Name = "Buildings"
	local mapSize = tileSize * (size+1)
	local heights = {}
	
	--Calculate heights
	for x = 0, size do
		heights[x] = {}
		for y = 0, size do
			heights[x][y] = math.clamp((math.noise(x / resolution * frequency,y / resolution * frequency, seed)+1)/2, 0, 1) * amplitude
		end
	end
	
	--Place tiles
	for x = 0, size do
		grid[x] = {}
		for y = 0, size do
			local height = heights[x][y]
			local hasAdjacentWater = (x > 0 and heights[x-1][y] < waterThreshold) or (x < size-1 and heights[x+1][y] < waterThreshold)
			hasAdjacentWater = hasAdjacentWater or (y > 0 and heights[x][y-1] < waterThreshold) or (y < size-1 and heights[x][y+1] < waterThreshold)
			
			local newTile
			if height < waterThreshold and hasAdjacentWater then
				newTile = tiles["Lake"]:Clone()
			else
				newTile = tiles["Grass"]:Clone()
			end
			newTile.Parent = tilesModel
			local newPos = origin + Vector3.new(x * tileSize, 0, y * tileSize)
			newTile:PivotTo(CFrame.new(newPos))
			grid[x][y] = newTile
		end	
	end
	
	--Place water and sand
	local center = Vector3.new(origin.X + (mapSize-tileSize)/2, origin.Y-tileHeight/2, origin.Z + (mapSize-tileSize)/2)
	local sand = tiles["Sand"]:Clone()
	sand.Parent = model
	sand.Size = Vector3.new(mapSize, sand.Size.Y, mapSize)
	sand.Position = center + Vector3.new(0, sand.Size.Y/2, 0)
	local water = tiles["Water"]:Clone()
	water.Parent = model
	water.Size = Vector3.new(mapSize, water.Size.Y, mapSize)
	water.Position = center + Vector3.new(0, water.Size.Y/2, 0)
	
	--Place Beach parts
	for x, row in pairs(grid) do
		for y, tile in pairs(row) do
			if tile.Name == "Lake" then
				local centerPos = tile.PrimaryPart.Position
				local left = false
				local right = false
				local up = false
				local down = false
				--Place Edges
				if x > 0 and grid[x-1][y].Name ~= "Lake" then
					makeBeach(beachParts, centerPos, 180)
					left = true
				end
				if x < size-1 and grid[x+1][y].Name ~= "Lake" then
					makeBeach(beachParts, centerPos, 0)
					right = true
				end
				if y > 0 and grid[x][y-1].Name ~= "Lake" then
					makeBeach(beachParts, centerPos, 270)
					down = true
				end
				if y < size-1 and grid[x][y+1].Name ~= "Lake" then
					makeBeach(beachParts, centerPos, 90)
					up = true
				end
				--Place Corners
				if not left and not down and (x>0 and y>0) and grid[x-1][y-1].Name ~= "Lake" then
					makeCorner(beachParts, centerPos, 225)
				end
				if not left and not up and (x>0 and y<size-1) and grid[x-1][y+1].Name ~= "Lake" then
					makeCorner(beachParts, centerPos, 135)
				end
				if not right and not up and (x<size-1 and y<size-1) and grid[x+1][y+1].Name ~= "Lake" then
					makeCorner(beachParts, centerPos, 45)
				end
				if not right and not down and (x<size-1 and y>0) and grid[x+1][y-1].Name ~= "Lake" then
					makeCorner(beachParts, centerPos, 315)
				end
			end
		end
	end
	
	return grid
end


return mapGen
