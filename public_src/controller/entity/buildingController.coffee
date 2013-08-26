define	[
		'../../controller/controller'
		'text!/../static/templates/formBuilding.html'
		'text!/../static/templates/listedBuilding.html'
		'../../models/building'
		],
	(Controller, FormTemplate, ListedBuildingTemplate, Building) ->
		class BuildingController extends Controller	
			id: "buildingController"
			query: null
			events:
				'submit' : 'save'
				'click #delte' : 'delete'
				'click #localCopyBtn' : 'localCopy'

			initialize: (buildings) ->
				$('body').append(@el)
				@buildings = buildings
				@buildings.bind('reset', @renderList, @)
				@buildings.bind('error', @showError, @)

			showError: (e, xhr) ->
				if xhr.status == 401
					if confirm "Bitte anmelden."
						$(window.location).attr
							href : '#login'
				if xhr.status == 0
					@useLocalstorage()


			useLocalstorage: () ->
				@buildings.loadLocalCopy()
				@renderList()

			list: ->
				# Normale Auflistung aller Einträge:
				# ...weil es zuvor eine Suche gegeben haben kann,
				# muss der Suchstring hier zurückgesetzt werden
				@query = null
				@buildings.fetch()

			search: (q) ->
				@query = q
				@buildings.fetch
					data : 
						q : @query
				# Funktion um die Tastatur von iOS Geräten auszublenden:
				$('#searchinput').blur()
				

			renderList: (event) ->
				$(@el).html('')

				# Bei der Anzeige von Suchergebnissen wird der Such-Term angezeigt
				if @query?
					$(@el).append('<li><b>Suche</b> für »' + @query + '«</li>')

				$(window.location).attr({'href':'#buildings'}) unless $(window.l)
				@listTemplate = _.template(ListedBuildingTemplate)
				_.each @buildings.models, (building) ->
					$(@el).append @listTemplate(building.toJSON())
				,@ 

			form: ->
				$(@el).html('')
				$(@el).html(_.template(FormTemplate))

			show: ->
				@building = @buildings.getCurrentBuilding()
				if @building.attributes.description?
					$(@el).html('')
					compiledFormTemplate = _.template(FormTemplate)
					$(@el).html(compiledFormTemplate(@building.toJSON()))
				else
					@building.bind('change', @show,@)
					@building.fetch()
				
				if localStorage[@building.id]?
					$(@el).append '<i class="icon-briefcase"></i>'

			save: (event) ->
				event.preventDefault()
				$(event.target).replaceWith('lädt')

				# inhalte des formulars serialisieren
				array = $(event.target).serializeArray()
				postdata = {}
				buildingId = null
				_.each array, (formInput) ->
					if formInput.name is "_id" then buildingId = formInput.value
					else postdata[formInput.name] = formInput.value
				
				building = null
				if buildingId != null
					building = @buildings.get(buildingId)
					building.set postdata
				else 
					building = new Building(postdata)

				building.bind 'sync', () ->
					building.unbind()
					$(window.location).attr({'href':'#buildings'})
				,@
				
				building.save()

			delete: (event) ->
				$(event.target).replaceWith('lädt')
				@buildings.bind('remove', () ->
					@buildings.unbind('remove')
					$(window.location).attr({'href':'#buildings'})
				, @)
				@buildings.getCurrentBuilding().destroy()

			localCopy : () ->
				localStorage.setItem( @building.id , JSON.stringify(@building.toJSON()) );

			release: ->
				@remove()