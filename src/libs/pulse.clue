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
    if (type(events)!="table" && type(events)!="nil") {error("Invalid Arugment #1 events: Expected Type Nil Or Function, Got Type: " .. type(events))}
    self.events={}
    self.cache={}
    for k, v of events {
        self.events[v]={}
        self.cache[v]={}
    }
}

method pulse::newEvent(event) {
    if (type(event)=="nil") {error("Invalid Argument #1 event: Argument Cannot Be Nil")}
    self.events[event]={}
}
method pulse::removeEvent(event) {
    if (type(event)=="nil") {error("Invalid Argument #1 event: Argument Cannot Be Nil")}
    self.events[event]=nil
}
method pulse::onEvent(event,id, func) {
    if (type(event)=="nil") {error("Invalid Argument #1 event: Argument Cannot Be Nil")}
    if (type(id)=="nil") {error("Invalid Argument #2 id: Argument Cannot Be Nil")}
    if (type(func)!="function") {error("Invalid Argument #3 func: Expected Type Function, Got Type: " .. type(func))}
    self.events[event][id]=func
}
method pulse::removeOnEvent(event, id) {
    if (type(event)=="nil") {error("Invalid Argument #1 event: Argument Cannot Be Nil")}
    if (type(id)=="nil") {error("Invalid Argument #2 id: Argument Cannot Be Nil")}
    self.events[event][id]=nil
}
method pulse::emit(event, ...) {
    if (type(event)=="nil") {error("Invalid Argument #1 event: Argument Cannot Be Nil")}
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