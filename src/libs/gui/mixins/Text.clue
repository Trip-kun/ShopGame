//Represents a text object that can be drawn to the screen.
//The text can be updated to new values.
//The text can have its own font size and alignment mode
local text={}
//Should be called within an implementing class's init function
//Param fontsize: integer representing the font size to be used for the Text's font.
//Param width: The width limit of the text
//Param height: The height limit of the text.
//Will be rounded to the nearest multiple of the Font's height for the purpose of cutting off the text at the bottom.
//Param text: initial string value for the text
//Param align: initial align mode for the text, see (love) AlignMode
local fontCache = import("libs.gui.subsystems.FontCache")
method text::initText(fontsize, width, height, text, align) {
    self.fontsize=fontsize
    self.align=align || "left"
    self.width=width
    self.height=height
    self.font=fontCache::getFont(fontsize)
    self.text=love.graphics.newText(self.font)
    self.textCanvas=love.graphics.newCanvas(self.width-(20*2), math.floor((self.height-(20*2))/self.font::getHeight())*self.font::getHeight())
    self.text::setf(text, width-(20*2), self.align)
}
//Used to draw the text.
//Should be used within the implementing class's draw function
//Should be used AFTER most other draw functions within the Class
method text::drawText(x, y, r, sx, sy, ox, oy, kx, ky) {
    x=x || 0
    y=y || 0
    local oldCanvas = love.graphics.getCanvas()
love.graphics.setCanvas(self.textCanvas)
    love.graphics.clear()
    local a, b, c, d = love.graphics.getScissor()
    love.graphics.setScissor(0, 0, self.width-(20*2), math.floor((self.height-(20*2))/self.font::getHeight())*self.font::getHeight())
    love.graphics.draw(self.text)

     love.graphics.setScissor(a, b, c, d)
    love.graphics.setCanvas(oldCanvas)
    love.graphics.push()
              love.graphics.translate(self.x+x+20 + (self.width-(20*2))/2, self.y+y+20 + (math.floor((self.height-(20*2))/self.font::getHeight())*self.font::getHeight())/2)
                love.graphics.scale(self.sx, self.sy)
        love.graphics.draw(self.textCanvas, -(self.width-(20*2))/2 , -(math.floor((self.height-(20*2))/self.font::getHeight())*self.font::getHeight())/2, r, sx, sy, ox, oy, kx, ky)
    //love.graphics.draw(self.textCanvas, self.x+x+20, self.y+y+20, r, sx, sy, ox, oy, kx, ky)
    love.graphics.pop()
}
//Used to update the string used within the text
method text::updateText(text) {
    self.text::setf(text, self.width-(20*2), self.align)
}


return text