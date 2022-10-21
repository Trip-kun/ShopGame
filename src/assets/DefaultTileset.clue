local fn generateQuad24X(x, y, tileset) {
    return love.graphics.newQuad(1+((x-1)*25), 1+((y-1)*25), 24, 24, tileset)

}

local TileMap = import("libs.TileMap")
local Tile = import("libs.tile")
return fn (GameData) {
local canvas = love.graphics.newCanvas(24, 24)
GameData.Default.Images.Empty=canvas
love.graphics.setCanvas(canvas)
love.graphics.clear(0, 0, 0, 0)
love.graphics.setCanvas()
local emptyQuad=love.graphics.newQuad(0, 0, 24, 24, canvas)
local orderedTable={}
GameData.Default.Tiles.DefaultTileset={

meta newindex = fn (tbl, key, value) {
    table.insert(orderedTable, {key, value})
    local coll=false
    rawset(tbl, key, {quad=value, collision=coll})
}
}
GameData.Default.Tiles.DefaultTileset.EmptyCollider=emptyQuad
GameData.Default.Tiles.DefaultTileset.Empty=emptyQuad
GameData.Default.Tiles.DefaultTileset.Dirt=generateQuad24X(8, 3, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DirtULGrassDR=generateQuad24X(2, 2, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DirtUGrassD=generateQuad24X(3, 2, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DirtURGrassDL=generateQuad24X(4, 2, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DirtLGrassR=generateQuad24X(2, 3, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DirtRGrassL=generateQuad24X(4, 3, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DirtDLGrassUR=generateQuad24X(2, 4, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DirtDGrassU=generateQuad24X(3, 4, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DirtDRGrassUL=generateQuad24X(4, 4, GameData.Default.Images.DefaultTileset)


GameData.Default.Tiles.DefaultTileset.DirtULDarkDR=generateQuad24X(2, 7, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DirtUDarkD=generateQuad24X(3, 7, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DirtURDarkDL=generateQuad24X(4, 7, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DirtLDarkR=generateQuad24X(2, 8, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DirtRDarkL=generateQuad24X(4, 8, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DirtDLDarkUR=generateQuad24X(2, 9, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DirtDDarkU=generateQuad24X(3, 9, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DirtDRDarkUL=generateQuad24X(4, 9, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.Dark=generateQuad24X(3, 8, GameData.Default.Images.DefaultTileset)


GameData.Default.Tiles.DefaultTileset.DarkULGrassDR=generateQuad24X(2, 7+5, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DarkUGrassD=generateQuad24X(3, 7+5, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DarkURGrassDL=generateQuad24X(4, 7+5, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DarkLGrassR=generateQuad24X(2, 8+5, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DarkRGrassL=generateQuad24X(4, 8+5, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DarkDLGrassUR=generateQuad24X(2, 9+5, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DarkDGrassU=generateQuad24X(3, 9+5, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DarkDRGrassUL=generateQuad24X(4, 9+5, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.Grass=generateQuad24X(3, 8+5, GameData.Default.Images.DefaultTileset)


GameData.Default.Tiles.DefaultTileset.GrassULDirtDR=generateQuad24X(2+5, 2, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.GrassUDirtD=generateQuad24X(3+5, 2, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.GrassURDirtDL=generateQuad24X(4+5, 2, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.GrassLDirtR=generateQuad24X(2+5, 3, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.GrassRDirtL=generateQuad24X(4+5, 3, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.GrassDLDirtUR=generateQuad24X(2+5, 4, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.GrassDDirtU=generateQuad24X(3+5, 4, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.GrassDRDirtUL=generateQuad24X(4+5, 4, GameData.Default.Images.DefaultTileset)


GameData.Default.Tiles.DefaultTileset.DarkULDirtDR=generateQuad24X(12-5, 7, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DarkUDirtD=generateQuad24X(13-5, 7, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DarkURDirtDL=generateQuad24X(14-5, 7, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DarkLDirtR=generateQuad24X(12-5, 8, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DarkRDirtL=generateQuad24X(14-5, 8, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DarkDLDirtUR=generateQuad24X(12-5, 9, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DarkDDirtU=generateQuad24X(13-5, 9, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.DarkDRDirtUL=generateQuad24X(14-5, 9, GameData.Default.Images.DefaultTileset)


GameData.Default.Tiles.DefaultTileset.GrassULDarkDR=generateQuad24X(2+5, 7+5, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.GrassUDarkD=generateQuad24X(3+5, 7+5, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.GrassURDarkDL=generateQuad24X(4+5, 7+5, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.GrassLDarkR=generateQuad24X(2+5, 8+5, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.GrassRDarkL=generateQuad24X(4+5, 8+5, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.GrassDLDarkUR=generateQuad24X(2+5, 9+5, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.GrassDDarkU=generateQuad24X(3+5, 9+5, GameData.Default.Images.DefaultTileset)
GameData.Default.Tiles.DefaultTileset.GrassDRDarkUL=generateQuad24X(4+5, 9+5, GameData.Default.Images.DefaultTileset)
rawset(GameData.Default.Tiles.DefaultTileset, "EmptyCollider",{quad=emptyQuad, collision=true})
rawset(GameData.Default.Tiles.DefaultTileset, "Empty",{quad=emptyQuad, collision=false})
local out={}
for k, v in orderedTable {

    local t = Tile()
    t.sx=1
    t.sy=1
    t.id=v[1]
    t.prefix="Default"
    if (v[2]==emptyQuad) {
        t.tileset="DefaultTileset"
        t.type="Utility_Tile"
    } else {
        t.type="Basic_Tile"
        t.tileset="DefaultTileset"
    }
    t.tilesetPrefix="Default"

    table.insert(out, t)
}
GameData.Default.TileMaps.DefaultTileset=TileMap.fromTable(out)
GameData.Default.TileMaps.DefaultTileset.name="DefaultTileset"
}