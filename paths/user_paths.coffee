nohm = require('nohm').Nohm
redis = require('redis').createClient()
redis.on 'connect', ->
	nohm.setClient redis
User = require '../models/user_model'
bcrypt = require 'bcrypt'
log = console.log

start = (app) ->

	app.get "/", (request, result) ->
		User.model.findAndLoad {}, (error, users) ->
			# Remove Current User
			result.render 'index', {
				header: 'Midway House',
				users: users
			}

	app.get '/themes', (request, result) ->
		result.render 'themes'

	app.post '/set_theme', (request, result) ->
		result.cookie 'theme', request.body.theme
		log request.body.theme
		result.redirect '/themes'

	app.get "/join", (request, result) ->
		result.render 'users/new', {
			title: 'Join'
		}

	app.get "/log_in", (request, result) ->
		result.render "users/log_in", {
			title: "Log In"
		}

	app.get '/log_out', (request, result) ->
		request.session.regenerate (error) ->
			log error if error
			request.flash 'success', 'You are now logged out.'
			result.redirect '/'

	app.post "/users/log_in", (request, result) ->
		username = request.body.username
		password = request.body.password
		if username && password
			User.model.find {
				username: username
				},  (error, ids) ->
					if error
						log error
						request.flash 'error', 'Something went wrong.'
						result.redirect '/log_in'
					else if ids[0]
						User.model.load ids[0], (error, properties) ->
							if error
								log error
								request.flash 'error', 'Something went wrong.'
								result.redirect '/log_in'
							else
								bcrypt.compare password, properties.password_hash, (error, test) ->
									log error if error
									if test
										log 'correct username and password'
										# request.session.username = username
										# request.session.password_hash = properties.password_hash
										user = properties
										user.id = ids[0]
										request.session.user = user
										request.session.authenticated = true
										request.flash 'success', 'Welcome back!'
										result.redirect "/"
									else
										log 'correct username but incorrect password'
										request.flash 'error', 'Wrong Username/Password'
										result.redirect "/log_in"
					else # !(error || ids[0])
						log 'incorrect username'
						request.flash 'error', 'Wrong Username/Password'
						result.redirect '/log_in'
		else # !(username || password)
			log 'no username or no password'
			request.flash 'error', 'Wrong Username/Password'
			result.redirect "/log_in"


	app.post "/users/new", (request, result) ->
		user = new User.model() # Making a new user
		password = request.body.password
		if request.body.password < 3
			request.flash 'error', 'You must have a username and password each longer than 3 characters.'
			result.redirect '/join'
		else
			bcrypt.hash password, 8, (error, hash) ->
				log error if error
				user.p 'username', request.body.username
				user.p 'password_hash', hash
				user.save (error) ->
					if error
						log user.errors
						User.model.find {
							username: request.body.username
						}, (error, ids) ->
							if error
								log error
							else if ids.length > 0
								request.flash 'error', "\"#{request.body.username}\" is already taken."
							else
								request.flash 'error', "You must have a username and password each longer than 3 characters."
							result.redirect '/join'
					else
						request.session.authenticated = true
						User.model.findAndLoad {
							username: request.body.username
						}, (error, users) ->
							log error if error
							request.session.user = {}
							request.session.user.username = users[0].properties.username.value
							request.session.user.password_hash = users[0].properties.password_hash.value
							request.session.user.id = users[0].id

							request.flash 'success', "Welcome, #{request.body.username}!"
							result.redirect '/'

exports.start = start
