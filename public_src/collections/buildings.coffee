define ['backbone', '../models/building'], (Backbone, Building) ->
	class Buildings extends Backbone.Collection
		model: Building
		url : 'api/buildings'
		_currentBuildingId : null
		
		parse : (response) ->

			_.each response, (building) ->
				building.localVersionAvailable = true if (localStorage.getItem building._id)?
					
			, @ 

			@reset(response)
			
			response

		setCurrentBuildingById: (id) ->
			@_currentBuildingId = id
			unless @getCurrentBuilding()?
				@add
					_id : @_currentBuildingId

		getCurrentBuilding: ->
			@get(@_currentBuildingId)

		getCurrentBuildingId: ->
			@_currentBuildingId

		loadLocalCopy: () ->
			@reset()
			i = 0
			while i < localStorage.length
				objectAttributes = $.parseJSON(localStorage.getItem(localStorage.key(i)))
				objectAttributes.localVersionAvailable = true
				@add objectAttributes
				i++

		saveLocalCopy: () ->

		addBuildingToLocalCopy: () ->