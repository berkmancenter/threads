(function () {
  var roomId = $('#room-id').val();
  var userId = $('#user-id').val();
  if (!roomId) {
    return;
  }

  var $messageArea = $('.message-area');
  var $messageForm = $('.message-form textarea');

  App.room = App.cable.subscriptions.create({ channel: 'RoomChannel', room_id: roomId }, {
    received: function (data) {
      switch (data.action) {
        case 'new_message':
          addNewMessage(data.data);

          break;
        case 'muted_user':
          removeMessagesOfMutedUser(data.data);
          muteMutedUser(data.data);

          break;
        default:

      }
    }
  });

  function addNewMessage (data) {
    let goDown = false;

    if($messageArea.scrollTop() + $messageArea.innerHeight() >= $messageArea[0].scrollHeight) {
      goDown = true;
    }

    $messageArea.append(data.message);

    if (goDown === true) {
      scrollToBottom($messageArea);
    }
  }

  function removeMessagesOfMutedUser (data) {
    var selectors = [];

    $(data.messages_ids).each(function (index, messageId) {
      selectors.push(`.message-area .message-item[data-message-id='${messageId}']`);
    });

    $(selectors.join(',')).remove();
  }

  function muteMutedUser (data) {
    if (data.muted_user_id === parseInt(userId)) {
      $messageForm.prop('disabled', true);
      $messageForm.val('You\'ve been muted in this thread and can\'t post any new messages');
    }
  }
})();
