nohm = require('nohm').Nohm
redis = require('redis').createClient()
redis.on 'connect', ->
  nohm.setClient redis
# User = require '../models/user_model'
Message = require '../models/message_model'
log = console.log

messages_between = (user_one, user_two, callback) ->
  Message.model.findAndLoad {
    receiver_id: user_one,
    sender_id: user_two
  }, (error, messages) ->
    log error if error && error != 'not found'
    # log 'or no messages' if error
    Message.model.findAndLoad {
      receiver_id: user_two,
      sender_id: user_one
    }, (error, messages2) ->
      log error if error && error != 'not found'
      # log 'or no messages' if error
      for message in messages2
        messages.push message
      messages.sort (a, b) ->
        a.id - b.id
      callback(messages)


exports.messages_between = messages_between
