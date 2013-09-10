define [
	'../controller'
	'text!/../static/layouts/login.html'
	],
	(Controller, Layout) ->
		class SessionController extends Controller
			events:
				'submit #signIn' : 'login'
				'submit #signUp' : 'login'

			initialize: (params) ->
				$('body').append(@el)
				@user = params.user
				unless @user.id?
					$(@el).html(_.template(Layout)) 
				else 
					$(@el).html('sie sind angemeldet')
	
			login: (event) ->
				event.preventDefault()

				# inhalte des formulars serialisieren
				array = $(event.target).serializeArray()
				postdata = {}
				_.each array, (formInput) ->
					postdata[formInput.name] = formInput.value

				@user.set postdata
				@user.bind('sync', @forwardToBuildings, @)
				@user.bind('error', @tryagain, @)
				@user.save()

			tryagain : (e) ->
				@user.unbind('error', @tryagain, @)
				alert "Nochmal bitte, irgendwas war falsch."

			forwardToBuildings: ->
				alert "Erfolgreich angemeldet!" 
				@user.unbind('sync', @forwardToBuildings, @)
				$(window.location).attr
					href : '#buildings'


			release: () ->
				if @user? then delete @user
				@remove()
