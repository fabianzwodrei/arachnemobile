define ['backbone', '../models/building'], (Backbone, Building) ->
	class Buildings extends Backbone.Collection
		model: Building
		url : 'api/buildings'
		_currentBuildingId : null
		
		parse : (response) ->
			# _.each response, (building) ->
				
			# 		if (localCopy = localStorage.getItem building._id)?
			# 		# Überprüfe ob es in der lokalen Version Änderungen gibt
			# 		# Falls es Änderungen gibt, muss zunächst diese lokale
			# 		# Version angezeigt werden, damit diese "zur Synchronisierung" gelistet wird
			# 		# Dann kann der Nutzer diese (neue!) lokale Version auf den Server synchronisieren
			# 		localCopy = $.parseJSON(localCopy)
			# 		if localCopy.status == "changedOnClient"
			# 			building.status = localCopy.status
			# , @

			@reset(response, {silent : true})
			# Überprüfe ob es eine lokale Version im Cache des Gerätes gibt
			@each (building) -> 
				if (localCopy = localStorage.getItem building.id)?
					building.localVersionAvailable = true
					localCopy = $.parseJSON(localCopy)
					if localCopy.status == "changedOnClient"
						building.set localCopy

			@trigger('reset')
			response

		setCurrentBuildingById: (id) ->
			@_currentBuildingId = id
			unless @getCurrentBuilding()?
				@add
					_id : @_currentBuildingId

		getCurrentBuilding: ->
			current = @get(@_currentBuildingId)
			if current?
				if current.attributes.status == "changedOnClient"
					current.set($.parseJSON(localStorage.getItem(@_currentBuildingId)))
			return current

		getCurrentBuildingId: ->
			@_currentBuildingId

		getChangedLocalCopy: (buildingId) ->
			if (localCopy = localStorage.getItem buildingId)?
				if localCopy.attributes.status == 'changedOnClient'
					return localCopy
			return false

		loadLocalCopy: () ->
			@reset()
			i = 0
			while i < localStorage.length
				objectAttributes = $.parseJSON(localStorage.getItem(localStorage.key(i)))
				building = new Building objectAttributes
				building.localVersionAvailable = true
				@add building
				i++

		saveLocalCopy: () ->

		addBuildingToLocalCopy: () ->