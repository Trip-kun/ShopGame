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

return BasicDrawable