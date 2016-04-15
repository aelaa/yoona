module.exports = (robot) ->

  robot.respond /wake up Glados/i, (msg) ->
    imageMe msg, msg.match[3], (url) ->
      msg.send url

  robot.respond /Glados을 깨워/i, (msg) ->
    imageMe msg, msg.match[3], (url) ->
      msg.send url

