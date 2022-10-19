//IMPORTS OF RELEVANT LIBRARIES
















local out = {}
/*
out.GUI=GUI

out.click=click

out.BasicButton=BasicButton

out.BasicDrawable=BasicDrawable

out.InvisibleButton=InvisibleButton
out.BasicTileMap=BasicTileMap
out.TextBox = TextBox
out.TextBoxButton=TextBoxButton
out.clickCache=clickCache
//Used to clear the click Cache at the end of every love.update
method GUI::clean() {
    clickCache={}
    out.clickCache=clickCache
}
*/

out.register= fn (name, class) {
    out[name]=class
}
return out