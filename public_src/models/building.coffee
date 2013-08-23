define ['backbone'], (Backbone) ->
	class Building extends Backbone.Model
		urlRoot : "api/buildings"
		idAttribute: "_id"