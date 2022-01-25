
local button = {}

local buttonAnimXOffset = 12
local buttonAnimSpeed = 4

function button.containsPoint(x, y, btn)
	local width = FONT:getWidth(btn.text)
	local height = FONT:getHeight(btn.text)
	return x > btn.x and x < btn.x + width and y > btn.y and y < btn.y + height
end

function button.updateAnim(btn, dt, dir)
	btn.animation = clamp(btn.animation + dt * dir * buttonAnimSpeed, 0, 1)
end

function button.drawTextOutline(text, x, y, outlineThickness, scale) -- Doesn't exactly belong in `button`, but whatevs.
	local t = outlineThickness or 1
	scale = scale or 1
	love.graphics.print(text, x - t, y, 0, scale)
	love.graphics.print(text, x + t, y, 0, scale)
	love.graphics.print(text, x, y - t, 0, scale)
	love.graphics.print(text, x, y + t, 0, scale)

	love.graphics.print(text, x - t, y - t, 0, scale)
	love.graphics.print(text, x + t, y + t, 0, scale)
	love.graphics.print(text, x + t, y - t, 0, scale)
	love.graphics.print(text, x - t, y + t, 0, scale)
end

function button.draw(btn)
	local text = btn.text
	local x = btn.x + btn.animation * buttonAnimXOffset
	local y = btn.y

	setColor(32, 46, 55)
	button.drawTextOutline(text, x, y)

	setColor(232, 193, 112)
	love.graphics.print(text, x, y, 0, 1, 1)
end

return button
