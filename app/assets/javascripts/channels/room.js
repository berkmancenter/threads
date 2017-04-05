(function () {
  var roomId = $('#room-id').val();
  if (!roomId) return;
  App.room = App.cable.subscriptions.create({channel: 'RoomChannel', room_id: roomId}, {
    received: function (data) {
      $('.message-area').append(this.renderMessage(data));
    },
    renderMessage: function (data) {
      return '<div class="message-item"><strong class="message-user">'+ data.user +': </strong><span>'+ data.message +'</span></div>'
    }
  });
})();
