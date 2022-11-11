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
	["conf"] = function()
		return "not_editor";
	end,
	["libs.util.wait"] = function()
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
	["libs.util.gamestate"] = function()
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
	["libs.util.util"] = function()
		log = import("libs.log");
		log.custom("UTIL", "Loaded");
		function Test(a, b)
			return a+b;
		end
	end,
	["libs.util.Math"] = function()
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
			local newY = ((self.x-centerPoint.x)*math.sin(rotation)+(self.y-centerPoint.y)*math.cos(rotation))+centerPoint.y;
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
	["libs.util.settings"] = function()
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
			return GameData[(self.tilesetPrefix)].Tiles[(self.tileset)][(self.id)].quad;
		end
		function Tile:getCollision()
			return GameData[(self.tilesetPrefix)].Tiles[(self.tileset)][(self.id)].collision;
		end
		function Tile:getTileset()
			return GameData[(self.prefix)].Images[(self.tileset)];
		end
		function Tile:isEmpty()
			return self.id=="Empty" or self.id=="EmptyCollider";
		end
		function Tile:draw(x, y, r, sx, sy, ox, oy, kx, ky, debug)
			if (not self:isEmpty() and not debug) then
				love.graphics.draw(self:getTileset(), self:getQuad(), -12*sx, -12*sx, r, sx, sy, ox, oy, kx, ky);
			elseif (self:isEmpty() and debug) then
				local oldColor = {
					love.graphics.getColor()
				};
				if (self.id=="EmptyCollider") then
					love.graphics.setColor(1, 0, 0, 0.5);
				else
					love.graphics.setColor(0, 1, 0, 0.5);
				end
				love.graphics.rectangle("fill", -12*sx, -12*sx, 24*sx, 24*sx);
				love.graphics.setColor(0, 0, 0, 0.5);
				love.graphics.rectangle("line", -12*sx, -12*sx, 24*sx, 24*sx);
				love.graphics.setColor(oldColor);
			else
				love.graphics.draw(self:getTileset(), self:getQuad(), -12*sx, -12*sx, r, sx, sy, ox, oy, kx, ky);
				local oldColor = {
					love.graphics.getColor()
				};
				love.graphics.setColor(0, 0, 0, 0.5);
				love.graphics.rectangle("line", -12*sx, -12*sx, 24*sx, 24*sx);
				love.graphics.setColor(oldColor);
			end
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
		function Tile:toLua(TileMapName, TileMapPrefix, x, y)
			local out = "GameData['"..TileMapPrefix.."']['TileMaps']['"..TileMapName.."']['data']["..x.."]["..y.."]=Tile:new()";
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
		function Tile.handle(self, data)
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
		GameData[('Default')][('TileMaps')][('SecondTileMap')] = {
			data = {			}
		};
		GameData[('Default')][('TileMaps')][('SecondTileMap')] = TileMap:new(5, 5);
		GameData[('Default')][('TileMaps')][('SecondTileMap')].name = 'SecondTileMap';
		for x = 1, 5, 1 do
			GameData[('Default')][('TileMaps')][('SecondTileMap')][('data')][(x)] = {			};
			for y = 1, 5, 1 do
				GameData[('Default')][('TileMaps')][('SecondTileMap')][('data')][(x)][(y)] = Tile:new();
				GameData[('Default')][('TileMaps')][('SecondTileMap')][('data')][(x)][(y)][('id')] = 'Empty';
				GameData[('Default')][('TileMaps')][('SecondTileMap')][('data')][(x)][(y)][('prefix')] = 'Default';
				GameData[('Default')][('TileMaps')][('SecondTileMap')][('data')][(x)][(y)][('type')] = 'Basic_Tile';
				GameData[('Default')][('TileMaps')][('SecondTileMap')][('data')][(x)][(y)][('tileset')] = 'DefaultTileset';
				GameData[('Default')][('TileMaps')][('SecondTileMap')][('data')][(x)][(y)][('tilesetPrefix')] = 'Default';
			end
		end
		return GameData;
	end,
	["libs.pulse"] = function()
		local Class = require("libs.class");
		local pulse = Class("Pulse");
		function pulse:first(event, id, ...)
			if (self.events[(event)][(id)] and not self.cache[(event)][(id)]) then
				self.events[(event)][(id)]();
			elseif (self.cache[(event)][(id)]) then
				
			else
				error("No Function Found with ID: "..id);
			end
		end
		function pulse:initialize(events)
			if (type(events)~="table" and type(events)~="nil") then
				error("Invalid Arugment #1 events: Expected Type Nil Or Function, Got Type: "..type(events));
			end
			self.events = {			};
			self.cache = {			};
			for k, v in pairs(events) do
				self.events[(v)] = {				};
				self.cache[(v)] = {				};
			end
		end
		function pulse:newEvent(event)
			if (type(event)=="nil") then
				error("Invalid Argument #1 event: Argument Cannot Be Nil");
			end
			self.events[(event)] = {			};
		end
		function pulse:removeEvent(event)
			if (type(event)=="nil") then
				error("Invalid Argument #1 event: Argument Cannot Be Nil");
			end
			self.events[(event)] = nil;
		end
		function pulse:onEvent(event, id, func)
			if (type(event)=="nil") then
				error("Invalid Argument #1 event: Argument Cannot Be Nil");
			end
			if (type(id)=="nil") then
				error("Invalid Argument #2 id: Argument Cannot Be Nil");
			end
			if (type(func)~="function") then
				error("Invalid Argument #3 func: Expected Type Function, Got Type: "..type(func));
			end
			self.events[(event)][(id)] = func;
		end
		function pulse:removeOnEvent(event, id)
			if (type(event)=="nil") then
				error("Invalid Argument #1 event: Argument Cannot Be Nil");
			end
			if (type(id)=="nil") then
				error("Invalid Argument #2 id: Argument Cannot Be Nil");
			end
			self.events[(event)][(id)] = nil;
		end
		function pulse:emit(event, ...)
			if (type(event)=="nil") then
				error("Invalid Argument #1 event: Argument Cannot Be Nil");
			end
			self.cache = {			};
			for k, v in pairs(self.events) do
				self.cache[(k)] = {				};
			end
			for k, v in pairs(self.events[(event)]) do
				if (not self.cache[(event)][(k)]) then
					v(...);
					self.cache[(event)][(k)] = true;
				end
			end
		end
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
	["libs.gui.elements.BasicTileMap"] = function()
		local Class = require("libs.class");
		local BasicTileMap = Class("BasicTileMap");
		local TileMapMixin = import("libs.gui.mixins.GuiTileMap");
		BasicTileMap:include(TileMapMixin);
		function BasicTileMap:initialize(x, y, sx, sy, map)
			self.x = x;
			self.y = y;
			self._sx = sx;
			self._sy = sy;
			self:initTileMap(map);
		end
		function BasicTileMap:draw(rx, ry, r, sx, sy, ox, oy, kx, ky)
			rx = rx or 0;
			ry = ry or 0;
			sx = sx or 1;
			sy = sy or 1;
			TileMapMixin.draw(self, rx+self.x, ry+self.y, r, sx*self._sx, sy*self._sy, ox, oy, kx, ky);
		end
		return BasicTileMap;
	end,
	["libs.gui.elements.Wrapper"] = function()
		local Class = require("libs.class");
		local ClickCache = import("libs.gui.subsystems.ClickCache");
		local backgroundColor = {
			0.5, 
			0.5, 
			0.5, 
			1
		};
		local flux = require("libs.flux");
		local GUI = Class("GUI");
		function GUI:initialize()
			self.children = {			};
		end
		function GUI:add(child)
			table.insert(self.children, child);
			return #self.children;
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
		function GUI:clean()
			ClickCache.clear();
		end
		GUI.click = function(x, y, button)
			ClickCache.click(x, y, button);
		end;
		return GUI;
	end,
	["libs.gui.elements.HoverTextBox"] = function()
		local Class = require("libs.class");
		local TextBox = Class("HoverTextBox");
		local text = import("libs.gui.mixins.Text");
		local rectangle = import("libs.gui.mixins.Rectangle");
		local drawable = import("libs.gui.mixins.Drawable");
		local hover = import("libs.gui.mixins.Hover");
		TextBox:include(text);
		TextBox:include(rectangle);
		TextBox:include(hover);
		function TextBox:draw(x, y, r, sx, sy, ox, oy, kx, ky)
			drawable.draw(self, x, y, r, sx, sy, ox, oy, kx, ky);
			self:drawRectangle(x, y, r, sx, sy, ox, oy, kx, ky);
			self:drawText(x, y, r, sx, sy, ox, oy, kx, ky);
		end
		function TextBox:initialize(x, y, color, width, height, fontsize, text, align)
			self:initRectangle(x, y, color, width, height);
			self:initText(fontsize, width, height, text, align);
			self:initHover(x, y, width, height);
		end
		function TextBox:update(dt, x, y)
			self:updateRectangle(dt, x, y);
		end
		return TextBox;
	end,
	["libs.gui.elements.BasicButton"] = function()
		local Class = require("libs.class");
		local BasicButton = Class("BasicButton");
		local button = import("libs.gui.mixins.Button");
		local drawable = import("libs.gui.mixins.Drawable");
		BasicButton:include(button);
		BasicButton:include(drawable);
		function BasicButton:initialize(x, y, active, width, height, canvas)
			self:initButton(x, y, active, width, height);
			self:initDrawable(x, y, canvas, width, height);
		end
		return BasicButton;
	end,
	["libs.gui.elements.ScrollableArea"] = function()
		local Class = require("libs.class");
		local ClickCache = import("libs.gui.subsystems.ClickCache");
		local ScrollableArea = Class("ScrollableArea");
		local push = require("libs.push");
		function ScrollableArea:initialize(x, y, width, height, true_width, true_height, start_offset_x, start_offset_y)
			firstRun = false;
			self.x, self.y = x, y;
			self.width = width;
			self.height = height;
			self.true_width = true_width;
			self.true_height = true_height;
			self.canvas = love.graphics.newCanvas(true_width, true_height);
			self.offsetX = start_offset_x or 0;
			self.offsetY = start_offset_y or 0;
			self.children = {			};
		end
		function ScrollableArea:add(child)
			table.insert(self.children, child);
			return #self.children;
		end
		function ScrollableArea:drawStart()
			self.oldCanvas = love.graphics.getCanvas();
			love.graphics.setCanvas(self.canvas);
			love.graphics.push();
			love.graphics.translate(-self.offsetX, -self.offsetY);
		end
		function ScrollableArea:drawFinish()
			love.graphics.setCanvas(self.oldCanvas);
			love.graphics.pop();
		end
		function ScrollableArea:draw()
			self:drawStart();
			for _, v in ipairs(self.children) do
				if v.draw then
					v:draw();
				end
			end
			self:drawFinish();
		end
		function ScrollableArea:updateStart()
			self.backup = {			};
			local cache = ClickCache.getCache();
			for i, v in ipairs(cache) do
				self.backup[(i)] = v;
			end
			for i, v in ipairs(self.backup) do
				cache[(i)] = self:fromWorld(v);
			end
		end
		function ScrollableArea:updateFinish()
			local cache = ClickCache.getCache();
			for i, v in ipairs(self.backup) do
				cache[(i)] = v;
			end
		end
		local function clamp(x, min, max)
			if (x<min) then
				return min;
			elseif (x>max) then
				return max;
			else
				return x;
			end
		end
		function ScrollableArea:scroll(dX, dY)
			dX = dX or 0;
			dY = dY or 0;
			self.offsetX = clamp(self.offsetX+dX, 0, self.true_width-self.width);
			self.offsetY = clamp(self.offsetY+dY, 0, self.true_height-self.height);
		end
		function ScrollableArea:fromWorld(pt)
			local x, y = pt.x, pt.y;
			if (x-self.x<0 or x-self.x>self.width or y-self.y<0 or y-self.y>self.height) then
				return {
					x = -1, 
					y = -1
				};
			end
			return {
				x = x-self.x+self.offsetX, 
				y = y-self.y+self.offsetY
			};
		end
		function ScrollableArea:update(dt, x, y)
			local pt = self:fromWorld({
				x = x, 
				y = y
			});
			local x, y = pt.x, pt, y;
			for _, v in ipairs(self.children) do
				if v.update then
					v:update(dt, x, y);
				end
			end
		end
	end,
	["libs.gui.elements.TextBox"] = function()
		local Class = require("libs.class");
		local TextBox = Class("TextBox");
		local text = import("libs.gui.mixins.Text");
		local rectangle = import("libs.gui.mixins.Rectangle");
		local drawable = import("libs.gui.mixins.Drawable");
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
		return TextBox;
	end,
	["libs.gui.elements.BasicDrawable"] = function()
		local Class = require("libs.class");
		local BasicDrawable = Class("BasicDrawable");
		local drawable = import("libs.gui.mixins.Drawable");
		BasicDrawable:include(drawable);
		function BasicDrawable:initialize(x, y, canvas, width, height)
			self:initDrawable(x, y, canvas, width, height);
		end
		return BasicDrawable;
	end,
	["libs.gui.elements.InvisibleButton"] = function()
		local Class = require("libs.class");
		local InvisibleButton = Class("InvisibleButton");
		local button = import("libs.gui.mixins.Button");
		InvisibleButton:include(button);
		function InvisibleButton:initialize(x, y, active, width, height)
			self:initButton(x, y, active, width, height);
		end
		return InvisibleButton;
	end,
	["libs.gui.elements.TextBoxButton"] = function()
		local Class = require("libs.class");
		local TextBoxButton = Class("TextBoxButton");
		local button = import("libs.gui.mixins.Button");
		local text = import("libs.gui.mixins.Text");
		local rectangle = import("libs.gui.mixins.Rectangle");
		local drawable = import("libs.gui.mixins.Drawable");
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
		return TextBoxButton;
	end,
	["libs.gui.elements.BasicLayeredTileMap"] = function()
		local Class = require("libs.class");
		local BasicLayeredTileMap = Class("BasicLayeredTileMap");
		local LayeredTileMapMixin = import("libs.gui.mixins.LayeredGuiTileMap");
		BasicLayeredTileMap:include(LayeredTileMapMixin);
		function BasicLayeredTileMap:initialize(x, y, sx, sy, map)
			self.x = x;
			self.y = y;
			self._sx = sx;
			self._sy = sy;
			self:initLayeredTileMap(map);
		end
		function BasicLayeredTileMap:draw(rx, ry, r, sx, sy, ox, oy, kx, ky)
			rx = rx or 0;
			ry = ry or 0;
			sx = sx or 1;
			sy = sy or 1;
			LayeredTileMapMixin.draw(self, rx+self.x, ry+self.y, r, sx*self._sx, sy*self._sy, ox, oy, kx, ky);
		end
		return BasicLayeredTileMap;
	end,
	["libs.gui.mixins.Hover"] = function()
		local hover = {		};
		function hover:initHover(x, y, width, height)
			self.x = x;
			self.y = y;
			self.width = width;
			self.height = height;
		end
		function hover:containsPoint(x, y)
			if not x or not y then
				return false;
			end
			point = {
				x = x, 
				y = y
			};
			return point.x>=self.x and point.x<=self.x+self.width and point.y>=self.y and point.y<=self.y+self.height;
		end
		return hover;
	end,
	["libs.gui.mixins.Active"] = function()
		local active = {		};
		function active:setActive(bool)
			self.active = bool;
		end
		function active:getActive()
			return self.active;
		end
		return active;
	end,
	["libs.gui.mixins.Button"] = function()
		local button = {		};
		local active = import("libs.gui.mixins.Active");
		local ClickCache = import("libs.gui.subsystems.ClickCache");
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
				for _, point in ipairs(ClickCache.getCache()) do
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
		return button;
	end,
	["libs.gui.mixins.Text"] = function()
		local text = {		};
		local fontCache = import("libs.gui.subsystems.FontCache");
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
		return text;
	end,
	["libs.gui.mixins.LayeredGuiTileMap"] = function()
		local LayeredTileMapMixin = {		};
		function LayeredTileMapMixin:initLayeredTileMap(map)
			self.map = map;
			self.debug = true;
		end
		function LayeredTileMapMixin:update(dt, x, y)
			
		end
		function LayeredTileMapMixin:setDebug(val)
			self.debug = val;
		end
		local function Array2DSize(arr)
			local lim = 0;
			for i = 1, #arr, 1 do
				if lim<=#arr[(i)] then
					lim = #arr[(i)];
				end
			end
			return lim;
		end
		function LayeredTileMapMixin:draw(rx, ry, r, sx, sy, ox, oy, kx, ky)
			local sx = sx or 1;
			local sy = sy or 1;
			self.sx = sx;
			self.sy = sy;
			self.rx = rx;
			self.ry = ry;
			for i = 1, #self.map.layers, 1 do
				for y = 1, Array2DSize(self.map.layers[(1)].data), 1 do
					for x = 1, #self.map.layers[(1)].data, 1 do
						love.graphics.push();
						love.graphics.translate(((x-0.5)*24*sx)+rx, ((y-0.5)*24*sy)+ry);
						self.map.layers[(i)].data[(x)][(y)]:draw(x, y, r, sx, sy, ox, oy, kx, ky, self.debug);
						love.graphics.pop();
					end
				end
			end
		end
		return LayeredTileMapMixin;
	end,
	["libs.gui.mixins.Drawable"] = function()
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
		return drawable;
	end,
	["libs.gui.mixins.GuiTileMap"] = function()
		local TileMapMixin = {		};
		function TileMapMixin:initTileMap(map)
			self.map = map;
			self.clickFunctions = {			};
		end
		local flux = require("libs.flux");
		local ClickCache = import("libs.gui.subsystems.ClickCache");
		function TileMapMixin:update(dt, x, y)
			self.map.mouse = {
				x = x, 
				y = y
			};
			for x = 1, #self.map.data, 1 do
				for y = 1, #self.map.data[(x)], 1 do
					if (self.map.data[(x)][(y)]) then
						local skip = false;
						if (self.interact and self.map.mouse.x>=(self.sx*(x-1)*24)+self.rx and self.map.mouse.x<=((x*24)*self.sx)+self.rx and self.map.mouse.y>=(y-1)*self.sy*24+self.ry and self.map.mouse.y<=((y)*self.sy*24)+self.ry) then
							if (love.mouse.isDown(1) or #love.touch.getTouches()>0) then
								for _, v in ipairs(self.clickFunctions) do
									v(self, x, y);
								end
							end
						end
					end
				end
			end
		end
		function TileMapMixin:draw(rx, ry, r, sx, sy, ox, oy, kx, ky)
			local found = false;
			local found_place = {
				x = -1, 
				y = -1
			};
			local sx = sx or 1;
			local sy = sy or 1;
			self.sx = sx;
			self.sy = sy;
			self.rx = rx;
			self.ry = ry;
			for x = 1, #self.map.data, 1 do
				for y = 1, #self.map.data[(x)], 1 do
					if (self.map.data[(x)][(y)]) then
						local skip = false;
						if (self.map.mouse.x>=(sx*(x-1)*24)+rx and self.map.mouse.x<=((x*24)*sx)+rx and self.map.mouse.y>=((y-1)*sy*24)+ry and self.map.mouse.y<=((y)*24*sy)+ry) then
							if (found~=true) then
								found = true;
								found_place = {
									x = x, 
									y = y
								};
								skip = true;
								if not self.map.data[(x)][(y)].tween then
									if self.interact then
										self.map.data[(x)][(y)].rect = true;
										self.map.data[(x)][(y)].tween = flux.to(self.map.data[(x)][(y)], 0.5, {
											sx = 1.2, 
											sy = 1.2
										});
									end
								end
							end
						elseif (self.map.data[(x)][(y)].tween) then
							self.map.data[(x)][(y)].rect = false;
							self.map.data[(x)][(y)].tween:stop();
							self.map.data[(x)][(y)].tween = nil;
							self.map.data[(x)][(y)].sx = 1;
							self.map.data[(x)][(y)].sy = 1;
						end
						if not skip then
							love.graphics.push();
							love.graphics.translate(((x-0.5)*24*sx)+rx, ((y-0.5)*24*sy)+ry);
							love.graphics.scale(self.map.data[(x)][(y)].sx, self.map.data[(x)][(y)].sy);
							self.map.data[(x)][(y)]:draw(x, y, r, sx, sy, ox, oy, kx, ky, true);
							love.graphics.pop();
						end
					end
				end
			end
			if found then
				local x, y = found_place.x, found_place.y;
				love.graphics.push();
				love.graphics.translate(((x-0.5)*24*sx)+rx, ((y-0.5)*24*sy)+ry);
				love.graphics.scale(self.map.data[(x)][(y)].sx, self.map.data[(x)][(y)].sy);
				self.map.data[(x)][(y)]:draw(x, y, r, sx, sy, ox, oy, kx, ky, true);
				love.graphics.pop();
			end
		end
		function TileMapMixin:onClick(func)
			table.insert(self.clickFunctions, func);
		end
		return TileMapMixin;
	end,
	["libs.gui.mixins.Rectangle"] = function()
		local rectangle = {		};
		local drawable = import("libs.gui.mixins.Drawable");
		local active = import("libs.gui.mixins.Active");
		local flux = require("libs.flux");
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
			local rotation = rotation or 0;
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
		return rectangle;
	end,
	["libs.gui.subsystems.FontCache"] = function()
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
		return fontCache;
	end,
	["libs.gui.subsystems.ClickCache"] = function()
		local clickCache = {		};
		local mathExtensions = import("libs.util.Math");
		for k, v in pairs(mathExtensions) do
			math[(k)] = v;
		end
		local function click(x, y, button)
			if button==1 then
				table.insert(clickCache, math.Point2D(x, y));
			end
		end
		local out = {		};
		out.click = click;
		out.clear = function()
			clickCache = {			};
		end;
		out.getCache = function()
			return clickCache;
		end;
		return out;
	end,
	["libs.gui.gui"] = function()
		local out = {		};
		out.register = function(name, class)
			out[(name)] = class;
		end;
		return out;
	end,
	["libs.LayeredTileMap"] = function()
		local Tile = import("libs.tile");
		local Class = require("libs.class");
		local LayeredTileMap = Class("LayeredTileMap");
		local dump = require("libs.dump");
		local flux = require("libs.flux");
		local TileMap = import("libs.TileMap");
		LayeredTileMap.name = "Default";
		LayeredTileMap.x = 10;
		LayeredTileMap.y = 10;
		LayeredTileMap.z = 5;
		LayeredTileMap.layers = {		};
		LayeredTileMap.mouse = {
			x = -1, 
			y = -1
		};
		function LayeredTileMap:initialize(x, y, z)
			self.debug = true;
			self.x = x;
			self.y = y;
			self.z = z;
			self.sx = 1;
			self.sy = 1;
			self.clickFunctions = {			};
			self.layers = {			};
			for i = 1, z, 1 do
				self.layers[(i)] = TileMap(x, y);
				self.layers[(i)].clickFunctions = {				};
			end
		end
		function LayeredTileMap:alias(index, alias)
			self[(alias)] = self.layers[(index)];
		end
		function LayeredTileMap:extend(left, right, up, down, func)
			for i = 1, #self.layers, 1 do
				self.layers[(i)]:extend(left, right, up, down, func);
			end
		end
		function LayeredTileMap:setDebug(val)
			self.debug = val;
			for i = 1, #self.layers, 1 do
				self.layers[(i)].debug = val;
			end
		end
		function LayeredTileMap:collisionOut()
			local out = self.layers[(#self.layers)]:collisionOut();
			for i = #self.layers-1, 1, 1 do
				out = TileMap.collapseCollision(out, self.layers[(i)]:collisionOut());
			end
			return out;
		end
		return LayeredTileMap;
	end,
	["libs.log"] = function()
		local function Log(level, msg)
			if (type(level)~="string") then
				error("Invalid Argument #1 level: Expected Type String, Got Type: "..type(level));
			end
			if (type(msg)~="string") then
				error("Invalid Argument #2 msg: Expected Type String, Got Type: "..type(msg));
			end
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
	["libs.TileMap"] = function()
		local Tile = import("libs.tile");
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
						out = out .. self.data[(x)][(y)]:toLua(self.name, self.prefix, x, y);
					end
				end
			end
			return out;
		end
		function TileMap:isFull()
			local out = true;
			for x = 1, self.x, 1 do
				local needBreak = false;
				if self.data[(x)] then
					for y = 1, self.y, 1 do
						if not self.data[(x)][(y)] then
							out = false;
							needBreak = true;
							break;
						end
					end
					if needBreak then
						break;
					end
				else
					out = false;
					break;
				end
			end
			return out;
		end
		function TileMap.fromTable(tbl)
			local rmvTotal = 0;
			local out = TileMap(1, 1);
			local secondRun = false;
			local function isEmpty(in_table)
				for k, v in pairs(in_table) do
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
			self.x = self.x + left+right;
			self.y = self.y + up+down;
		end
		function TileMap:setDebug(val)
			self.debug = val;
		end
		function TileMap:collisionOut()
			local out = {			};
			for x = 1, #self.data, 1 do
				out[(x)] = {				};
				for y = 1, #self.data[(x)], 1 do
					out[(x)][(y)] = self.data[(x)][(y)]:getCollision();
				end
			end
			return out;
		end
		function TileMap.collapseCollision(out1, out2)
			local out = {			};
			for x = 1, #out1, 1 do
				out[(x)] = {				};
				for y = 1, #out1[(x)], 1 do
					out[(x)][(y)] = out1[(x)][(y)] or out2[(x)][(y)];
				end
			end
			return out;
		end
		function TileMap:loadEdits(new_data, first)
			if type(self.data[(1)])~="table" and not first then
				error("incomplete data");
			end
			for x, z in pairs(new_data) do
				for y in pairs(z) do
					self.data[(x)][(y)] = new_data[(x)][(y)];
				end
			end
		end
		return TileMap;
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
		bump = require("libs.bump");
		Tile = nil;
		TileMap = nil;
		GUI = nil;
		GameData = nil;
		local function loadLibraries()
			util = import("libs.util.util");
			log = import("libs.log");
			splash = require("libs.splash");
			gamestate = import("libs.util.gamestate");
			talkies = require("libs.talkies");
			wait = import("libs.util.wait");
			dump = require("libs.dump");
			settings = import("libs.util.settings");
			class = require("libs.class");
			Item = import("libs.Item");
			Tile = import("libs.tile");
			TileMap = import("libs.TileMap");
			GameData = import("libs.GameData");
			LayeredTileMap = import("libs.LayeredTileMap");
			local mathExtensions = import("libs.util.Math");
			for k, v in pairs(mathExtensions) do
				math[(k)] = v;
			end
			GUI = import("libs.gui.gui");
			GUI.register("BasicButton", import("libs.gui.elements.BasicButton"));
			GUI.register("BasicDrawable", import("libs.gui.elements.BasicDrawable"));
			GUI.register("BasicTileMap", import("libs.gui.elements.BasicTileMap"));
			GUI.register("InvisibleButton", import("libs.gui.elements.InvisibleButton"));
			GUI.register("TextBox", import("libs.gui.elements.TextBox"));
			GUI.register("TextBoxButton", import("libs.gui.elements.TextBoxButton"));
			GUI.register("GUI", import("libs.gui.elements.Wrapper"));
			GUI.register("BasicLayeredTileMap", import("libs.gui.elements.BasicLayeredTileMap"));
			GUI.register("HoverTextBox", import("libs.gui.elements.HoverTextBox"));
			GUI.register("ScrollableArea", import("libs.gui.elements.ScrollableArea"));
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
					gui.click(x, y, button);
				end
			end
		else
			local coll = {			};
			local world = bump.newWorld(48);
			local playing = {
				name = "playing"
			};
			local player = {			};
			local tile;
			local gui;
			tileset = {			};
			local move = 0;
			local mx, my = -1, -1;
			tileset.switched = false;
			tileset.name = "tileset";
			function tileset.draw()
				local self = tileset;
				push:start();
				self.gui:background();
				self.gui:draw();
				push:finish();
			end
			local up;
			local down;
			local left;
			local right;
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
				self.gui:clean();
			end
			function playing.switchto()
				if (not playing.switched) then
					local self = playing;
					self.gui = GUI.GUI();
					self.scrollable = GUI.ScrollableArea(0, 0, 100, 100, 300, 300, 0, 0);
					self.scrollable:add(GUI.TextBoxButton(50, 50, {
						1, 
						0, 
						1, 
						1
					}, 100, 100, 36, "Testing", true));
					self.layeredMap = main.layeredMap;
					self.button = GUI.TextBoxButton(240*2, 0, {
						0, 
						0, 
						1, 
						1
					}, 1920-(240*4), 100, 36, "Tilemap Editor", true);
					self.gui:add(self.button);
					self.button:onClick(function(self, x, y)
						gamestate.switch(main);
					end);
					self.layeredMap = GUI.BasicLayeredTileMap(0, 100, 2, 2, main.newMap);
					self.gui:add(self.layeredMap);
					if (love.system.getOS()=="Android") then
						up = GUI.HoverTextBox(800, 500, {
							0, 
							0, 
							1, 
							1
						}, 100, 200, 36, "Up");
						down = GUI.HoverTextBox(800, 800, {
							0, 
							0, 
							1, 
							1
						}, 100, 200, 36, "Down");
						left = GUI.HoverTextBox(600, 700, {
							0, 
							0, 
							1, 
							1
						}, 200, 100, 36, "Left");
						right = GUI.HoverTextBox(900, 700, {
							0, 
							0, 
							1, 
							1
						}, 200, 100, 36, "Right");
					end
					self.gui:add(up);
					self.gui:add(down);
					self.gui:add(left);
					self.gui:add(right);
				end
				playing.switched = true;
			end
			local function whatCollider(item, other)
				if other.collision then
					return "slide";
				else
					return "cross";
				end
			end
			function playing.update(dt)
				local collisionOut = main.layeredMap.map:collisionOut();
				for x = 1, #main.map.map.data, 1 do
					for y = 1, #main.map.map.data[(x)], 1 do
						coll[(x)][(y)].collision = collisionOut[(x)][(y)];
					end
				end
				local x = 0;
				local y = 0;
				if (love.system.getOS()=="Android") then
					local touches = love.touch.getTouches();
					local upped = false;
					local downed = false;
					local lefted = false;
					local speed = 3;
					local righted = false;
					for k, v in ipairs(touches) do
						local rx, ry = love.touch.getPosition(v);
						rx, ry = push.toGame(rx, ry);
						if (not upped and up:containsPoint(rx, ry)) then
							upped = true;
							y = y + -24*speed;
						end
						if (not downed and down:containsPoint(rx, ry)) then
							downed = true;
							y = y + 24*speed;
						end
						if (not lefted and left:containsPoint(rx, ry)) then
							lefted = true;
							x = x + -24*speed;
						end
						if (not righted and right:containsPoint(rx, ry)) then
							righted = true;
							x = x + 24*speed;
						end
					end
				else
					if love.keyboard.isDown("w") then
						y = y + -24;
					end
					if love.keyboard.isDown("s") then
						y = y + 24;
					end
					if love.keyboard.isDown("a") then
						x = x + -24;
					end
					if love.keyboard.isDown("d") then
						x = x + 24;
					end
				end
				playing.scrollable:scroll(x*dt, y*dt);
				player.ttx, player.tty = world:move(player, player.ttx+(x*dt), player.tty+(y*dt), whatCollider);
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
				playing.gui:update(dt, x, y);
				playing:update(dt, x, y);
			end
			function playing.draw()
				push:start();
				playing.gui:background();
				playing.gui:draw();
				playing.scrollable:draw();
				love.graphics.rectangle("fill", player.ttx*2, 2*player.tty+100, 48, 48);
				push:finish();
			end
			function tileset.switchto()
				if (not tileset.switched) then
					local self = tileset;
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
					self.gui:add(self.map);
					self.gui:add(self.button);
					self.map.map:setDebug(true);
					self.map.interact = true;
				end
				tileset.switched = true;
			end
			function main.draw()
				push:start();
				main.gui:background();
				main.gui:draw();
				push:finish();
			end
			local index = 0;
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
				main.gui:update(dt, x, y);
				main.gui:clean();
			end
			main.switched = false;
			function main.switchto()
				local self = main;
				if (not main.switched) then
					main.map = GUI.BasicTileMap(20, 20, 2, 2, GameData.Default.TileMaps.SecondTileMap);
					main.map2 = GUI.BasicTileMap(20, 20, 2, 2, GameData.Default.TileMaps.DefaultTileMap);
					tileset.map = GUI.BasicTileMap(20, 20, 2, 2, GameData.Default.TileMaps.DefaultTileset);
					local newMap = LayeredTileMap(9, 9, 0);
					self.newMap = newMap;
					newMap.layers[(1)] = GameData.Default.TileMaps.DefaultTileMap;
					newMap.layers[(2)] = GameData.Default.TileMaps.SecondTileMap;
					tile = main.map.map:newBasicTile();
					local textboxbutton = GUI.TextBoxButton(240*2, 0, {
						0, 
						0, 
						1, 
						1
					}, 1920-(240*4), 100, 36, "Tileset Picker", true);
					local textboxbutton2 = GUI.TextBoxButton(1920-(240*2), 0, {
						0, 
						0, 
						1, 
						1
					}, 240*2, 100, 36, "Background Layer", true);
					local textboxbutton3 = GUI.TextBoxButton(1920-(240*2), 100, {
						0, 
						0, 
						1, 
						1
					}, 240*2, 100, 36, "Front Layer", true);
					local textboxbutton4 = GUI.TextBoxButton(1920-(240*2), 200, {
						0, 
						0, 
						1, 
						1
					}, 240*2, 100, 36, "Playing", true);
					textboxbutton:onClick(function(self, x, y)
						gamestate.switch(tileset);
					end);
					textboxbutton4:onClick(function(self, x, y)
						gamestate.switch(playing);
					end);
					textboxbutton2:onClick(function(self, x, y)
						gui.children[(index)] = main.map2;
					end);
					textboxbutton3:onClick(function(self, x, y)
						gui.children[(index)] = main.map;
					end);
					gui = GUI.GUI();
					main.gui = gui;
					index = gui:add(main.map);
					gui:add(textboxbutton);
					gui:add(textboxbutton2);
					gui:add(textboxbutton3);
					gui:add(textboxbutton4);
					textboxbutton2:onClick(function(self, x, y)
						gui.children[(index)] = main.map2;
					end);
					textboxbutton3:onClick(function(self, x, y)
						gui.children[(index)] = main.map;
					end);
					main.layeredMap = GUI.BasicLayeredTileMap(600, 200, 2, 2, newMap);
					gui:add(self.layeredMap);
					main.map.interact = true;
					main.map.map:setDebug(true);
					main.map2.interact = true;
					main.map2.map:setDebug(true);
					main.map:onClick(function(self, x, y)
						self.map.data[(x)][(y)] = tile:cloneTile();
					end);
					main.map2:onClick(function(self, x, y)
						self.map.data[(x)][(y)] = tile:cloneTile();
					end);
					tileset.map:onClick(function(self, x, y)
						tile = self.map.data[(x)][(y)]:cloneTile();
					end);
					local collisionOut = main.layeredMap.map:collisionOut();
					for x = 1, #main.map.map.data, 1 do
						coll[(x)] = {						};
						for y = 1, #main.map.map.data[(x)], 1 do
							coll[(x)][(y)] = {
								collision = collisionOut[(x)][(y)]
							};
							world:add(coll[(x)][(y)], (x-1)*24+1, (y-1)*24+1, 22, 22);
						end
					end
					world:add(player, 4*24, 4*24, 24, 24);
					player.ttx = 4*24;
					player.tty = 4*24;
				end
				main.switched = true;
				self.layeredMap:setDebug(true);
				self.gui:clean();
			end
			function main.mousereleased(x, y, button, istouch, presses)
				local x, y = love.mouse.getPosition();
				local x, y = push.toGame(x, y);
				if x and y then
					gui.click(x, y, button);
				end
			end
		end
		function love.quit()
			
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
			GameData.Default.TileMaps.SecondTileMap:extend(2, 2, 2, 2, function()
				local DefaultTile = Tile:new();
				DefaultTile[('id')] = 'Empty';
				DefaultTile[('prefix')] = 'Default';
				DefaultTile[('type')] = 'Basic_Tile';
				DefaultTile[('tileset')] = 'DefaultTileset';
				DefaultTile[('tilesetPrefix')] = 'Default';
				return DefaultTile;
			end);
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
	["assets.DefaultTileset"] = function()
		local function generateQuad24X(x, y, tileset)
			return love.graphics.newQuad(1+((x-1)*25), 1+((y-1)*25), 24, 24, tileset);
		end
		local TileMap = import("libs.TileMap");
		local Tile = import("libs.tile");
		return function(GameData)
			local canvas = love.graphics.newCanvas(24, 24);
			GameData.Default.Images.Empty = canvas;
			love.graphics.setCanvas(canvas);
			love.graphics.clear(0, 0, 0, 0);
			love.graphics.setCanvas();
			local emptyQuad = love.graphics.newQuad(0, 0, 24, 24, canvas);
			local orderedTable = {			};
			GameData.Default.Tiles.DefaultTileset = setmetatable({			}, {
				__newindex = function(tbl, key, value)
					table.insert(orderedTable, {
						key, 
						value
					});
					local coll = false;
					rawset(tbl, key, {
						quad = value, 
						collision = coll
					});
				end
			});
			GameData.Default.Tiles.DefaultTileset.EmptyCollider = emptyQuad;
			GameData.Default.Tiles.DefaultTileset.Empty = emptyQuad;
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
			rawset(GameData.Default.Tiles.DefaultTileset, "EmptyCollider", {
				quad = emptyQuad, 
				collision = true
			});
			rawset(GameData.Default.Tiles.DefaultTileset, "Empty", {
				quad = emptyQuad, 
				collision = false
			});
			local out = {			};
			for k, v in ipairs(orderedTable) do
				local t = Tile();
				t.sx = 1;
				t.sy = 1;
				t.id = v[(1)];
				t.prefix = "Default";
				if (v[(2)]==emptyQuad) then
					t.tileset = "DefaultTileset";
					t.type = "Utility_Tile";
				else
					t.type = "Basic_Tile";
					t.tileset = "DefaultTileset";
				end
				t.tilesetPrefix = "Default";
				table.insert(out, t);
			end
			GameData.Default.TileMaps.DefaultTileset = TileMap.fromTable(out);
			GameData.Default.TileMaps.DefaultTileset.name = "DefaultTileset";
		end;
	end,
}
if _modules["main"] then
	import("main")
else
	error("File \"main.clue\" was not found!")
end