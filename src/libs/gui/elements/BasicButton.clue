local Class = require("libs.class")
local BasicButton = Class("BasicButton")
local button = import("libs.gui.mixins.Button")
local drawable = import("libs.gui.mixins.Drawable")
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

return BasicButton