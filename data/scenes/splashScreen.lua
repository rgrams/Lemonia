
local SplashScreen = {}

local shaders = require "data.scripts.shaders"

local timer
local GRAVITY
local shouldFall
local squash
local flash
local titleRotation
local TITLE
local titleY
local STOMP_PARTICLES
local TUNE

function SplashScreen.Reload()
	timer = 5
	GRAVITY = 540
	shouldFall = 1
	squash = newVec(1, 1)
	flash = 0
	titleRotation = 1
	TITLE = love.graphics.newImage("data/images/splashScreen/title.png")
	titleY = -80
	STOMP_PARTICLES = newParticleSystem(400, 325, loadJson("data/particles/splashScreen/splashScreenParticles.json"))
	TUNE = love.audio.newSource("data/sound/SFX/splashScreen/intro.wav", "stream")
	TUNE:play()
end

function SplashScreen.Die()
	TITLE = nil
end

function SplashScreen.Update(dt)
	-- Reset
	local nextScene = "splash"

	setColor(255, 255, 255)
	clear(99, 199, 77)

	timer = timer - dt
	titleY = titleY + dt * GRAVITY * shouldFall

	if titleY > 300 then titleY = 300; shouldFall = 0; squash.x = 1.4; squash.y = 0.75; flash = 1; STOMP_PARTICLES.ticks = 1 end

	local speed = 15
	squash.x = lerp(squash.x,1,dt*speed); squash.y = lerp(squash.y,1,dt*speed); flash = lerp(flash,0,dt*speed*0.5)

	STOMP_PARTICLES:process(dt)

	setColor(0, 0, 0, 60)
	local scale = clamp(titleY,0,300)/300
	love.graphics.ellipse("fill",400,320,160*scale,20*scale)

	shaders.fx.FLASH:send("intensity",flash)
	love.graphics.setShader(shaders.fx.FLASH)
	love.graphics.draw(TITLE,400,titleY,titleRotation*clamp(timer-4.65,0,1),squash.x,squash.y,TITLE:getWidth()*0.5,TITLE:getHeight()*0.5)
	love.graphics.setShader()

	if timer < 0 then
		nextScene = "menu"
	end


	setColor(0,0,0,255*(1-timer))
	love.graphics.rectangle("fill",0,0,800,600)

	-- Return scene
	return nextScene
end

return SplashScreen
