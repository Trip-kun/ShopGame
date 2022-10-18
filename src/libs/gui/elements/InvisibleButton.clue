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

return InvisibleButton