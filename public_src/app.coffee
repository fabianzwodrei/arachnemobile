define [
	'backbone',
	'routers/router',
	'controller/common/menuController'
	'collections/buildings'
	],
(Backbone, Router, MenuController, BuildingsCollection) ->
	initialize: ->
		if @router
			delete @router
		
		@menu = new MenuController
			el : $('nav')

		@buildings = new BuildingsCollection()

		# The router gets a reference to the main app to instantiate the views in the main app-scope 
		@router = new Router
			buildings : @buildings
		
		
		Backbone.history.start()