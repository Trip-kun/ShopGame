//IMPORTS OF RELEVANT LIBRARIES
local flux = require("libs.flux")
local dump=require("libs.dump")
local Class = require("libs.class")
local mathExtensions = import("libs.Math")
//Used to cache fonts to avoid doubling up on identical fonts

//import math extensions into the global lua math library
for k, v of mathExtensions {
    math[k]=v
}


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

local fn click(x, y, button) {
if button==1 {
    table.insert(clickCache, math.Point2D(x, y))
}

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