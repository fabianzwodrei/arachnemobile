###
backbone and underscore are required to have AMD support
the current versions were taken from:
- https://github.com/amdjs/backbone
- https://github.com/amdjs/underscore
###
require.config paths:
  underscore:   "../static/lib/underscore-min"
  backbone:     "../static/lib/backbone-min"
  domReady:     "../static/lib/domReady-min"
  text:         "../static/lib/text"
  jquery:		"../static/lib/jquery-1.10.2.min"


require.config shim:
	'backbone' :
		'deps' : ['underscore','jquery']
		'exports' : 'Backbone'
	'underscore':
		'exports': '_'

require ["domReady", "app"], (domReady, app) ->
  domReady ->
  	app.initialize()