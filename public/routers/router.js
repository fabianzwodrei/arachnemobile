// Generated by CoffeeScript 1.6.3
(function() {
  define(['backbone', '../controller/entity/buildingController', '../controller/common/sessionController'], function(backbone, BuildingController, SessionController) {
    return Backbone.Router.extend({
      controller: null,
      routes: {
        '': 'index',
        'buildings/:id': 'buildings',
        'buildings': 'buildings',
        'buildings/search/:q': 'search',
        'login': 'login'
      },
      initialize: function(params) {
        return this.buildings = params.buildings;
      },
      index: function() {},
      search: function(q) {
        this.initBuildingController();
        return this.controller.search(q);
      },
      initBuildingController: function() {
        if (this.controller == null) {
          return this.controller = new BuildingController(this.buildings);
        } else if (this.controller.id !== "buildingController") {
          this.controller.release();
          return this.controller = new BuildingController(this.buildings);
        }
      },
      buildings: function(id) {
        if (id == null) {
          id = null;
        }
        this.initBuildingController();
        switch (id) {
          case "new":
            return this.controller.form();
          case null:
            return this.controller.list();
          default:
            this.buildings.setCurrentBuildingById(id);
            return this.controller.show();
        }
      },
      login: function() {
        if (this.controller == null) {
          return this.controller = new SessionController();
        } else if (this.controller.id !== 'sessionController') {
          this.controller.release();
          return this.controller = new SessionController();
        }
      }
    });
  });

}).call(this);