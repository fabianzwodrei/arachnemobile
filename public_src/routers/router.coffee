define [
	'backbone'
	'../controller/entity/buildingController'
	'../controller/common/sessionController'
	],
	(backbone, BuildingController, SessionController) ->
		Backbone.Router.extend
			controller : null
			routes:
				'' : 'index'
				'buildings/:id': 'buildings'
				'buildings' : 'buildings'
				'buildings/search/:q' : 'search'
				'login' : 'login'

			initialize: (params) ->
				@buildings = params.buildings

			index: ->

			search: (q) ->
				@initBuildingController()
				@controller.search(q)

			initBuildingController: ->
				unless @controller?
					@controller = new BuildingController(@buildings)
				else if @controller.id != "buildingController"
					@controller.release()
					@controller = new BuildingController(@buildings)

			buildings: (id) ->
				id = null unless id?

				@initBuildingController()

				switch id
					when "new" then @controller.form()
					when null then @controller.list()
					else
						@buildings.setCurrentBuildingById(id)
						@controller.show()


			login : () ->
				unless @controller?
					@controller = new SessionController()
				else if @controller.id != 'sessionController'
					@controller.release()
					@controller = new SessionController()