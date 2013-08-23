define ['../controller', 'text!/../static/layouts/menu.html'	],
	(Controller, Layout) ->
		class MenuController extends Controller
			events:
				'submit' : 'forwardToSearch'
			initialize: (params) ->
				$(@el).html(_.template(Layout)) 

			forwardToSearch: (event) ->
				event.preventDefault()
				window.location.hash = '#buildings/search/'+ $(event.target).serializeArray()[0].value

