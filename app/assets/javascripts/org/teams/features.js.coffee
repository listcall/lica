updateServer = (teamId, feature, status)->
  $.ajax
    url: "/org/teams/#{teamId}/team_features/#{feature}"
    method: "put"
    data: {status: status}
    success: ->
      return unless status == "RESET"
      getTeamFeatures(teamId)

renderCheckboxes = (teamId, data)->
  hash = JSON.parse(data)
  keys = _.keys(hash)
  list = _.map keys, (key)->
    name = key.split('_')[1]
    chkd = if hash[key] == "on" then 'checked' else ''
    "<input type=checkbox id='#{key}' class='jX' #{chkd}> #{key}"
  $('#featureBody').html(list.join("<p></p>"))
  $('.jX').change (ev)->
    $tgt = $(ev.target)
    status = if $tgt.prop('checked') then 'on' else 'off'
    updateServer(teamId, $tgt.attr('id'), status)

getTeamFeatures = (id)->
  $('#featureBody').text('Loading...')
  $.get "/org/teams/#{id}/team_features", (data)->
    renderCheckboxes(id, data)

$(document).ready ->
  $('.ftBtn').click (ev)->
    $tgt = $(ev.target)
    name = $tgt.data('teamname')
    id   = $tgt.attr('id').split('_')[1]
    $('#modal-title').text("Update Features for #{name}")
    $('#featureModal').modal()
    getTeamFeatures(id)
    $('#resetBtn').click ->
      updateServer(id, "TBD", "RESET")
