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
return active