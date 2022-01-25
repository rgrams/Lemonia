-------- INIT shaders --------

local shaders = {}

shaders.fx = {
	GLOW = love.graphics.newShader((love.filesystem.read("data/shaders/GLOW.fs"))),
	PIXEL_PERFECT = love.graphics.newShader((love.filesystem.read("data/shaders/PIXEL_PERFECT.fs"))),
	FLASH = love.graphics.newShader((love.filesystem.read("data/shaders/FLASH.fs"))),
	LIGHT = love.graphics.newShader((love.filesystem.read("data/shaders/LIGHT.fs"))),
	GLITCH = love.graphics.newShader((love.filesystem.read("data/shaders/GLITCH.fs"))),
	EMPTY = love.graphics.newShader((love.filesystem.read("data/shaders/EMPTY.fs"))),
	INVERT = love.graphics.newShader((love.filesystem.read("data/shaders/INVERT.fs"))),
	GRAYSCALE = love.graphics.newShader((love.filesystem.read("data/shaders/GRAYSCALE.fs")))
}

shaders.fx.GLOW:send("xRatio",VIEW_ASPECT_RATIO)
shaders.fx.GLITCH:send("mask",love.graphics.newImage("data/images/shaderMasks/glitch.png"))

-------- LIGHT SHADER FUNCTIONS --------
local lights = {}

function shaders.shine(x,y,diffuse,power)
	table.insert(lights,{position={x,y},diffuse=diffuse,power=power})
end

function shaders.processLights(position,diffuse,power,displayScale)
	shaders.fx.LIGHT:send("offset",{w*0.5-dw*0.5*displayScale,h*0.5-dh*0.5*displayScale})
	shaders.fx.LIGHT:send("numLights",table.getn(lights))

	for id,L in pairs(lights) do
		local actualId = id - 1
		shaders.fx.LIGHT:send("lights["..tostring(actualId).."].position",L.position)
		shaders.fx.LIGHT:send("lights["..tostring(actualId).."].diffuse",L.diffuse)
		shaders.fx.LIGHT:send("lights["..tostring(actualId).."].power",L.power)
	end
end

function shaders.resetLights()
	lights = {}
end

-- Table of all post process effects you want, example: postPro = {"PIXEL_PERFECT","GLOW"}
local postPro = {}

return shaders
