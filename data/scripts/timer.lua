
local function processTimer(timer, dt)
	timer.time = clamp(timer.time - dt * boolToInt(timer.playing), 0, timer.timeMax)
end

local function isTimerDone(timer)
	return timer.time == 0
end

local function resetTimer(timer)
	timer.time = timer.timeMax
end

function newTimer(time)
	return {
		playing = true,
		time = time or 0,
		timeMax = time,
		isDone = isTimerDone,
		process = processTimer,
		reset = resetTimer
	}
end
