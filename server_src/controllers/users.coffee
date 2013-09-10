User = require('../models/user')

exports.loginOrNew = (request, response) ->
	if request.body.email? and request.body.email.length > 5
		if request.body.passwordrepeated?
			if request.body.password is request.body.passwordrepeated
				
				user = new User(request.body.email, request.body.password)
				user.save (error, obj) ->
					unless error?
						# created new user
						request.session.user = user.email
						request.session.authenticated
						response.send 200,
							email: user.email
							_id : obj.id
					else
						console.log err
			else
				response.send '400', 'Retyped password did not match the password.'
		else # not a new user
			user = new User request.body.email, request.body.password
			user.findOne (error, dbUser) ->
				unless error?
					# Es konnte ein User in der DB mit der eingegebenen Email-Adresse gefunden werden
					# Nun wird wird das eingegebene Passwort mit dem aus der DB (zu gefundenen User) verglichen
					user.comparePassword dbUser.password, (err, isMatch) ->
						unless err?
							if isMatch?
								# das eigegebene Passwort simmte mit dem aus der DB überein. 
								# der User gilt als angemeldet und es kann eine Session vergeben werden.
								request.session.user = user.email
								request.session.authenticated
								response.send 200,
									email: dbUser.email
									_id : dbUser.id								
						else
							# Das eingebene Passwort stimmt nicht mit dem des Users in DB überein
							response.send 403
				else
					# Eine Abfrage, ob der User existiert konnte nicht durchgeführt werden.
					# Es wird ein HTTP Server Error Code gesendet
					response.send 500

	else
		response.send 400