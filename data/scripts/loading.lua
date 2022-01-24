
local json = require "data.scripts.json"

function loadJson(path)
	local file = love.filesystem.read(path)
	return json.decode(file)
end
