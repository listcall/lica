# old_serv

setEditorHeight = ->
  winHeight = window.innerHeight
  buffer = 170
  $('#editor').height(winHeight - buffer)

$(document).ready ->
  setEditorHeight()
  $(window).resize setEditorHeight
  if $('#editor').length > 0
    editor = ace.edit("editor")
    editor.setKeyboardHandler("ace/keyboard/vim")
    editor.getSession().setMode("ace/mode/handlebars")
    editor.getSession().setTabSize(2)
    editor.setValue(_.unescape($('#inputTemplate').html()))
    $('#saveBtn').click ->
      $.ajax
        method: "put"
        url   : "/admin/service_reps/#{lclData.reportId}"
        data:
          name : 'template_text'
          value: "#{editor.getValue()}"