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
				'click #deleteLocalCopyBtn' : 'deleteLocalCopy'
				'change #cameraInput' : 'preprocessUploadedImage'

			initialize: (buildings) ->
				$('body').append(@el)
				@buildings = buildings
				# @buildings.bind('all', @logger, @)
				@buildings.bind('reset', @renderList, @)
				@buildings.bind('error', @showError, @)

			logger: (e) ->
				console.log e

			showError: (e, xhr) ->
				if xhr.status == 401
					if confirm "Bitte anmelden."
						$(window.location).attr
							href : '#login'
				if xhr.status == 0
					@useLocalstorage()


			useLocalstorage: () ->
				console.log "useLocalStorage"
				@buildings.loadLocalCopy()
				$(window.location).attr({'href':'#buildings', 'trigger' :false })
				@renderList()

			list: ->

				# Normale Auflistung aller Einträge:
				# ...weil es zuvor eine Suche gegeben haben kann,
				# muss der Suchstring hier zurückgesetzt werden
				@query = null
				@buildings.fetch()

			search: (q) ->
				@query = q
				@buildings.search(@query)
				# Funktion um die Tastatur von iOS Geräten auszublenden:
				$('#searchinput').blur()
				

			renderList: () ->
				$(@el).html('')
				# Bei der Anzeige von Suchergebnissen wird der Such-Term angezeigt
				if @query?
					$(@el).append('<li><b>Suche</b> für »' + @query + '«</li>')

				$(window.location).attr({'href':'#buildings'}) unless $(window.l)
				@listTemplate = _.template(ListedBuildingTemplate)
				_.each @buildings.models, (building) ->
					$(@el).append @listTemplate
						obj: building.toJSON()
						localVersionAvailable : building.localVersionAvailable 
				,@ 

			form: ->
				$(@el).html('')
				$(@el).html(_.template(FormTemplate))

			show: ->
				@building = @buildings.getCurrentBuilding()
				if @building.attributes.description?
					$(@el).html('')
					compiledFormTemplate = _.template(FormTemplate)
					$(@el).html compiledFormTemplate
						obj: @building.toJSON()
						localVersionAvailable : @building.localVersionAvailable
						revisionsList : @building.revisionsList
					
					$('input, textarea').change ()->						
						$('#status').val('modified')

				else
					@building.bind('change', @show,@)
					@building.fetch()

			save: (event) ->
				event.preventDefault()
				$(event.target).replaceWith('lädt')

				# $('#status').attr
				# 	'disaled' : false
				# inhalte des formulars serialisieren
				array = $(event.target).serializeArray()
				console.log array
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
				# RevisionsInfos müssen entfernt werden
				if building.attributes._revs_info?
					delete building.attributes._revs_info
				building.save()

			delete: (event) ->
				if localStorage.getItem @building.id?
					@deleteLocalCopy()

				$(event.target).replaceWith('lädt')
				@buildings.bind('remove', () ->
					@buildings.unbind('remove')
					$(window.location).attr({'href':'#buildings'})
				, @)
				@buildings.getCurrentBuilding().destroy()

			localCopy : ->
				localStorage.setItem( @building.id , JSON.stringify(@building.toJSON()) );
				window.location.hash = 'buildings'
			
			deleteLocalCopy : ->
				localStorage.removeItem @building.id
				window.location.hash = 'buildings'

			preprocessUploadedImage: () ->
				input = document.getElementById('cameraInput');

				file = input.files[0]
				filename = input.value
				fr = new FileReader()
				self = @
				fr.onload = () ->
					$('#newImagePreview').show()
					img = new Image()
					img.onload = () ->
						canvas = document.getElementById("canvas")
						canvas.width = img.width;
						canvas.height = img.height;
						ctx = canvas.getContext("2d");
						ctx.drawImage(img,0,0);
						dataURL = canvas.toDataURL("image/png")

						unless self.building.attributes['_attachments']?
							self.building.attributes['_attachments'] = {}

						self.building.attributes['_attachments'][filename] = {}
						self.building.attributes['_attachments'][filename] =
							"content_type" :"image\/png"
							"data" : dataURL.replace(/^data:image\/(png|jpg);base64,/, "")

					img.src = fr.result
				fr.readAsDataURL(file)

			release: ->
				@remove()









