
-- NOTE: Most of this is not actually used/doesn't do anything.
--       Only the screenshake is used.

local camera = {}

local camPos = { x = 0, y = 0 }
local boundCamPos = { x = 0, y = 0 }

local lerpSpeed = 10

local shakeStr = 0
local shakes = 0
local shakeTimer = newTimer(0)
local screenshake = { x = 0, y = 0 }

function camera.getShakeOffset()
	return screenshake.x, screenshake.y
end

function camera.bind(x, y)
	boundCamPos.x, boundCamPos.y = x, y
end

function camera.update(dt)
	shakeTimer:process(dt)

	if shakeTimer:isDone() then
		if shakes > 0 then
			shakes = shakes - 1

			shakeTimer:reset()

			screenshake.x = love.math.random(-shakeStr,shakeStr)
			screenshake.y = love.math.random(-shakeStr,shakeStr)
		else
			shakeStr = 0
			screenshake.x = 0
			screenshake.y = 0
		end
	end

	camPos.x = lerp(camPos.x, boundCamPos.x, dt*lerpSpeed)
	camPos.y = lerp(camPos.y, boundCamPos.y, dt*lerpSpeed)
end

function camera.shake(shakeStrNew, shakesNew, time)
	if shakeStr <= shakeStrNew then
		shakeStr = shakeStrNew
		shakes = shakesNew
		shakeTimer.timeMax = time
		shakeTimer.time = 0
	end
end

function camera.lockScreenshake(bool)
	shakeTimer.playing = bool
end

return camera
