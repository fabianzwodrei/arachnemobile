// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['../controller', 'text!/../static/layouts/login.html', '../../models/user'], function(Controller, Layout, User) {
    var SessionController, _ref;
    return SessionController = (function(_super) {
      __extends(SessionController, _super);

      function SessionController() {
        _ref = SessionController.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      SessionController.prototype.events = {
        'submit #signIn': 'login',
        'submit #signUp': 'login'
      };

      SessionController.prototype.initialize = function(params) {
        $('body').append(this.el);
        return $(this.el).html(_.template(Layout));
      };

      SessionController.prototype.login = function(event) {
        var array, postdata;
        event.preventDefault();
        array = $(event.target).serializeArray();
        postdata = {};
        _.each(array, function(formInput) {
          return postdata[formInput.name] = formInput.value;
        });
        this.user = new User(postdata);
        this.user.bind('sync', this.forwardToBuildings, this);
        this.user.bind('error', this.tryagain, this);
        return this.user.save();
      };

      SessionController.prototype.tryagain = function(e) {
        this.user.unbind('error', this.tryagain, this);
        return alert("Nochmal bitte, irgendwas war falsch.");
      };

      SessionController.prototype.forwardToBuildings = function() {
        this.user.unbind('sync', this.forwardToBuildings, this);
        return $(window.location).attr({
          href: '#buildings'
        });
      };

      SessionController.prototype.release = function() {
        if (this.user != null) {
          delete this.user;
        }
        return this.remove();
      };

      return SessionController;

    })(Controller);
  });

}).call(this);
