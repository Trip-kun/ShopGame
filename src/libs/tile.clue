global Class = require("libs.class")
global log = import("libs.log")
global json = require("libs.json")
local Tile = Class("Tile")
local GameData = nil
Tile.sx=1
Tile.sy=1
Tile.type="Basic_Tile"
Tile.prefix="Default"
Tile.id="Default"
Tile.tileset="DefaultTileset"
Tile.tilesetPrefix="Default"
method Tile::initialize() {
    self.sx=1
    self.sy=1
}
method Tile.loadGameData() {
    GameData= import("libs.GameData")


}
method Tile::getQuad() {
    return GameData[self.tilesetPrefix].Tiles[self.tileset][self.id]
}
method Tile::getTileset() {
    return GameData[self.prefix].Images[self.tileset]



}
method Tile::toClue(TileMapName, TileMapPrefix, x, y) {
    local out = "GameData['" .. TileMapPrefix .. "']['TileMaps']['" .. TileMapName .. "']['data'][" .. x .. "][" .. y .. "]=Tile::new()"

    out..="\n"
    out..= "GameData['" .. TileMapPrefix .. "']['TileMaps']['" .. TileMapName .. "']['data'][" .. x .. "][" .. y .. "]['id']='" .. self.id .. "'"

    out..="\n"
    out..= "GameData['" .. TileMapPrefix .. "']['TileMaps']['" .. TileMapName .. "']['data'][" .. x .. "][" .. y .. "]['prefix']='" .. self.prefix .. "'"

    out..="\n"
    out..= "GameData['" .. TileMapPrefix .. "']['TileMaps']['" .. TileMapName .. "']['data'][" .. x .. "][" .. y .. "]['type']='" .. self.type .. "'"

    out..="\n"
    out..= "GameData['" .. TileMapPrefix .. "']['TileMaps']['" .. TileMapName .. "']['data'][" .. x .. "][" .. y .. "]['tileset']='" .. self.tileset .. "'"

    out..="\n"
    out..= "GameData['" .. TileMapPrefix .. "']['TileMaps']['" .. TileMapName .. "']['data'][" .. x .. "][" .. y .. "]['tilesetPrefix']='" .. self.tilesetPrefix .. "'"

    return out
}
method Tile.handle(object, data) {
    self.type=data.type
    self.prefix=data.prefix
    self.id=data.id



}

method Tile.fromJSON(data) {
    if type(data)!="string" {
        error("Not a string.")
    }
    local dataInTable=json.decode(data)





}

return Tile