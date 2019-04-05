(function () {
  if (!$('.room-item').length) return;

  App.unread_message = App.cable.subscriptions.create('UnreadMessageChannel', {
    received: function (data) {
      $.get('/rooms/simple', {
        id: $('#room-id').val(),
        access_token: $('#access-token').val()
      }, function (data) {
        if ($('.room-list:hover').length === 0) {
          var list = $('.room-list').first();
          list.html(data);
        }
      })
    }
  });
})();
