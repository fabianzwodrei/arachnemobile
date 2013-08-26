define ['backbone'], (Backbone) ->
	class AppStatus extends Backbone.Model
		url : 'api'
		defaults :
			online : false

		initialize : () ->
			@checkConnectivity()
			@bind 'error', @setOffline, @

			self = this
			@interval = setInterval(->
				self.checkConnectivity()
			, 1000)

		checkConnectivity: () ->
			@fetch()

		setOffline: ->
			@set
				online : false

		isOnline: () ->
			@attributes.online
