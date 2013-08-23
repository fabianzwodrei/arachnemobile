nano = require('nano')('http://localhost:5984')
db = nano.use('arachne')

exports.list = (request, response) ->
	db.view_with_list 'entities', 'preview', 'index', (error, body) ->
		unless error?
			response.send body
		else
			response.send 500, error

# Building = require('../models/building')

# # REST Interface definitions
# #Get a list of all buildings
# # exports.get "/api/buildings", (request, response) ->
# exports.list = (request, response) ->
# 	unless request.session.user? then return response.send 401
# 	if request.query.q?
# 		Building.find
# 			$or : [
# 				title : new RegExp(request.query.q, 'i')
# 			,
# 				description : new RegExp(request.query.q, 'i')
# 			]
# 			(err, buildings) ->
# 				unless err
# 					response.send buildings
# 				else
# 					console.log err
# 	else 
# 		Building.find (err, buildings) ->
# 			unless err
# 				response.send buildings
# 			else
# 				console.log err



# #Post for  a new building
# exports.new = (request, response) ->
# 	unless request.sesssion.user? then return response.send 401
# 	building = new Building(
# 		title: request.body.title
# 		description: request.body.description
# 		gps: request.body.gps
# 	)
# 	building.save (err) ->
# 		unless err
# 			console.log "created"
# 			response.send building
# 		else
# 			console.log err

# #Get a single buidling by id
# exports.get = (request, response) ->
# 	Building.findById request.params.id, (err, book) ->
# 		unless err
# 			response.send book
# 		else
# 			console.log err

exports.get = (request, response) ->
	# Optionen für die DB-Anfrage
	#  rev_info = true bewirkt eine Übertragung einer Versionsliste,
	#  die man dem Nutzer anzeigen kann
	options = {
		revs_info : true
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


# #Update a building
# exports.put = (request, response) ->
# 	unless request.sesssion.user? then return response.send 401
# 	console.log "Updating building " + request.body.title
# 	Building.findById request.params.id, (err, building) ->
# 		building.title = request.body.title
# 		building.description = request.body.description
# 		building.gps = request.body.gps
# 		building.save (err) ->
# 			unless err
# 				console.log "building updated"
# 				response.send building
# 			else
# 				console.log err
# 			response.send building

exports.insert = (request, response) ->
	if request.body?
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

# exports.delete = (request, response) ->
# 	db.destroy request.params.id, (error, body) ->
# 		unless error?
# 			response.send body
# 		else 
# 			response.send 500, error


# #Update a building
# exports.delete = (request, response) ->
# 	unless request.sesssion.user? then return response.send 401
# 	console.log "Deleteing building with id" + request.params.id
# 	Building.findById request.params.id, (err, building) ->
# 		building.remove (err) ->
# 			unless err
# 				console.log "building deleted"
# 				response.send(200);
# 			else
# 				console.log err

