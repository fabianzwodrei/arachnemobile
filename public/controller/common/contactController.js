// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['../../controller/controller', 'text!../../../layouts/contact.html'], function(Controller, layout) {
    var ContactController, _ref;
    return ContactController = (function(_super) {
      __extends(ContactController, _super);

      function ContactController() {
        _ref = ContactController.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      ContactController.prototype.layout = _.template(layout);

      ContactController.prototype.id = 'contactView';

      ContactController.prototype.className = 'container';

      ContactController.prototype.initialize = function(params) {
        this.user = params.user;
        return $(this.el).html(this.layout({
          user: this.user.toJSON()
        }));
      };

      ContactController.prototype.release = function() {
        this.undelegateEvents();
        return this.remove();
      };

      return ContactController;

    })(Controller);
  });

}).call(this);
