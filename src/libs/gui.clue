local flux = require("libs.flux")
local dump=require("libs.dump")
local Class = require("libs.class")
local mathExtensions = import("libs.Math")
local fontCache={}
fontCache[12]=love.graphics.newFont(12)
fontCache[14]=love.graphics.newFont(14)
local backgroundColor={0.2, 0.2, 0.2, 1}
method fontCache::getFont(num) {

    if (!fontCache[num]) {
        fontCache[num]=love.graphics.newFont(num)

    }
    return fontCache[num]
}
for k, v of mathExtensions {
    math[k]=v
}

local buttonCache={}

local GUI = Class("GUI")

method GUI::initialize() {
    self.children={}
}

method GUI::add(child) {
    table.insert(self.children, child)
}

method GUI::draw(x, y, r, sx, sy, ox, oy, kx, ky) {
    local oldColor={love.graphics.getColor()}
    love.graphics.setColor(backgroundColor)
    love.graphics.rectangle("fill", 0, 0, 1920, 1080)
    love.graphics.setColor(oldColor)
    for _, v in self.children {
        if v.draw {
            v::draw(x, y, r, sx, sy, ox, oy, kx, ky)
        }
    }
}

method GUI::update(dt, x, y) {
    flux.update(dt)
    for _, v in self.children {
            if v.update {
                v::update(dt, x, y)
            }
        }
}

local fn click(x, y, button) {
if button==1 {
    table.insert(buttonCache, math.Point2D(x, y))
}

}

method GUI::clean() {
    buttonCache={}
}



local drawable={}

method drawable::initDrawable(x, y, canvas, width, height) {
    self.x=x
    self.y=y
    self.width=width
    self.height=height
    if type(canvas)=="boolean" && canvas {

        self.drawable=love.graphics.newCanvas(width, height)
    } else {
        self.drawable=canvas
    }
}

method drawable::draw(x, y, r, sx, sy, ox, oy, kx, ky) {
    x=x || self.x
    y=y || self.y
    love.graphics.draw(self.drawable, x, y, r, sx, sy, ox, oy, kx, ky)
}

local text={}
method text::initText(fontsize, width, height, text, align) {
    self.fontsize=fontsize
    self.align=align || "left"
    self.width=width
    self.height=height
    self.font=fontCache::getFont(fontsize)
    self.text=love.graphics.newText(self.font)
    self.textCanvas=love.graphics.newCanvas(self.width-(20*2), math.floor((self.height-(20*2))/self.font::getHeight())*self.font::getHeight())
    self.text::setf(text, width-(20*2), self.align)
}
method text::drawText(x, y, r, sx, sy, ox, oy, kx, ky) {
    x=x || 0
    y=y || 0
    local oldCanvas = love.graphics.getCanvas()
love.graphics.setCanvas(self.textCanvas)
    love.graphics.clear()
    local a, b, c, d = love.graphics.getScissor()
    love.graphics.setScissor(0, 0, self.width-(20*2), math.floor((self.height-(20*2))/self.font::getHeight())*self.font::getHeight())
    love.graphics.draw(self.text)

     love.graphics.setScissor(a, b, c, d)
    love.graphics.setCanvas(oldCanvas)
    love.graphics.push()
              love.graphics.translate(self.x+x+20 + (self.width-(20*2))/2, self.y+y+20 + (math.floor((self.height-(20*2))/self.font::getHeight())*self.font::getHeight())/2)
                love.graphics.scale(self.sx, self.sy)
        love.graphics.draw(self.textCanvas, -(self.width-(20*2))/2 , -(math.floor((self.height-(20*2))/self.font::getHeight())*self.font::getHeight())/2, r, sx, sy, ox, oy, kx, ky)
    //love.graphics.draw(self.textCanvas, self.x+x+20, self.y+y+20, r, sx, sy, ox, oy, kx, ky)
    love.graphics.pop()
}
method text::drawText2(x, y, r, sx, sy, ox, oy, kx, ky) {
    x=x || 0
    y=y || 0
    self.sx=self.sx || 1
    self.sy=self.sy || 1
     local a, b, c, d = love.graphics.getScissor()
     love.graphics.push()
            love.graphics.translate(self.x+x+20 + (self.width-(20*2))/2, self.y+y+20 + (math.floor((self.height-(20*2))/self.font::getHeight())*self.font::getHeight())/2)
            love.graphics.scale(self.sx, self.sy)

    love.graphics.setScissor(self.x+x+20, self.y+y+20, self.width-(20*2), math.floor((self.height-(20*2))/self.font::getHeight())*self.font::getHeight())
    love.graphics.draw(self.text, -(self.width-(20*2))/2 , -(math.floor((self.height-(20*2))/self.font::getHeight())*self.font::getHeight())/2, r, sx, sy, ox, oy, kx, ky)
    love.graphics.pop()
     love.graphics.setScissor(a, b, c, d)
}
method text::updateText(text) {
    self.text::setf(text, self.width-(20*2), self.align)
}
local active={}

