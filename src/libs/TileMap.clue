local Tile = import("libs.tile")
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
    self.x=x
    self.y=y
    self.sx=1
    self.sy=1
    self.data={}
    for i=1, x {
        self.data[i]={}
    }
}
method TileMap::toClue() {
    out = "GameData['" .. self.prefix .. "']['TileMaps']['" .. self.name .."']=TileMap::new(" .. self.x .. "," .. self.y .. ")"
    out ..="\n"
    out ..="GameData['" .. self.prefix .. "']['TileMaps']['" .. self.name .."'].name='" .. self.name .. "'"
    for x=1, #self.data {
        for y=1, #self.data[1] {
            out..="\n"
            out..=self.data[x][y]::toClue(self.name, self.prefix, x, y)

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
method TileMap::update(dt, x, y) {
    self.mouse={x=x,y=y}
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
method TileMap::extend(left, right, up, down) {
    extend2DArray(self.data, left, right, down, up, fn () {
        local DefaultTile=Tile::new()
        DefaultTile['id']='Dirt01'
        DefaultTile['prefix']='Default'
        DefaultTile['type']='Basic_Tile'
        DefaultTile['tileset']='DefaultTileset'
        DefaultTile['tilesetPrefix']='Default'
        return DefaultTile
    })
}
method TileMap::draw(rx, ry, r, sx, sy, ox, oy, kx, ky) {
    local found=false
    local foundplace={x=-1, y=-1}
    for x=1, #self.data {
        for y=1, #self.data[x] {
            local skip=false
                if  ( self.mouse.x>=(x-1)*24+rx && self.mouse.x<=(x*24)+rx && self.mouse.y>=(y-1)*24+ry && self.mouse.y<=((y)*24)+ry) {
                    if (found!=true) {
                    found=true
                    foundplace={x=x, y=y}
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
            love.graphics.translate((x*24)-12+rx, (y*24)-12+ry)
            love.graphics.scale(self.data[x][y].sx, self.data[x][y].sy)
            love.graphics.draw(self.data[x][y]::getTileset(), self.data[x][y]::getQuad(), -12, -12, r, sx, sy, ox, oy, kx, ky)
            if self.data[x][y].rect {
                love.graphics.rectangle("line", -12, -12, 24, 24)
            }
            love.graphics.pop()
            }
        }

    }
    if found {
    love.graphics.print("FOUND YA", 1000, 1000)
    local x, y = foundplace.x, foundplace.y
    love.graphics.push()
    print(x, y)
    love.graphics.translate((x*24)-12+rx, (y*24)-12+ry)
    love.graphics.scale(self.data[x][y].sx, self.data[x][y].sy)
    love.graphics.draw(self.data[x][y]::getTileset(), self.data[x][y]::getQuad(), -12, -12, r, sx, sy, ox, oy, kx, ky)
        love.graphics.rectangle("line", -12, -12, 24, 24)
    love.graphics.pop()
    }
}
method TileMap::loadEdits(newdata, first) {

    if type(self.data[1])!="table" && !first {
        error("incomplete data")
    }
    for x, z of newdata {
        for y of z {
            self.data[x][y]=newdata[x][y]

        }

    }

}


return TileMap