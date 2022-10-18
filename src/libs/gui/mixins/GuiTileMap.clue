
local TileMapMixin = {}
//Param map: TileMap (libs.TileMap) to use for drawing
method TileMapMixin::initTileMap(map) {
    self.map=map
    self.clickFunctions={}
}

method TileMapMixin::update(dt, x, y) {
    self.map.mouse={x=x,y=y}
     for x=1, #self.map.data {
            for y=1, #self.map.data[x] {
            if (self.map.data[x][y]) {
                local skip=false
                    if  (self.interact && self.map.mouse.x>=(self.sx*(x-1)*24)+self.rx && self.map.mouse.x<=((x*24)*self.sx)+self.rx && self.map.mouse.y>=(y-1)*self.sy*24+self.ry && self.map.mouse.y<=((y)*self.sy*24)+self.ry) {
                        //for _, point in GUI.clickCache
                        if (love.mouse.isDown(1) || #love.touch.getTouches( ) > 0) {
                               for _, v in self.clickFunctions {
                                    v(self, x, y)
                               }
                        }
                    }
                }
            }
     }
}
method TileMapMixin::draw(rx, ry, r, sx, sy, ox, oy, kx, ky) {
    local found=false
    local found_place={x=-1, y=-1}
    local sx = sx || 1
    local sy = sy || 1
    self.sx=sx
    self.sy=sy
    self.rx=rx
    self.ry=ry
    for x=1, #self.map.data {
        for y=1, #self.map.data[x] {
            if (self.map.data[x][y]) {
            local skip=false
                if  ( self.map.mouse.x>=(sx*(x-1)*24)+rx && self.map.mouse.x<=((x*24)*sx)+rx && self.map.mouse.y>=((y-1)*sy*24)+ry && self.map.mouse.y<=((y)*24*sy)+ry) {
                    if (found!=true) {
                    found=true
                    found_place={x=x, y=y}
                    skip=true
                    if !self.map.data[x][y].tween {
                        if self.interact {
                            self.map.data[x][y].rect=true
                            self.map.data[x][y].tween=flux.to(self.map.data[x][y], 0.5, {sx=1.2, sy=1.2})
                        }
                    }
                    }
                }   elseif (self.map.data[x][y].tween) {
                        self.map.data[x][y].rect=false
                        self.map.data[x][y].tween::stop()
                        self.map.data[x][y].tween=nil
                        self.map.data[x][y].sx=1
                        self.map.data[x][y].sy=1
                }
            if !skip {
            love.graphics.push()
            love.graphics.translate(((x-0.5)*24*sx)+rx, ((y-0.5)*24*sy)+ry)
            love.graphics.scale(self.map.data[x][y].sx, self.map.data[x][y].sy)
            
            self.map.data[x][y]::draw(x, y, r, sx, sy, ox, oy, kx, ky, true)
            
            love.graphics.pop()
            }
        }
        }
    }
    if found {
    local x, y = found_place.x, found_place.y
    love.graphics.push()
    love.graphics.translate(((x-0.5)*24*sx)+rx, ((y-0.5)*24*sy)+ry)
    love.graphics.scale(self.map.data[x][y].sx, self.map.data[x][y].sy)
    self.map.data[x][y]::draw(x, y, r, sx, sy, ox, oy, kx, ky, true)
    love.graphics.pop()
    }
}
method TileMapMixin::onClick(func) {
    table.insert(self.clickFunctions, func)
}

return TileMapMixin