local gamestate={}
local currstate={name="firstlogo"}
global log = import("libs.log")
method gamestate.switch(state) {
    local statename = state.name || "NONAME"
    local currstatename = currstate.name || "NONAME"
    log.custom("GAMESTATE", "Switching To State: " .. statename  .. " from state: " .. currstatename)
    if currstate.switchaway {
        currstate.switchaway()
    }
    if state.switchto {
        state.switchto()
    }
    for k, v of state {
        if k!='content' && k!='name' && k!='switchaway' && k!='switchto' && k!='quit' {
            love[k]=v
        }

    }
    currstate=state
}
method gamestate.getStateName() {
    return currstate.name
}
log.custom("GAMESTATE", "Loaded")

return gamestate