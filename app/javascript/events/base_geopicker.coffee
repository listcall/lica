window.initMap = (locName)->
  $('#searchBox').val(locName)
  $('#searchBox').focus()
  unless $('#map-canvas').is(':empty')
    $('#searchBtn')[0].click() unless locName == ""
    return
  $('.dataUpdate').hide()
  startPos   = new google.maps.LatLng(37.48853, -122.23026)
  lastSearch = ""
  mapOptions =
    zoom:      10
    center:    startPos
    mapTypeId: google.maps.MapTypeId.ROADMAP
    streetViewControl: false
    disableDoubleClickZoom: true
  map    = new google.maps.Map($("#map-canvas")[0], mapOptions)
  marker = new google.maps.Marker
    map:       map
    position:  startPos
    animation: google.maps.Animation.DROP
    draggable: true
  updateLocDisplay = (pos)->
    adj = 10000                                 # four digits = 10m accuracy, five digits = 1m accuracy
    lat = Math.round(pos.lat() * adj) / adj
    lon = Math.round(pos.lng() * adj) / adj
    $('#locLat').text(lat)
    $('#locLon').text(lon)
    $('.dataUpdate').show()
  getAdrDisplay = (result)->
    address = result.formatted_address.replace(/, [A-Z][A-Z][A-Z ]*/g, '').
                                       replace(/\d\d\d\d\d/g,'').
                                       replace(/, California *$/, '').
                                       replace(/, United States */, '').
                                       replace(/^- /,'')
    parseAdrDisplay(address)
  parseAdrDisplay = (address) ->
    if address.indexOf(',') == -1     # if there is no comma...
      setAdrDisplay address, "", ""
      return
    spAdr = address.split(', ')
    if lastSearch == "" or address.toLowerCase().indexOf("#{lastSearch.toLowerCase()}, ") == -1
      name  = spAdr[spAdr.length - 1]
      adrs  = spAdr.slice(0, spAdr.length - 1).join(', ')
      setAdrDisplay(name, '<br/>', adrs)
      return
    name = spAdr[0]
    adrs = spAdr.slice(1, spAdr.length).join(', ')
    setAdrDisplay(name, "<br/>", adrs)
  setAdrDisplay = (name, sep, address) ->
    $('#locNam').text(name)
    $('#locSep').html(sep)
    $('#locAdr').text(address)
  setMarker = (results, pos)->
    map.setCenter(pos)
    updateLocDisplay(pos)
    getAdrDisplay(results[0])
    $('#searchBox').focus()
  google.maps.event.addListener map, 'dragend', =>
    $('#searchBox').focus()
  google.maps.event.addListener marker, 'dragend', =>
    pos = marker.getPosition()
    coder = new google.maps.Geocoder()
    coder.geocode {latLng: pos}, (results)->
      setMarker(results, pos)
  google.maps.event.addListener map, 'dblclick', (data)=>
    data.stop()
    loc = data.latLng
    coder = new google.maps.Geocoder()
    coder.geocode {latLng: loc}, (results)->
      lat = loc.lat() || loc.ob()
      lon = loc.lng() || loc.pb()
      pos = new google.maps.LatLng(lat, lon)
      marker.setPosition(pos)
      setMarker(results, pos)
  google.maps.event.addDomListener $('#searchBtn')[0], 'click', =>
    adr = $('#searchBox').val()
    return if adr == ''
    lastSearch = adr
    $('#searchBox').val('')
    $('#searchBox').focus()
    coder = new google.maps.Geocoder()
    coder.geocode {address: adr}, (results) ->
      loc = results[0].geometry.location
      lat = loc.lat() || loc.ob()
      lon = loc.lng() || loc.pb()
      pos = new google.maps.LatLng(lat, lon)
      marker.setPosition(pos)
      setMarker(results, pos)
  $('#searchBtn')[0].click() unless locName == ""

window.geoPickerModal = (startVal = "")->
  $('#geoPicker').modal()
  initMap(startVal)

$(document).ready ->
  $('#searchBox').keyup (ev)->
    if (ev.keyCode == 13)
      $('#searchBtn')[0].click()

