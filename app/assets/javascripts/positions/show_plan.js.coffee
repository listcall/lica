# ----- utility functions -----

findSelectedInCol = (weekId)->
  $("[id^='#{weekId}-'].green")

weekIdFx = (cell) ->
  idString = getId(cell)
  idString.split('-')[0..2].join('-')

getIds = (cell) ->
  idString = getId(cell)
  week_id  = idString.split('-')[2]
  mem_id   = idString.split('-')[3]
  {"week":week_id, "mem":mem_id}

getId = (cell) ->
  cell.attr('id')

# ----- show/clear extra assignments -----

clearExtraAssignments = ->
  $('.memlink').each (idx, el) ->
    label = $(el).text()
    return unless label.indexOf(" : ") != -1
    name = label.split(' : ')[0]
    $(el).text(name)

showExtraAssignments = ->
  $('.memrow').each (idx, el) ->
    numGreen = $(el).find('.green').length
    return if numGreen < 2
    linkEl = $(el).find('.memlink')
    linkTxt = $(linkEl).text()
    $(linkEl).text("#{linkTxt} : #{numGreen}")

adjustExtraAssignments = ->
  clearExtraAssignments()
  showExtraAssignments()

# ----- highlight row and column labels -----

highlightUnassignedMembers = ->
  $('.memrow').each (idx, el) ->
    numGreen = $(el).find('.green').length
    numAvail = $(el).find(':contains(A)').length
    if numGreen == 0 && numAvail != 0
      $(el).find('.memlabel').addClass('blue')
    else
      $(el).find('.memlabel').removeClass('blue')

highlightUnscheduledWeek = ->
  for idx in [1..13]
    headerCell = $("#week#{idx}")
    weekId = headerCell.attr('data-weekid')
    numGreen = findSelectedInCol(weekId).length
    if numGreen == 0
      headerCell.addClass('pink')
    else
      headerCell.removeClass('pink')

# ----- highlight top corner -----

unscheduledMemberCount = ->
  $('.blue').length

unscheduledWeekCount = ->
  $('.pink').length

highlightTopCorner = ->
  memberCount = unscheduledMemberCount()
  weekCount   = unscheduledWeekCount()
  if weekCount > 0
    weekHtml = "<span class='pink_label padded'>#{weekCount}</span>"
    memberHtml = "<span class='blue_label padded'>#{memberCount}</span>"
    dividerHtml = "<span class='padded'> / </span>"
    $('#top_corner').html("<nobr class='padded'>#{memberHtml}#{dividerHtml}#{weekHtml}</nobr>")
  else
    $('#top_corner').html("")

# ----- find/highlight clicked cells -----

findClickedCells = (el) ->
  new_cell = $(el)
  week_id  = weekIdFx(new_cell)
  old_cell = findSelectedInCol(week_id)
  {"new": new_cell, "old": old_cell}

highlightClickedCells = (tgt_cell) ->
  tgt_cell.new.addClass('green')
  tgt_cell.old.removeClass('green')

# ----- update the database using AJAX -----

doAjax = (cell, directive)->
  $.ajax
    method: 'put'
    url: "/ajax/position_bookings/#{cell}"
    data: {directive: directive}
    success: (data)->
      $('#rost').html(data)
    failure: -> console.log "it failed"

updateDatabaseUsingAjax = (tgt_cell) ->
  doAjax(getId(tgt_cell.new), 'select')
  doAjax(getId(tgt_cell.old), 'unselect') unless tgt_cell.old.length == 0

# ----- callback when a cell is clicked -----

selectClickedCell = (el) ->
  tgt_cell = findClickedCells(el)
  highlightClickedCells(tgt_cell)
  highlightUnassignedMembers()
  highlightUnscheduledWeek()
  highlightTopCorner()
  adjustExtraAssignments()
  updateDatabaseUsingAjax(tgt_cell)

# ----- callback upon cell mouseover -----

clearMouseoverHeaders = ->
  $('.mouseover_hdr').removeClass('mouseover_hdr')

highlightMouseoverHeaders = (ids) ->
  $("#week#{ids["week"]}").addClass('mouseover_hdr')
  $("#mem#{ids["mem"]}").addClass('mouseover_hdr')

highlightMouseoverCell = (el) ->
  cell  = $(el)
  ids   = getIds(cell)
  clearMouseoverHeaders()
  highlightMouseoverHeaders(ids)

# ----- initializer -----

$(document).ready ->
  highlightUnassignedMembers()
  highlightUnscheduledWeek()
  highlightTopCorner()
  adjustExtraAssignments()
  $('.status').click      -> selectClickedCell(@)
  $('.status').mouseenter -> highlightMouseoverCell(@)
  $('.status').mouseleave -> clearMouseoverHeaders()