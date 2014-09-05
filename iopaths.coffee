log = console.log

start = (io) ->

  io.on 'connection', (socket) ->

    sender = ''
    receiver = ''
    room = ''

    socket.on 'start', (data) ->
      sender = data.sender
      receiver = data.receiver
      if Number(sender) < Number(receiver)
        list = [Number(sender), Number(receiver)]
      else
        list = [Number(receiver), Number(sender)]
      room = "#{list[0]}-#{list[1]}"
      # log room
      socket.join room # Untested

    socket.on 'disconnect', ->
      # Do nothing
    socket.on 'chat message', (message) ->
      io.to(room).emit("chat message", {sender: sender, receiver: receiver, message: message})
      # log "#{sender} to #{receiver}: #{message}"


exports.start = start
