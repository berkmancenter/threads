(function () {
  var roomId = $('#room-id').val();
  if (!roomId) {
    return;
  }

  var $messageArea = $('.message-area');
  var $messageForm = $('.message-form textarea');
  var messagesExpanded = false;

  $(function () {
    scrollToBottom($messageArea);
    onEnterMessageform();
    handleMessageAreaExpanding();
  });

  function onEnterMessageform () {
    $messageForm.on('keydown', function (e) {
      if (!this.value || !this.value.trim()) return;
      if (e.keyCode == 13 && !e.shiftKey) {
        e.preventDefault();
        $('form#new_message').submit();
      }
    });
  }

  function handleMessageAreaExpanding () {
    $('.room-chat-expander').on('click', function () {
      if (!messagesExpanded) {
        $('.room-chat-messages').animate({ width: '100%' }, 600);
        $('.room-chat-rooms').animate({ width: 'toggle' }, 450);
        $('.room-chat-rooms').css({ maxHeight: '200px' }, 450);
        $('.room-chat-expander i').removeClass('fa-expand');
        $('.room-chat-expander i').addClass('fa-compress');
        $('.room-chat-expander').attr(
          'title',
          'Click to show the threads list'
        );
      } else {
        $('.room-chat-messages').animate({ width: '50%' }, 300);
        setTimeout(function () {
          $('.room-chat-rooms').animate({ width: 'toggle' }, 450);
          $('.room-chat-rooms').css({ maxHeight: 'auto' }, 450);
        }, 100);
        $('.room-chat-expander i').addClass('fa-expand');
        $('.room-chat-expander i').removeClass('fa-compress');
        $('.room-chat-expander').attr(
          'title',
          'Click to expand the message area'
        );
      }

      messagesExpanded = !messagesExpanded;
    });
  }
})();
