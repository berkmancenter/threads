(function () {
  App.unread_messages = [];
  $('.room-item').each(function (e, i) {
    var $this = $(this);
    var roomId = $this.data('room-id');
    App.unread_messages[i] = App.cable.subscriptions.create({channel: 'UnreadMessageChannel', room_id: roomId}, {
      received: function (data) {
        $this.find('.badge').html(data.count_unread_messages)
      }
    });
  });
})();
