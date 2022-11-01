local Class = require("libs.class")
local pulse = Class("Pulse")

method pulse::first(event, id) {
    if (self.events[event][id] && !self.cache[event][req]) {
        self.events[event][id]()
    } elseif (self.cache[event][id]) {
        
    } else {
        error("No Function Found with ID: " .. id)
    }
}
method pulse::initialize(events) {
    self.events={}
    self.cache={}
    for k, v in events {
        self.events[v]={}
        self.cache[v]={}
    }
}

method pulse::newEvent(event) {
    self.events[event]={}
}

method pulse::onEvent(event,id, func)