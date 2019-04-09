(function () {
  var roomId = $('#room-id').val();
  if (!roomId) {
    return;
  }

  var $messageArea = $('.message-area');
  var $messageForm = $('.message-form textarea');

  App.room = App.cable.subscriptions.create({channel: 'RoomChannel', room_id: roomId}, {
    received: function (data) {
      let goDown = false;

      if($messageArea.scrollTop() + $messageArea.innerHeight() >= $messageArea[0].scrollHeight) {
        goDown = true;
      }

      $messageArea.append(this.renderMessage(data));
      $messageForm.val('');

      if (goDown === true) {
        scrollToBottom($messageArea);
      }
    },
    renderMessage: function (data) { return messageItemTmpl(data.username, data.content); }
  });

  function messageItemTmpl(user, message) {
    return '<div class="message-item"><strong class="message-user">'+ user +': </strong><span>'+ message +'</span></div>'
  }
})();
