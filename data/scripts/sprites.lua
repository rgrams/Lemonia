
local SPRSCL = 1

-- Spritesheets

function loadSpritesheet(filename,w,h)
	h = h or w
	local sheet = love.graphics.newImage(filename)
	local x = sheet:getWidth()/w
	local y = sheet:getHeight()/h

	local images = {}
	for i=0,x do table.insert(images,{}) end

	for X=0,x do for Y=0,y do
		images[tostring(X+1)..","..tostring(Y+1)] = love.graphics.newQuad(X*w,Y*h,w,h,sheet)
	end end

	images.texture = sheet

	return images
end

function drawFrame(spritesheet,X,Y,x,y,sx,sy,r)
	sx = sx or 1
	sy = sy or 1
	r = r or 0

	local quad = spritesheet[tostring(X)..","..tostring(Y)]
	local qx, qy, qw, qh = quad:getViewport()

	love.graphics.draw(spritesheet.texture,quad,x,y,r,SPRSCL*sx,SPRSCL*sy, round(qw * 0.5), round(qh * 0.5))
end

-- Sprites

function drawSprite(tex, x, y, sx, sy, r)
	sx = sx or 1
	sy = sy or 1
	r = r or 0

	love.graphics.draw(tex, math.floor(x), math.floor(y), r, SPRSCL * sx, SPRSCL * sy, math.floor(tex:getWidth() * 0.5 + 0.5), math.floor(tex:getHeight() * 0.5 + 0.5))
end
