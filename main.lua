

local isFullscreen = false
local scenes
local curScene
local startingScene = "menu"
local displayScale = 1
local viewArea = { w = 800, h = 600 }
local sound
local camera

_G.VIEW_ASPECT_RATIO = viewArea.w/viewArea.h
_G.GLOBAL_TIMER = 0
_G.TRANSITION = 1
_G.FONT = nil -- Set in love.load().
_G.DISPLAY_CANVAS = nil -- Set in love.load().
_G.SCORE = 0

function love.load()
	-- Window
	love.window.setTitle("Lemonia                   [F1 for fullscreen]")
	local windowFlags = { resizable = true }
	love.window.setMode(viewArea.w, viewArea.h, windowFlags)

	-- Rendering
	love.graphics.setDefaultFilter("nearest","nearest")
	love.graphics.setBackgroundColor(0, 0, 0, 1)

	DISPLAY_CANVAS = love.graphics.newCanvas(viewArea.w, viewArea.h)
	-- postProCanvas = love.graphics.newCanvas(viewArea.w, viewArea.h)

	-- Textures
	require "data.scripts.images" -- load images

	-- Font
	FONT = love.graphics.newFont("data/font.ttf", 8)
	love.graphics.setFont(FONT)

	-- Audio
	love.audio.setVolume(0.1)
	sound = require("data.scripts.audio") -- load audio sources

	-- Imports
	require "data.scripts.misc"
	require "data.scripts.loading"
	require "data.scripts.shaders"
	require "data.scripts.mathPlus"
	require "data.scripts.input"
	require "data.scripts.sprites"
	require "data.scripts.particles"
	require "data.scripts.tiles"
	require "data.scripts.timer"
	require "data.scripts.audio"

	camera = require "data.scripts.camera"

	-- Mouse
	love.mouse.setVisible(false)

	-- Scenes
	scenes = {
		menu = require("data.scenes.menu"),
		deathScreen = require("data.scenes.deathScreen"),
		game = require("data.scenes.game"),
		splash = require("data.scenes.splashScreen"),
		blank = require("data.scenes.blank")
	}

	-- Set default scene (the first one)
	curScene = startingScene
	scenes[curScene].Reload()
	TRANSITION = 1

	-- Set joysticks
	JOYSTICKS = love.joystick.getJoysticks()
	JOYSTICK_LAST_PRESSES = {}
	for id,J in pairs(JOYSTICKS) do
		JOYSTICK_LAST_PRESSES[id] = "none"
	end
end

local function changeFullscreen()
	isFullscreen = not isFullscreen
	love.window.setFullscreen(isFullscreen)
	if isFullscreen == false then
		love.window.width = viewArea.w
		love.window.height = viewArea.h
		displayScale = 1
	end
end

-- Play scenes
function love.draw()
	-- Time and resetting
	local dt = love.timer.getDelta()
	GLOBAL_TIMER = GLOBAL_TIMER + dt

	-- Mouse pos
	xM, yM = love.mouse.getPosition()

	local w, h = love.graphics.getDimensions()

	local viewportWidth = viewArea.w*displayScale
	local viewportHeight = viewArea.h*displayScale
	local viewportLeft = w/2 - viewportWidth/2
	local viewportTop = h/2 - viewportHeight/2
	local viewportRight = w/2 + viewportWidth/2
	local viewportBottom = h/2 + viewportHeight/2

	-- Clamp mouse to view area (reverse scale canvas size)
	xM = clamp(xM, viewportLeft, viewportRight)
	yM = clamp(yM, viewportTop, viewportBottom)
	-- Center mouse pos.
	xM = xM - viewportLeft
	yM = yM - viewportTop
	-- Scale mouse pos down to canvas pixel size.
	xM = xM/displayScale
	yM = yM/displayScale

	-- Bg and canvas resetting
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setCanvas(DISPLAY_CANVAS)
	love.graphics.clear(0, 0, 0, 1)

	--------------------------------------------------------------------------SCENE CALLED
	local nextScene = scenes[curScene].Update(dt)

	camera.update(dt)

	if nextScene ~= curScene then
		scenes[curScene].Die()
		curScene = nextScene
		scenes[curScene].Reload()
		TRANSITION = 1
	end

	if TRANSITION > 0 then
		setColor(0, 0, 0, 255*TRANSITION)
		love.graphics.rectangle("fill", 0, 0, 800, 600)
		TRANSITION = clamp(TRANSITION - dt, 0, 1)
	end

	love.graphics.setColor(1, 1, 1, 1)

	-- Draw display
	love.graphics.setCanvas()

	local shakeX, shakeY = camera.getShakeOffset()
	love.graphics.draw(DISPLAY_CANVAS, viewportLeft + shakeX * displayScale, viewportTop + shakeY * displayScale, 0, displayScale, displayScale)

	love.graphics.setColor(1, 0, 1, 1)
	-- shaders.resetLights()

	-- Check for fullscreen
	if justPressed("f1") then
		changeFullscreen()
	end

	sound.update()

	-- Reset input
	lastKeyPressed = "none"
	lastMouseButtonPressed = -1
	for id,J in pairs(JOYSTICKS) do
		JOYSTICK_LAST_PRESSES[id] = "none"
	end
end

-- Display resizing
function love.resize(w, h)
	-- Scale down to fit window while maintaining aspect ratio
	displayScale = math.min(w/viewArea.w, h/viewArea.h)
end

-- Keyboard
function love.keypressed(key, scancode, isrepeat)
	setJustPressed(scancode)
end

-- Mouse
function love.mousepressed(x, y, button)
	setMouseJustPressed(button)
end

-- Joysticks
function love.joystickadded(joystick)
	table.insert(JOYSTICKS, joystick)
	table.insert(JOYSTICK_LAST_PRESSES, "none")
end

function love.joystickremoved(joystick)
	local id = elementIndex(JOYSTICKS, joystick)
	table.remove(JOYSTICKS, id)
	table.remove(JOYSTICK_LAST_PRESSES, id)
end

function love.joystickpressed(joystick, button)
	local id = elementIndex(JOYSTICKS, joystick)
	JOYSTICK_LAST_PRESSES[id] = button
end
