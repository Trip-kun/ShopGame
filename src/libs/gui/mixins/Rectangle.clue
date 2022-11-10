//A Simple Universal Background for UI elements
local rectangle={}
local drawable = import("libs.gui.mixins.Drawable")
local active = import("libs.gui.mixins.Active")
local flux = require("libs.flux")
//Should be called within an implementing class's init function
//DO NOT call self::initDrawable within the class's init function
//Param x: x position the internal drawable element should be drawn at.
//Param y: y position the internal drawable element should be drawn at.
//Param color: the color to draw this element with: in the form {red, green, blue, alpha} see love (Color)
//Param width: The width to create the canvas
//Param height: The height to create the canvas
method rectangle::initRectangle(x, y, color, width, height) {
    self::initDrawable(x, y, true, width, height)
    self.rectangleCanvas=love.graphics.newCanvas(width, height)
    self.color=color
    self.sx=1
    self.sy=1
    self.tween=nil
    self.hovered=false
}
//Used to draw the UI background
//Should be used within the implementing class's draw function
//Should be used BEFORE most other draw functions within the Class
method rectangle::drawRectangle(x, y, rotation, sx, sy, ox, oy, kx, ky) {
    local x = x || 0
    local y = y || 0
    local sx = sx || 1
    local sy = sy || 1
    local rotation = rotation || 0
    local oldCanvas = love.graphics.getCanvas()
        love.graphics.setCanvas(self.rectangleCanvas)
        local a, b, c, d = love.graphics.getScissor()
        love.graphics.setScissor()
        love.graphics.clear()
        love.graphics.setScissor(a, b, c, d)
        local r, g, b, a = love.graphics.getColor()
        love.graphics.setColor(self.color)
        love.graphics.rectangle("fill", 0, 0, self.width, self.height, 20, 20)
        love.graphics.setColor(self.color[1]*0.5, self.color[2]*0.5, self.color[3]*0.5, self.color[4])
        local oldWidth = love.graphics.getLineWidth()
        love.graphics.setLineWidth(20)
        love.graphics.rectangle("line", 20/2, 20/2, self.width-20, self.height-20, 20*0.45, 20*0.45)
        love.graphics.setLineWidth(oldWidth)
        love.graphics.setCanvas(oldCanvas)
        love.graphics.setColor(r, g, b, a)
        love.graphics.push()
        love.graphics.translate(self.x+(self.width/2), self.y+(self.height/2))
        love.graphics.scale(self.sx, self.sy)
        love.graphics.draw(self.rectangleCanvas, (-self.width/2)+x, (-self.height/2)+y, rotation, sx, sy, ox, oy, kx, ky)
        love.graphics.pop()
}
//Used each update frame to update the rectangle
//Param dt: deltaTime passed from love.update or GUI instance
//Param x: current x position of the mouse, should be -1 if mouse is not currently available
//Param y: current y position of the mouse, should be -1 if mouse is not currently available

method rectangle::updateRectangle(dt, x, y) {
    if (self.clickFunctions && x>=self.x && x<=(self.x+self.width) && y>=self.y && y<=(self.y+self.height)) {
        if !self.tween {
            self.tween=flux.to(self, 0.5, {sx=1.2, sy=1.2})
        }
    } elseif (self.tween) {
        self.tween::stop()
        self.tween=nil
        self.sx=1
        self.sy=1
    }
}
//Used by class library to ensure klass has included the drawable mixin.
method rectangle::included(klass) {
    klass::include(active)
    klass::include(drawable)
}

return rectangle