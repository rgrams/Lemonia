
local isFullscreen = false

-- All global values used in all scenes (display, textures, options, etc.)
function love.load()
	-- Window and defaulting
	love.graphics.setDefaultFilter("nearest","nearest")

	love.window.setTitle("Lemonia                   [F1 for fullscreen]")

	WS = { 800,600 }
	wFlags = { resizable=true }
	aspectRatio = { WS[1]/WS[2], WS[2]/WS[1] }
	love.graphics.setBackgroundColor(0, 0, 0, 1)
	love.window.setMode(WS[1], WS[2], wFlags)
	displayScale = 1
	display = love.graphics.newCanvas(WS[1], WS[2])
	postProCanvas = love.graphics.newCanvas(WS[1], WS[2])

	globalTimer = 0

	-- Font
	FONT = love.graphics.newFont("data/font.ttf", 8)
	love.graphics.setFont(FONT)

	-- Audio
	love.audio.setVolume(0.1)

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
	require "data.scripts.camera"
	require "data.scripts.audio"

	-- Mouse
	love.mouse.setVisible(false)

	-- Scenes
	require "data.scenes.blank"
	require "data.scenes.splashScreen"
	require "data.scenes.game"
	require "data.scenes.deathScreen"
	require "data.scenes.menu"
	scenes = {
		menu = { menu, menuReload, menuDie },
		deathScreen = { deathScreen, deathScreenReload, deathScreenDie },
		game = { game, gameReload, gameDie },
		["splash"] = { splashScreen, splashScreenReload, splashScreenDie },
		["blank"] = { blank, blankReload, blankDie }
	}

	-- Set default scene (the first one)
	scene = "menu"
	firstScene = "menu"
	scenes[scene][2]()

	-- Set joysticks
	JOYSTICKS = love.joystick.getJoysticks()
	JOYSTICK_LAST_PRESSES = {}
	for id,J in pairs(JOYSTICKS) do
		JOYSTICK_LAST_PRESSES[id] = "none"
	end

	-- Transitions
	transition = 1
end

local function changeFullscreen()
	isFullscreen = not isFullscreen
	love.window.setFullscreen(isFullscreen)
	if isFullscreen == false then
		love.window.width = WS[1]
		love.window.height = WS[2]
		displayScale = 1
	end
end

-- Play scenes
function love.draw()
	-- Time and resetting
	dt = love.timer.getDelta()
	globalTimer = globalTimer + dt

	-- Mouse pos
	xM, yM = love.mouse.getPosition()

	w, h = love.graphics.getDimensions()
	dw, dh = display:getDimensions()

	xM = clamp(xM, w*0.5-dw*0.5*displayScale, w*0.5+dw*0.5*displayScale)
	yM = clamp(yM, h*0.5-dh*0.5*displayScale, h*0.5+dh*0.5*displayScale)
	xM = xM - (w*0.5-dw*0.5*displayScale)
	yM = yM - (h*0.5-dh*0.5*displayScale)
	xM = xM/displayScale
	yM = yM/displayScale

	-- Bg and canvas resetting
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setCanvas(display)
	love.graphics.clear(0,0,0,1)

	--------------------------------------------------------------------------SCENE CALLED
	sceneNew = scenes[scene][1]()

	if sceneNew ~= scene then
		scenes[scene][3]()
		scene = sceneNew
		scenes[scene][2]()
		transition = 1
	end

	setColor(0, 0, 0, 255*transition)
	love.graphics.rectangle("fill", 0, 0, 800, 600)
	transition = clamp(transition - dt, 0, 1)

	processCamera()

	love.graphics.setColor(1, 1, 1, 1)

	-- Draw display
	love.graphics.setCanvas()

	love.graphics.draw(display, w*0.5-dw*0.5*displayScale + screenshake[1] * displayScale, h*0.5-dh*0.5*displayScale + screenshake[2] * displayScale, 0, displayScale, displayScale)

	love.graphics.setColor(1, 0, 1, 1)
	resetLights()

	-- Check for fullscreen
	if justPressed("f1") then
		changeFullscreen()
	end

	processSound()

	-- Reset input
	lastKeyPressed = "none"
	lastMouseButtonPressed = -1
	for id,J in pairs(JOYSTICKS) do
		JOYSTICK_LAST_PRESSES[id] = "none"
	end
end

-- Display resizing
function love.resize(w, h)
	-- Clamp
	if w < WS[1] then
		w = WS[1]
	end
	if h < WS[2] then
		h = WS[2]
	end

	-- Set display scale
	if w < h then
		displayScale = w/WS[1]
	else
		displayScale = h/WS[2]
	end

	-- Set window
	love.window.width = w
	love.window.height = h
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
	id = elementIndex(JOYSTICKS, joystick)
	table.remove(JOYSTICKS, id)
	table.remove(JOYSTICK_LAST_PRESSES, id)
end

function love.joystickpressed(joystick, button)
	id = elementIndex(JOYSTICKS, joystick)
	JOYSTICK_LAST_PRESSES[id] = button
end
