nohm = require('nohm').Nohm
redis = require('redis').createClient()
redis.on 'connect', ->
	nohm.setClient redis
message_helper = require '../helpers/message_helper'
User = require '../models/user_model'
Message = require '../models/message_model'
bcrypt = require 'bcrypt'
log = console.log

start = (app) ->

	app.get '/messages', (request, result) ->
		Message.model.findAndLoad {}, (error, messages) ->
			log error if error
			result.type("txt").status(200).send JSON.stringify messages

	app.get '/chat/:id', (request, result) ->
		unless result.locals.authenticated
			log 'Unauthorized or mistaken attempt at chat.'
			result.redirect '/'
		else
			User.model.load request.params.id, (error, receiver) ->
				receiver.id = request.params.id
				message_helper.messages_between request.params.id, request.session.user.id, (messages) ->
					result.render 'messages/chat', {
						sender: request.session.user,
						receiver: receiver,
						messages: messages
					}

	app.post '/messages/:id/new', (request, result) ->
		unless result.locals.authenticated
			log 'Unauthorized or mistaken attempt at chat.'
			result.redirect '/'
		else
			message = new Message.model()
			message.p 'receiver_id', request.params.id
			message.p 'sender_id', request.session.user.id
			message.p 'content', request.body.content
			message.save (error) ->
				log JSON.stringify message.errors if error
				result.redirect "/chat/#{request.params.id}"



exports.start = start
