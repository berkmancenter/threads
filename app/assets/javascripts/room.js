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
    var expander = $('.room-chat-expander').first();
    var headerTitleText = $('.room-chat-header-title').first().text();

    expander.on('click', function () {
      var roomsBox = $('.room-chat-rooms').first();
      var messagesBox = $('.room-chat-messages').first();
      var headerTitle = $('.room-chat-header-title').first();
      var headerSubtitle = $('.room-chat-header-subtitle').first();

      if (!messagesExpanded) {
        // Ugly fix (but works) to stop removeClass animations play with the
        // height of the messages container
        $('head').append(
          '<style id="expanderCustomCSS">.room-chat-messages { height: 100% !important; }</style>'
        );
        messagesBox
          .removeClass('col-sm-6', 600)
          .addClass('col-sm-12', 600);
        roomsBox
          .animate({ width: 'toggle' }, 450)
          .css('maxHeight', '200px');
        expander.find('i')
          .removeClass('fa-expand')
          .addClass('fa-compress');
        expander.attr(
          'title',
          'Click to show the threads list'
        );
        headerTitle.text($('.room-item.active .media-heading').text());
        headerSubtitle.hide();
      } else {
        $('#expanderCustomCSS').remove();
        messagesBox
          .css('height', 'auto')
          .addClass('col-sm-6', 300)
          .removeClass('col-sm-12', 300);
        setTimeout(function () {
          roomsBox.animate({ width: 'toggle' }, 450);
        }, 100);
        setTimeout(function () {
          roomsBox.css('maxHeight', 'none');
        }, 250);
        expander.find('i')
          .addClass('fa-expand')
          .removeClass('fa-compress');
        expander.attr(
          'title',
          'Click to expand the message area'
        );
        headerTitle.text(headerTitleText);
        headerSubtitle.show();
      }

      messagesExpanded = !messagesExpanded;
    });
  }
})();
