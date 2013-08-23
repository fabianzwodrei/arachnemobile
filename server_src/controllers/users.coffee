User = require('../models/user')

exports.loginOrNew = (request, response) ->
	if request.body.email? and request.body.email.length > 5
		if request.body.passwordrepeated?
			if request.body.password is request.body.passwordrepeated
				user = new User
					email : request.body.email
					password : request.body.password
				user.save (err) ->
					unless err
						console.log "created new user"
						console.log user
						response.redirect '/'
					else
						console.log err
			else
				response.send '400', 'Retyped password did not match the password.'
		else # not a new user
			User.findOne
				email : request.body.email
				(err, user) ->
					unless error?
						request.session.user = user.email
						request.session.authenticated
						response.send 200,
							email: user.email
							_id : user._id
					else 
						console.log "err"
	else
		response.send 400

