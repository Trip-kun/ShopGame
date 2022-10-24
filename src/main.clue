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
global bump = require("libs.bump")
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
            GUI.register("BasicLayeredTileMap", import("libs.gui.elements.BasicLayeredTileMap"))
            GUI.register("HoverTextBox", import("libs.gui.elements.HoverTextBox"))

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
        local coll={}
               local world = bump.newWorld(48)
       local playing={name="playing"}
       local player={}
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
       local up
       local down
       local left
       local right
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
       method playing.switchto() {
        if (!playing.switched) {
            local self = playing
            self.gui=GUI.GUI()

            self.layeredMap=main.layeredMap

            self.button=
            GUI.TextBoxButton(240*2, 0, {0, 0, 1, 1}, 1920-(240*4), 100, 36, "Tilemap Editor", true)
            self.gui::add(self.button)
                                       self.button::onClick(fn (self, x, y) {
                                           gamestate.switch(main)


                                       })
            self.layeredMap=GUI.BasicLayeredTileMap(0, 100, 2, 2, main.newMap)
                               self.gui::add(self.layeredMap)
if (love.system.getOS()=="Android") {
                         up = GUI.HoverTextBox(800, 500, {0, 0, 1, 1}, 100, 200, 36, "Up")
                        down = GUI.HoverTextBox(800, 800, {0, 0, 1, 1}, 100, 200, 36, "Down")
                         left = GUI.HoverTextBox(600, 700, {0, 0, 1, 1}, 200, 100, 36, "Left")
                         right = GUI.HoverTextBox(900, 700, {0, 0, 1, 1}, 200, 100, 36, "Right")
                    }
                    self.gui::add(up)
                    self.gui::add(down)
                    self.gui::add(left)
                    self.gui::add(right)
        }
        playing.switched=true
       }
       local fn whatCollider(item, other) {
                   if other.collision {

                       return "slide"
                   } else {
                       return "cross"
                   }
              }
       method playing.update(dt) {

            local collisionOut=main.layeredMap.map::collisionOut()
                               for x=1,#main.map.map.data {
                                        for y=1, #main.map.map.data[x] {
                                            coll[x][y].collision=collisionOut[x][y]

                                        }
                                          }

            local x = 0
            local y = 0
            if (love.system.getOS()=="Android") {
                                    local touches=love.touch.getTouches()
                                    local upped=false
                                    local downed=false
                                    local lefted=false
                                    local speed=3
                                    local righted=false
                                    for k, v in touches {
                                    local rx,ry = love.touch.getPosition(v)
                                    rx,ry=push.toGame(rx,ry)
                                    if (!upped && up::containsPoint(rx,ry)) {
                                        upped=true
                                        y+=-24*speed
                                    }
                                if (!downed && down::containsPoint(rx,ry)) {

                                        downed=true
                                        y+=24*speed
                                    }

                                if (!lefted && left::containsPoint(rx,ry)) {
                                        lefted=true
                                        x+=-24*speed
                                    }
                                if (!righted && right::containsPoint(rx,ry)) {
                                        righted=true
                                        x+=24*speed
                                    }
                                    }
                                } else {
            if love.keyboard.isDown("w") {
                y+=-24
            }
            if love.keyboard.isDown("s") {
                y+=24
            }
            if love.keyboard.isDown("a") {
                x+=-24
            }
            if love.keyboard.isDown("d") {
                x+=24
            }
            }
            player.ttx, player.tty = world::move(player, player.ttx+ (x*dt), player.tty+ (y*dt), whatCollider)
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
            playing.gui::update(dt, x, y)
       }
       method playing.draw() {
       push::start()
        playing.gui::background()
                   playing.gui::draw()
        love.graphics.rectangle("fill", player.ttx*2, 2*player.tty+100, 48, 48)
        push::finish()
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
           main.gui::background()
           main.gui::draw()
           //love.graphics.setColor(1, 0, 1, 1)
           //love.graphics.rectangle("fill", mx, my, 24, 24)
           //love.graphics.setColor(r, g, b, a)
           push::finish()
       }
        local index = 0;
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
           main.gui::update(dt, x, y)
           main.gui::clean()
       }


       main.switched=false
       method main.switchto() {
           local self=main
           if (!main.switched) {

           main.map=GUI.BasicTileMap(20, 20, 2, 2, GameData.Default.TileMaps.SecondTileMap)
           main.map2=GUI.BasicTileMap(20, 20, 2, 2, GameData.Default.TileMaps.DefaultTileMap)
           tileset.map=GUI.BasicTileMap(20, 20, 2, 2, GameData.Default.TileMaps.DefaultTileset)
            local newMap= LayeredTileMap(9, 9, 0)
            self.newMap = newMap
            newMap.layers[1]=GameData.Default.TileMaps.DefaultTileMap
            newMap.layers[2]=GameData.Default.TileMaps.SecondTileMap

           tile=main.map.map::newBasicTile()
                   local textboxbutton=GUI.TextBoxButton(240*2, 0, {0, 0, 1, 1}, 1920-(240*4), 100, 36, "Tileset Picker", true)
                   local textboxbutton2=GUI.TextBoxButton(1920-(240*2), 0, {0, 0, 1, 1}, 240*2, 100, 36, "Background Layer", true)
                   local textboxbutton3=GUI.TextBoxButton(1920-(240*2), 100, {0, 0, 1, 1}, 240*2, 100, 36, "Front Layer", true)
                   local textboxbutton4=GUI.TextBoxButton(1920-(240*2), 200, {0, 0, 1, 1}, 240*2, 100, 36, "Playing", true)
               textboxbutton::onClick(fn (self, x, y) {
                   gamestate.switch(tileset)


               })
               textboxbutton4::onClick(fn (self, x, y) {
                                  gamestate.switch(playing)


                              })
               textboxbutton2::onClick(fn (self, x, y) {
                    gui.children[index]=main.map2
               })
                textboxbutton3::onClick(fn (self, x, y) {
                    gui.children[index]=main.map
                })
       gui=GUI.GUI()
       main.gui=gui
       index = gui::add(main.map)
       gui::add(textboxbutton)
       gui::add(textboxbutton2)
       gui::add(textboxbutton3)
       gui::add(textboxbutton4)
       textboxbutton2::onClick(fn (self, x, y) {
                           gui.children[index]=main.map2
                      })
                       textboxbutton3::onClick(fn (self, x, y) {
                           gui.children[index]=main.map
                       })
                       main.layeredMap=GUI.BasicLayeredTileMap(600, 200, 2, 2, newMap)
       gui::add(self.layeredMap)
           main.map.interact=true
           main.map.map::setDebug(true)
           main.map2.interact=true
           main.map2.map::setDebug(true)
           main.map::onClick(fn (self, x, y) {
               self.map.data[x][y]=tile::cloneTile()
           })
           main.map2::onClick(fn (self, x, y) {
                          self.map.data[x][y]=tile::cloneTile()
                      })
           tileset.map::onClick(fn (self, x, y) {
                       tile=self.map.data[x][y]::cloneTile()
                   })

                   local collisionOut=main.layeredMap.map::collisionOut()
                   for x=1,#main.map.map.data {
                            coll[x]={}
                            for y=1, #main.map.map.data[x] {
                                coll[x][y]={collision=collisionOut[x][y]}
                                world::add(coll[x][y], (x-1)*24+1, (y-1)*24+1, 22, 22)
                            }
                              }
                              world::add(player, 4*24, 4*24, 24, 24)
                              player.ttx=4*24
                              player.tty=4*24
           }

           main.switched=true

           self.layeredMap::setDebug(true)
           self.gui::clean()
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
        GameData.Default.TileMaps.SecondTileMap::extend(2, 2, 2, 2, fn () {local DefaultTile=Tile::new()
            DefaultTile['id']='Empty'
            DefaultTile['prefix']='Default'
            DefaultTile['type']='Basic_Tile'
            DefaultTile['tileset']='DefaultTileset'
            DefaultTile['tilesetPrefix']='Default'
            return DefaultTile
        })
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