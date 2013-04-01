(function() {
  var PlayerView;

  PlayerView = Backbone.View.extend({
    el: '#current-track',
    tracks_container: '#tracks',
    bootstrap: function() {
      this.buildPreviousTrack();
      this.buildCurrentTrack();
      this.buildNextTrack();
      this.controls = new Smoothie.Views.ControlsView({
        el: "#controls"
      });
      return this.render();
    },
    moveTracksForward: function() {
      this.previousTrack.unbind().remove();
      this.previousTrack = this.currentTrack;
      this.previousTrack.$el.removeClass('current').addClass('previous');
      this.currentTrack = this.nextTrack;
      this.currentTrack.$el.removeClass('next').addClass('current');
      return this.buildNextTrack();
    },
    moveTracksBackward: function() {
      this.nextTrack.unbind().remove();
      this.nextTrack = this.currentTrack;
      this.nextTrack.$el.removeClass('current').addClass('next');
      this.currentTrack = this.previousTrack;
      this.currentTrack.$el.removeClass('previous').addClass('current');
      return this.buildPreviousTrack();
    },
    buildPreviousTrack: function() {
      this.previousTrack = new Smoothie.Views.TrackView({
        className: 'track previous',
        model: Smoothie.Modules.Playlist.getPreviousTrack()
      });
      return this.$el.find(this.tracks_container).append(this.previousTrack.render().el);
    },
    buildCurrentTrack: function() {
      this.currentTrack = new Smoothie.Views.TrackView({
        className: 'track current',
        model: Smoothie.Modules.Playlist.getCurrentTrack()
      });
      return this.$el.find(this.tracks_container).append(this.currentTrack.render().el);
    },
    buildNextTrack: function() {
      this.nextTrack = new Smoothie.Views.TrackView({
        className: 'track next',
        model: Smoothie.Modules.Playlist.getNextTrack()
      });
      return this.$el.find(this.tracks_container).append(this.nextTrack.render().el);
    },
    render: function() {
      return this.controls.render();
    }
  });

  Smoothie.Views.PlayerView = new PlayerView;

}).call(this);
