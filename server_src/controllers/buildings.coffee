nano = require('nano')('http://localhost:5984')
db = nano.use('arachne')

exports.list = (request, response) ->
	db.view_with_list 'entities', 'preview', 'index', (error, body) ->
		unless error?
			response.send body
		else
			response.send 500, error

exports.get = (request, response) ->
	# Optionen für die DB-Anfrage
	#  rev_info = true bewirkt eine Übertragung einer Versionsliste,
	#  die man dem Nutzer anzeigen kann
	options = {
		revs_info : false
	}

	# wenn eine spezielle Version angefragt wurde,
	# muss die Versionsnummer an CouchDB übermittelt werden
	if request.query.rev? 
		options.rev = request.query.rev

	db.get request.params.id, options, (error, body) ->
		unless error?
			response.send body
		else 
			response.send 500, error

exports.insert = (request, response) ->
	if request.body._id?
		if request.body.status == 'changedOnClient'
			request.body.status = 'serverVersion'

		db.insert request.body, request.body._id, (error, obj) ->
			unless error?
				response.send 200, obj
			else 
				response.send 500, error
	else
		db.insert request.body, (error, obj) ->
			unless error?
				response.send 200, obj
			else 
				response.send 500, error
