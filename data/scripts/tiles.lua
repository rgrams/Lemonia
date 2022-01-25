
-- Tile functions
local function getTilemapTile(tilemap,x,y)
	return tilemap.tiles[tostring(x)..","..tostring(y)]
end

local function setTilemapTile(tilemap,x,y,tile)
	tilemap.tiles[tostring(x)..","..tostring(y)] = tile
end

local function removeTilemapTile(tilemap,x,y)
	tilemap.tiles[tostring(x)..","..tostring(y)] = nil
end

-- Drawing
local function drawTilemap(tilemap)
	for id,T in pairs(tilemap.tiles) do
		local pos = splitString(id,",")
		local tileX = tonumber(pos[1]); local tileY = tonumber(pos[2])

		drawFrame(tilemap.sheet,T[1],T[2],tileX*tilemap.tileSize,tileY*tilemap.tileSize)
	end
end

-- Build colliders (goes trough all tiles, places a collider on them in the tilemap.collided if they dont have a neightbour somewhere)
local function buildTilemapColliders(tilemap)
	tilemap.colliders = {}

	for id,T in pairs(tilemap.tiles) do
		local pos = splitString(id,",")
		local tileX = tonumber(pos[1]); local tileY = tonumber(pos[2])

		local place = tilemap.tiles[tostring(tileX - 1)..","..tostring(tileY)] == nil or tilemap.tiles[tostring(tileX + 1)..","..tostring(tileY)] == nil or
		tilemap.tiles[tostring(tileX)..","..tostring(tileY - 1)] == nil or tilemap.tiles[tostring(tileX)..","..tostring(tileY + 1)] == nil

		if place then
			local rect = newRect(tileX * tilemap.tileSize, tileY * tilemap.tileSize, tilemap.tileSize, tilemap.tileSize)
			table.insert(tilemap.colliders,rect)
		end
	end
end

-- New tilemap
function newTilemap(texture,tileSize,tiles)
	local tilemap = {
		tiles=tiles or {},
		tileSize=tileSize,
		sheet=texture,

		getTile=getTilemapTile,
		setTile=setTilemapTile,
		removeTile=removeTilemapTile,
		draw=drawTilemap,

		colliders={},
		buildColliders=buildTilemapColliders
	}

	return tilemap
end
