local hover={}

method hover::initHover(x, y, width, height) {
    self.x=x
    self.y=y
    self.width=width
    self.height=height
}

method hover::containsPoint(x, y) {
    if !x || !y { return false}
    point={x=x, y=y}
    return point.x>=self.x && point.x<=self.x+self.width && point.y>=self.y && point.y<=self.y+self.height
}

return hover