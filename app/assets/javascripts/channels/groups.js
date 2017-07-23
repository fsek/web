function initGroupCable() {
  var messages = $('#group-messages');
  if(messages.length <= 0) return;

  var groupId = messages.data('group-id');
  var userId = messages.data('user-id');
  var template = JST['templates/message'];

  var page = 2;
  var totalPages = 37;
  var loadingMessages = false;

  var toBottom = function() {
    messages.scrollTop(messages.prop('scrollHeight'));
  };

  var prependMessage = function(message) {
    messages.prepend(template({message: message, current_user: userId}));
  };

  var loadMessages = (function() {
    $.getJSON('/grupper/' + groupId + '/meddelanden/')
      .then(function(resp) {
        for (var i = 0; i < resp.messages.length; i++) {
          prependMessage(resp.messages[i]);
        }

        totalPages = resp.meta.total_pages;
        toBottom();
      });
  }());

  var appendMessage = function(message) {
    messages.append(template({message: message, current_user: userId}));
    toBottom();
  };

  var removeMessage = function(messageId) {
    $('.message#' + messageId).remove();
  };

  var updateMessage = function(message) {
    // If the message is loaded, update it!
    var msg = $('.message#' + message.id);
    if(!msg.length) return;

    msg.find('.msg-content').html(message.text);
    msg.find('.updated').html(message.updated_at);
  };

  var moreMessages = function() {
    // Keep a reference to the current top element
    var topMsg = $('.message:first');

    $.getJSON('/grupper/' + groupId + '/meddelanden?page=' + page)
      .then(function(resp) {
        for (var i = 0; i < resp.messages.length; i++) {
          prependMessage(resp.messages[i]);
        }

        // Scroll to the old top message
        messages.scrollTop(topMsg.position().top);

        page++;
        loadingMessages = false;
      });
  };

  App.groups = App.cable.subscriptions.create({
    channel: 'GroupsChannel',
    group_id: groupId },
  { connected: function() {},
    disconnected: function() {},
    received: function(data) {
      if (data.action == 'create') {
        appendMessage(data.message.message);
      } else if (data.action == 'destroy') {
        removeMessage(data.message_id);
      } else if (data.action == 'update') {
        updateMessage(data.message.message);
      }
    },
    sendMessage: function(content) {
      return this.perform('send_message', {
        content: content,
        group_id: groupId
      });
    },
    destroyMessage: function(messageId) {
      return this.perform('destroy_message', {
        message_id: messageId
      });
    }
  });

  $('#message_content').keypress(function(e) {
    if(e.which == 13 && !e.shiftKey) {
      App.groups.sendMessage($(this).val());
      $(this).val('');

      e.preventDefault();
      return false;
    }
  });

  $('#new_message').submit(function(e) {
    var content = $(this).find('#message_content');
    App.groups.sendMessage(content.val());
    content.val('');

    e.preventDefault();
    return false;
  });

  messages.on('click', '.destroy_button', function() {
    var messageId = $(this).closest('.message').attr('id');
    App.groups.destroyMessage(messageId);
  });

  messages.on('scroll', function() {
    if (messages.scrollTop() < 1 && page <= totalPages) {
      loadingMessages = true;
      moreMessages();
    }
  });
}

function removeGroupApp() {
  if(App.groups) App.cable.subscriptions.remove(App.groups);
  $('#group-messages').html('');
}

$(document).on('turbolinks:load', initGroupCable);
$(document).on('turbolinks:before-cache', removeGroupApp);
