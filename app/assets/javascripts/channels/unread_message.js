(function () {
  if (!$('.room-item').length) return;
  App.unread_message = App.cable.subscriptions.create('UnreadMessageChannel', {
    received: function (data) {
      debugger;
      var $badge = $('.room-item[data-room-id="'+ data.room_id +'"]').find('.badge');
      $badge.html(Number($badge.html()) + 1);
    }
  });
})();
