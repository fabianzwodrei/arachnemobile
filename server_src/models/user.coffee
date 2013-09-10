bcrypt = require('bcrypt')
SALT_WORK_FACTOR = 10

nano = require('nano')('http://localhost:5984')
db = nano.use('arachneusers')

User = (email, password) ->
	@email = email
	@password = password

User.prototype.save = (callback) ->
	user = @
	# generate a salt
	bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) ->
		if err
			callback(error)
		# hash the password along with our new salt
		bcrypt.hash user.password, salt, (err, hash) ->
			if err 
				callback(error)
			
			# override the cleartext password with the hashed one
			user.password = hash
			
			attributes =
				email : user.email
				password : user.password 

			db.insert attributes, (err, obj) ->
				unless error?
					console.log  "no error in user insert"
					callback(err,obj)
				else 
					callback(err,obj)

User.prototype.comparePassword = (candidatePassword, cb) ->
	bcrypt.compare candidatePassword, @password, (err, isMatch) ->
		if err then return cb(err)
		cb null, isMatch 

User.prototype.findOne = (callback) ->
	# http://127.0.0.1:5984/arachneusers/_design/users/_view/by_email?key="shit@you.too"
	db.view 'users', 'by_email', { keys : [@email]}, (error, object) ->
		unless error?
			# wenn ein user mit der richtigen emailadresse gefunden wurde, wird er zurückgegeben
			if object.rows[0]? then callback(error, object.rows[0].value)
		else
			callback(error)			

module.exports = User