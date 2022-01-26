
function gameReload() -- Loading the scene
    gameLayer = love.graphics.newCanvas(200,150)
    splatLayer = love.graphics.newCanvas(200,150)
    ENEMY_COLORS = {
        {232/255, 193/255, 112/255}, {208/255, 218/255, 145/255}, {223/255, 132/255, 165/255}
        }

    love.graphics.setCanvas(splatLayer)
    love.graphics.draw(love.graphics.newImage("data/images/background.png"))
    love.graphics.setCanvas()
    
    -- Enemy spray disappear over time
    bg = love.graphics.newImage("data/images/background.png")
    
    -- Images
    IMAGE_ENEMY = {love.graphics.newImage("data/images/lemon.png"), love.graphics.newImage("data/images/lemon2.png"), love.graphics.newImage("data/images/lemon3.png")}

    IMAGE_PLAYER = loadSpritesheet("data/images/player.png", 11, 16)
    IMAGE_PLAYER_GUN = love.graphics.newImage("data/images/shooter.png")

    IMAGE_BULLET = love.graphics.newImage("data/images/playerBullet.png")

    IMAGE_COG = love.graphics.newImage("data/images/cog.png")


    -- Player
    player = {
        x = 100, y = 77,

        vel = newVec(0, 0),

        hp = 5, speed = 80,

        shootTimer = newTimer(0.2), iFrames = 0
    }

    died = false

    -- Projectiles
    playerBullets = {}

    -- Particles
    particleSystems = {}
    lemonSplatParticleSystems = {}

    PARTICLES_PLAYER_SHOOT = loadJson("data/particles/playerShot.json")
    PARTICLES_PLAYER_WALK = newParticleSystem(0, 0, loadJson("data/particles/playerWalk.json"))
    PARTICLES_PLAYER_DIE = loadJson("data/particles/playerDie.json")

    PARTICLES_ENEMY_HIT = loadJson("data/particles/playerShotHit.json")
    PARTICLES_ENEMY_SPLAT = loadJson("data/particles/enemySplat.json")
    PARTICLES_ENEMY_DIE = loadJson("data/particles/enemyDie.json")
    PARTICLES_LAST_ENEMY_DIE = loadJson("data/particles/lastEnemyDie.json")

    -- Enemies and waves
    enemies = {}

    waveCooldown = newTimer(1)

    wave = 0; waveJustEnded = true

    -- Sprites
    sprites = {}

    -- Wave messages and score messages
    waveMessages = {}; scoreMessages = {}

    -- Score
    score = 0

    -- Sound
    MUSIC = love.audio.newSource("data/sound/music/music.wav", "stream")
    MUSIC:play()

    -- Cogs
    cogs = {}

    -- Death animation
    deathAnimationTimer = newTimer(4)

end

function gameDie()
end

function orderY(a,b) return a.y > a.y end

function addSprite(tex, x, y, sx, sy, rot, flash)
    local r, g, b, a = love.graphics.getColor()
    table.insert(sprites, {tex = tex, x = x, y = y, sx = sx, sy = sy, rot = rot, animated = false, flash = flash or 0,r=r,g=g,b=b,a=a})
end
function addAnimatedSprite(spritesheet, X, Y, x, y, sx, sy, rot, flash)
    local r, g, b, a = love.graphics.getColor()
    table.insert(sprites, {spritesheet = spritesheet, X = X, Y = Y, x = x, y = y, sx = sx, sy = sy, rot = rot, animated = true, flash = flash or 0,r=r,g=g,b=b,a=a})
end

