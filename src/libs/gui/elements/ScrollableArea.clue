local Class = require("libs.class")
local ClickCache = import("libs.gui.subsystems.ClickCache")
local ScrollableArea=Class("ScrollableArea")
local push= require("libs.push")
method ScrollableArea::initialize(x, y, width, height, true_width, true_height, start_offset_x, start_offset_y) {
    firstRun=false

    self.x, self.y= x, y
    self.width=width
    self.height=height
    self.true_width=true_width
    self.true_height=true_height
    self.canvas=love.graphics.newCanvas(true_width, true_height)
    self.offsetX=start_offset_x || 0
    self.offsetY=start_offset_y || 0
    self.children={}
}


method ScrollableArea::drawStart() {
    self.oldCanvas=love.graphics.getCanvas()
    love.graphics.setCanvas(self.canvas)
    love.graphics.push()
    love.graphics.translate(-self.offsetX, -self.offsetY)
}
method ScrollableArea::drawFinish() {
    love.graphics.setCanvas(self.oldCanvas)
    love.graphics.pop()
}
method ScrollableArea::draw() {
    self::drawStart()
    
    for _, v in self.children {
        if v.draw {
            v::draw()
        }
    }
    
    self::drawFinish()

    
}
method ScrollableArea::updateStart() {
    self.backup={}
    local cache=ClickCache.getCache()
    for i, v in cache {
        self.backup[i]=v
    }
    for i, v in self.backup {
        cache[i]= self::fromWorld(v)
    }

}
method ScrollableArea::updateFinish() {
    local cache=ClickCache.getCache()
    for i, v in self.backup {
        cache[i]=v
    }

}
method ScrollableArea::fromWorld(pt) {
    local x, y = pt.x, pt.y
    if (x-self.x <0 || x-self.x>self.width || y-self.y<0 || y-self.y>self.height) {
        return {x=-1, y=-1}
    }
    return {x=x-self.x+self.offsetX, y=y-self.y+self.offsetY}
}
method ScrollableArea::update(dt, x, y) {
    local pt = self::fromWorld({x=x, y=y})
    local x, y = pt.x, pt,y
    for _, v in self.children {
        if v.update {
            v::update(x, y)
        }
    }
}