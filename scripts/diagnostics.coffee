#   hubot ping - Reply with pong
#   hubot adapter - Reply with the adapter
#   hubot echo <text> - Reply back with <text>
#   hubot time - Reply with current time

global.hostname = ""
global.ip = ""

module.exports = (robot) ->
  @exec = require('child_process').spawn

  run_cmd = (cmd, args, envs) ->
    new Promise( (resolve, reject) ->
      opts =
        env: envs
      child = @exec(cmd, args, opts)
      child.stdout.on "data", (buffer) -> resolve buffer.toString()
      child.stderr.on "data", (buffer) -> reject buffer.toString()
    )

  robot.respond /PING$/i, (msg) ->
    msg.send "PONG"

  robot.respond /ADAPTER$/i, (msg) ->
    msg.send robot.adapterName

  robot.respond /ECHO (.*)$/i, (msg) ->
    msg.send msg.match[1]

  robot.respond /TIME$/i, (msg) ->
    msg.send "Server time is: #{new Date()}"

  robot.respond /where are you?/i, (msg) ->
    Promise.all([
      run_cmd("hostname", [], "")
      run_cmd "wget", ['http://ipinfo.io/ip', '-qO', '-'], ""
    ])
      .then(
        (results) ->
          msg.send "I'm on #{results[0].replace(/\n/, "")}, ip #{results[1].replace(/\n/, "")}"
      )
