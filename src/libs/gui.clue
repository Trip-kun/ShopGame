//IMPORTS OF RELEVANT LIBRARIES
local flux = require("libs.flux")
local dump=require("libs.dump")
local Class = require("libs.class")
local mathExtensions = import("libs.Math")
//Used to cache fonts to avoid doubling up on identical fonts
local fontCache={}
fontCache[12]=love.graphics.newFont(12)
fontCache[14]=love.graphics.newFont(14)
local backgroundColor={0.2, 0.2, 0.2, 1}
//Gets a font based on font-size.
//If not already found in the cache, creates and adds the fonts to the cache before returning the font.
//If found in the cache, simply return font from the cache.
method fontCache::getFont(num) {

    if (!fontCache[num]) {
        fontCache[num]=love.graphics.newFont(num)

    }
    return fontCache[num]
}
//import math extensions into the global lua math library
for k, v of mathExtensions {
    math[k]=v
}
//Used to allow multiple sources to use data from a click (sourced from love.mousereleased)
//Cleared at the end of every love.update
//Data is stored in the form of clickCache[index]={x=x, y=y}
local clickCache={}

//GUI is a user interface holder class, designed for several purposes.
//1. Manage and update the click cache
//2. Set the background color without interfering with PUSH library
//3. Manage several GUI elements, updating and drawing them as a group
local GUI = Class("GUI")

//Method called upon GUI() or GUI::new()
method GUI::initialize() {
    self.children={}
}
//Used to add a GUI element to an instance of GUI
method GUI::add(child) {
    table.insert(self.children, child)
}
//Used each frame to draw the background color.
method GUI::background() {
        //Backup existing graphics color
        local oldColor={love.graphics.getColor()}
        //Change color to background color
        love.graphics.setColor(backgroundColor)
        //Draw background color using a "fill" rectangle
        love.graphics.rectangle("fill", 0, 0, 1920, 1080)
        //Restore existing graphics color
        love.graphics.setColor(oldColor)
}
//Used each frame to draw the child GUI elements
method GUI::draw(x, y, r, sx, sy, ox, oy, kx, ky) {
    for _, v in self.children {
        if v.draw {
            v::draw(x, y, r, sx, sy, ox, oy, kx, ky)
        }
    }
}
//Used each update frame to update the child GUI elements
//Param dt: deltaTime passed from love.update
//Param x: current x position of the mouse, should be -1 if mouse is not currently available
//Param y: current y position of the mouse, should be -1 if mouse is not currently available
method GUI::update(dt, x, y) {
    flux.update(dt)
    for _, v in self.children {
            if v.update {
                v::update(dt, x, y)
            }
        }
}
//TODO: Update to support responding to different mouse buttons
//Used to insert into the clickCache
//Param x: current x position of the mouse. Should not be called if mouse is not currently available
//Param y: current y position of the mouse. Should not be called if mouse is not currently available
//Param button: Mouse button index (e.g. 1=leftMouseButton). Only will respond if button=1.

local fn click(x, y, button) {
if button==1 {
    table.insert(clickCache, math.Point2D(x, y))
}

}




//Represents a GUI element with an internal (love) Drawable element.
local drawable={}
//Should be called within an implementing class's init function
//Should NOT be called within an implementing class's init function if used by another mixin
//Param x: x position the internal drawable element should be drawn at.
//Param y: y position the internal drawable element should be drawn at.
//Param canvas (bool==true and canvas==true): an internal canvas will be created based off of the width and height parameters
//Param canvas (bool==false || (bool==true && canvas==false): the drawable will be set the the value of canvas
//Param width: The width to create the canvas
//Param height: The height to create the canvas
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
//Used to draw the internal drawable.
//Param x: Will take precedence over the internal x value. Will not overwrite internal value though.
//Param y: Will take precedence over the internal y value. Will not overwrite internal value though.
method drawable::draw(x, y, r, sx, sy, ox, oy, kx, ky) {
    x=x || self.x
    y=y || self.y
    love.graphics.draw(self.drawable, x, y, r, sx, sy, ox, oy, kx, ky)
}
//Represents a text object that can be drawn to the screen.
//The text can be updated to new values.
//The text can have its own font size and alignment mode
local text={}
//Should be called within an implementing class's init function
//Param fontsize: integer representing the font size to be used for the Text's font.
//Param width: The width limit of the text
//Param height: The height limit of the text.
//Will be rounded to the nearest multiple of the Font's height for the purpose of cutting off the text at the bottom.
//Param text: initial string value for the text
//Param align: initial align mode for the text, see (love) AlignMode
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
//Used to draw the text.
//Should be used within the implementing class's draw function
//Should be used AFTER most other draw functions within the Class
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
//Used to update the string used within the text
method text::updateText(text) {
    self.text::setf(text, self.width-(20*2), self.align)
}


//Simple mixin used to add a universal active value for a GUI element.
local active={}
//Sets internal active value
method active::setActive(bool) {
    self.active=bool
}
//Returns internal active value
method active::getActive() {
    return self.active
}
//A Simple Universal Background for UI elements
local rectangle={}
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
//Internal, Invisible on it's own UI mixin to allow an element to be clicked and emit onClick functions.
local button={}
//Should be called within an implementing class's init function
//Param x: x position the internal drawable element should be drawn at.
//Param y: y position the internal drawable element should be drawn at.
//Param active: whether this button is active. Can be disabled to disable click reactions
//Param width: The width to create the canvas
//Param height: The height to create the canvas
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
//Used by class library to ensure klass has included the active mixin.
method button::included(klass) {
    klass::include(active)


}
//Used each update frame to update the rectangle
//Param dt: deltaTime passed from love.update or GUI instance
method button::update(dt) {
    if self::getActive() {
        for _, point in clickCache {
            if (point.x>=self.upperLeft.x && point.x<=self.bottomRight.x && point.y>=self.upperLeft.y && point.y<=self.bottomRight.y) {
                for _, v in self.clickFunctions {
                    v(self)
                }
            }
        }
    }

}
//Used to register a callback function that will be called upon each click when active.
method button::onClick(func) {
    table.insert(self.clickFunctions, func)
}

