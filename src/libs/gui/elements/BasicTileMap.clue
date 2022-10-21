local Class = require("libs.class")
local BasicTileMap = Class("BasicTileMap")
local TileMapMixin = import("libs.gui.mixins.GuiTileMap")
BasicTileMap::include(TileMapMixin)
//A simple implementation of a TileMap. See GuiTileMap for more info
//Param x: x position the internal drawable element should be drawn at.
//Param y: y position the internal drawable element should be drawn at.
//Param sx: x-scale value when drawing.
//Param sy: y-scale value when drawing.
//Param map: TileMap (libs.TileMap) to use for drawing
method BasicTileMap::initialize(x, y, sx, sy, map) {
    self.x=x
    self.y=y
    self._sx=sx
    self._sy=sy
    self::initTileMap(map)


}
method BasicTileMap::draw(rx, ry, r, sx, sy, ox, oy, kx, ky) {
    rx=rx || 0
    ry=ry || 0
    sx=sx || 1
    sy=sy || 1
    TileMapMixin.draw(self, rx+self.x, ry+self.y, r, sx*self._sx, sy*self._sy, ox, oy, kx, ky)

}


return BasicTileMap