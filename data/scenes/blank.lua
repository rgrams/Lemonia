
local BlankScene = {}

function BlankScene.Reload()
end

function BlankScene.Die()
end

function BlankScene.Update()
	-- Reset
	local nextScene = "blank"

	setColor(255, 255, 255)
	clear(255, 20, 255)

	-- Return scene
	return nextScene
end

return BlankScene
