doShow = ->
  $('#descEdit').editable('show')

startEditor = ->
  $('#descShow').hide()
  $('#descEdit').show()
  setTimeout doShow, 150

stopEditor = ->
  $('#descShow').show()
  $('#descEdit').hide()

$(document).ready ->
  $('#descEdit').editable
    rows: 4
    inputclass:  'text-area-input'
    showbuttons: 'bottom'
    ajaxOptions:
      type: 'put'
  $('#descShow').click startEditor
  $('#descEdit').on 'hidden', ->
    stopEditor()
  $('#descEdit').on 'save', (e, params)->
    $('#descShow').html(params.newValue)
    $('#descShow').addClass('editable-unsaved')