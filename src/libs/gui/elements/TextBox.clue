local TextBox = Class("TextBox")
TextBox::include(text)
TextBox::include(rectangle)
method TextBox::draw(x, y, r, sx, sy, ox, oy, kx, ky) {
    drawable.draw(self, x, y, r, sx, sy, ox, oy, kx, ky)
    self::drawRectangle(x, y, r, sx, sy, ox, oy, kx, ky)
    self::drawText(x, y, r, sx, sy, ox, oy, kx, ky)
}
//A simple TextBox Using a Rectangle background.
//Param x: x position the internal drawable element should be drawn at.
//Param y: y position the internal drawable element should be drawn at.
//Param color: the color to draw this element's background with: in the form {red, green, blue, alpha} see love (Color)
//Param width: The width to create the canvas
//Param height: The height to create the canvas
//Will be rounded to the nearest multiple of the Font's height for the purpose of cutting off the text at the bottom.
//Param fontsize: integer representing the font size to be used for the Text's font.
//Param text: initial string value for the text
//Param align: initial align mode for the text, see (love) Al

method TextBox::initialize(x, y, color, width, height, fontsize, text, align) {
   self::initRectangle(x, y, color, width, height)
   self::initText(fontsize, width, height, text, align)
}
method TextBox::update(dt, x, y) {
    self::updateRectangle(dt, x, y)
}

return TextBox