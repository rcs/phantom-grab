express = require 'express'
querystring = require 'querystring'
URL = require 'url'
sysPath = require 'path'
phantom = require 'phantom'


currentTime = ->
  (new Date).getTime()


renderPhantom = (url, cb) ->
  phantom = require('child_process').spawn('phantomjs', ['phantom-grab.coffee', url]);
  phantom.stdout.setEncoding('utf8')
  content = ''

  phantom.stdout.on 'data', (data) ->
    content += data.toString();

  phantom.on 'exit', (code) ->
    if code != 0
      console.log('We have an error')
    else
      cb content

exports.startServer = (port, path, callback = ->) ->
  console.error "Path is #{path}"
  server = express()
  server.use express.logger()
  if process.env.NODE_ENV != "production"
    server.use (request, response, next) ->
      response.header 'Cache-Control', 'no-cache'
      next()
  server.use "/", express.static path
  server.all "/*", (request, response) ->
    url = "http:/" + request.url

    console.log "Doing #{url}"
    renderPhantom url, (content) ->
      response.send content
  server.listen port, callback
  server
