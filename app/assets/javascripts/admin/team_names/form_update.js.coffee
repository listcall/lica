updateHelper = ->
  valz = $('#team_subdomain').val().replace(/\s+/g, ' ')
  valz = 'sub-domain' if valz.length == 0
  $('#subDomDisplay').text(valz)

$(document).ready ->
  updateHelper()
  $('#team_subdomain').keyup ->
    updateHelper()

