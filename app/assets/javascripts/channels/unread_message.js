(function () {
  if (!$('.room-item').length) return;
  App.unread_message = App.cable.subscriptions.create('UnreadMessageChannel', {
    received: function (data) {
      var room = $('.room-item[data-room-id="'+ data.room_id +'"]').parent();
      var $badge = room.find('.badge');
      var list = $('.room-list').first();

      if ($badge.length === 0) {
        $('<span>| <span class="badge">1</span> unread</span>').insertAfter(room.find('.room-item-replies'));
      } else {
        $badge.html(Number($badge.html()) + 1);
      }

      var room_clone = room.clone();
      room.remove();
      list.prepend(room_clone);
    }
  });
})();
