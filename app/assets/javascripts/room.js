(function () {
  var roomId = $('#room-id').val();
  if (!roomId) return;

  var $messageArea = $('.message-area');
  var $messageForm = $('.message-form textarea');

  $(function () {
    scrollToBottom($messageArea);
    onEnterMessageform();
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
})();
