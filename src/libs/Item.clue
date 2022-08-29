global Class = require("libs.class")
global log = import("libs.log")
global dump = require("libs.dump")
local json = require("libs.json")
local Item = Class("Item")
local Weapon = nil
local GameData = import("libs.GameData")
//String
//Item.id
//Default Value: ""
//When instantiated, should be assigned string id
Item.id=""

//String
//Item.type
//Default Value: "Item"
//When instantiated, should not be altered unless a special item type.
//If this is a case, should be set to appropriate value for item type.
//TRANSIENT
Item.type="Item"

//String
//Item.prefix
//Default Value: "Default"
//When instantiated by vanilla game, should not be altered.
//When instantiated by a mod, should be altered to mod id
Item.prefix="Default"

//String
//Item.name
//Default Value: "New Item"
//When instantiated, should be set to Item's name value according to current language
//TRANSIENT
Item.name="New Item"

//Quad
//Item.quad
//Represent the sprite/image for this item
//TRANSIENT
Item.quad=nil

//Item
//Returns an Item instance generated from JSON data for an item.
//Will Error on anything that is not Item JSON data
//Paramaters:
//String data
//JSON data within a string for an Item.

//Returns:
//1: Item in lowest applicable type in the Item class tree.:
//i.e. if choosing between Item and Weapon, and weapon is applicable, returns a weapon.
method Item.loadSubclasses() {
    log.custom("ITEM", "Loading Subclasses:")
    Weapon = import("libs.Weapon")
    log.custom("ITEM", "All Subclasses Loaded. ")

}
//String
//Returns an Items name from the GameData table
//TODO: IMPLEMENT LANGUAGE SWITCHING
//Paramaters:
//Item: any instantiated item.
//May be called as item_instance::getName() or Item.getName(item)
method Item.getName(item) {
    return GameData[item.prefix].Items[item.id].name_en


}
method Item.handle(item, data) {



        item.prefix=data.prefix
        item.id=data.id
        item.type=GameData[item.prefix].Items[item.id].type
        item.name=item::getName()


    return item
}

method Item.fromJSON(data) {
    if type(data)!="string" {
        error("Not a string.")
    }
    local dataInTable=json.decode(data)
    local type=GameData[dataInTable.prefix].Items[dataInTable.id].type
    if (type=="Item") {
        local newItem = Item::new()
        return Item.handle(newItem, dataInTable)

    } elseif (type=="Weapon") {
        local newWeapon = Weapon::new()
        Item.handle(newWeapon, dataInTable)
        return Weapon.handle(newWeapon, dataInTable.WeaponData)
    }
}
//String
//Returns
method Item::toJSON() {
    local data={}
    data.id=self.id
    data.prefix=self.prefix
    if self.type=="Weapon" {
        data.WeaponData={}
        data.WeaponData.sharpened=self.sharpened

    }

    return json.encode(data)

}
log.custom("ITEM", "Initial Log Complete")
return Item