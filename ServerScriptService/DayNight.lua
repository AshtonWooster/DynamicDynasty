--Day & Night Script--
--Derek--

local lighting = game:GetService("Lighting")
local minutes = 7 * 60

while wait(1) do
	lighting:SetMinutesAfterMidnight(minutes)
	minutes = lighting:GetMinutesAfterMidnight()

	if minutes > 19 * 60 then
		minutes = minutes + 3
	elseif minutes > 7 * 60 then
		minutes = minutes + 1
	else
		minutes = minutes + 3
	end
end
