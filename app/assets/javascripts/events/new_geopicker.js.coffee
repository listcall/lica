initAdr = ->
  lNam = $('#frmNam').val()
  lAdr = $('#frmAdr').val()
  "#{lAdr}, #{lNam}, California"

$(document).ready ->
  # launching the geopicker
  $('#frmNam').keyup (ev)->
    if (ev.keyCode == 13 && ev.ctrlKey)
      ev.preventDefault()
      geoPickerModal(initAdr())
  $('#frmNam-ico').click ->
    geoPickerModal(initAdr())

  # geopicker save event
  $('#geoPickerSaveBtn').click ->
    nam = $('#locNam').text()
    adr = $('#locAdr').text()
    lat = $('#locLat').text()
    lon = $('#locLon').text()
    $('#frmNam').val(nam)
    $('#frmAdr').val(adr)
    $('#frmLat').val(lat)
    $('#frmLon').val(lon)
    $('#geoPicker').modal('hide')
    $('#frmNam').focus()

