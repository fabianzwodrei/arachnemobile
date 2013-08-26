define [
	'backbone',
	'routers/router',
	'controller/common/menuController'
	'collections/buildings'
	'models/appStatus'
	],
(Backbone, Router, MenuController, BuildingsCollection, AppStatus) ->
	initialize: ->
		if @router
			delete @router
		
		@appStatus = new AppStatus()


		@menu = new MenuController
			el : $('nav')
			appStatus : @appStatus

		@buildings = new BuildingsCollection()

		# The router gets a reference to the main app to instantiate the views in the main app-scope 
		@router = new Router
			buildings : @buildings
			appStatus : @appStatus
		
		
		Backbone.history.start()