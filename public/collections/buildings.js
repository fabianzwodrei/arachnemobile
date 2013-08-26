// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone', '../models/building'], function(Backbone, Building) {
    var Buildings, _ref;
    return Buildings = (function(_super) {
      __extends(Buildings, _super);

      function Buildings() {
        _ref = Buildings.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Buildings.prototype.model = Building;

      Buildings.prototype.url = 'api/buildings';

      Buildings.prototype._currentBuildingId = null;

      Buildings.prototype.parse = function(response) {
        _.each(response, function(building) {
          if ((localStorage.getItem(building._id)) != null) {
            return building.localVersionAvailable = true;
          }
        }, this);
        this.reset(response);
        return response;
      };

      Buildings.prototype.setCurrentBuildingById = function(id) {
        this._currentBuildingId = id;
        if (this.getCurrentBuilding() == null) {
          return this.add({
            _id: this._currentBuildingId
          });
        }
      };

      Buildings.prototype.getCurrentBuilding = function() {
        return this.get(this._currentBuildingId);
      };

      Buildings.prototype.getCurrentBuildingId = function() {
        return this._currentBuildingId;
      };

      Buildings.prototype.loadLocalCopy = function() {
        var i, objectAttributes, _results;
        this.reset();
        i = 0;
        _results = [];
        while (i < localStorage.length) {
          objectAttributes = $.parseJSON(localStorage.getItem(localStorage.key(i)));
          objectAttributes.localVersionAvailable = true;
          this.add(objectAttributes);
          _results.push(i++);
        }
        return _results;
      };

      Buildings.prototype.saveLocalCopy = function() {};

      Buildings.prototype.addBuildingToLocalCopy = function() {};

      return Buildings;

    })(Backbone.Collection);
  });

}).call(this);
