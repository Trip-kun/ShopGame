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

return button