(function () {
  if (!$('.room-item').length) return;
  App.unread_message = App.cable.subscriptions.create('UnreadMessageChannel', {
    received: function (data) {
      $.get('/rooms/simple', {
        room_id: $('#room-id').val()
      }, function (data) {
        var list = $('.room-list').first();
        list.html(data);
      })
    }
  });
})();
