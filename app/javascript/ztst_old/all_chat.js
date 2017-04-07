// app/assets/javascripts/ztst/all_cable.js
//
//
//= require action_cable
//= require_self
//= require chat

(function() {
  this.App || (this.App = {});

  App.cable = ActionCable.createConsumer("/cable");

}).call(this);
