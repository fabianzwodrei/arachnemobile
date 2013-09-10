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
				@appStatus = params.appStatus
				@user = params.user
				@appStatus.bind 'change:online', @reloadControllerForConnectivityChange, @
				
				appCache = window.applicationCache;
				switch appCache.status
					when appCache.UNCACHED
						console.log 'App cache status: UNCACHED'
					when appCache.IDLE 
						console.log 'App cache status: IDLE'
					when appCache.CHECKING
						console.log 'App cache status: CHECKING'
					when appCache.DOWNLOADING
						console.log 'App cache status: DOWNLOADING'
					when appCache.UPDATEREADY
						console.log 'App cache status: UPDATEREADY'
						appCache.swapCache()
						appCache.reload()
					when appCache.OBSOLETE
						console.log 'App cache status: OBSOLETE'
					else
						console.log 'App cache status: UKNOWN CACHE STATUS'

			reloadControllerForConnectivityChange: () ->
				if @controller.id == 'buildingController' and Backbone.history.fragment == "buildings"
					@controller.list()

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
					@controller = new SessionController
						user : @user
				else if @controller.id != 'sessionController'
					@controller.release()
					@controller = new SessionController
						user : @user