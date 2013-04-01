(function() {

  Smoothie.Views.ControlsView = Backbone.View.extend({
    template: '\
    <a class="control pull-left" id="prev"><i class="icon-backward"></i></a>\
    <% if (playing) { %>\
      <a class="control" id="pause"><i class="icon-pause"></i></a>\
    <% } else { %>\
      <a class="control" id="play"><i class="icon-play"></i></a>\
    <% } %>\
    <a class="control pull-right" id="next"><i class="icon-forward"></i></a>\
  ',
    events: {
      "click #play": "onPlay",
      "click #pause": "onPause",
      "click #next": "onNext",
      "click #prev": "onPrevious"
    },
    onPlay: function() {
      return Smoothie.Modules.Player.play();
    },
    onPause: function() {
      return Smoothie.Modules.Player.pause();
    },
    onPause: function() {
      return Smoothie.Modules.Player.pause();
    },
    onPrevious: function() {
      return Smoothie.Modules.Playlist.previous();
    },
    onNext: function() {
      return Smoothie.Modules.Playlist.next();
    },
    render: function() {
      return this.$el.html(_.template(this.template, {
        playing: Smoothie.Modules.Player.playing
      }));
    }
  });

}).call(this);
