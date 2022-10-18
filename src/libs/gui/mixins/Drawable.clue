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
return drawable