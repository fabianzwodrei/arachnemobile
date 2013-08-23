// Generated by CoffeeScript 1.6.3
(function() {
  var SALT_WORK_FACTOR, UserSchema, bcrypt, mongoose;

  mongoose = require('mongoose');

  bcrypt = require('bcrypt');

  SALT_WORK_FACTOR = 10;

  UserSchema = new mongoose.Schema({
    email: {
      type: String,
      required: true,
      index: {
        unique: true
      }
    },
    password: {
      type: String,
      required: true
    }
  });

  UserSchema.pre('save', function(next) {
    var user;
    user = this;
    if (!user.isModified('password')) {
      retrun(next());
    }
    return bcrypt.genSalt(SALT_WORK_FACTOR, function(err, salt) {
      if (err) {
        return next(err);
      }
      return bcrypt.hash(user.password, salt, function(err, hash) {
        if (err) {
          return next(err);
        }
        user.password = hash;
        return next();
      });
    });
  });

  UserSchema.methods.comparePassword = function(candidatePassword, cb) {
    return bcrypt.compare(candidatePassword, this.password, function(err, isMatch) {
      if (err) {
        return cb(err);
      }
      return cb(null, isMatch);
    });
  };

  module.exports = mongoose.model("User", UserSchema);

}).call(this);