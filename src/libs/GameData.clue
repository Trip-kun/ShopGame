//IMPORTS OF RELEVANT LIBRARIES
local TileMap = import("libs.TileMap")
local Tile = import("libs.tile")
local log = import("libs.log")
local dump = require("libs.dump")

//GameData contains most of the data required for the game to run.
//Data is generally contained in the sturcture::
//GameData is the root of the structure
//GameData.Prefix (eg. GameData.Default) allows for multiple sources (e.g. mods) to add the same named data without conflicts
//GameData.Prefix.DataType (eg. GameData.Default.Items) allows for separating different types of data.
//GameData.Prefix.DataType.DataName (eg. GameData.Default.Items.BasicSword) allows for data to be fetched by name


local GameData={}
GameData.Default={}
GameData.Default.Items={}
GameData.Default.Items.BasicSword={}
GameData.Default.Items.BasicSword.damage=5
GameData.Default.Items.BasicSword.name_en="Basic Sword"
GameData.Default.Items.BasicSword.type="Weapon"
GameData.Default.Items.Emerald={}
GameData.Default.Items.Emerald.name_en="Emerald"
GameData.Default.Items.Emerald.type="Item"
GameData.Default.Tiles={}
GameData.Default.Images={}
GameData.Default.Images.DefaultTileset=love.graphics.newImage("assets/Tileset.png")
//Function used to easily generate quads for a 24x24-tile based tileset
local fn generateQuad24X(x, y, tileset) {
    return love.graphics.newQuad(1+((x-1)*25), 1+((y-1)*25), 24, 24, tileset)

}
GameData.Default.TileMaps={}
//Most if not all data should be loaded in separate files
import("assets.DefaultTileset")(GameData)

GameData['Default']['TileMaps']['DefaultTileMap']=TileMap::new(5,5)
GameData['Default']['TileMaps']['DefaultTileMap'].name='DefaultTileMap'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][1]=Tile::new()
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][1]['id']='Dirt'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][1]['prefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][1]['type']='Basic_Tile'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][1]['tileset']='DefaultTileset'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][1]['tilesetPrefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][2]=Tile::new()
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][2]['id']='Dirt'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][2]['prefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][2]['type']='Basic_Tile'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][2]['tileset']='DefaultTileset'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][2]['tilesetPrefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][3]=Tile::new()
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][3]['id']='Dirt'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][3]['prefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][3]['type']='Basic_Tile'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][3]['tileset']='DefaultTileset'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][3]['tilesetPrefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][4]=Tile::new()
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][4]['id']='Dirt'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][4]['prefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][4]['type']='Basic_Tile'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][4]['tileset']='DefaultTileset'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][4]['tilesetPrefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][5]=Tile::new()
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][5]['id']='Dirt'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][5]['prefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][5]['type']='Basic_Tile'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][5]['tileset']='DefaultTileset'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][1][5]['tilesetPrefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][1]=Tile::new()
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][1]['id']='Dirt'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][1]['prefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][1]['type']='Basic_Tile'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][1]['tileset']='DefaultTileset'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][1]['tilesetPrefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][2]=Tile::new()
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][2]['id']='DirtULGrassDR'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][2]['prefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][2]['type']='Basic_Tile'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][2]['tileset']='DefaultTileset'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][2]['tilesetPrefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][3]=Tile::new()
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][3]['id']='DirtLGrassR'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][3]['prefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][3]['type']='Basic_Tile'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][3]['tileset']='DefaultTileset'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][3]['tilesetPrefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][4]=Tile::new()
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][4]['id']='DirtDLGrassUR'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][4]['prefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][4]['type']='Basic_Tile'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][4]['tileset']='DefaultTileset'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][4]['tilesetPrefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][5]=Tile::new()
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][5]['id']='Dirt'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][5]['prefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][5]['type']='Basic_Tile'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][5]['tileset']='DefaultTileset'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][2][5]['tilesetPrefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][1]=Tile::new()
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][1]['id']='Dirt'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][1]['prefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][1]['type']='Basic_Tile'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][1]['tileset']='DefaultTileset'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][1]['tilesetPrefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][2]=Tile::new()
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][2]['id']='DirtUGrassD'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][2]['prefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][2]['type']='Basic_Tile'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][2]['tileset']='DefaultTileset'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][2]['tilesetPrefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][3]=Tile::new()
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][3]['id']='Grass'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][3]['prefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][3]['type']='Basic_Tile'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][3]['tileset']='DefaultTileset'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][3]['tilesetPrefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][4]=Tile::new()
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][4]['id']='DirtDGrassU'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][4]['prefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][4]['type']='Basic_Tile'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][4]['tileset']='DefaultTileset'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][4]['tilesetPrefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][5]=Tile::new()
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][5]['id']='Dirt'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][5]['prefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][5]['type']='Basic_Tile'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][5]['tileset']='DefaultTileset'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][3][5]['tilesetPrefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][1]=Tile::new()
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][1]['id']='Dirt'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][1]['prefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][1]['type']='Basic_Tile'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][1]['tileset']='DefaultTileset'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][1]['tilesetPrefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][2]=Tile::new()
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][2]['id']='DirtURGrassDL'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][2]['prefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][2]['type']='Basic_Tile'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][2]['tileset']='DefaultTileset'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][2]['tilesetPrefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][3]=Tile::new()
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][3]['id']='DirtRGrassL'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][3]['prefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][3]['type']='Basic_Tile'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][3]['tileset']='DefaultTileset'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][3]['tilesetPrefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][4]=Tile::new()
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][4]['id']='DirtDRGrassUL'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][4]['prefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][4]['type']='Basic_Tile'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][4]['tileset']='DefaultTileset'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][4]['tilesetPrefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][5]=Tile::new()
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][5]['id']='Dirt'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][5]['prefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][5]['type']='Basic_Tile'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][5]['tileset']='DefaultTileset'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][4][5]['tilesetPrefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][1]=Tile::new()
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][1]['id']='Dirt'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][1]['prefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][1]['type']='Basic_Tile'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][1]['tileset']='DefaultTileset'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][1]['tilesetPrefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][2]=Tile::new()
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][2]['id']='Dirt'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][2]['prefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][2]['type']='Basic_Tile'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][2]['tileset']='DefaultTileset'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][2]['tilesetPrefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][3]=Tile::new()
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][3]['id']='Dirt'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][3]['prefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][3]['type']='Basic_Tile'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][3]['tileset']='DefaultTileset'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][3]['tilesetPrefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][4]=Tile::new()
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][4]['id']='Dirt'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][4]['prefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][4]['type']='Basic_Tile'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][4]['tileset']='DefaultTileset'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][4]['tilesetPrefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][5]=Tile::new()
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][5]['id']='Dirt'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][5]['prefix']='Default'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][5]['type']='Basic_Tile'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][5]['tileset']='DefaultTileset'
GameData['Default']['TileMaps']['DefaultTileMap']['data'][5][5]['tilesetPrefix']='Default'

//Return GameData to source requiring this file.
return GameData