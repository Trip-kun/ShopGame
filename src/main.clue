global mode = import("conf")
local push=require("libs.push")
local windowWidth, windowHeight = love.window.getDesktopDimensions()
push.setupScreen(1920, 1080, {canvas=true, upscale="normal", resizable=true})
global util = nil
global log = nil
global splash=nil
global gamestate=nil
global talkies = nil
global wait = nil
global vars = {}
global dump = nil
global settings = nil
global class = nil
global Item = nil
global Weapon = nil
global logo = nil
global player = {100, 100, 24, 24, 0, 0}
global bump = nil
global Tile = nil
global TileMap = nil
global GUI=nil
global GameData = nil
local fn loadLibraries () {
            global util = import("libs.util.util")
            global log = import("libs.log")
            global splash = require("libs.splash")
            global gamestate = import("libs.util.gamestate")
            global talkies = require("libs.talkies")
            global wait = import("libs.util.wait")
            global dump = require("libs.dump")
            global settings = import("libs.util.settings")
            global class = require("libs.class")
            global Item = import("libs.Item")
            global bump = require("libs.bump")
            global Tile = import("libs.tile")
            global TileMap = import("libs.TileMap")
            global GameData=import("libs.GameData")
            global LayeredTileMap=import("libs.LayeredTileMap")
            local mathExtensions=import("libs.util.Math")
            for k, v of mathExtensions {
                math[k]=v

            }
            global GUI=import("libs.gui.gui")
            GUI.register("BasicButton", import("libs.gui.elements.BasicButton"))
            GUI.register("BasicDrawable", import("libs.gui.elements.BasicDrawable"))
            GUI.register("BasicTileMap", import("libs.gui.elements.BasicTileMap"))
            GUI.register("InvisibleButton", import("libs.gui.elements.InvisibleButton"))
            GUI.register("TextBox", import("libs.gui.elements.TextBox"))
            GUI.register("TextBoxButton", import("libs.gui.elements.TextBoxButton"))
            GUI.register("GUI", import("libs.gui.elements.Wrapper"))
}
method love.resize(w, h) {
push.resize(w, h)
}
local logo1= {
    name="secondlogo"
}

local splashscreen = nil
method logo1.draw() {
        push::start()
        splashscreen::draw()
        push::finish()
}
method logo1.update(dt) {
        splashscreen::update(dt)
        wait.update()
}

local main= {
    name="main"
}

if (mode=="editor") {
    local gui
    local Title
    local textboxbutton
    local textboxbutton2
    local textboxbutton3
    method main.draw() {
        push::start()
        //love.graphics.scale((10+textboxbutton.clicks)/10, (10+textboxbutton.clicks)/10)
        gui::draw()
        push::finish()
    }

    method main.update(dt) {
        local x, y = love.mouse.getPosition()
        local x, y = push.toGame(x, y)
        if (love.system.getOS()=="Android") {
            local touches=love.touch.getTouches()
            if #touches==0 {
                x, y = -1, -1
            }
        }
        x=x || -1
        y=y || -1
        gui::update(dt, x, y)
        gui::clean()
    }
    method main.switchto() {
        gui=GUI.GUI()
        Title=GUI.TextBox(240, 0, {1, 0, 1, 1}, 1920-(240*2), 100, 36, "NAME NOT YET DISCOVERED", "center")
        textboxbutton=GUI.TextBoxButton(240*2, 200, {0, 0, 1, 1}, 1920-(240*4), 75, 28, "Current Clicks: 0", true)
        textboxbutton.clicks=0
        textboxbutton::onClick(fn (self) {
            self.clicks+=1
            self::updateText("Current Clicks: " .. self.clicks)

        })
        textboxbutton2=GUI.TextBoxButton(240*2, 300, {math.random(), math.random(), math.random(), 1}, 1920-(240*4), 75, 28, "Reset Clicks", true)
        textboxbutton2.clicks=0
        textboxbutton2::onClick(fn (self) {
            textboxbutton.clicks=0
            textboxbutton::updateText("Current Clicks: " .. self.clicks)

        })
        textboxbutton3=GUI.TextBoxButton(240*2, 400, {math.random(), math.random(), math.random(), 1}, 1920-(240*4), 75, 28, "New Color", true)
        textboxbutton3.clicks=0
        textboxbutton3::onClick(fn (self) {
            textboxbutton2.color={math.random(), math.random(), math.random(), 1}

        })
        gui::add(Title)
        gui::add(textboxbutton)
        gui::add(textboxbutton2)
        gui::add(textboxbutton3)
    }
    method main.mousereleased(x, y, button, istouch, presses) {
        local x, y = love.mouse.getPosition()
        local x, y = push.toGame(x, y)
        if x && y {
            gui.click(x, y, button)
        }

    }
} else {
       local tile
       local gui
       tileset={}
       local move=0
       local mx, my = -1, -1
       tileset.switched=false
       tileset.name="tileset"
       method tileset.draw() {
           local self = tileset
           push::start()
               self.gui::background()
               self.gui::draw()

               //love.graphics.print("Hello World")
           push::finish()

       }
       method tileset.update(dt) {
           local self = tileset
           local x, y = love.mouse.getPosition()
           local x, y = push.toGame(x, y)
           if (love.system.getOS()=="Android") {
                       local touches=love.touch.getTouches()
                       if #touches==0 {
                           x, y = -1, -1
                       }
                   }
           local x=x || -1
           local y=y || -1
           self.gui::update(dt, x, y)
           self.gui::clean()
       }
       method tileset.switchto() {
           if (!tileset.switched) {

               local self = tileset

               self.button=GUI.TextBoxButton(240*2, 0, {0, 0, 1, 1}, 1920-(240*4), 100, 36, "Tilemap Editor", true)

                           self.button::onClick(fn (self, x, y) {
                               gamestate.switch(main)


                           })
                   self.gui=GUI.GUI()
                   self.gui::add(self.map)
                   self.gui::add(self.button)

                       self.map.map::setDebug(true)
                       self.map.interact=true
           }
           tileset.switched=true
       }
       method main.draw() {
           push::start()
           //love.graphics.print("Hello World!")
           //local r, g, b, a = love.graphics.getColor()
           gui::background()
           gui::draw()
           //love.graphics.setColor(1, 0, 1, 1)
           //love.graphics.rectangle("fill", mx, my, 24, 24)
           //love.graphics.setColor(r, g, b, a)
           push::finish()
       }

       method main.update(dt) {
           wait.update()
           local x, y = love.mouse.getPosition()
           local x, y = push.toGame(x, y)
           if (love.system.getOS()=="Android") {
                       local touches=love.touch.getTouches()
                       if #touches==0 {
                           x, y = -1, -1
                       }
                   }
           local x=x || -1
           local y=y || -1
           gui::update(dt, x, y)
           gui::clean()
       }
       main.switched=false
       method main.switchto() {
           if (!main.switched) {
           main.map=GUI.BasicTileMap(20, 20, 2, 2, GameData.Default.TileMaps.DefaultTileMap)
           tileset.map=GUI.BasicTileMap(20, 20, 2, 2, GameData.Default.TileMaps.DefaultTileset)

           tile=main.map.map::newBasicTile()
                   local textboxbutton=GUI.TextBoxButton(240*2, 0, {0, 0, 1, 1}, 1920-(240*4), 100, 36, "Tileset Picker", true)

               textboxbutton::onClick(fn (self, x, y) {
                   gamestate.switch(tileset)


               })
       gui=GUI.GUI()
       gui::add(main.map)
       gui::add(textboxbutton)
           main.map.interact=true
           main.map.map::setDebug(true)
           main.map::onClick(fn (self, x, y) {
               self.map.data[x][y]=tile::cloneTile()
           })
           tileset.map::onClick(fn (self, x, y) {
                       tile=self.map.data[x][y]::cloneTile()
                   })
           }
           main.switched=true
       }
       method main.mousereleased(x, y, button, istouch, presses) {
               local x, y = love.mouse.getPosition()
               local x, y = push.toGame(x, y)
               if x && y {
                   gui.click(x, y, button)
               }

           }
   }
