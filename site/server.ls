Express   = require \express
HttpCode  = require \http-status
_         = require \lodash

env = (express = Express!).settings.env

module.exports = express
  ..set \port, process.env.PORT || 7000
  ..use Express.logger \dev if env in <[ development ]>
  ..use Express.bodyParser!
  ..use express.router
  ..use Express.static "#{__dirname}/app"
  ..use handle-error
  ..use Express.errorHandler!

function handle-error err, req, res, next
  log (msg = if err.stack then err.stack else err.message)
  res.send HttpCode.INTERNAL_SERVER_ERROR, msg
  next err
