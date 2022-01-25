
local sound = {}

local sources = {
	shoot = love.audio.newSource("data/sound/SFX/shoot.wav", "stream"),
	enemyHit = love.audio.newSource("data/sound/SFX/enemyHit.wav", "stream"),
	enemyDie = love.audio.newSource("data/sound/SFX/enemyDie.wav", "stream"),
	playerHit = love.audio.newSource("data/sound/SFX/playerStolen.wav", "stream"),
	playerDie = love.audio.newSource("data/sound/SFX/playerDie.wav", "stream"),
	music = love.audio.newSource("data/sound/music/music.wav", "stream")
}

local activeSounds = {}

local activeSoundCount = {}
for name,snd in pairs(sources)do
	activeSoundCount[name] = 0
end

local function stopSound(snd)
	snd.isLooping = false
	snd.voice:stop()
end

local function newSound(name, voice, isLooping)
	return {
		name = name,
		voice = voice,
		isLooping = isLooping,
		stop = stopSound -- Needed to stop looping sounds.
	}
end

function sound.play(name, pitch, isLooping, maxPlays)
	if (maxPlays or 99) > activeSoundCount[name]  then
		pitch = pitch or 1
		local voice = sources[name]:clone()
		voice:setPitch(pitch)
		voice:play()
		if isLooping then
			voice:setLooping(true)
		end
		local snd = newSound(name, voice, isLooping)
		table.insert(activeSounds, snd)
		activeSoundCount[name] = activeSoundCount[name] + 1
		return snd
	end
end

function sound.update() -- processSound
	for i=#activeSounds,1,-1 do -- Need to iterate backwards because we're removing elements.
		local snd = activeSounds[i]
		if not snd.isLooping and not snd.voice:isPlaying() then
			table.remove(activeSounds, i)
			activeSoundCount[snd.name] = activeSoundCount[snd.name] - 1
		end
	end
end

return sound
