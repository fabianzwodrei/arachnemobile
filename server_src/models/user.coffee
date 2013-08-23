mongoose = require('mongoose')
bcrypt = require('bcrypt')
SALT_WORK_FACTOR = 10
    
UserSchema = new mongoose.Schema(
    email:
    	type : String
    	required : true
    	index:
    		unique : true

    password: 
    	type : String
    	required : true
)

UserSchema.pre 'save', (next) ->
	user = this
	# only hash the password if it has been modified (or is new)
	unless user.isModified('password') then retrun next()
	# generate a salt
	bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) ->
		if err then return next(err)

		# hash the password along with our new salt
		bcrypt.hash user.password, salt, (err, hash) ->
			if err then return next(err)

			# override the cleartext password with the hashed one
			user.password = hash
			next()

UserSchema.methods.comparePassword = (candidatePassword, cb) ->
	bcrypt.compare candidatePassword, @password, (err, isMatch) ->
		if err then return cb(err)
		cb null, isMatch 

module.exports = mongoose.model("User", UserSchema)