global.log = console.log

Http    = require \http
Express = require \./server

<- Http.createServer(Express).listen port = Express.settings.port
console.log "Express server http listening on port #{port}"
