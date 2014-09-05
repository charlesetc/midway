log = console.log

start = (app) ->

	app.get '/themes', (request, result) ->
		result.render 'themes'

	app.post '/set_theme', (request, result) ->
		result.cookie 'theme', request.body.theme
		# log request.body.theme
		result.redirect '/'

	app.get '/bulletin', (request, result) ->
		result.render 'bulletin'

exports.start = start
