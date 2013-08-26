# Module dependencies.
application_root = __dirname
express = require("../node_modules/express") #Web framework
path = require("../node_modules/path") #Utilities for dealing with file paths
nano = require("../node_modules/nano") #MongoDB integration



#Create server
app = express()

# Configure server
app.configure ->
	app.use express.cookieParser('manny is cool')

	app.use express.cookieSession()
	
	#parses request body and populates request.body
	app.use express.bodyParser()
	
	#checks request.body for HTTP method overrides
	app.use express.methodOverride()
	
	#perform route lookup based on url and HTTP method
	app.use app.router
	
	# app.use (request, response) ->
	# 	request.session.count = request.session.count || 0
	# 	n = request.session.count++;
	# 	response.send 'viewed ' + n + ' times\n'

	#Where to serve static content
	app.use express.static(path.join(application_root, "../public"))
	app.use('/static', express.static(path.join(application_root, "../static")));
	# app.use (req, res) ->
	# 	newUrl = req.protocol + '://' + req.get('Host') + '/#' + req.url
	# 	res.redirect newUrl
		
	#Show all errors in development
	app.use express.errorHandler(
		dumpExceptions: true
		showStack: true
	)


buildingController = require('./controllers/buildings')
# userController  = require('./controllers/users')
#Connect to database
# mongoose.connect "mongodb://localhost/library_database"
nano = require('nano')('http://localhost:5984')
# db_name = 'arachne'
# app.get "/", (request, response) ->
# 	nano.db.create db_name, (error, body, headers) ->
# 		if error?
# 			return response.send error.message, error['status-code']
# 	@db = nano.use db_name
# 	buildingController.list() 


app.get "/api", (request, response) ->
	response.header "Content-Type", "application/json"
	response.send 200, '{ "online" : true }'

app.get "/api/buildings", buildingController.list
app.post "/api/buildings", buildingController.insert
app.get "/api/buildings/:id", buildingController.get
app.put "/api/buildings/:id", buildingController.insert
# app.delete "/api/buildings/:id", buildingController.delete

# app.post "/api/user", userController.loginOrNew

app.get "/site.manifest", (request, response, next) ->
	response.header "Content-Type", "text/cache-manifest"
	console.log "Site Manifest File was requested"
	next()

#Start server
port = 4000
app.listen port, ->
	console.log "Express server listening on port %d in %s mode", port, app.settings.env
