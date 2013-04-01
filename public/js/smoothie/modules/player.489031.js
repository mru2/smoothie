(function() {

  Smoothie.Modules.Player = {
    playing: false,
    track: null,
    play: function() {
      this.playing = true;
      return Smoothie.Views.PlayerView.render();
    },
    pause: function() {
      this.playing = false;
      return Smoothie.Views.PlayerView.render();
    }
  };

}).call(this);
