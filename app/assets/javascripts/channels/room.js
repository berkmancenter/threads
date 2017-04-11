(function () {
  var roomId = $('#room-id').val();
  if (!roomId) return;

  App.room = App.cable.subscriptions.create({channel: 'RoomChannel', room_id: roomId}, {
    received: function (data) {
      $('.message-area').append(this.renderMessage(data));
      $('.message-form textarea').val('');
    },
    renderMessage: function (data) {
      return '<div class="message-item"><strong class="message-user">'+ data.user +': </strong><span>'+ data.message +'</span></div>'
    }
  });

  $(function () {
    $('.message-area').scrollTop($('.message-area')[0].scrollHeight);
    $('.message-form textarea').on('keydown', function (e) {
      if (!this.value || !this.value.trim()) return;
      if (e.keyCode == 13 && !e.shiftKey) {
        e.preventDefault();
        $('form#new_message').submit();
      }
    });
  });
})();
