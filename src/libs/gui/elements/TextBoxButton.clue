local TextBoxButton = Class("TextBoxButton")
TextBoxButton::include(button)
TextBoxButton::include(text)
TextBoxButton::include(rectangle)
method TextBoxButton::draw(x, y, r, sx, sy, ox, oy, kx, ky) {
    drawable.draw(self, x, y, r, sx, sy, ox, oy, kx, ky)
    self::drawRectangle(x, y, r, sx, sy, ox, oy, kx, ky)
    self::drawText(x, y, r, sx, sy, ox, oy, kx, ky)
}
//A simple TextBox Using a Rectangle background with a button attached.
//Param x: x position the internal drawable element should be drawn at.
//Param y: y position the internal drawable element should be drawn at.
//Param color: the color to draw this element's background with: in the form {red, green, blue, alpha} see love (Color)
//Param width: The width to create the canvas
//Param height: The height to create the canvas
//Will be rounded to the nearest multiple of the Font's height for the purpose of cutting off the text at the bottom.
//Param fontsize: integer representing the font size to be used for the Text's font.
//Param text: initial string value for the text
//Param active: whether this button is active. Can be disabled to disable click reactions
//Param align: initial align mode for the text, see (love) Al

method TextBoxButton::initialize(x, y, color, width, height, fontsize, text, active, align) {
    self::initButton(x, y, active, width, height)
   self::initRectangle(x, y, color, width, height)
   self::initText(fontsize, width, height, text, align)
}
method TextBoxButton::update(dt, x, y) {
    button.update(self, dt)
    self::updateRectangle(dt, x, y)
}

return TextBoxButton