local InvisibleButton = Class("InvisibleButton")

InvisibleButton::include(button)
//Used whenever a button needs to be implemented with no visible UI
//Param x: x position the internal drawable element should be drawn at.
//Param y: y position the internal drawable element should be drawn at.
//Param active: whether this button is active. Can be disabled to disable click reactions
//Param width: The width to create the canvas
//Param height: The height to create the canvas
method InvisibleButton::initialize(x, y, active, width, height) {
    self::initButton(x, y, active, width, height)

}

local BasicButton = Class("BasicButton")

BasicButton::include(button)

BasicButton::include(drawable)
//A simple, crude combination of a drawable and a button. Will draw whatever is used via canvas parameter.
//Param x: x position the internal drawable element should be drawn at.
//Param y: y position the internal drawable element should be drawn at.
//Param active: whether this button is active. Can be disabled to disable click reactions
//Param width: The width to create the canvas
//Param height: The height to create the canvas
//Param canvas (bool==true and canvas==true): an internal canvas will be created based off of the width and height parameters
//Param canvas (bool==false || (bool==true && canvas==false): the drawable will be set the the value of canvas
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
//A simple TextBox Using a Rectangle background.
//Param x: x position the internal drawable element should be drawn at.
//Param y: y position the internal drawable element should be drawn at.
//Param color: the color to draw this element's background with: in the form {red, green, blue, alpha} see love (Color)
//Param width: The width to create the canvas
//Param height: The height to create the canvas
//Will be rounded to the nearest multiple of the Font's height for the purpose of cutting off the text at the bottom.
//Param fontsize: integer representing the font size to be used for the Text's font.
//Param text: initial string value for the text
//Param align: initial align mode for the text, see (love) Al

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
//A simple TextBox Using a Rectangle background with a button attached.
//Param x: x position the internal drawable element should be drawn at.
//Param y: y position the internal drawable element should be drawn at.
//Param color: the color to draw this element's background with: in the form {red, green, blue, alpha} see love (Color)
//Param width: The width to create the canvas
//Param height: The height to create the canvas
//Will be rounded to the nearest multiple of the Font's height for the purpose of cutting off the text at the bottom.
//Param fontsize: integer representing the font size to be used for the Text's font.
//Param text: initial string value for the text
//Param active: whether this button is active. Can be disabled to disable click reactions
//Param align: initial align mode for the text, see (love) Al

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
//Literally just a wrapper over Drawable. See (gui) drawable mixin for more info
//Param x: x position the internal drawable element should be drawn at.
//Param y: y position the internal drawable element should be drawn at.
//Param canvas (bool==true and canvas==true): an internal canvas will be created based off of the width and height parameters
//Param canvas (bool==false || (bool==true && canvas==false): the drawable will be set the the value of canvas
//Param width: The width to create the canvas
//Param height: The height to create the canvas
method BasicDrawable::initialize(x, y, canvas, width, height) {

    self::initDrawable(x, y, canvas, width, height)

}

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
                    if  ( self.map.mouse.x>=(self.sx*(x-1)*24)+self.rx && self.map.mouse.x<=((x*24)*self.sx)+self.rx && self.map.mouse.y>=(y-1)*self.sy*24+self.ry && self.map.mouse.y<=((y)*self.sy*24)+self.ry) {
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
                        self.map.data[x][y].rect=true
                        self.map.data[x][y].tween=flux.to(self.map.data[x][y], 0.5, {sx=1.2, sy=1.2})
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
            love.graphics.draw(self.map.data[x][y]::getTileset(), self.map.data[x][y]::getQuad(), -12*sx, -12*sx, r, sx, sy, ox, oy, kx, ky)
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
    love.graphics.scale(self.map.data[x][y].sx, self.map.data[x][y].sy)
    love.graphics.draw(self.map.data[x][y]::getTileset(), self.map.data[x][y]::getQuad(), -12*sx, -12*sx, r, sx, sy, ox, oy, kx, ky)
        love.graphics.rectangle("line", -12*sx, -12*sx, 24*sx, 24*sx)
    love.graphics.pop()
    }
}
method TileMapMixin::onClick(func) {
    table.insert(self.clickFunctions, func)
}


local BasicTileMap = Class("BasicTileMap")

BasicTileMap::include(TileMapMixin)
//A simple implementation of a TileMap. See (gui) TileMapMixin for more info
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



local out = {}

out.GUI=GUI

out.click=click

out.BasicButton=BasicButton

out.BasicDrawable=BasicDrawable

out.InvisibleButton=InvisibleButton
out.BasicTileMap=BasicTileMap
out.TextBox = TextBox
out.TextBoxButton=TextBoxButton
out.clickCache=clickCache
//Used to clear the click Cache at the end of every love.update
method GUI::clean() {
    clickCache={}
    out.clickCache=clickCache
}
return out