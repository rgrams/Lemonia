
SOUNDS = {
	shoot = love.audio.newSource("data/sound/SFX/shoot.wav", "stream"),
	enemyHit = love.audio.newSource("data/sound/SFX/enemyHit.wav", "stream"),
	enemyDie = love.audio.newSource("data/sound/SFX/enemyDie.wav", "stream"),
	playerHit = love.audio.newSource("data/sound/SFX/playerStolen.wav", "stream"),
	playerDie = love.audio.newSource("data/sound/SFX/playerDie.wav", "stream")
}

SOUNDS_NUM_PLAYING = {}
for id,S in pairs(SOUNDS) do SOUNDS_NUM_PLAYING[id] = 0 end

SOUNDS_PLAYING = {}

function playSound(string, pitch, maxPlays)
	if (maxs or 99) > SOUNDS_NUM_PLAYING[string]  then
		local pitch = pitch or 1
		local NEW_SOUND = SOUNDS[string]:clone(); NEW_SOUND:setPitch(pitch); NEW_SOUND:play()
		table.insert(SOUNDS_PLAYING,{NEW_SOUND, string})
		SOUNDS_NUM_PLAYING[string] = SOUNDS_NUM_PLAYING[string] + 1
	end
end

function processSound()
	for id,S in ipairs(SOUNDS_PLAYING) do
		if not S[1]:isPlaying() then table.remove(SOUNDS_PLAYING,id); SOUNDS_NUM_PLAYING[S[2]] = SOUNDS_NUM_PLAYING[S[2]] - 1 end
	end
end
