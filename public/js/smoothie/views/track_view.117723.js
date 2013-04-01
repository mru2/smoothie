(function() {

  Smoothie.Views.TrackView = Backbone.View.extend({
    template: '\
    <div class="overlay"></div>\
    <a class="artist" href="<%= track.uploader_url %>"><%= track.uploader_name %></a>\
    <br>\
    <a class="title" href="<%= track.url %>"><%= track.title %></a>\
  ',
    initialize: function() {
      return console.log('Initializing TrackView');
    },
    render: function() {
      if (this.model) {
        this.$el.html(_.template(this.template, {
          track: this.model
        }));
        this.$el.css('background-image', "url(" + this.model.artwork + ")");
      }
      return this;
    }
  });

}).call(this);
