(function () {
  var roomId = $('#room-id').val();
  App.messages = App.cable.subscriptions.create({channel: 'MessagesChannel', room_id: roomId}, {
    received: function (data) {
      $('.message-area').append(this.renderMessage(data));
    },
    renderMessage: function (data) {
      return '<div class="message-item"><strong class="message-user">'+ data.user +': </strong><span>'+ data.message +'</span></div>'
    }
  });
})();
