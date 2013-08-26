define ['../controller', 'text!/../static/layouts/menu.html'	],
	(Controller, Layout) ->
		class MenuController extends Controller
			events:
				'submit' : 'forwardToSearch'

			initialize: (params) ->
				$(@el).html(_.template(Layout))
				@appStatus = params.appStatus
				@appStatus.bind 'change:online', @updateConnectivityIcon, @


			updateConnectivityIcon : () ->
				if @appStatus.isOnline()
					$('#connectivity').addClass 'icon-cloud'
				else
					$('#connectivity').removeClass 'icon-cloud'

			forwardToSearch: (event) ->
				event.preventDefault()
				window.location.hash = '#buildings/search/'+ $(event.target).serializeArray()[0].value

