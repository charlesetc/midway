redis = require('redis').createClient()
nohm = require('nohm').Nohm
# nohm.setClient(redis)
redis.on 'connect', ->
	nohm.setClient redis
model = nohm.model 'message', {
	properties: {
	content: {
		type: 'string',
		validations: ['notEmpty', ['length', {min:3}]]
	},
	sender_id: {
		type: 'integer',
		validations: ['notEmpty'],
		index: true
	},
	receiver_id: {
		type: 'integer',
		validations: ['notEmpty'],
		index: true
	}
	},
	idGenerator: 'increment'
}

exports.model = model
