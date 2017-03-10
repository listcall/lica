window.Shared ||= {}

opts =
  format:    "yyyy-mm-dd"
  autoclose: true

Shared.setupDatepicker = ->
  $('#mem_cert_form_expire_date').unbind().datepicker(opts).on 'show', ->
    $('.datepicker').css('z-index', 1500)

addNewField = ->
  $el = $('#mem_cert_form_title option:selected')
  if $el.text() != "- add new -"
    $('#newTitle').hide()
    return
  $('#newTitle').show()

showLink = ->
  $('#linkBtn').attr('checked', 'checked')
  $('#fFile').addClass('hide')
  $('#fLink').removeClass('hide')

showFile = ->
  $('#fileBtn').attr('checked', 'checked')
  $('#fFile').removeClass('hide')
  $('#fLink').addClass('hide')

Shared.setupEvidenceField = ->
  switch "#{[hasFile, hasLink]}"
    when "true,true"
      $('#typeSelect').removeClass('hide')
      $('#fileBtn').click -> showFile()
      $('#linkBtn').click -> showLink()
      switch evType
        when 'link' then showLink()
        when 'file' then showFile()
        else showFile()
    when "true,false"
      showFile()
    when "false,true"
      showLink()
    when "false,false"
      "no-op"

Shared.setupTitleField = ->
  $('#mem_cert_form_title').unbind()
  addNewField()
  $('#mem_cert_form_title').change -> addNewField()