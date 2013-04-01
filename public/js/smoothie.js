(function() {

  window.Smoothie = {
    Models: {},
    Views: {},
    Modules: {}
  };

  $(function() {
    return Smoothie.Views.PlayerView.bootstrap();
  });

}).call(this);
