page = require('webpage').create()
system = require 'system'

targetUrl = system.args[1]

currentTime = ->
  (new Date).getTime()

startedTime = currentTime()
lastActive = currentTime()
outstandingRequests = []

page.settings.loadImages = false

page.onResourceRequested = (request) ->
  if idx = outstandingRequests.indexOf(request.id)
    outstandingRequests.push idx

page.onResourceReceived = (response) ->
  if 0
    if response.url == targetUrl and response.stage == 'end'
      for header in response.headers when not header.name.match /content-length/i
        console.log "#{header.name}: #{header.value}"

  if idx = outstandingRequests.indexOf(response.id)
    lastActive = currentTime()
    outstandingRequests.splice idx, 1

printAndExit = ->
  console.log page.content
  phantom.exit()

doneAfterFive = setInterval printAndExit, 5000

page.open targetUrl, (success) ->


  if success == 'success'
    page.evaluate (targetUrl) ->
        r = document.getElementsByTagName('script');
        for i in [r.length-1..0]
          r[i].parentNode.removeChild(r[i])

        base = document.createElement('base');
        base.setAttribute 'href', document.location.toString()

        head = document.getElementsByTagName('head')[0]
        head.insertBefore(base,head.firstChild)
      ,
        targetUrl

  checkCompletion = setInterval ->
      if currentTime() - lastActive > 300 and outstandingRequests.length == 0
        printAndExit()
    , 300
