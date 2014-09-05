
user_paths = require "./paths/user_paths"
message_paths = require './paths/message_paths'
bcrypt = require 'bcrypt'
log = console.log

start = (app) ->


	# Setting Authentication
	app.use (request, result, next) ->
		unless request.session.authenticated
			request.session.authenticated = false
		result.locals.authenticated = request.session.authenticated
		next()

	# Setting Auth_Token
	app.use (request, result, next) ->
		result.locals.auth_token = request.csrfToken()
		result.locals.auth_token_tag = "<input type = 'hidden' name = '_csrf'
			value = '#{request.csrfToken()}' />"
		next()

	# Setting Theme Cookies
	app.use (request, result, next) ->
		theme = request.cookies.theme
		if theme
			result.locals.theme = theme
		else
			result.locals.theme = 'shadowy'
		next()

	user_paths.start(app)
	message_paths.start(app)



exports.start = start
