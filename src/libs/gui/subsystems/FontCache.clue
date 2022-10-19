//Used to cache fonts to avoid doubling up on identical fonts
local fontCache={}
fontCache[12]=love.graphics.newFont(12)
fontCache[14]=love.graphics.newFont(14)
local backgroundColor={0.2, 0.2, 0.2, 1}
//Gets a font based on font-size.
//If not already found in the cache, creates and adds the fonts to the cache before returning the font.
//If found in the cache, simply return font from the cache.
method fontCache::getFont(num) {

    if (!fontCache[num]) {
        fontCache[num]=love.graphics.newFont(num)

    }
    return fontCache[num]
}
reurn fontCache