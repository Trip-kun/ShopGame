local LayeredTileMapMixin={}

method LayeredTileMapMixin::initLayeredTileMap(map) {
    self.map=map
    self.debug=true
}
method LayeredTileMapMixin::update(dt, x, y) {



}

method LayeredTileMapMixin::setDebug(val) {
    self.debug=val
}
local fn Array2DSize(arr) {
    local lim = 0
    for i=1, #arr {
        if lim<=#arr[i] {
            lim=#arr[i]
        }
    }
    return lim
}
method LayeredTileMapMixin::draw(rx, ry, r, sx, sy, ox, oy, kx, ky) {
    local sx = sx || 1
    local sy = sy || 1
    self.sx=sx
    self.sy=sy
    self.rx=rx
    self.ry=ry
    for i=1, #self.map.layers {
        for y=1, Array2DSize(self.map.layers[1].data) {
            for x=1, #self.map.layers[1].data {
                love.graphics.push()
                love.graphics.translate(((x-0.5)*24*sx)+rx, ((y-0.5)*24*sy)+ry)
                //love.graphics.scale(self.map.layers[i].data[x][y].sx, self.map.layers[i].data[x][y].sy)

                self.map.layers[i].data[x][y]::draw(x, y, r, sx, sy, ox, oy, kx, ky, self.debug)

                love.graphics.pop()
            }
        }
    }



}

return LayeredTileMapMixin