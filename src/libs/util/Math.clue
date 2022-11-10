local Class = require("libs.class")
local Point2D = Class("Point2D")
local Vector2D = Class("Vector2D")
Point2D.__eq = fn (point1, point2) {
    return point1.x==point2.x && point1.y==point2.y

}

Point2D.__tostring=fn (point) {
    return "2D Point: {" .. point.x .. ", " .. point.y .. "}"

}

method Point2D::initialize(x, y) {
    self.x=x
    self.y=y
}

Vector2D.__eq = fn (vector1, vector2) {
    return vector1.x==vector2.x && vector1.y==vector2.y

}

Vector2D.__tostring=fn (vector) {
    return "2D Vector: {X " .. vector.x .. ", Y " .. vector.y .. ", Angle (Radians) " ..   vector::getAngle()   .. ", MAGNITUDE " .. vector::getMagnitude() .. "}"

}

method Vector2D::getMagnitude() {
    return  ( ( (self.x^2) + (self.y^2) )^0.5 )
}

method Vector2D::getAngle() {
    return math.atan2(self.y, self.x)


}
//x, y, mode
//theta, magnitude
method Vector2D::initialize(x, y, mode) {
    if (mode=="Polar") {
        self.x=math.cos(x)*y
        self.y=math.sin(x)*y
    } else {


        self.x=x
        self.y=y
    }
}

method Vector2D::apply(vector) {
    return Vector2D(self.x+vector.x, self.y+vector.y)


}
method Vector2D.fromPoint(point) {
    return Vector2D(point.x, point.y)


}
method Vector2D::multiply(vector) {
    return Vector2D(self.x*vector.x, self.y*vector.y)



}
method Vector2D::toPoint() {
    return Point2D.fromVector(self)


}



method Point2D::distanceToPoint(point) {
    return ((self.x-point.x)^2+(self.y-point.y)^2)^ 0.5


}
method Point2D::toVector() {
    return Vector2D.fromPoint(self)

}
method Point2D.fromVector(vector) {
    return Point2D(vector.x, vector.y)

}
method Point2D::rotate( rotation, centerPoint) {
    centerPoint = centerPoint  Point2D(0, 0)
    local newX= ((self.x-centerPoint.x)*math.cos(rotation) - (self.y - centerPoint.y)*math.sin(rotation)) + centerPoint.x
    local newY= ((self.x-centerPoint.x)*math.sin(rotation) + (self.y - centerPoint.y)*math.cos(rotation)) + centerPoint.y
    return Point2D(newX, newY)
}

method Point2D::translate(vector) {
    return Point2D(self.x+vector.x, self.y+vector.y)


}
local negativeVector = Vector2D(-1, -1)
method Point2D::scale(scaleVector, centerVector) {
    return self::toVector()::apply(centerVector::multiply(negativeVector))::multiply(scaleVector)::apply(centerVector)::toPoint()



}

local out = {}
out.Point2D=Point2D
out.Vector2D=Vector2D
return out