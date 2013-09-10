define [
	'backbone',
	'routers/router',
	'controller/common/menuController'
	'collections/buildings'
	'models/appStatus'
	'models/user'
	],
(Backbone, Router, MenuController, BuildingsCollection, AppStatus, User) ->
	initialize: ->
		if @router
			delete @router
		
		@appStatus = new AppStatus()

		@user = new User()

		@menu = new MenuController
			el : $('nav')
			appStatus : @appStatus

		@buildings = new BuildingsCollection()

		# The router gets a reference to the main app to instantiate the views in the main app-scope 
		@router = new Router
			buildings : @buildings
			appStatus : @appStatus
			user      : @user
		
		
		Backbone.history.start()