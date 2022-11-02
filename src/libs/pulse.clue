local Class = require("libs.class")
local pulse = Class("Pulse")

method pulse::first(event, id, ...) {
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
    for k, v of events {
        self.events[v]={}
        self.cache[v]={}
    }
}

method pulse::newEvent(event) {
    self.events[event]={}
}
method pulse::removeEvent(event) {
    self.events[event]=nil
}
method pulse::onEvent(event,id, func) {
    self.events[event][id]=func
}
method pulse::removeOnEvent(event, id) {
    self.events[event][id]=nil
}
method pulse::emit(event, ...) {
    self.cache={}
    for k, v of self.events {
        self.cache[k]={}
    }
    for k, v of self.events[event] {
        if (!self.cache[event][k]) {
            v(...)
            self.cache[event][k]=true
        }
    }
}