function game()
    -- RESET
    sceneAt = "game"
    
    love.graphics.setCanvas(gameLayer)
    setColor(255, 255, 255)
    clear(80, 80, 80)

    xM = xM * 0.25; yM = yM * 0.25

    sprites = {}


    -- Enemy spray disappear over time

    -- MUSIC
    if not MUSIC:isPlaying() then MUSIC:play() end

    -- WAVE PROCESSING

    if #enemies == 0 then

         wave = wave + 1

        -- Spawn enemies
        for e=0, wave * 2 + 1 do
            
            -- Random position
            local enemyPos = newVec(love.math.random(300, 530), 0); enemyPos:rotate(love.math.random(0, 360))

            -- New wave message
            table.insert(waveMessages,{

                lifetime = 2.5, wave = wave

                }
            )

            -- Insert the enemy in the enemies table
            table.insert(enemies, {

                x = enemyPos.x + 100; y = enemyPos.y + 75,

                hp = 3, hasItem = false,

                knockback = newVec(0, 0), flashTimer = newTimer(0.6), sprite = love.math.random(1,3)

                }
            )

        end
        
    end

    -- SPLAT
    love.graphics.draw(splatLayer)

    -- PLAYER
    if player.hp > 0 then
        player.iFrames = clamp(player.iFrames - dt, 0, 99)
        
        player.vel.x = lerp(player.vel.x, (boolToInt(pressed("d")) - boolToInt(pressed("a"))) * player.speed, dt * 5)
        player.vel.y = lerp(player.vel.y, (boolToInt(pressed("s")) - boolToInt(pressed("w"))) * player.speed, dt * 5)

        player.x = clamp(player.x + player.vel.x * dt, 0, 200); player.y = clamp(player.y + player.vel.y * dt, 0, 150)

        local moving = (math.abs(player.vel.x) + math.abs(player.vel.y)) / player.speed

        player.shootTimer:process()

        -- Drawing
        PARTICLES_PLAYER_WALK.x = player.x; PARTICLES_PLAYER_WALK.y = player.y + 8
        PARTICLES_PLAYER_WALK.ticks = round(moving)
        PARTICLES_PLAYER_WALK:process()

        setColor(255, 255, 255, 255 * (1 - math.abs(math.sin(player.iFrames / 1.15 * 3.14 * 5))))
        addAnimatedSprite(IMAGE_PLAYER, 6 - player.hp, 1, player.x, player.y, boolToInt(xM > player.x) * 2 - 1, 1, math.sin(globalTimer * 12) * 0.2 * moving)
        setColor(255,255,255)

        local aimerOffset = newVec(8, 0)
        local aimerRotation = newVec(xM - player.x, yM - player.y):getRot()
        aimerOffset:rotate(aimerRotation)

        addSprite(IMAGE_PLAYER_GUN, player.x + aimerOffset.x, player.y + aimerOffset.y, 1, 1, aimerRotation / 180 * 3.14)

        -- Shooting
        if mousePressed(1) and player.shootTimer:isDone() then

            player.shootTimer:reset()
            playSound("shoot", love.math.random(40,160) * 0.01)

            table.insert(playerBullets,
                {
                x = player.x + aimerOffset.x * 1.4; y = player.y + aimerOffset.y * 1.4,

                vel = newVec(160, 0):rotate(aimerRotation + love.math.random(-5, 5))
                }
        
            )

            table.insert(particleSystems, newParticleSystem(player.x + aimerOffset.x * 1.4, player.y + aimerOffset.y * 1.4, deepcopyTable(PARTICLES_PLAYER_SHOOT)))

            --shake(2, 1, 0.1)

        end
    else

        deathAnimationTimer:process()
        transition = 1 - (deathAnimationTimer.time / deathAnimationTimer.timeMax)
        MUSIC:setVolume(deathAnimationTimer.time / deathAnimationTimer.timeMax)

        if deathAnimationTimer:isDone() then

            sceneAt = "deathScreen"

        end

        if died == false then

            died = true
            table.insert(particleSystems, newParticleSystem(player.x, player.y, PARTICLES_PLAYER_DIE)); playSound("playerDie", 1)

        end

    end

    -- ENEMIES

    local kill = {}
    for id, E in ipairs(enemies) do
        local rot = nil; local dir = nil
        if E.hasItem then

            rot = newVec(E.x - player.x, E.y - player.y)
            dir = newVec(30, 0):rotate(rot:getRot())

            if E.x < -100 or E.x > 300 or E.y < -100 or E.y > 250 then table.insert(kill, id) end

        else

            rot = newVec(E.x - player.x, E.y - player.y)
            dir = newVec(40, 0):rotate(rot:getRot() + 180)

            if newVec(player.x - E.x, player.y - E.y):getLen() < 4 and player.iFrames == 0 then

                E.hasItem = true; player.hp = player.hp - 1; player.iFrames = 1.5; playSound("playerHit", love.math.random(80,120) * 0.01); shake(8, 3, 0.075)

            end

        end

        E.knockback.x = lerp(E.knockback.x, 0, dt * 4); E.knockback.y = lerp(E.knockback.y, 0, dt * 4)

        E.x = E.x + (dir.x + E.knockback.x) * dt; E.y = E.y + (dir.y + E.knockback.y) * dt

        E.flashTimer:process()

        addSprite(IMAGE_ENEMY[E.sprite], E.x, E.y, boolToInt(dir.x > 0) * 2 - 1, 1, E.flashTimer.time, boolToInt(E.flashTimer.time > 0.5))
        if E.hasItem then addSprite(IMAGE_COG, E.x, E.y - 12, 1, 1) end

        local bulletKill = {}
        for idB, B in ipairs(playerBullets) do

            local difference = newVec(B.x - E.x, B.y - E.y)

            if difference:getLen() < 12 then
                    
                table.insert(bulletKill, idB)

                E.hp = E.hp - 1

                -- Juice
                --shake(3, 2, 0.1)

                E.flashTimer:reset()

                playSound("enemyHit", love.math.random(80,120) * 0.01)

                local knockback = newVec(40, 0):rotate(difference:getRot() + 180)

                table.insert(particleSystems, newParticleSystem(B.x, B.y, deepcopyTable(PARTICLES_ENEMY_HIT)))

                E.knockback.x = E.knockback.x + knockback.x
                E.knockback.y = E.knockback.y + knockback.y

                if E.hp == 0 then

                    if E.hasItem then

                        table.insert(cogs,
                            {
                                x = E.x, y = E.y
                            }
                        )

                    end

                    score = score + 100
                    table.insert(scoreMessages, {message = ""..tostring(100), x = E.x, y = E.y - 12, lifetime = 0.8})

                    --shake(5, 2, 0.1)

                    table.insert(kill, id)

                    playSound("enemyDie", love.math.random(80,120) * 0.01)

                    local particleData = deepcopyTable(PARTICLES_ENEMY_SPLAT); particleData.rotation = B.vel:getRot()
                    print(ENEMY_COLORS[E.sprite].r)            

                    particleData.particleData.color.r.a = ENEMY_COLORS[E.sprite][1]
                    particleData.particleData.color.r.b = ENEMY_COLORS[E.sprite][1]

                    particleData.particleData.color.g.a = ENEMY_COLORS[E.sprite][2]
                    particleData.particleData.color.g.b = ENEMY_COLORS[E.sprite][2]

                    particleData.particleData.color.b.a = ENEMY_COLORS[E.sprite][3]
                    particleData.particleData.color.b.b = ENEMY_COLORS[E.sprite][3]
                    
                    table.insert(lemonSplatParticleSystems, newParticleSystem(B.x, B.y, particleData))

                    table.insert(particleSystems, newParticleSystem(B.x, B.y, deepcopyTable(PARTICLES_ENEMY_DIE)))

                    if #enemies - #kill == 0 then table.insert(particleSystems, newParticleSystem(B.x, B.y, deepcopyTable(PARTICLES_LAST_ENEMY_DIE))); shake(7, 2, 0.1) end
                    
                    
                    break
                end

            end

        end playerBullets = wipeKill(bulletKill, playerBullets)

    end enemies = wipeKill(kill, enemies)

    -- COGS

    local kill = {}
    for id, C in ipairs(cogs) do

        addSprite(IMAGE_COG, C.x, C.y + math.sin(globalTimer * 3) * 2, 1, 1, 0)
        
        if newVec(player.x - C.x, player.y - C.y):getLen() < 16 then

            player.hp = player.hp + 1
            table.insert(kill, id)

        end

    end cogs = wipeKill(kill, cogs)

    -- SPRITES

    -- Sort
    table.sort(sprites, orderY)

    -- Draw
    love.graphics.setShader(SHADERS.FLASH)

    for id, S in ipairs(sprites) do
        SHADERS.FLASH:send("intensity", S.flash or 0)
        
        love.graphics.setColor(S.r, S.g, S.b, S.a)

        if S.animated then

            drawFrame(S.spritesheet, S.X, S.Y, S.x, S.y, S.sx, S.sY, S.rot)

        else

            drawSprite(S.tex, S.x, S.y, S.sx, S.sy, S.rot)

        end
    end

    love.graphics.setShader()

    -- PLAYER BULLETS

    -- Loop trough all bullelts
    local kill = {}
    for id, B in ipairs(playerBullets) do

        -- Move bullet
        B.x = B.x + B.vel.x * dt; B.y = B.y + B.vel.y * dt

        -- Draw bullet
        drawSprite(IMAGE_BULLET, B.x, B.y, 1, 1, B.vel:getRot() / 180 * 3.14)

        -- Kill bullets offscreen
        if B.x < -8 or B.x > 208 or B.y < -8 or B.y > 158 then table.insert(kill, id) end

    end playerBullets = wipeKill(kill, playerBullets)

    -- PARTICLES AND MARKS
    local kill = {}
    for id, P in ipairs(particleSystems) do

        -- Process particle system
        P:process()

        -- Kill if it is done
        if P.ticks == 0 and #P.particles == 0 then table.insert(kill, id) end

    end particleSystems = wipeKill(kill, particleSystems)

    love.graphics.setCanvas(splatLayer)

    local kill = {}
    for id, P in ipairs(lemonSplatParticleSystems) do

        -- Process particle system
        P:process()

        -- Kill if it is done
        if P.ticks == 0 and #P.particles == 0 then table.insert(kill, id) end

    end lemonSplatParticleSystems = wipeKill(kill, lemonSplatParticleSystems)

    love.graphics.setCanvas(gameLayer)

    -- SCORE MESSAGES

    local kill = {}
    for id, M in ipairs(scoreMessages) do

        M.lifetime = M.lifetime - dt
        
        local text = M.message

        local X = round(M.x); local Y = round(M.y + 8 * M.lifetime / 0.8)

        local A = 255 * M.lifetime / 0.8

        setColor(207,87,60,A)
        love.graphics.print(text, X - 1, Y, 0, 1, 1, round(FONT:getWidth(text)) * 0.5, round(FONT:getHeight(text)) * 0.5)
        love.graphics.print(text, X + 1, Y, 0, 1, 1, round(FONT:getWidth(text)) * 0.5, round(FONT:getHeight(text)) * 0.5)
        love.graphics.print(text, X, Y - 1, 0, 1, 1, round(FONT:getWidth(text)) * 0.5, round(FONT:getHeight(text)) * 0.5)
        love.graphics.print(text, X, Y + 1, 0, 1, 1, round(FONT:getWidth(text)) * 0.5, round(FONT:getHeight(text)) * 0.5)

        love.graphics.print(text, X - 1, Y - 1, 0, 1, 1, round(FONT:getWidth(text)) * 0.5, round(FONT:getHeight(text)) * 0.5)
        love.graphics.print(text, X + 1, Y + 1, 0, 1, 1, round(FONT:getWidth(text)) * 0.5, round(FONT:getHeight(text)) * 0.5)
        love.graphics.print(text, X + 1, Y - 1, 0, 1, 1, round(FONT:getWidth(text)) * 0.5, round(FONT:getHeight(text)) * 0.5)
        love.graphics.print(text, X - 1, Y + 1, 0, 1, 1, round(FONT:getWidth(text)) * 0.5, round(FONT:getHeight(text)) * 0.5)

        setColor(231,213,179, A)
        love.graphics.print(text, X, Y, 0, 1, 1, round(FONT:getWidth(text)) * 0.5, round(FONT:getHeight(text)) * 0.5)

        if M.lifetime < 0 then table.insert(kill, id) end

    end scoreMessages = wipeKill(kill, scoreMessages)

    -- WAVE MESSAGES

    local kill = {}
    for id, M in ipairs(waveMessages) do

        M.lifetime = M.lifetime - dt

        text = "Wave "..tostring(M.wave)

        local X = 100; local Y = 95 * math.abs(math.sin((1 - M.lifetime / 2.5) * 3.14)) - 20
        setColor(122,72,65,A)
        love.graphics.print(text, X - 2, Y, 0, 2, 2, round(FONT:getWidth(text) * 0.5), round(FONT:getHeight(text) * 0.5))
        love.graphics.print(text, X + 2, Y, 0, 2, 2, round(FONT:getWidth(text) * 0.5), round(FONT:getHeight(text) * 0.5))
        love.graphics.print(text, X, Y - 2, 0, 2, 2, round(FONT:getWidth(text) * 0.5), round(FONT:getHeight(text) * 0.5))
        love.graphics.print(text, X, Y + 2, 0, 2, 2, round(FONT:getWidth(text) * 0.5), round(FONT:getHeight(text) * 0.5))

        love.graphics.print(text, X - 2, Y - 2, 0, 2, 2, round(FONT:getWidth(text) * 0.5), round(FONT:getHeight(text) * 0.5))
        love.graphics.print(text, X + 2, Y + 2, 0, 2, 2, round(FONT:getWidth(text) * 0.5), round(FONT:getHeight(text) * 0.5))
        love.graphics.print(text, X + 2, Y - 2, 0, 2, 2, round(FONT:getWidth(text) * 0.5), round(FONT:getHeight(text) * 0.5))
        love.graphics.print(text, X - 2, Y + 2, 0, 2, 2, round(FONT:getWidth(text) * 0.5), round(FONT:getHeight(text) * 0.5))

        setColor(231,213,179, A)
        love.graphics.print(text, X, Y, 0, 2, 2, round(FONT:getWidth(text) * 0.5), round(FONT:getHeight(text) * 0.5))

        if M.lifetime < 0 then table.insert(kill, id) end
        
    end waveMessages = wipeKill(kill, waveMessages)

    -- SCORE
    local text = tostring(score)
    local X = 4; local Y = 2

    setColor(129,151,150)
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

    -- MOUSE
    setColor(255, 255, 255)
    drawSprite(MOUSE, xM, yM)
    drawSprite(MOUSE_OUTER, xM, yM, 1, 1, player.shootTimer.time / player.shootTimer.timeMax * 1.57)
    
    -- Draw the layer to the display (the layer is smaller size and gets scaled so the game is pixel perfect)
    love.graphics.setCanvas(display)
    love.graphics.draw(gameLayer, 0, 0, 0, 4, 4)

    -- Return scene
    return sceneAt
end