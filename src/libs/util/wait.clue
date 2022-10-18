local waitTable={}
global log = import("libs.log")
local wait = {

meta call = fn (self, seconds, func, args) {
   table.insert(waitTable, {love.timer.getTime()+seconds, func, args})
 }
}
method wait.update() {
    for k, v of waitTable {
        if love.timer.getTime()>=v[1] {
            if v[2] {
                v[2](v[3])
            }
            table.remove(waitTable, k)
        }
    }
}
log.custom("WAIT", "Loaded")
return wait