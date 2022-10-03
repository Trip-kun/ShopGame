local Tile = import("libs.tile")
local Class = require("libs.class")
local LayeredTileMap = Class("LayeredTileMap")
local dump = require("libs.dump")
local flux = require("libs.flux")
local TileMap = import("libs.TileMap")
LayeredTileMap.name="Default"
LayeredTileMap.x=10
LayeredTileMap.y=10
LayeredTileMap.z=5
LayeredTileMap.layers={}
LayeredTileMap.mouse={x=-1, y=-1}
//z=1 == bottom layer
//z=z == top layer
method LayeredTileMap::initialize(x, y, z) {
    self.debug=false
    self.x=x
    self.y=y
    self.z=z
    self.sx=1
    self.sy=1
    self.clickFunctions={}
    self.layers={}
    for i=1, z {
        self.layers[i]=TileMap(x, y)
        self.layers[i].clickFunctions={}
    }
}
method LayeredTileMap::alias(index, alias) {
    self[alias]=self.layers[index]
}
method LayeredTileMap::extend(left, right, up, down, func) {
    for i=1, #self.layers {
        self.layers[i]::extend(left, right, up, down, func)
    }
}
method LayeredTileMap::setDebug(val) {
    self.debug=val
    for i=1, #self.layers {
        self.layers[i].debug=val
    }
}
method LayeredTileMap::collisionOut() {
    local out = self.layers[#self.layers]::collisionOut()
    for i=#self.layers-1, 1 {
        out = TileMap.collapseCollision(out, self.layers[i]::collisionOut())
    }
    return out
}
