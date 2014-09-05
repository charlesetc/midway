redis = require('redis').createClient()
nohm = require('nohm').Nohm
# nohm.setClient(redis)
redis.on 'connect', ->
	nohm.setClient redis
model = nohm.model 'user', {

	properties: {
	username: {
	type: 'string',
	index: true,
	unique: true,
	validations: ['notEmpty', ['length', {min:3}]]
	},
	password_hash: {
	type: 'string',
	validations: ['notEmpty']
	}
	},
	idGenerator: 'increment'
}

exports.model = model
