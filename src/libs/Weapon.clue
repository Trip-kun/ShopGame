global Class = require("libs.class")
local Item = import("libs.Item")
local Weapon = Item::subclass("Weapon")
local GameData=import("libs.GameData")
//Number
//Weapon.damage
//Represents how much damage a weapon does.
//When instantiated should be set to the appropriate number for the weapon.
//TRANSIENT - NOT SERIALIZED
Weapon.damage=0

//BOOLEAN
//Weapon.sharpened
//Represents whether or not a weapon is sharpened
//When instantiated should be set to false unless loading from previous data saying otherwise
//SERIALIZED
Weapon.sharpened=false

method Weapon.handle(weapon, data) {
    weapon.damage=GameData[weapon.prefix].Items[weapon.id].damage
    weapon.sharpened=data.sharpened

    return weapon
}

return Weapon