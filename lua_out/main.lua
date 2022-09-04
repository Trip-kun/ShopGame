local bit = require("bit");
local import, _modules
do
	local cache = {}
	local nils = {}
	function import(modname)
		if nils[modname] then return end
		local cached = cache[modname]
		if cached ~= nil then return cached end
		cached = _modules[modname]
		if cached ~= nil then
			cached = cached();
			if cached == nil then
				nils[modname] = true
			else
				cache[modname] = cached
			end
			return cached
		end
	end
end
_modules = {
	["assets.DefaultTileset"] = function()
		local function generateQuad24X(x, y, tileset)
			return love.graphics.newQuad(1+((x-1)*25), 1+((y-1)*25), 24, 24, tileset);
		end
		local TileMap = import("libs.TileMap");
		local Tile = import("libs.tile");
		return function(GameData)
			local orderedTable = {			};
			GameData.Default.Tiles.DefaultTileset = setmetatable({			}, {
				__newindex = function(tbl, key, value)
					table.insert(orderedTable, {
						key, 
						value
					});
					rawset(tbl, key, value);
				end
			});
			GameData.Default.Tiles.DefaultTileset.Dirt = generateQuad24X(8, 3, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DirtULGrassDR = generateQuad24X(2, 2, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DirtUGrassD = generateQuad24X(3, 2, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DirtURGrassDL = generateQuad24X(4, 2, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DirtLGrassR = generateQuad24X(2, 3, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DirtRGrassL = generateQuad24X(4, 3, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DirtDLGrassUR = generateQuad24X(2, 4, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DirtDGrassU = generateQuad24X(3, 4, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DirtDRGrassUL = generateQuad24X(4, 4, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DirtULDarkDR = generateQuad24X(2, 7, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DirtUDarkD = generateQuad24X(3, 7, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DirtURDarkDL = generateQuad24X(4, 7, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DirtLDarkR = generateQuad24X(2, 8, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DirtRDarkL = generateQuad24X(4, 8, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DirtDLDarkUR = generateQuad24X(2, 9, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DirtDDarkU = generateQuad24X(3, 9, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DirtDRDarkUL = generateQuad24X(4, 9, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.Dark = generateQuad24X(3, 8, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DarkULGrassDR = generateQuad24X(2, 7+5, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DarkUGrassD = generateQuad24X(3, 7+5, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DarkURGrassDL = generateQuad24X(4, 7+5, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DarkLGrassR = generateQuad24X(2, 8+5, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DarkRGrassL = generateQuad24X(4, 8+5, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DarkDLGrassUR = generateQuad24X(2, 9+5, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DarkDGrassU = generateQuad24X(3, 9+5, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DarkDRGrassUL = generateQuad24X(4, 9+5, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.Grass = generateQuad24X(3, 8+5, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.GrassULDirtDR = generateQuad24X(2+5, 2, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.GrassUDirtD = generateQuad24X(3+5, 2, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.GrassURDirtDL = generateQuad24X(4+5, 2, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.GrassLDirtR = generateQuad24X(2+5, 3, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.GrassRDirtL = generateQuad24X(4+5, 3, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.GrassDLDirtUR = generateQuad24X(2+5, 4, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.GrassDDirtU = generateQuad24X(3+5, 4, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.GrassDRDirtUL = generateQuad24X(4+5, 4, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DarkULDirtDR = generateQuad24X(12-5, 7, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DarkUDirtD = generateQuad24X(13-5, 7, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DarkURDirtDL = generateQuad24X(14-5, 7, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DarkLDirtR = generateQuad24X(12-5, 8, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DarkRDirtL = generateQuad24X(14-5, 8, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DarkDLDirtUR = generateQuad24X(12-5, 9, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DarkDDirtU = generateQuad24X(13-5, 9, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.DarkDRDirtUL = generateQuad24X(14-5, 9, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.GrassULDarkDR = generateQuad24X(2+5, 7+5, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.GrassUDarkD = generateQuad24X(3+5, 7+5, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.GrassURDarkDL = generateQuad24X(4+5, 7+5, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.GrassLDarkR = generateQuad24X(2+5, 8+5, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.GrassRDarkL = generateQuad24X(4+5, 8+5, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.GrassDLDarkUR = generateQuad24X(2+5, 9+5, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.GrassDDarkU = generateQuad24X(3+5, 9+5, GameData.Default.Images.DefaultTileset);
			GameData.Default.Tiles.DefaultTileset.GrassDRDarkUL = generateQuad24X(4+5, 9+5, GameData.Default.Images.DefaultTileset);
			local out = {			};
			for k, v in ipairs(orderedTable) do
				local t = Tile();
				t.sx = 1;
				t.sy = 1;
				t.id = v[(1)];
				t.prefix = "Default";
				t.tileset = "DefaultTileset";
				t.tilesetPrefix = "Default";
				t.type = "Basic_Tile";
				table.insert(out, t);
			end
			GameData.Default.TileMaps.DefaultTileset = TileMap.fromTable(out);
			GameData.Default.TileMaps.DefaultTileset.name = "DefaultTileset";
		end;
	end,
	["conf"] = function()
		return "not_editor";
	end,
	["libs.GameData"] = function()
		local TileMap = import("libs.TileMap");
		local Tile = import("libs.tile");
		local log = import("libs.log");
		local dump = require("libs.dump");
		local GameData = {		};
		GameData.Default = {		};
		GameData.Default.Items = {		};
		GameData.Default.Items.BasicSword = {		};
		GameData.Default.Items.BasicSword.damage = 5;
		GameData.Default.Items.BasicSword.name_en = "Basic Sword";
		GameData.Default.Items.BasicSword.type = "Weapon";
		GameData.Default.Items.Emerald = {		};
		GameData.Default.Items.Emerald.name_en = "Emerald";
		GameData.Default.Items.Emerald.type = "Item";
		GameData.Default.Tiles = {		};
		GameData.Default.Images = {		};
		GameData.Default.Images.DefaultTileset = love.graphics.newImage("assets/Tileset.png");
		local function generateQuad24X(x, y, tileset)
			return love.graphics.newQuad(1+((x-1)*25), 1+((y-1)*25), 24, 24, tileset);
		end
		GameData.Default.TileMaps = {		};
		import("assets.DefaultTileset")(GameData);
		GameData[('Default')][('TileMaps')][('DefaultTileMap')] = TileMap:new(5, 5);
		GameData[('Default')][('TileMaps')][('DefaultTileMap')].name = 'DefaultTileMap';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(1)] = Tile:new();
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(1)][('id')] = 'Dirt';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(1)][('prefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(1)][('type')] = 'Basic_Tile';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(1)][('tileset')] = 'DefaultTileset';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(1)][('tilesetPrefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(2)] = Tile:new();
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(2)][('id')] = 'Dirt';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(2)][('prefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(2)][('type')] = 'Basic_Tile';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(2)][('tileset')] = 'DefaultTileset';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(2)][('tilesetPrefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(3)] = Tile:new();
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(3)][('id')] = 'Dirt';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(3)][('prefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(3)][('type')] = 'Basic_Tile';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(3)][('tileset')] = 'DefaultTileset';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(3)][('tilesetPrefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(4)] = Tile:new();
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(4)][('id')] = 'Dirt';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(4)][('prefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(4)][('type')] = 'Basic_Tile';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(4)][('tileset')] = 'DefaultTileset';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(4)][('tilesetPrefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(5)] = Tile:new();
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(5)][('id')] = 'Dirt';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(5)][('prefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(5)][('type')] = 'Basic_Tile';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(5)][('tileset')] = 'DefaultTileset';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(1)][(5)][('tilesetPrefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(1)] = Tile:new();
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(1)][('id')] = 'Dirt';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(1)][('prefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(1)][('type')] = 'Basic_Tile';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(1)][('tileset')] = 'DefaultTileset';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(1)][('tilesetPrefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(2)] = Tile:new();
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(2)][('id')] = 'DirtULGrassDR';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(2)][('prefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(2)][('type')] = 'Basic_Tile';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(2)][('tileset')] = 'DefaultTileset';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(2)][('tilesetPrefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(3)] = Tile:new();
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(3)][('id')] = 'DirtLGrassR';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(3)][('prefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(3)][('type')] = 'Basic_Tile';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(3)][('tileset')] = 'DefaultTileset';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(3)][('tilesetPrefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(4)] = Tile:new();
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(4)][('id')] = 'DirtDLGrassUR';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(4)][('prefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(4)][('type')] = 'Basic_Tile';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(4)][('tileset')] = 'DefaultTileset';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(4)][('tilesetPrefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(5)] = Tile:new();
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(5)][('id')] = 'Dirt';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(5)][('prefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(5)][('type')] = 'Basic_Tile';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(5)][('tileset')] = 'DefaultTileset';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(2)][(5)][('tilesetPrefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(1)] = Tile:new();
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(1)][('id')] = 'Dirt';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(1)][('prefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(1)][('type')] = 'Basic_Tile';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(1)][('tileset')] = 'DefaultTileset';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(1)][('tilesetPrefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(2)] = Tile:new();
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(2)][('id')] = 'DirtUGrassD';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(2)][('prefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(2)][('type')] = 'Basic_Tile';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(2)][('tileset')] = 'DefaultTileset';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(2)][('tilesetPrefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(3)] = Tile:new();
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(3)][('id')] = 'Grass';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(3)][('prefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(3)][('type')] = 'Basic_Tile';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(3)][('tileset')] = 'DefaultTileset';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(3)][('tilesetPrefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(4)] = Tile:new();
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(4)][('id')] = 'DirtDGrassU';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(4)][('prefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(4)][('type')] = 'Basic_Tile';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(4)][('tileset')] = 'DefaultTileset';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(4)][('tilesetPrefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(5)] = Tile:new();
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(5)][('id')] = 'Dirt';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(5)][('prefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(5)][('type')] = 'Basic_Tile';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(5)][('tileset')] = 'DefaultTileset';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(3)][(5)][('tilesetPrefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(1)] = Tile:new();
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(1)][('id')] = 'Dirt';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(1)][('prefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(1)][('type')] = 'Basic_Tile';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(1)][('tileset')] = 'DefaultTileset';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(1)][('tilesetPrefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(2)] = Tile:new();
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(2)][('id')] = 'DirtURGrassDL';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(2)][('prefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(2)][('type')] = 'Basic_Tile';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(2)][('tileset')] = 'DefaultTileset';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(2)][('tilesetPrefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(3)] = Tile:new();
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(3)][('id')] = 'DirtRGrassL';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(3)][('prefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(3)][('type')] = 'Basic_Tile';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(3)][('tileset')] = 'DefaultTileset';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(3)][('tilesetPrefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(4)] = Tile:new();
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(4)][('id')] = 'DirtDRGrassUL';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(4)][('prefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(4)][('type')] = 'Basic_Tile';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(4)][('tileset')] = 'DefaultTileset';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(4)][('tilesetPrefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(5)] = Tile:new();
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(5)][('id')] = 'Dirt';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(5)][('prefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(5)][('type')] = 'Basic_Tile';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(5)][('tileset')] = 'DefaultTileset';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(4)][(5)][('tilesetPrefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(1)] = Tile:new();
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(1)][('id')] = 'Dirt';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(1)][('prefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(1)][('type')] = 'Basic_Tile';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(1)][('tileset')] = 'DefaultTileset';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(1)][('tilesetPrefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(2)] = Tile:new();
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(2)][('id')] = 'Dirt';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(2)][('prefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(2)][('type')] = 'Basic_Tile';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(2)][('tileset')] = 'DefaultTileset';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(2)][('tilesetPrefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(3)] = Tile:new();
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(3)][('id')] = 'Dirt';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(3)][('prefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(3)][('type')] = 'Basic_Tile';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(3)][('tileset')] = 'DefaultTileset';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(3)][('tilesetPrefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(4)] = Tile:new();
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(4)][('id')] = 'Dirt';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(4)][('prefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(4)][('type')] = 'Basic_Tile';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(4)][('tileset')] = 'DefaultTileset';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(4)][('tilesetPrefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(5)] = Tile:new();
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(5)][('id')] = 'Dirt';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(5)][('prefix')] = 'Default';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(5)][('type')] = 'Basic_Tile';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(5)][('tileset')] = 'DefaultTileset';
		GameData[('Default')][('TileMaps')][('DefaultTileMap')][('data')][(5)][(5)][('tilesetPrefix')] = 'Default';
		return GameData;
	end,
	["libs.gamestate"] = function()
		local gamestate = {		};
		log = import("libs.log");
		local currstate = {
			name = "initialstate"
		};
		function gamestate.switch(state)
			local statename = state.name or "NONAME";
			local currstatename = currstate.name or "NONAME";
			log.custom("GAMESTATE", "Switching To State: "..statename.." from state: "..currstatename);
			if currstate.switchaway then
				currstate.switchaway();
			end
			if state.switchto then
				state.switchto();
			end
			for k, v in pairs(state) do
				if k~='content' and k~='name' and k~='switchaway' and k~='switchto' and k~='quit' then
					love[(k)] = v;
				end
			end
			currstate = state;
		end
		function gamestate.getStateName()
			return currstate.name;
		end
		log.custom("GAMESTATE", "Loaded");
		return gamestate;
	end,
	["libs.gui"] = function()
		local flux = require("libs.flux");
		local dump = require("libs.dump");
		local Class = require("libs.class");
		local mathExtensions = import("libs.Math");
		local fontCache = {		};
		fontCache[(12)] = love.graphics.newFont(12);
		fontCache[(14)] = love.graphics.newFont(14);
		local backgroundColor = {
			0.2, 
			0.2, 
			0.2, 
			1
		};
		function fontCache:getFont(num)
			if (not fontCache[(num)]) then
				fontCache[(num)] = love.graphics.newFont(num);
			end
			return fontCache[(num)];
		end
		for k, v in pairs(mathExtensions) do
			math[(k)] = v;
		end
		local clickCache = {		};
		local GUI = Class("GUI");
		function GUI:initialize()
			self.children = {			};
		end
		function GUI:add(child)
			table.insert(self.children, child);
		end
		function GUI:background()
			local oldColor = {
				love.graphics.getColor()
			};
			love.graphics.setColor(backgroundColor);
			love.graphics.rectangle("fill", 0, 0, 1920, 1080);
			love.graphics.setColor(oldColor);
		end
		function GUI:draw(x, y, r, sx, sy, ox, oy, kx, ky)
			for _, v in ipairs(self.children) do
				if v.draw then
					v:draw(x, y, r, sx, sy, ox, oy, kx, ky);
				end
			end
		end
		function GUI:update(dt, x, y)
			flux.update(dt);
			for _, v in ipairs(self.children) do
				if v.update then
					v:update(dt, x, y);
				end
			end
		end
		local function click(x, y, button)
			if button==1 then
				table.insert(clickCache, math.Point2D(x, y));
			end
		end
		local drawable = {		};
		function drawable:initDrawable(x, y, canvas, width, height)
			self.x = x;
			self.y = y;
			self.width = width;
			self.height = height;
			if type(canvas)=="boolean" and canvas then
				self.drawable = love.graphics.newCanvas(width, height);
			else
				self.drawable = canvas;
			end
		end
		function drawable:draw(x, y, r, sx, sy, ox, oy, kx, ky)
			x = x or self.x;
			y = y or self.y;
			love.graphics.draw(self.drawable, x, y, r, sx, sy, ox, oy, kx, ky);
		end
		local text = {		};
		function text:initText(fontsize, width, height, text, align)
			self.fontsize = fontsize;
			self.align = align or "left";
			self.width = width;
			self.height = height;
			self.font = fontCache:getFont(fontsize);
			self.text = love.graphics.newText(self.font);
			self.textCanvas = love.graphics.newCanvas(self.width-(20*2), math.floor((self.height-(20*2))/self.font:getHeight())*self.font:getHeight());
			self.text:setf(text, width-(20*2), self.align);
		end
		function text:drawText(x, y, r, sx, sy, ox, oy, kx, ky)
			x = x or 0;
			y = y or 0;
			local oldCanvas = love.graphics.getCanvas();
			love.graphics.setCanvas(self.textCanvas);
			love.graphics.clear();
			local a, b, c, d = love.graphics.getScissor();
			love.graphics.setScissor(0, 0, self.width-(20*2), math.floor((self.height-(20*2))/self.font:getHeight())*self.font:getHeight());
			love.graphics.draw(self.text);
			love.graphics.setScissor(a, b, c, d);
			love.graphics.setCanvas(oldCanvas);
			love.graphics.push();
			love.graphics.translate(self.x+x+20+(self.width-(20*2))/2, self.y+y+20+(math.floor((self.height-(20*2))/self.font:getHeight())*self.font:getHeight())/2);
			love.graphics.scale(self.sx, self.sy);
			love.graphics.draw(self.textCanvas, -(self.width-(20*2))/2, -(math.floor((self.height-(20*2))/self.font:getHeight())*self.font:getHeight())/2, r, sx, sy, ox, oy, kx, ky);
			love.graphics.pop();
		end
		function text:updateText(text)
			self.text:setf(text, self.width-(20*2), self.align);
		end
		local active = {		};
		function active:setActive(bool)
			self.active = bool;
		end
		function active:getActive()
			return self.active;
		end
		local rectangle = {		};
		function rectangle:initRectangle(x, y, color, width, height)
			self:initDrawable(x, y, true, width, height);
			self.rectangleCanvas = love.graphics.newCanvas(width, height);
			self.color = color;
			self.sx = 1;
			self.sy = 1;
			self.tween = nil;
			self.hovered = false;
		end
		function rectangle:drawRectangle(x, y, rotation, sx, sy, ox, oy, kx, ky)
			local x = x or 0;
			local y = y or 0;
			local sx = sx or 1;
			local sy = sy or 1;
			local r = r or 0;
			local oldCanvas = love.graphics.getCanvas();
			love.graphics.setCanvas(self.rectangleCanvas);
			local a, b, c, d = love.graphics.getScissor();
			love.graphics.setScissor();
			love.graphics.clear();
			love.graphics.setScissor(a, b, c, d);
			local r, g, b, a = love.graphics.getColor();
			love.graphics.setColor(self.color);
			love.graphics.rectangle("fill", 0, 0, self.width, self.height, 20, 20);
			love.graphics.setColor(self.color[(1)]*0.5, self.color[(2)]*0.5, self.color[(3)]*0.5, self.color[(4)]);
			local oldWidth = love.graphics.getLineWidth();
			love.graphics.setLineWidth(20);
			love.graphics.rectangle("line", 20/2, 20/2, self.width-20, self.height-20, 20*0.45, 20*0.45);
			love.graphics.setLineWidth(oldWidth);
			love.graphics.setCanvas(oldCanvas);
			love.graphics.setColor(r, g, b, a);
			love.graphics.push();
			love.graphics.translate(self.x+(self.width/2), self.y+(self.height/2));
			love.graphics.scale(self.sx, self.sy);
			love.graphics.draw(self.rectangleCanvas, (-self.width/2)+x, (-self.height/2)+y, rotation, sx, sy, ox, oy, kx, ky);
			love.graphics.pop();
		end
		function rectangle:updateRectangle(dt, x, y)
			if (self.clickFunctions and x>=self.x and x<=(self.x+self.width) and y>=self.y and y<=(self.y+self.height)) then
				if not self.tween then
					self.tween = flux.to(self, 0.5, {
						sx = 1.2, 
						sy = 1.2
					});
				end
			elseif (self.tween) then
				self.tween:stop();
				self.tween = nil;
				self.sx = 1;
				self.sy = 1;
			end
		end
		function rectangle:included(klass)
			klass:include(active);
			klass:include(drawable);
		end
		local button = {		};
		function button:initButton(x, y, active, width, height)
			self.x = x;
			self.y = y;
			self.width = width;
			self.height = height;
			self.upperLeft = math.Point2D(x, y);
			self.bottomRight = math.Point2D(x+width, y+height);
			self:setActive(active);
			self.clickFunctions = {			};
		end
		function button:included(klass)
			klass:include(active);
		end
		function button:update(dt)
			if self:getActive() then
				for _, point in ipairs(clickCache) do
					if (point.x>=self.upperLeft.x and point.x<=self.bottomRight.x and point.y>=self.upperLeft.y and point.y<=self.bottomRight.y) then
						for _, v in ipairs(self.clickFunctions) do
							v(self);
						end
					end
				end
			end
		end
		function button:onClick(func)
			table.insert(self.clickFunctions, func);
		end
		local InvisibleButton = Class("InvisibleButton");
		InvisibleButton:include(button);
		function InvisibleButton:initialize(x, y, active, width, height)
			self:initButton(x, y, active, width, height);
		end
		local BasicButton = Class("BasicButton");
		BasicButton:include(button);
		BasicButton:include(drawable);
		function BasicButton:initialize(x, y, active, width, height, canvas)
			self:initButton(x, y, active, width, height);
			self:initDrawable(x, y, canvas, width, height);
		end
		local TextBox = Class("TextBox");
		TextBox:include(text);
		TextBox:include(rectangle);
		function TextBox:draw(x, y, r, sx, sy, ox, oy, kx, ky)
			drawable.draw(self, x, y, r, sx, sy, ox, oy, kx, ky);
			self:drawRectangle(x, y, r, sx, sy, ox, oy, kx, ky);
			self:drawText(x, y, r, sx, sy, ox, oy, kx, ky);
		end
		function TextBox:initialize(x, y, color, width, height, fontsize, text, align)
			self:initRectangle(x, y, color, width, height);
			self:initText(fontsize, width, height, text, align);
		end
		function TextBox:update(dt, x, y)
			self:updateRectangle(dt, x, y);
		end
		local TextBoxButton = Class("TextBoxButton");
		TextBoxButton:include(button);
		TextBoxButton:include(text);
		TextBoxButton:include(rectangle);
		function TextBoxButton:draw(x, y, r, sx, sy, ox, oy, kx, ky)
			drawable.draw(self, x, y, r, sx, sy, ox, oy, kx, ky);
			self:drawRectangle(x, y, r, sx, sy, ox, oy, kx, ky);
			self:drawText(x, y, r, sx, sy, ox, oy, kx, ky);
		end
		function TextBoxButton:initialize(x, y, color, width, height, fontsize, text, active, align)
			self:initButton(x, y, active, width, height);
			self:initRectangle(x, y, color, width, height);
			self:initText(fontsize, width, height, text, align);
		end
		function TextBoxButton:update(dt, x, y)
			button.update(self, dt);
			self:updateRectangle(dt, x, y);
		end
		local BasicDrawable = Class("BasicDrawable");
		BasicDrawable:include(drawable);
		function BasicDrawable:initialize(x, y, canvas, width, height)
			self:initDrawable(x, y, canvas, width, height);
		end
		local out = {		};
		out.GUI = GUI;
		out.click = click;
		out.BasicButton = BasicButton;
		out.BasicDrawable = BasicDrawable;
		out.InvisibleButton = InvisibleButton;
		out.TextBox = TextBox;
		out.TextBoxButton = TextBoxButton;
		out.clickCache = clickCache;
		function GUI:clean()
			clickCache = {			};
			out.clickCache = clickCache;
		end
		return out;
	end,
	["libs.Item"] = function()
		Class = require("libs.class");
		log = import("libs.log");
		dump = require("libs.dump");
		local json = require("libs.json");
		local Item = Class("Item");
		local Weapon = nil;
		local GameData = import("libs.GameData");
		Item.id = "";
		Item.type = "Item";
		Item.prefix = "Default";
		Item.name = "New Item";
		Item.quad = nil;
		function Item.loadSubclasses()
			log.custom("ITEM", "Loading Subclasses:");
			Weapon = import("libs.Weapon");
			log.custom("ITEM", "All Subclasses Loaded. ");
		end
		function Item.getName(item)
			return GameData[(item.prefix)].Items[(item.id)].name_en;
		end
		function Item.handle(item, data)
			item.prefix = data.prefix;
			item.id = data.id;
			item.type = GameData[(item.prefix)].Items[(item.id)].type;
			item.name = item:getName();
			return item;
		end
		function Item.fromJSON(data)
			if type(data)~="string" then
				error("Not a string.");
			end
			local dataInTable = json.decode(data);
			local type = GameData[(dataInTable.prefix)].Items[(dataInTable.id)].type;
			if (type=="Item") then
				local newItem = Item:new();
				return Item.handle(newItem, dataInTable);
			elseif (type=="Weapon") then
				local newWeapon = Weapon:new();
				Item.handle(newWeapon, dataInTable);
				return Weapon.handle(newWeapon, dataInTable.WeaponData);
			end
		end
		function Item:toJSON()
			local data = {			};
			data.id = self.id;
			data.prefix = self.prefix;
			if self.type=="Weapon" then
				data.WeaponData = {				};
				data.WeaponData.sharpened = self.sharpened;
			end
			return json.encode(data);
		end
		log.custom("ITEM", "Initial Log Complete");
		return Item;
	end,
	["libs.log"] = function()
		local function Log(level, msg)
			print("["..level.."] "..msg);
		end
		log = {		};
		function log.warn(msg)
			Log("WARN", msg);
		end
		function log.info(msg)
			Log("INFO", msg);
		end
		function log.error(msg)
			Log("ERROR", msg);
		end
		function log.fatal(msg)
			Log("FATAL", msg);
		end
		log.custom = Log;
		log.custom("LOG", "Loaded");
		return log;
	end,
	["libs.Math"] = function()
		local Class = require("libs.class");
		local Point2D = Class("Point2D");
		local Vector2D = Class("Vector2D");
		Point2D.__eq = function(point1, point2)
			return point1.x==point2.x and point1.y==point2.y;
		end;
		Point2D.__tostring = function(point)
			return "2D Point: {"..point.x..", "..point.y.."}";
		end;
		function Point2D:initialize(x, y)
			self.x = x;
			self.y = y;
		end
		Vector2D.__eq = function(vector1, vector2)
			return vector1.x==vector2.x and vector1.y==vector2.y;
		end;
		Vector2D.__tostring = function(vector)
			return "2D Vector: {X "..vector.x..", Y "..vector.y..", Angle (Radians) "..vector:getAngle()..", MAGNITUDE "..vector:getMagnitude().."}";
		end;
		function Vector2D:getMagnitude()
			return (((self.x^2)+(self.y^2))^0.5);
		end
		function Vector2D:getAngle()
			return math.atan2(self.y, self.x);
		end
		function Vector2D:initialize(x, y, mode)
			if (mode=="Polar") then
				self.x = math.cos(x)*y;
				self.y = math.sin(x)*y;
			else
				self.x = x;
				self.y = y;
			end
		end
		function Vector2D:apply(vector)
			return Vector2D(self.x+vector.x, self.y+vector.y);
		end
		function Vector2D.fromPoint(point)
			return Vector2D(point.x, point.y);
		end
		function Vector2D:multiply(vector)
			return Vector2D(self.x*vector.x, self.y*vector.y);
		end
		function Vector2D:toPoint()
			return Point2D.fromVector(self);
		end
		function Point2D:distanceToPoint(point)
			return ((self.x-point.x)^2+(self.y-point.y)^2)^0.5;
		end
		function Point2D:toVector()
			return Vector2D.fromPoint(self);
		end
		function Point2D.fromVector(vector)
			return Point2D(vector.x, vector.y);
		end
		function Point2D:rotate(rotation, centerPoint)
			centerPoint = centerPoint;
			Point2D(0, 0);
			local newX = ((self.x-centerPoint.x)*math.cos(rotation)-(self.y-centerPoint.y)*math.sin(rotation))+centerPoint.x;
			local newX = ((self.xy-centerPoint.x)*math.sin(rotation)+(self.y-centerPoint.y)*math.cos(rotation))+centerPoint.y;
			return Point2D(newX, newY);
		end
		function Point2D:translate(vector)
			return Point2D(self.x+vector.x, self.y+vector.y);
		end
		local negativeVector = Vector2D(-1, -1);
		function Point2D:scale(scaleVector, centerVector)
			return self:toVector():apply(centerVector:multiply(negativeVector)):multiply(scaleVector):apply(centerVector):toPoint();
		end
		local out = {		};
		out.Point2D = Point2D;
		out.Vector2D = Vector2D;
		return out;
	end,
	["libs.settings"] = function()
		local settings = {		};
		local stgs;
		return settings;
	end,
	["libs.tile"] = function()
		Class = require("libs.class");
		log = import("libs.log");
		json = require("libs.json");
		local Tile = Class("Tile");
		local GameData = nil;
		Tile.sx = 1;
		Tile.sy = 1;
		Tile.type = "Basic_Tile";
		Tile.prefix = "Default";
		Tile.id = "Default";
		Tile.tileset = "DefaultTileset";
		Tile.tilesetPrefix = "Default";
		function Tile:initialize()
			self.sx = 1;
			self.sy = 1;
		end
		function Tile.loadGameData()
			GameData = import("libs.GameData");
		end
		function Tile:getQuad()
			return GameData[(self.tilesetPrefix)].Tiles[(self.tileset)][(self.id)];
		end
		function Tile:getTileset()
			return GameData[(self.prefix)].Images[(self.tileset)];
		end
		function Tile:cloneTile()
			local tile = Tile();
			tile.id = self.id;
			tile.prefix = self.prefix;
			tile.type = self.type;
			tile.tileset = self.tileset;
			tile.tilesetPrefix = self.tilesetPrefix;
			return tile;
		end
		function Tile:toClue(TileMapName, TileMapPrefix, x, y)
			local out = "GameData['"..TileMapPrefix.."']['TileMaps']['"..TileMapName.."']['data']["..x.."]["..y.."]=Tile::new()";
			out = out .. "\n";
			out = out .. "GameData['"..TileMapPrefix.."']['TileMaps']['"..TileMapName.."']['data']["..x.."]["..y.."]['id']='"..self.id.."'";
			out = out .. "\n";
			out = out .. "GameData['"..TileMapPrefix.."']['TileMaps']['"..TileMapName.."']['data']["..x.."]["..y.."]['prefix']='"..self.prefix.."'";
			out = out .. "\n";
			out = out .. "GameData['"..TileMapPrefix.."']['TileMaps']['"..TileMapName.."']['data']["..x.."]["..y.."]['type']='"..self.type.."'";
			out = out .. "\n";
			out = out .. "GameData['"..TileMapPrefix.."']['TileMaps']['"..TileMapName.."']['data']["..x.."]["..y.."]['tileset']='"..self.tileset.."'";
			out = out .. "\n";
			out = out .. "GameData['"..TileMapPrefix.."']['TileMaps']['"..TileMapName.."']['data']["..x.."]["..y.."]['tilesetPrefix']='"..self.tilesetPrefix.."'";
			return out;
		end
		function Tile.handle(object, data)
			self.type = data.type;
			self.prefix = data.prefix;
			self.id = data.id;
		end
		function Tile.fromJSON(data)
			if type(data)~="string" then
				error("Not a string.");
			end
			local dataInTable = json.decode(data);
		end
		return Tile;
	end,
	["libs.TileMap"] = function()
		local Tile = import("libs.tile");
		local GUI = import("libs.gui");
		local Class = require("libs.class");
		local TileMap = Class("TileMap");
		local dump = require("libs.dump");
		local flux = require("libs.flux");
		TileMap.name = "Default";
		TileMap.x = 10;
		TileMap.prefix = "Default";
		TileMap.y = 10;
		TileMap.data = {		};
		TileMap.mouse = {
			x = -1, 
			y = -1
		};
		function TileMap:initialize(x, y)
			self.debug = false;
			self.x = x;
			self.y = y;
			self.sx = 1;
			self.sy = 1;
			self.data = {			};
			for i = 1, x, 1 do
				self.data[(i)] = {				};
			end
			self.clickFunctions = {			};
		end
		function TileMap:toClue()
			out = "GameData['"..self.prefix.."']['TileMaps']['"..self.name.."']=TileMap::new("..#self.data..","..#self.data[(1)]..")";
			out = out .. "\n";
			out = out .. "GameData['"..self.prefix.."']['TileMaps']['"..self.name.."'].name='"..self.name.."'";
			for x = 1, #self.data, 1 do
				for y = 1, #self.data[(1)], 1 do
					if self.data[(x)][(y)] then
						out = out .. "\n";
						out = out .. self.data[(x)][(y)]:toClue(self.name, self.prefix, x, y);
					end
				end
			end
			return out;
		end
		function TileMap:toLua()
			out = "GameData['"..self.prefix.."']['TileMaps']['"..self.name.."']=TileMap:new("..#self.data..","..#self.data[(1)]..")";
			out = out .. "\n";
			out = out .. "GameData['"..self.prefix.."']['TileMaps']['"..self.name.."'].name='"..self.name.."'";
			for x = 1, #self.data, 1 do
				for y = 1, #self.data[(1)], 1 do
					if self.data[(x)][(y)] then
						out = out .. "\n";
						out = out .. self.data[(x)][(y)]:toClue(self.name, self.prefix, x, y);
					end
				end
			end
			return out;
		end
		function TileMap:prepare(tileset)
			self.prepared = true;
			self.spriteBatch = love.graphics.newSpriteBatch(tileset, #self.data*#self.data[(1)], "dynamic");
			for x = 1, #self.data, 1 do
				for y = 1, #self.data[(1)], 1 do
					self.spriteBatch:add(self.data[(x)][(y)]:getQuad(), (x-1)*24, (y-1)*24);
				end
			end
		end
		function TileMap:drawBatch(x, y, r, sx, sy, ox, oy, kx, ky)
			love.graphics.draw(self.spriteBatch, x, y, r, sx, sy, ox, oy, kx, ky);
		end
		function TileMap:isFull()
			
		end
		function TileMap.fromTable(tbl)
			local rmvTotal = 0;
			local out = TileMap(1, 1);
			local secondRun = false;
			local function isEmpty(tabl)
				for k, v in pairs(tabl) do
					return false;
				end
				return true;
			end
			local xRun = 1;
			local yRun = 1;
			repeat 
				if (secondRun) then
					yRun = yRun + 1;
					xRun = xRun + 1;
					out:extend(0, 1, 0, 1, function()
						
					end);
				end
				local rmv = {				};
				for k, v in pairs(tbl) do
					if out:isFull() then
						goto continue;
					else
						for x = 1, xRun, 1 do
							local needBreak = false;
							for y = 1, yRun, 1 do
								if (not out.data[(x)][(y)]) then
									table.insert(rmv, k, true);
									out.data[(x)][(y)] = v;
									needBreak = true;
									break;
								end
							end
							if needBreak then
								break;
							end
						end
					end
					::continue::
				end
				for k in pairs(rmv) do
					rmvTotal = rmvTotal + 1;
					tbl[(k)] = nil;
				end
				secondRun = true;
			until isEmpty(tbl)
			return out;
		end
		function TileMap:update(dt, x, y)
			self.mouse = {
				x = x, 
				y = y
			};
			for x = 1, #self.data, 1 do
				for y = 1, #self.data[(x)], 1 do
					if (self.data[(x)][(y)]) then
						local skip = false;
						if (self.mouse.x>=(self.sx*(x-1)*24)+self.rx and self.mouse.x<=((x*24)*self.sx)+self.rx and self.mouse.y>=(y-1)*self.sy*24+self.ry and self.mouse.y<=((y)*self.sy*24)+self.ry) then
							for _, point in ipairs(GUI.clickCache) do
								for _, v in ipairs(self.clickFunctions) do
									v(self, x, y);
								end
							end
						end
					end
				end
			end
		end
		local function extend2DArray(arr, lx, rx, dy, uy, fill)
			if rx and rx>0 then
				for x = #arr+1, #arr+rx, 1 do
					arr[(x)] = {					};
					for y = 1, #arr[(1)], 1 do
						arr[(x)][(y)] = fill();
					end
				end
			end
			if lx and lx>0 then
				for x = #arr, 1, -1 do
					arr[(x+lx)] = arr[(x)];
				end
				for x = 1, lx, 1 do
					arr[(x)] = {					};
					for y = 1, #arr[(lx+1)], 1 do
						arr[(x)][(y)] = fill();
					end
				end
			end
			if dy and dy>0 then
				for x = 1, #arr, 1 do
					for y = #arr[(x)]+1, #arr[(x)]+dy, 1 do
						arr[(x)][(y)] = fill();
					end
				end
			end
			if uy and uy>0 then
				for x = 1, #arr, 1 do
					for y = #arr[(1)], 1, -1 do
						arr[(x)][(y+uy)] = arr[(x)][(y)];
					end
					for y = 1, uy, 1 do
						arr[(x)][(y)] = fill();
					end
				end
			end
			return arr;
		end
		local DefaultTile = Tile:new();
		DefaultTile[('id')] = 'Dirt';
		DefaultTile[('prefix')] = 'Default';
		DefaultTile[('type')] = 'Basic_Tile';
		DefaultTile[('tileset')] = 'DefaultTileset';
		DefaultTile[('tilesetPrefix')] = 'Default';
		function TileMap:newBasicTile()
			return DefaultTile:cloneTile();
		end
		function TileMap:extend(left, right, up, down, func)
			extend2DArray(self.data, left, right, down, up, func or self.newBasicTile);
		end
		function TileMap:setDebug(val)
			self.debug = val;
		end
		function TileMap:draw(rx, ry, r, sx, sy, ox, oy, kx, ky)
			local found = false;
			local foundplace = {
				x = -1, 
				y = -1
			};
			local sx = sx or 1;
			local sy = sy or 1;
			self.sx = sx;
			self.sy = sy;
			self.rx = rx;
			self.ry = ry;
			for x = 1, #self.data, 1 do
				for y = 1, #self.data[(x)], 1 do
					if (self.data[(x)][(y)]) then
						local skip = false;
						if (self.mouse.x>=(sx*(x-1)*24)+rx and self.mouse.x<=((x*24)*sx)+rx and self.mouse.y>=(y-1)*24+ry and self.mouse.y<=((y)*24)+ry) then
							if (found~=true) then
								found = true;
								foundplace = {
									x = x, 
									y = y
								};
								skip = true;
								if not self.data[(x)][(y)].tween then
									self.data[(x)][(y)].rect = true;
									self.data[(x)][(y)].tween = flux.to(self.data[(x)][(y)], 0.5, {
										sx = 1.2, 
										sy = 1.2
									});
								end
							end
						elseif (self.data[(x)][(y)].tween) then
							self.data[(x)][(y)].rect = false;
							self.data[(x)][(y)].tween:stop();
							self.data[(x)][(y)].tween = nil;
							self.data[(x)][(y)].sx = 1;
							self.data[(x)][(y)].sy = 1;
						end
						if not skip then
							love.graphics.push();
							love.graphics.translate((x*24)-12+rx, (y*24)-12+ry);
							love.graphics.scale(self.data[(x)][(y)].sx, self.data[(x)][(y)].sy);
							love.graphics.draw(self.data[(x)][(y)]:getTileset(), self.data[(x)][(y)]:getQuad(), -12, -12, r, sx, sy, ox, oy, kx, ky);
							local oldColor = {
								love.graphics.getColor()
							};
							love.graphics.setColor(0, 0, 0, 0.5);
							love.graphics.rectangle("line", -12, -12, 24, 24);
							love.graphics.setColor(oldColor);
							love.graphics.pop();
						end
					end
				end
			end
			if found then
				local x, y = foundplace.x, foundplace.y;
				love.graphics.push();
				love.graphics.translate((x*24)-12+rx, (y*24)-12+ry);
				love.graphics.scale(self.data[(x)][(y)].sx, self.data[(x)][(y)].sy);
				love.graphics.draw(self.data[(x)][(y)]:getTileset(), self.data[(x)][(y)]:getQuad(), -12, -12, r, sx, sy, ox, oy, kx, ky);
				love.graphics.rectangle("line", -12, -12, 24, 24);
				love.graphics.pop();
			end
		end
		function TileMap:onClick(func)
			table.insert(self.clickFunctions, func);
		end
		function TileMap:loadEdits(newdata, first)
			if type(self.data[(1)])~="table" and not first then
				error("incomplete data");
			end
			for x, z in pairs(newdata) do
				for y in pairs(z) do
					self.data[(x)][(y)] = newdata[(x)][(y)];
				end
			end
		end
		return TileMap;
	end,
	["libs.util"] = function()
		log = import("libs.log");
		log.custom("UTIL", "Loaded");
		function Test(a, b)
			return a+b;
		end
	end,
	["libs.wait"] = function()
		local waitTable = {		};
		log = import("libs.log");
		local wait = setmetatable({		}, {
			__call = function(self, seconds, func, args)
				table.insert(waitTable, {
					love.timer.getTime()+seconds, 
					func, 
					args
				});
			end
		});
		function wait.update()
			for k, v in pairs(waitTable) do
				if love.timer.getTime()>=v[(1)] then
					if v[(2)] then
						v[(2)](v[(3)]);
					end
					table.remove(waitTable, k);
				end
			end
		end
		log.custom("WAIT", "Loaded");
		return wait;
	end,
	["libs.Weapon"] = function()
		Class = require("libs.class");
		local Item = import("libs.Item");
		local Weapon = Item:subclass("Weapon");
		local GameData = import("libs.GameData");
		Weapon.damage = 0;
		Weapon.sharpened = false;
		function Weapon.handle(weapon, data)
			weapon.damage = GameData[(weapon.prefix)].Items[(weapon.id)].damage;
			weapon.sharpened = data.sharpened;
			return weapon;
		end
		return Weapon;
	end,
	["main"] = function()
		mode = import("conf");
		local push = require("libs.push");
		local windowWidth, windowHeight = love.window.getDesktopDimensions();
		push.setupScreen(1920, 1080, {
			canvas = true, 
			upscale = "normal", 
			resizable = true
		});
		util = nil;
		log = nil;
		splash = nil;
		gamestate = nil;
		talkies = nil;
		wait = nil;
		vars = {		};
		dump = nil;
		settings = nil;
		class = nil;
		Item = nil;
		Weapon = nil;
		logo = nil;
		player = {
			100, 
			100, 
			24, 
			24, 
			0, 
			0
		};
		bump = nil;
		Tile = nil;
		TileMap = nil;
		GUI = nil;
		GameData = nil;
		local function loadLibraries()
			util = import("libs.util");
			log = import("libs.log");
			splash = require("libs.splash");
			gamestate = import("libs.gamestate");
			talkies = require("libs.talkies");
			wait = import("libs.wait");
			dump = require("libs.dump");
			settings = import("libs.settings");
			class = require("libs.class");
			Item = import("libs.Item");
			bump = require("libs.bump");
			Tile = import("libs.tile");
			TileMap = import("libs.TileMap");
			GameData = import("libs.GameData");
			local mathExtensions = import("libs.Math");
			for k, v in pairs(mathExtensions) do
				math[(k)] = v;
			end
			GUI = import("libs.gui");
		end
		function love.resize(w, h)
			push.resize(w, h);
		end
		local logo1 = {
			name = "secondlogo"
		};
		local splashscreen = nil;
		function logo1.draw()
			push:start();
			splashscreen:draw();
			push:finish();
		end
		function logo1.update(dt)
			splashscreen:update(dt);
			wait.update();
		end
		local main = {
			name = "main"
		};
		if (mode=="editor") then
			local gui;
			local Title;
			local textboxbutton;
			local textboxbutton2;
			local textboxbutton3;
			function main.draw()
				push:start();
				gui:draw();
				push:finish();
			end
			function main.update(dt)
				local x, y = love.mouse.getPosition();
				local x, y = push.toGame(x, y);
				if (love.system.getOS()=="Android") then
					local touches = love.touch.getTouches();
					if #touches==0 then
						x, y = -1, -1;
					end
				end
				x = x or -1;
				y = y or -1;
				gui:update(dt, x, y);
				gui:clean();
			end
			function main.switchto()
				gui = GUI.GUI();
				Title = GUI.TextBox(240, 0, {
					1, 
					0, 
					1, 
					1
				}, 1920-(240*2), 100, 36, "NAME NOT YET DISCOVERED", "center");
				textboxbutton = GUI.TextBoxButton(240*2, 200, {
					0, 
					0, 
					1, 
					1
				}, 1920-(240*4), 75, 28, "Current Clicks: 0", true);
				textboxbutton.clicks = 0;
				textboxbutton:onClick(function(self)
					self.clicks = self.clicks + 1;
					self:updateText("Current Clicks: "..self.clicks);
				end);
				textboxbutton2 = GUI.TextBoxButton(240*2, 300, {
					math.random(), 
					math.random(), 
					math.random(), 
					1
				}, 1920-(240*4), 75, 28, "Reset Clicks", true);
				textboxbutton2.clicks = 0;
				textboxbutton2:onClick(function(self)
					textboxbutton.clicks = 0;
					textboxbutton:updateText("Current Clicks: "..self.clicks);
				end);
				textboxbutton3 = GUI.TextBoxButton(240*2, 400, {
					math.random(), 
					math.random(), 
					math.random(), 
					1
				}, 1920-(240*4), 75, 28, "New Color", true);
				textboxbutton3.clicks = 0;
				textboxbutton3:onClick(function(self)
					textboxbutton2.color = {
						math.random(), 
						math.random(), 
						math.random(), 
						1
					};
				end);
				gui:add(Title);
				gui:add(textboxbutton);
				gui:add(textboxbutton2);
				gui:add(textboxbutton3);
			end
			function main.mousereleased(x, y, button, istouch, presses)
				local x, y = love.mouse.getPosition();
				local x, y = push.toGame(x, y);
				if x and y then
					GUI.click(x, y, button);
				end
			end
		else
			local tile;
			local gui;
			tileset = {			};
			local move = 0;
			local mx, my = -1, -1;
			tileset.switched = false;
			tileset.name = "TILESET";
			function tileset.draw()
				local self = tileset;
				push:start();
				self.gui:background();
				self.map:draw(20, 20);
				self.gui:draw();
				push:finish();
			end
			function tileset.update(dt)
				local self = tileset;
				local x, y = love.mouse.getPosition();
				local x, y = push.toGame(x, y);
				if (love.system.getOS()=="Android") then
					local touches = love.touch.getTouches();
					if #touches==0 then
						x, y = -1, -1;
					end
				end
				local x = x or -1;
				local y = y or -1;
				self.gui:update(dt, x, y);
				self.map:update(dt, x, y);
				self.gui:clean();
			end
			function tileset.switchto()
				if (not tileset.switched) then
					local self = tileset;
					self.map = GameData.Default.TileMaps.DefaultTileset;
					self.button = GUI.TextBoxButton(240*2, 0, {
						0, 
						0, 
						1, 
						1
					}, 1920-(240*4), 100, 36, "Tilemap Editor", true);
					self.button:onClick(function(self, x, y)
						gamestate.switch(main);
					end);
					self.gui = GUI.GUI();
					self.gui:add(self.button);
					GameData.Default.TileMaps.DefaultTileset:setDebug(true);
				end
				tileset.switched = true;
			end
			function main.draw()
				push:start();
				gui:background();
				GameData.Default.TileMaps.DefaultTileMap:draw(20, 20);
				gui:draw();
				push:finish();
			end
			function main.update(dt)
				wait.update();
				local x, y = love.mouse.getPosition();
				local x, y = push.toGame(x, y);
				if (love.system.getOS()=="Android") then
					local touches = love.touch.getTouches();
					if #touches==0 then
						x, y = -1, -1;
					end
				end
				local x = x or -1;
				local y = y or -1;
				gui:update(dt, x, y);
				GameData.Default.TileMaps.DefaultTileMap:update(dt, x, y);
				gui:clean();
			end
			main.switched = false;
			function main.switchto()
				if (not main.switched) then
					tile = GameData.Default.TileMaps.DefaultTileMap:newBasicTile();
					local textboxbutton = GUI.TextBoxButton(240*2, 0, {
						0, 
						0, 
						1, 
						1
					}, 1920-(240*4), 100, 36, "Tileset Picker", true);
					textboxbutton:onClick(function(self, x, y)
						gamestate.switch(tileset);
					end);
					gui = GUI.GUI();
					gui:add(textboxbutton);
					GameData.Default.TileMaps.DefaultTileMap:setDebug(true);
					GameData.Default.TileMaps.DefaultTileMap:onClick(function(self, x, y)
						self.data[(x)][(y)] = tile:cloneTile();
					end);
					GameData.Default.TileMaps.DefaultTileset:onClick(function(self, x, y)
						tile = self.data[(x)][(y)]:cloneTile();
					end);
				end
				main.switched = true;
			end
			function main.mousereleased(x, y, button, istouch, presses)
				local x, y = love.mouse.getPosition();
				local x, y = push.toGame(x, y);
				if x and y then
					GUI.click(x, y, button);
				end
			end
		end
		function love.quit()
			log.info(GameData[('Default')][('TileMaps')][('DefaultTileMap')]:toLua());
		end
		function love.load()
			love.mouse.setVisible(true);
			loadLibraries();
			Tile.loadGameData();
			local newData = {			};
			newData[(1)] = {			};
			newData[(1)][(5)] = Tile:new();
			newData[(1)][(5)].id = "DirtULGrassDR";
			GameData.Default.TileMaps.DefaultTileMap:extend(2, 2, 2, 2);
			Item.loadSubclasses();
			Weapon = import("libs.Weapon");
			local FirstWeapon = Weapon:new();
			FirstWeapon.id = "BasicSword";
			FirstWeapon.type = "Weapon";
			FirstWeapon.sharpened = true;
			local WeaponData = FirstWeapon:toJSON();
			talkies.optionCharacter = "";
			talkies.padding = 0;
			talkies.backgroundColor = {
				0, 
				0, 
				0, 
				0
			};
			log.info("Fully Loaded");
			local intro = love.audio.newSource("assets/intro.mp3", "static");
			logo = love.graphics.newImage("assets/logo.png");
			wait(4, function()
				talkies.onAction();
			end);
			intro:play();
			local talkies_text = "";
			if (mode=="editor") then
				talkies_text = "Shop Game Thing Tileset Editor\nBy Trip-kun\nGithub: https://github.com/Trip-kun/";
			else
				talkies_text = "Shop Game Thing\nBy Trip-kun\nGithub: https://github.com/Trip-kun/";
			end
			talkies.say("", talkies_text, {
				image = logo, 
				oncomplete = function()
					intro:release();
					if (love.system.getOS()=="Android") then
						gamestate.switch(main);
						love.graphics.setColor(1, 1, 1, 1);
					else
						splashscreen = splash({
							fill = "rain"
						});
						splashscreen.onDone = function()
							love.graphics.setColor(1, 1, 1, 1);
							gamestate.switch(main);
						end;
						gamestate.switch(logo1);
					end
				end
			});
		end
		function love.draw()
			push:start();
			talkies.draw(3);
			push:finish();
		end
		function love.update(dt)
			wait.update();
			talkies.update(dt);
		end
	end,
	}
import("main")