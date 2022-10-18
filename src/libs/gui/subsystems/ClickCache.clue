//Used to allow multiple sources to use data from a click (sourced from love.mousereleased)
//Cleared at the end of every love.update
//Data is stored in the form of clickCache[index]={x=x, y=y}
local clickCache={}


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
local out = {}
out.click=click
out.clear = fn () {clickCache={}}

return out