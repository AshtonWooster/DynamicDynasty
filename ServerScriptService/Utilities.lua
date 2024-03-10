-- Server Utilities Module
-- Ashton

--Objects--
local utilities = {}
local repStorage = game:GetService("ReplicatedStorage")
local eventsFolder = repStorage:WaitForChild("Events")
local modules = script:GetChildren()
local events = eventsFolder:GetChildren()

--Set Up Events--
for _, event in pairs(events) do
	utilities[event.Name] = event
end

return utilities
