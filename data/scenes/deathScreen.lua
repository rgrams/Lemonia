
local DeathScreen = {}

local images = require "data.scripts.images"
local button = require "data.scripts.button"

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

function DeathScreen.Update(dt)
	local nextScene = "deathScreen"

	xM = xM * 0.25
	yM = yM * 0.25

	love.graphics.setCanvas(gameLayer)

	setColor(255, 255, 255)
	love.graphics.draw(images.background)

	-- BUTTONS
	button.draw(BUTTON_AGAIN)

	if button.containsPoint(xM, yM, BUTTON_AGAIN) then
		button.updateAnim(BUTTON_AGAIN, dt, 1)

		if mouseJustPressed(1) then
			nextScene = "game"
		end
	else
		button.updateAnim(BUTTON_AGAIN, dt, -1)
	end

	button.draw(BUTTON_QUIT)

	if button.containsPoint(xM, yM, BUTTON_QUIT) then
		button.updateAnim(BUTTON_QUIT, dt, 1)

		if mouseJustPressed(1) then
			love.event.quit()
		end
	else
		button.updateAnim(BUTTON_QUIT, dt, -1)
	end

	button.draw(BUTTON_TWITTER)

	if button.containsPoint(xM, yM, BUTTON_TWITTER) then
		button.updateAnim(BUTTON_TWITTER, dt, 1)

		if mouseJustPressed(1) then
			print(love.system.openURL("https://twitter.com/CF_IS_HERE"))
		end
	else
		button.updateAnim(BUTTON_TWITTER, dt, -1)
	end

	button.draw(BUTTON_SITE)

	if button.containsPoint(xM, yM, BUTTON_SITE) then
		button.updateAnim(BUTTON_SITE, dt, 1)

		if mouseJustPressed(1) then
			love.system.openURL("https://leyuan.wixsite.com/love/en?ref=lemonia")
		end
	else
		button.updateAnim(BUTTON_SITE, dt, -1)
	end

	local text = "Score"; local X = 4; local Y = 4
	setColor(32,46,55)
	button.drawTextOutline(text, X, Y, 2, 2)

	setColor(235,237,233)
	love.graphics.print(text, X, Y, 0, 2, 2)

	setColor(255, 255, 255)
	drawSprite(images.mouse, xM, yM)
	drawSprite(images.mouseOuter, xM, yM)

	local text = ""..SCORE; local X = 4; local Y = 24
	setColor(32,46,55)
	button.drawTextOutline(text, X, Y, 2, 2)

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