method love.quit() {
//log.info(GameData['Default']['TileMaps']['DefaultTileMap']::toLua())
}
//Called Once Before the main love.run loop
method love.load() {
        love.mouse.setVisible(true)
        loadLibraries()
        Tile.loadGameData()
        local newData={}
        newData[1]={}
        newData[1][5]=Tile::new()
        newData[1][5].id="DirtULGrassDR"
        //GameData.Default.TileMaps.DefaultTileMap::loadEdits(newData)
        //GameData.Default.TileMaps.DefaultTileMap::prepare(GameData.Default.Images.DefaultTileset)
        GameData.Default.TileMaps.DefaultTileMap::extend(2, 2, 2, 2)
        Item.loadSubclasses()
        global Weapon = import("libs.Weapon")
        local FirstWeapon = Weapon::new()
        FirstWeapon.id="BasicSword"
        FirstWeapon.type="Weapon"
        FirstWeapon.sharpened=true
        //log.info(dump.dump2(FirstWeapon))
        local WeaponData=FirstWeapon::toJSON()
        //log.info(dump.dump2(WeaponData))
        //log.info(GameData.Default.TileMaps.DefaultTileMap::toClue())
        //log.info(dump.dump2(Item.fromJSON(WeaponData)))
        //GameData.Default.TileMaps.DefaultTileMap=GameData.Default.TileMaps.DefaultTileset
        //log.info(GameData.Default.TileMaps.DefaultTileMap::toClue())
        talkies.optionCharacter=""
        talkies.padding=0
        talkies.backgroundColor={0, 0, 0, 0}
        log.info("Fully Loaded")
        local intro = love.audio.newSource("assets/intro.mp3", "static")
        global logo = love.graphics.newImage("assets/logo.png")
        //log.info(dump.dump2(GameData.Default.TileMaps.DefaultTileset::collisionOut()))
       wait(4, fn () { talkies.onAction()})
       intro::play()
       local talkies_text = ""
       if (mode=="editor") {
        talkies_text="Shop Game Thing Tileset Editor\nBy Trip-kun\nGithub: https://github.com/Trip-kun/"

       } else {
        talkies_text="Shop Game Thing\nBy Trip-kun\nGithub: https://github.com/Trip-kun/"

       }
       talkies.say("", talkies_text, {image=logo, oncomplete= fn () {
           intro::release()
           if (love.system.getOS()=="Android") {
            gamestate.switch(main)
            love.graphics.setColor(1, 1, 1, 1)
           } else {
           splashscreen=splash({fill="rain"});
           splashscreen.onDone = fn () { love.graphics.setColor(1, 1, 1, 1) gamestate.switch(main) }

           gamestate.switch(logo1)
           }
       }})
}

// Contains All Graphical Calls
method love.draw() {
    push::start()
    talkies.draw(3)
    push::finish()
}

// Is used for physics or other time-based function calls
// Also used for anything else that needs updating.
method love.update(dt) {
    wait.update()
    talkies.update(dt)
}