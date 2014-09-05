
socket = io()

$ ->

  scroll_message = ->
    $("#message_index").scrollTop($('#message_index').height() * 2)

  scroll_message()

  data = {sender: '', receiver: ''}
  data.sender = $(".chat_data").data('sender')
  data.receiver = $(".chat_data").data('receiver')
  socket.emit 'start', data

  $('#chat_form').submit ->
    content = $("#message_content").val()
    socket.emit 'chat message', content
    $('#message_content').val ''
    $.post "/messages/#{data.receiver}/new", {
      _csrf: AUTH_TOKEN,
      content: content
    }
    return false

  socket.on "chat message", (message) ->
    if data.sender == message.sender
      m = "<p class = 'message message_sender'>#{message.message}</p>"
    else
      m = "<p class = 'message message_receiver'>#{message.message}</p>"
    $("#message_index").append m
    scroll_message()
