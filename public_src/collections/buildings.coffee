define ['backbone', '../models/building'], (Backbone, Building) ->
	class Buildings extends Backbone.Collection
		model: Building
		url : 'api/buildings'
		_currentBuildingId : null
		
		parse : (response) ->
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