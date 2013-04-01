(function() {

  Smoothie.Modules.Playlist = {
    tracks: [
      {
        artwork: 'https://i4.sndcdn.com/artworks-000034170195-wb7buo-t500x500.jpg',
        title: 'Mammals - Move Slower Feat. Flash Forest (FREE D/L in description)',
        url: 'http://www.google.com',
        uploader_name: 'Flash Forest',
        uploader_url: 'http://www.google.com'
      }, {
        artwork: 'https://i4.sndcdn.com/artworks-000037931943-gkafnb-t500x500.jpg',
        title: 'Sir Sly - Gold',
        url: 'http://www.google.com',
        uploader_name: 'Sir Sly',
        uploader_url: 'http://www.google.com'
      }, {
        artwork: 'https://i1.sndcdn.com/artworks-000033642979-p06mxq-t500x500.jpg',
        title: 'The Temper Trap - Sweet Disposition (RAC Mix)',
        url: 'http://www.google.com',
        uploader_name: 'RAC',
        uploader_url: 'http://www.google.com'
      }
    ],
    index: 1,
    next: function() {
      this.index += 1;
      return Smoothie.Views.PlayerView.moveTracksForward();
    },
    previous: function() {
      this.index -= 1;
      return Smoothie.Views.PlayerView.moveTracksBackward();
    },
    getPreviousTrack: function() {
      return this.tracks[this.index - 1];
    },
    getCurrentTrack: function() {
      return this.tracks[this.index];
    },
    getNextTrack: function() {
      return this.tracks[this.index + 1];
    }
  };

}).call(this);
