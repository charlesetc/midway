express = require("express")
paths = require("./paths")
stylus = require('stylus')
body_parser = require("body-parser")
coffee = require("coffee-middleware")
cookie_parser = require 'cookie-parser'
iopaths = require './iopaths'
flash = require("express-flash")
path = require("path")
favicon = require("serve-favicon")
session = require 'express-session'
csrf= require 'csurf'
app = express()
http = require("http").Server(app)
io = require("socket.io")(http)

app.use favicon './favicon.ico'
app.use coffee {
	src: __dirname + '/public'
}

app.use cookie_parser()

app.use session {secret: 'hey kitty wow this is a nice
country! muhahahahahahah o3u2toiu
to stey in',
resave: true,
saveUninitialized: true
cookie: {
	maxAge: 1000 * 60 * 60 * 24 * 365 * 5
}
}

app.use(body_parser.urlencoded({ extended: false }))

app.use csrf()
app.use flash()

app.use stylus.middleware {
	debug: true,
	force: true,
	src: __dirname + '/public',
	compress: true
}

app.use express.static 'public'

app.set 'view engine', 'toffee'

paths.start(app)
iopaths.start(io)

# app.use (request, result, next) ->
# 	result.status(404).type('txt').send "Oops, it looks like you've found a non-existant page! What a 'beaut."

app.use (error, request, result, next) ->
	if error.status != 403
		next(error)
	else
  	# handle CSRF token errors here
		console.error 'Session has expired or form tampered with.'
		console.error JSON.stringify request.body
		result.type('txt').status(403).send('Session has expired or form tampered with. What have you been up to?')


app.use (error, request, result, next) ->
	console.error error.stack
	result.status(500).type('txt').send 'Oops, it looks like something went
	 wrong! Please alert the nearest sys admin.'

port = 4004

http.listen port, ->
	console.log "Listening on #{port}..."
