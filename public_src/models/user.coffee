define ['backbone'], (Backbone) ->
	class User extends Backbone.Model
		urlRoot : "api/user"
		idAttribute: "_id"

		

