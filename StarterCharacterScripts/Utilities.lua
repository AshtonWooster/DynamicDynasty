-- Client Utilities Module
-- Ashton

--Objects--
local utilities = {}
local repStorage = game:GetService("ReplicatedStorage")
local eventsFolder = repStorage:WaitForChild("Events")

--Set Up events--
for _, event in pairs(eventsFolder:GetChildren()) do
	utilities[event.Name] = event
end

return utilities
