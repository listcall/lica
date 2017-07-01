# note this ajax call relies on the CSRF token
# being set in show_ajax.coffee...
updateServer = (val)->
  $.ajax
    url:  "/ajax/members/#{lclData.memberId}"
    type: 'put'
    data: {name: 'editor_keystyle', value: val}

setHandler = (state)->
  mode = switch state
    when "emacs"    then "ace/keyboard/emacs"
    when "vim"      then "ace/keyboard/vim"
    when "notepad"  then ""
  editor = ace.edit("editor")
  editor.setKeyboardHandler(mode)

updateKeyStyleSettings = (showState = lclData.keyStyle)->
  updateServer(showState)
  setHandler(showState)

$(document).ready ->
  $('#styleRadio').button()
  $('.styleBtn').change (ev)->
    newState = ev.target.id
    return unless $("#" + "#{newState}").is(':checked')
    lclData.keyStyle = newState
    updateKeyStyleSettings(newState)
  $("#" + "#{lclData.keyStyle}").click()
