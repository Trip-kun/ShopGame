//Prints a log message to the Console and stdout
//level -> A string representing the log level of the message
// Should be one of the following:
// FATAL, ERROR, WARN, INFO
//msg -> A string with the log message
local fn Log(level, msg) {
    //io.write("[" .. level .. "] " .. msg .. "\n")
    if (type(level)!=string) {error("Invalid Argument #1 level: Expected Type String, Got Type: " .. type(level))}
    if (type(msg)!=string) {error("Invalid Argument #2 msg: Expected Type String, Got Type: ".. type(msg))}
    print("[" .. level .. "] " .. msg)
}

log = {}


// Calls log as a warning
//msg -> A string with the log message.
method log.warn(msg) {
    Log("WARN", msg)
}

// Calls log as info
//msg -> A string with the log message.
method log.info(msg) {
    Log("INFO", msg)
}

// Calls log as an error
//msg -> A string with the log message.
method log.error(msg) {
    Log("ERROR", msg)
}

// Calls log as a FATAL ERROR
//msg -> A string with the log message.
method log.fatal(msg) {
    Log("FATAL", msg)
}

log.custom=Log;
log.custom("LOG", "Loaded")
return log