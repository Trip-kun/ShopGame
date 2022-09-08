local Tile = import("libs.tile")
local GUI=import("libs.gui")
local Class = require("libs.class")
local TileMap = Class("TileMap")
local dump = require("libs.dump")
local flux = require("libs.flux")
TileMap.name="Default"
TileMap.x=10
TileMap.prefix="Default"
TileMap.y=10
TileMap.data={}
TileMap.mouse={x=-1, y=-1}
method TileMap::initialize(x, y) {
    self.debug=false
    self.x=x
    self.y=y
    self.sx=1
    self.sy=1
    self.data={}
    for i=1, x {
        self.data[i]={}
    }
    self.clickFunctions={}
}
method TileMap::toClue() {
    out = "GameData['" .. self.prefix .. "']['TileMaps']['" .. self.name .."']=TileMap::new(" .. #self.data .. "," .. #self.data[1] .. ")"
    out ..="\n"
    out ..="GameData['" .. self.prefix .. "']['TileMaps']['" .. self.name .."'].name='" .. self.name .. "'"
    for x=1, #self.data {
        for y=1, #self.data[1] {
            if self.data[x][y] {
                out..="\n"
                out..=self.data[x][y]::toClue(self.name, self.prefix, x, y)
            }
        }

    }
    return out
}
method TileMap::toLua() {
    out = "GameData['" .. self.prefix .. "']['TileMaps']['" .. self.name .."']=TileMap:new(" .. #self.data .. "," .. #self.data[1] .. ")"
    out ..="\n"
    out ..="GameData['" .. self.prefix .. "']['TileMaps']['" .. self.name .."'].name='" .. self.name .. "'"
    for x=1, #self.data {
        for y=1, #self.data[1] {
            if self.data[x][y] {
                out..="\n"
                out..=self.data[x][y]::toLua(self.name, self.prefix, x, y)
            }
        }

    }
    return out
}
method TileMap::prepare(tileset) {
    self.prepared=true
    self.spriteBatch = love.graphics.newSpriteBatch(tileset, #self.data * #self.data[1], "dynamic")
    for x=1, #self.data {
        for y=1, #self.data[1] {
            self.spriteBatch::add(self.data[x][y]::getQuad(), (x-1)*24, (y-1)*24)


        }

    }

}
method TileMap::drawBatch(x, y, r, sx, sy, ox, oy, kx, ky) {
    love.graphics.draw(self.spriteBatch, x, y, r, sx, sy, ox, oy, kx, ky)
}
method TileMap::isFull() {

}
method TileMap.fromTable(tbl) {
    local rmvTotal=0
    local out=TileMap(1, 1)
    local secondRun=false
    local fn isEmpty(in_table) {
        for k, v of in_table {
            return false
        }
        return true
    }
    local xRun=1
    local yRun=1
    loop {

        if (secondRun) {
            yRun+=1
            xRun+=1
            out::extend(0, 1, 0, 1, fn {})

        }
        local rmv={}

        for k, v of tbl {
            if out::isFull() {
                continue
            } else {

                for x=1, xRun {
                    local needBreak=false
                    for y=1, yRun {
                        if (!out.data[x][y]) {
                        table.insert(rmv, k, true)
                            out.data[x][y]=v
                            needBreak=true
                            break
                        }

                    }
                    if needBreak {
                        break
                    }
                }

            }
        }
        for k of rmv {
            rmvTotal+=1
            tbl[k]=nil
        }
        secondRun=true
    } until isEmpty(tbl)
    return out
}

method TileMap::update(dt, x, y) {
    self.mouse={x=x,y=y}
     for x=1, #self.data {
            for y=1, #self.data[x] {
            if (self.data[x][y]) {
                local skip=false
                    if  ( self.mouse.x>=(self.sx*(x-1)*24)+self.rx && self.mouse.x<=((x*24)*self.sx)+self.rx && self.mouse.y>=(y-1)*self.sy*24+self.ry && self.mouse.y<=((y)*self.sy*24)+self.ry) {
                        //for _, point in GUI.clickCache {
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
local fn extend2DArray(arr, lx, rx, dy, uy, fill) {
    if rx && rx>0 {
        for x=#arr+1, #arr+rx {
            arr[x]={}
            for y=1, #arr[1] {
                arr[x][y]=fill()
            }
        }
    }
    if lx && lx>0 {
        for x=#arr, 1, -1 {
            arr[x+lx]=arr[x]
        }
        for x=1, lx {
            arr[x]={}
            for y=1, #arr[lx+1] {
                arr[x][y]=fill()
            }
        }
    }

    if dy && dy>0 {
        for x=1, #arr {
            for y=#arr[x]+1, #arr[x]+dy {
                arr[x][y]=fill()
            }
        }
    }
    if uy && uy>0 {
        for x=1, #arr {
            for y= #arr[1], 1, -1 {
                arr[x][y+uy]=arr[x][y]
            }
            for y=1, uy {
                arr[x][y]=fill()
            }
        }
    }
    return arr
}
local DefaultTile=Tile::new()
    DefaultTile['id']='Dirt'
    DefaultTile['prefix']='Default'
    DefaultTile['type']='Basic_Tile'
    DefaultTile['tileset']='DefaultTileset'
    DefaultTile['tilesetPrefix']='Default'
