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
}
method ScrollableArea::drawFinish() {
    love.graphics.setCanvas(self.oldCanvas)
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