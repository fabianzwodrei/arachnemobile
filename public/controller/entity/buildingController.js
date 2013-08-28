// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['../../controller/controller', 'text!/../static/templates/formBuilding.html', 'text!/../static/templates/listedBuilding.html', '../../models/building'], function(Controller, FormTemplate, ListedBuildingTemplate, Building) {
    var BuildingController, _ref;
    return BuildingController = (function(_super) {
      __extends(BuildingController, _super);

      function BuildingController() {
        _ref = BuildingController.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      BuildingController.prototype.id = "buildingController";

      BuildingController.prototype.query = null;

      BuildingController.prototype.events = {
        'submit': 'save',
        'click #delte': 'delete',
        'click #localCopyBtn': 'localCopy',
        'click #deleteLocalCopyBtn': 'deleteLocalCopy'
      };

      BuildingController.prototype.initialize = function(buildings) {
        $('body').append(this.el);
        this.buildings = buildings;
        this.buildings.bind('reset', this.renderList, this);
        return this.buildings.bind('error', this.showError, this);
      };

      BuildingController.prototype.logger = function(e) {
        return console.log(e);
      };

      BuildingController.prototype.showError = function(e, xhr) {
        if (xhr.status === 401) {
          if (confirm("Bitte anmelden.")) {
            $(window.location).attr({
              href: '#login'
            });
          }
        }
        if (xhr.status === 0) {
          return this.useLocalstorage();
        }
      };

      BuildingController.prototype.useLocalstorage = function() {
        this.buildings.loadLocalCopy();
        return this.renderList();
      };

      BuildingController.prototype.list = function() {
        this.query = null;
        return this.buildings.fetch();
      };

      BuildingController.prototype.search = function(q) {
        this.query = q;
        this.buildings.fetch({
          data: {
            q: this.query
          }
        });
        return $('#searchinput').blur();
      };

      BuildingController.prototype.renderList = function() {
        $(this.el).html('');
        if (this.query != null) {
          $(this.el).append('<li><b>Suche</b> für »' + this.query + '«</li>');
        }
        if (!$(window.l)) {
          $(window.location).attr({
            'href': '#buildings'
          });
        }
        this.listTemplate = _.template(ListedBuildingTemplate);
        return _.each(this.buildings.models, function(building) {
          return $(this.el).append(this.listTemplate({
            obj: building.toJSON(),
            localVersionAvailable: building.localVersionAvailable
          }));
        }, this);
      };

      BuildingController.prototype.form = function() {
        $(this.el).html('');
        return $(this.el).html(_.template(FormTemplate));
      };

      BuildingController.prototype.show = function() {
        var compiledFormTemplate;
        this.building = this.buildings.getCurrentBuilding();
        if (this.building.attributes.description != null) {
          $(this.el).html('');
          compiledFormTemplate = _.template(FormTemplate);
          return $(this.el).html(compiledFormTemplate({
            obj: this.building.toJSON(),
            localVersionAvailable: this.building.localVersionAvailable
          }));
        } else {
          this.building.bind('change', this.show, this);
          return this.building.fetch();
        }
      };

      BuildingController.prototype.save = function(event) {
        var array, building, buildingId, postdata;
        event.preventDefault();
        $(event.target).replaceWith('lädt');
        array = $(event.target).serializeArray();
        postdata = {};
        buildingId = null;
        _.each(array, function(formInput) {
          if (formInput.name === "_id") {
            return buildingId = formInput.value;
          } else {
            return postdata[formInput.name] = formInput.value;
          }
        });
        building = null;
        if (buildingId !== null) {
          building = this.buildings.get(buildingId);
          building.set(postdata);
        } else {
          building = new Building(postdata);
        }
        building.bind('sync', function() {
          building.unbind();
          return $(window.location).attr({
            'href': '#buildings'
          });
        }, this);
        return building.save();
      };

      BuildingController.prototype["delete"] = function(event) {
        if (localStorage.getItem(this.building.id != null)) {
          this.deleteLocalCopy();
        }
        $(event.target).replaceWith('lädt');
        this.buildings.bind('remove', function() {
          this.buildings.unbind('remove');
          return $(window.location).attr({
            'href': '#buildings'
          });
        }, this);
        return this.buildings.getCurrentBuilding().destroy();
      };

      BuildingController.prototype.localCopy = function() {
        localStorage.setItem(this.building.id, JSON.stringify(this.building.toJSON()));
        return window.location.hash = 'buildings';
      };

      BuildingController.prototype.deleteLocalCopy = function() {
        localStorage.removeItem(this.building.id);
        return window.location.hash = 'buildings';
      };

      BuildingController.prototype.release = function() {
        return this.remove();
      };

      return BuildingController;

    })(Controller);
  });

}).call(this);