method active::setActive(bool) {
    self.active=bool
}

method active::getActive() {
    return self.active
}

local rectangle={}
method rectangle::initRectangle(x, y, color, width, height) {
    self::initDrawable(x, y, true, width, height)
    self.rectangleCanvas=love.graphics.newCanvas(width, height)
    self.color=color
    self.sx=1
    self.sy=1
    self.tween=nil
    self.hovered=false
}
method rectangle::drawRectangle(x, y, rotation, sx, sy, ox, oy, kx, ky) {
    local x = x || 0
    local y = y || 0
    local sx = sx || 1
    local sy = sy || 1
    local r = r || 0
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
method rectangle::included(klass) {
    klass::include(active)
    klass::include(drawable)
}

local button={}

method button::initButton(x, y, active, width, height) {

    self.x=x
    self.y=y
    self.width=width
    self.height=height
    self.upperLeft=math.Point2D(x, y)
    self.bottomRight=math.Point2D(x+width, y+height)
    self::setActive(active)
    self.clickFunctions={}
}

method button::included(klass) {
    klass::include(active)


}

method button::update(dt) {
    if self::getActive() {
        for _, point in buttonCache {
            if (point.x>=self.upperLeft.x && point.x<=self.bottomRight.x && point.y>=self.upperLeft.y && point.y<=self.bottomRight.y) {
                for _, v in self.clickFunctions {
                    v(self)
                }
            }
        }
    }

}

method button::onClick(func) {
    table.insert(self.clickFunctions, func)
}

local InvisibleButton = Class("InvisibleButton")

InvisibleButton::include(button)

method InvisibleButton::initialize(x, y, active, width, height) {
    self::initButton(x, y, active, width, height)

}

local BasicButton = Class("BasicButton")

BasicButton::include(button)

BasicButton::include(drawable)

method BasicButton::initialize(x, y, active, width, height, canvas) {
    self::initButton(x, y, active, width, height)

    self::initDrawable(x, y, canvas, width, height)

}
local TextBox = Class("TextBox")
TextBox::include(text)
TextBox::include(rectangle)
method TextBox::draw(x, y, r, sx, sy, ox, oy, kx, ky) {
    drawable.draw(self, x, y, r, sx, sy, ox, oy, kx, ky)
    self::drawRectangle(x, y, r, sx, sy, ox, oy, kx, ky)
    self::drawText(x, y, r, sx, sy, ox, oy, kx, ky)
}
method TextBox::initialize(x, y, color, width, height, fontsize, text, align) {
   self::initRectangle(x, y, color, width, height)
   self::initText(fontsize, width, height, text, align)
}
method TextBox::update(dt, x, y) {
    self::updateRectangle(dt, x, y)
}
local TextBoxButton = Class("TextBoxButton")
TextBoxButton::include(button)
TextBoxButton::include(text)
TextBoxButton::include(rectangle)
method TextBoxButton::draw(x, y, r, sx, sy, ox, oy, kx, ky) {
    drawable.draw(self, x, y, r, sx, sy, ox, oy, kx, ky)
    self::drawRectangle(x, y, r, sx, sy, ox, oy, kx, ky)
    self::drawText(x, y, r, sx, sy, ox, oy, kx, ky)
}
method TextBoxButton::initialize(x, y, color, width, height, fontsize, text, active, align) {
    self::initButton(x, y, active, width, height)
   self::initRectangle(x, y, color, width, height)
   self::initText(fontsize, width, height, text, align)
}
method TextBoxButton::update(dt, x, y) {
    button.update(self, dt)
    self::updateRectangle(dt, x, y)
}
local BasicDrawable = Class("BasicDrawable")

BasicDrawable::include(drawable)

method BasicDrawable::initialize(x, y, canvas, width, height) {

    self::initDrawable(x, y, canvas, width, height)

}

local out = {}

out.GUI=GUI

out.click=click

out.BasicButton=BasicButton

out.BasicDrawable=BasicDrawable

out.InvisibleButton=InvisibleButton

out.TextBox = TextBox
out.TextBoxButton=TextBoxButton
return out