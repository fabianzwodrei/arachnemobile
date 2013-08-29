define ['backbone'], (Backbone) ->
	class Building extends Backbone.Model
		urlRoot : "api/buildings"
		idAttribute: "_id"
		localVersionAvailable = false

		attributes : 
			status : 'unknown'

		save : (attributes, options) ->
			options = {}
			options.error = (building, xhr, options) ->
				console.log "error while saving"
				building.set
					status : 'modified'
				localStorage.setItem(building.id , JSON.stringify(building.toJSON()))
			options.success = (building, xhr) ->
				if (localStorage.getItem building.id)?
					localStorage.removeItem(building.id)
			Backbone.Model.prototype.save.call(this, attributes, options)

		
		destroy : () ->
			@url = "api/buildings/" + @id + "?rev=" + @attributes._rev
			Backbone.Model.prototype.destroy.call(this)
