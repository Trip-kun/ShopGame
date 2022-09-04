local gamestate={}
//IMPORTS OF RELEVANT LIBRARIES
global log = import("libs.log")


//Local variable used to hold data bout the current state
local currstate={name="initialstate"}
//Function used to switch the callbacks within the global love to a different set of callbacks. Used for menu navigation, loading logos, etc.
//Gamestates can be identified by their state.name property, which should be unique/.
method gamestate.switch(state) {
    //Set the local names of the new and old gamestates to avoid concatenation errors while writing to the log.
    local statename = state.name || "NONAME"
    local currstatename = currstate.name || "NONAME"
    log.custom("GAMESTATE", "Switching To State: " .. statename  .. " from state: " .. currstatename)
    //Call the old gamestate's "switchaway" function if available
    if currstate.switchaway {
        currstate.switchaway()
    }
    //Call the new gamestate's "switchto" function if available
    if state.switchto {
        state.switchto()
    }
    //Replace love callbacks with those of the new gamestate
    //Will not null out callbacks used in the old gamestate and not in the new one
    //Protects love.quit, which should be specially handled.
    for k, v of state {
        if k!='content' && k!='name' && k!='switchaway' && k!='switchto' && k!='quit' {
            love[k]=v
        }

    }
    //Sets the current gamestate variable to the new gamestate
    currstate=state
}
//Method used to get the name of the currently active state.
method gamestate.getStateName() {
    return currstate.name
}
log.custom("GAMESTATE", "Loaded")
//Return data to file that required this file.
return gamestate