initAdr = ->
  lNam = $('#location_name').editable('getValue').location_name
  lAdr = $('#location_address').editable('getValue').location_address
  "#{lAdr}, #{lNam}, California"

$(document).ready ->
  # launching the geopicker
  $('#geoPick').click ->
    geoPickerModal(initAdr())

  # geopicker save event
  $('#geoPickerSaveBtn').click ->
    nam = $('#locNam').text()
    adr = $('#locAdr').text()
    lat = $('#locLat').text()
    lon = $('#locLon').text()
    $('#location_name').editable    'setValue', nam, false
    $('#location_address').editable 'setValue', adr, false
    $('#lat').editable              'setValue', lat, false
    $('#lon').editable              'setValue', lon, false
    $('#location_name').addClass    'editable-unsaved'
    $('#location_address').addClass 'editable-unsaved'
    $('#lat').addClass              'editable-unsaved'
    $('#lon').addClass              'editable-unsaved'
    $('#geoPicker').modal('hide')
    data =
      "event[location_name]" : nam
      "event[location_address]" : adr
      "event[lat]" : lat
      "event[lon]" : lon
    doAjax data