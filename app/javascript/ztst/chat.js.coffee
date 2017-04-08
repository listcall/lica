ActionCable = require("actioncable")

Zapp = {}

Zapp.cable = ActionCable.createConsumer("/cable");

Zapp.chatChannel = Zapp.cable.subscriptions.create { channel: "ChatChannel", room: "Lobby"},
  received: (data) ->
    @appendLine(data)
    #
    $('#chat-feed').stop().animate { scrollTop: $('#chat-feed')[0].scrollHeight }, 800

  appendLine: (data) ->
    html = @createLine(data)
    $("[data-chatroom='Lobby']").append(html)

  createLine: (data) ->
    """
    <article class="chat-line">
      <span class="speaker">#{data["username"]} :</span>
      <span class="body">#{data["message"]}</span>
    </article>
    """

module.exports = Zapp
