
local DeathScreen = {}

local images = require "data.scripts.images"

local gameLayer

local bOffset = 60
local BUTTON_AGAIN = {x = 4, y = 4 + bOffset, text = "Again", animation = 0}
local BUTTON_TWITTER = {x = 4, y = 16 + bOffset, text = "Twitter", animation = 0}
local BUTTON_SITE = {x = 4, y = 28 + bOffset, text = "Homepage", animation = 0}
local BUTTON_QUIT = {x = 4, y = 40 + bOffset, text = "Quit", animation = 0}

function DeathScreen.Reload()
	gameLayer = love.graphics.newCanvas(200,150)
end

function DeathScreen.Die()
end

function DeathScreen.Update()
	-- Reset
	local nextScene = "deathScreen"
	xM = xM * 0.25; yM = yM * 0.25

	love.graphics.setCanvas(gameLayer)

	setColor(255, 255, 255)
	love.graphics.draw(images.background)

	-- BUTTONS
	local text = BUTTON_AGAIN.text; local X = BUTTON_AGAIN.x + BUTTON_AGAIN.animation * 12; local Y = BUTTON_AGAIN.y
	setColor(32,46,55)
	love.graphics.print(text, X - 1, Y, 0, 1, 1)
	love.graphics.print(text, X + 1, Y, 0, 1, 1)
	love.graphics.print(text, X, Y - 1, 0, 1, 1)
	love.graphics.print(text, X, Y + 1, 0, 1, 1)

	love.graphics.print(text, X - 1, Y - 1, 0, 1, 1)
	love.graphics.print(text, X + 1, Y + 1, 0, 1, 1)
	love.graphics.print(text, X + 1, Y - 1, 0, 1, 1)
	love.graphics.print(text, X - 1, Y + 1, 0, 1, 1)

	setColor(232,193,112)
	love.graphics.print(text, X, Y, 0, 1, 1)

	if xM > BUTTON_AGAIN.x and xM < BUTTON_AGAIN.x + FONT:getWidth(text) and yM > BUTTON_AGAIN.y and yM < BUTTON_AGAIN.y + FONT:getHeight(text) then
		BUTTON_AGAIN.animation = clamp(BUTTON_AGAIN.animation + dt * 4, 0, 1)

		if mouseJustPressed(1) then
			nextScene = "game"
			TRANSITION = 1
		end
	else
		BUTTON_AGAIN.animation = clamp(BUTTON_AGAIN.animation - dt * 4, 0, 1)
	end

	local text = BUTTON_QUIT.text; local X = BUTTON_QUIT.x + BUTTON_QUIT.animation * 12; local Y = BUTTON_QUIT.y
	setColor(32,46,55)
	love.graphics.print(text, X - 1, Y, 0, 1, 1)
	love.graphics.print(text, X + 1, Y, 0, 1, 1)
	love.graphics.print(text, X, Y - 1, 0, 1, 1)
	love.graphics.print(text, X, Y + 1, 0, 1, 1)

	love.graphics.print(text, X - 1, Y - 1, 0, 1, 1)
	love.graphics.print(text, X + 1, Y + 1, 0, 1, 1)
	love.graphics.print(text, X + 1, Y - 1, 0, 1, 1)
	love.graphics.print(text, X - 1, Y + 1, 0, 1, 1)

	setColor(235,237,233)
	love.graphics.print(text, X, Y, 0, 1, 1)

	if xM > BUTTON_QUIT.x and xM < BUTTON_QUIT.x + FONT:getWidth(text) and yM > BUTTON_QUIT.y and yM < BUTTON_QUIT.y + FONT:getHeight(text) then

		BUTTON_QUIT.animation = clamp(BUTTON_QUIT.animation + dt * 4, 0, 1)

		if mouseJustPressed(1) then

			love.event.quit()

		end

	else

		BUTTON_QUIT.animation = clamp(BUTTON_QUIT.animation - dt * 4, 0, 1)

	end

	local text = BUTTON_TWITTER.text; local X = BUTTON_TWITTER.x + BUTTON_TWITTER.animation * 12; local Y = BUTTON_TWITTER.y
	setColor(32,46,55)
	love.graphics.print(text, X - 1, Y, 0, 1, 1)
	love.graphics.print(text, X + 1, Y, 0, 1, 1)
	love.graphics.print(text, X, Y - 1, 0, 1, 1)
	love.graphics.print(text, X, Y + 1, 0, 1, 1)

	love.graphics.print(text, X - 1, Y - 1, 0, 1, 1)
	love.graphics.print(text, X + 1, Y + 1, 0, 1, 1)
	love.graphics.print(text, X + 1, Y - 1, 0, 1, 1)
	love.graphics.print(text, X - 1, Y + 1, 0, 1, 1)

	setColor(235,237,233)
	love.graphics.print(text, X, Y, 0, 1, 1)

	if xM > BUTTON_TWITTER.x and xM < BUTTON_TWITTER.x + FONT:getWidth(text) and yM > BUTTON_TWITTER.y and yM < BUTTON_TWITTER.y + FONT:getHeight(text) then

		BUTTON_TWITTER.animation = clamp(BUTTON_TWITTER.animation + dt * 4, 0, 1)

		if mouseJustPressed(1) then

			print(love.system.openURL("https://twitter.com/CF_IS_HERE"))

		end

	else

		BUTTON_TWITTER.animation = clamp(BUTTON_TWITTER.animation - dt * 4, 0, 1)

	end

	local text = BUTTON_SITE.text; local X = BUTTON_SITE.x + BUTTON_SITE.animation * 12; local Y = BUTTON_SITE.y
	setColor(32,46,55)
	love.graphics.print(text, X - 1, Y, 0, 1, 1)
	love.graphics.print(text, X + 1, Y, 0, 1, 1)
	love.graphics.print(text, X, Y - 1, 0, 1, 1)
	love.graphics.print(text, X, Y + 1, 0, 1, 1)

	love.graphics.print(text, X - 1, Y - 1, 0, 1, 1)
	love.graphics.print(text, X + 1, Y + 1, 0, 1, 1)
	love.graphics.print(text, X + 1, Y - 1, 0, 1, 1)
	love.graphics.print(text, X - 1, Y + 1, 0, 1, 1)

	setColor(235,237,233)
	love.graphics.print(text, X, Y, 0, 1, 1)

	if xM > BUTTON_SITE.x and xM < BUTTON_SITE.x + FONT:getWidth(text) and yM > BUTTON_SITE.y and yM < BUTTON_SITE.y + FONT:getHeight(text) then

		BUTTON_SITE.animation = clamp(BUTTON_SITE.animation + dt * 4, 0, 1)

		if mouseJustPressed(1) then

			love.system.openURL("https://leyuan.wixsite.com/love/en?ref=lemonia")

		end

	else

		BUTTON_SITE.animation = clamp(BUTTON_SITE.animation - dt * 4, 0, 1)

	end

	local text = "Score"; local X = 4; local Y = 4
	setColor(32,46,55)
	love.graphics.print(text, X - 2, Y, 0, 2, 2)
	love.graphics.print(text, X + 2, Y, 0, 2, 2)
	love.graphics.print(text, X, Y - 2, 0, 2, 2)
	love.graphics.print(text, X, Y + 2, 0, 2, 2)

	love.graphics.print(text, X - 2, Y - 2, 0, 2, 2)
	love.graphics.print(text, X + 2, Y + 2, 0, 2, 2)
	love.graphics.print(text, X + 2, Y - 2, 0, 2, 2)
	love.graphics.print(text, X - 2, Y + 2, 0, 2, 2)

	setColor(235,237,233)
	love.graphics.print(text, X, Y, 0, 2, 2)

	setColor(255, 255, 255)
	drawSprite(images.mouse, xM, yM)
	drawSprite(images.mouseOuter, xM, yM)

	local text = ""..SCORE; local X = 4; local Y = 24
	setColor(32,46,55)
	love.graphics.print(text, X - 2, Y, 0, 2, 2)
	love.graphics.print(text, X + 2, Y, 0, 2, 2)
	love.graphics.print(text, X, Y - 2, 0, 2, 2)
	love.graphics.print(text, X, Y + 2, 0, 2, 2)

	love.graphics.print(text, X - 2, Y - 2, 0, 2, 2)
	love.graphics.print(text, X + 2, Y + 2, 0, 2, 2)
	love.graphics.print(text, X + 2, Y - 2, 0, 2, 2)
	love.graphics.print(text, X - 2, Y + 2, 0, 2, 2)

	setColor(235,237,233)
	love.graphics.print(text, X, Y, 0, 2, 2)

	setColor(255, 255, 255)
	drawSprite(images.mouse, xM, yM)
	drawSprite(images.mouseOuter, xM, yM)

	-- Draw the layer to the display (the layer is smaller size and gets scaled so the game is pixel perfect)
	love.graphics.setCanvas(DISPLAY_CANVAS)
	love.graphics.draw(gameLayer, 0, 0, 0, 4, 4)

	-- Return scene
	return nextScene
end

return DeathScreen