method TileMap::newBasicTile() {

    return DefaultTile::cloneTile()
}
method TileMap::extend(left, right, up, down, func) {
    extend2DArray(self.data, left, right, down, up, func || self.newBasicTile )
}
method TileMap::setDebug(val) {
    self.debug=val
}
method TileMap::collisionOut() {
    local out={}
    for x=1, #self.data {
        out[x]={}
        for y=1, #self.data[x] {
            out[x][y]=self.data[x][y]::getCollision()
        }
    }
    return out
}
method TileMap.collapseCollision(out1, out2) {
    local out={}
        for x=1, #out1 {
            out[x]={}
            for y=1, #out1[x] {
                out[x][y]=out1[x][y] || out2[x][y]
            }
        }
    return out
}
method TileMap::draw(rx, ry, r, sx, sy, ox, oy, kx, ky) {
    local found=false
    local found_place={x=-1, y=-1}
    local sx = sx || 1
    local sy = sy || 1
    self.sx=sx
    self.sy=sy
    self.rx=rx
    self.ry=ry
    for x=1, #self.data {
        for y=1, #self.data[x] {
            if (self.data[x][y]) {
            local skip=false
                if  ( self.mouse.x>=(sx*(x-1)*24)+rx && self.mouse.x<=((x*24)*sx)+rx && self.mouse.y>=((y-1)*sy*24)+ry && self.mouse.y<=((y)*24*sy)+ry) {
                    if (found!=true) {
                    found=true
                    found_place={x=x, y=y}
                    skip=true
                    if !self.data[x][y].tween {
                        self.data[x][y].rect=true
                        self.data[x][y].tween=flux.to(self.data[x][y], 0.5, {sx=1.2, sy=1.2})
                    }
                    }
                }   elseif (self.data[x][y].tween) {
                        self.data[x][y].rect=false
                        self.data[x][y].tween::stop()
                        self.data[x][y].tween=nil
                        self.data[x][y].sx=1
                        self.data[x][y].sy=1
                }
            if !skip {
            love.graphics.push()
            love.graphics.translate(((x-0.5)*24*sx)+rx, ((y-0.5)*24*sy)+ry)
            love.graphics.scale(self.data[x][y].sx, self.data[x][y].sy)
            love.graphics.draw(self.data[x][y]::getTileset(), self.data[x][y]::getQuad(), -12*sx, -12*sx, r, sx, sy, ox, oy, kx, ky)
            local oldColor = {love.graphics.getColor()}
            love.graphics.setColor(0, 0, 0, 0.5)
            love.graphics.rectangle("line", -12*sx, -12*sx, 24*sx, 24*sx)
            love.graphics.setColor(oldColor)
            love.graphics.pop()
            }
        }
        }
    }
    if found {
    local x, y = found_place.x, found_place.y
    love.graphics.push()
    love.graphics.translate(((x-0.5)*24*sx)+rx, ((y-0.5)*24*sy)+ry)
    love.graphics.scale(self.data[x][y].sx, self.data[x][y].sy)
    love.graphics.draw(self.data[x][y]::getTileset(), self.data[x][y]::getQuad(), -12*sx, -12*sx, r, sx, sy, ox, oy, kx, ky)
        love.graphics.rectangle("line", -12*sx, -12*sx, 24*sx, 24*sx)
    love.graphics.pop()
    }
}
method TileMap::onClick(func) {
    table.insert(self.clickFunctions, func)
}
method TileMap::loadEdits(new_data, first) {

    if type(self.data[1])!="table" && !first {
        error("incomplete data")
    }
    for x, z of new_data {
        for y of z {
            self.data[x][y]=new_data[x][y]

        }

    }

}


return TileMap