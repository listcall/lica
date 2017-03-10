$ ->
  $.extend $.tablesorter.themes.bootstrap,
#    table      : 'table table-bordered'
#    table      : 'table'
    table      : ''
    caption    : 'caption'
#    header     : 'bootstrap-header'
    header     : ''
    footerRow  : ''
    footerCells: ''
    icons      : ''
    sortNone   : ''
    sortAsc    : ''
    sortDesc   : ''
    active     : ''  # applied when column is sorted
    hover      : ''  # use custom css here - bootstrap class may not override it
    filterRow  : ''  # filter row class
    even       : ''  # odd row zebra striping
    odd        : ''  # even row zebra striping

dataSort =
  id     : 'dataSort'
  is     : (s) -> false
  type   : 'text'
  format : (s, table, cell) ->
             $(cell).attr('data-sort')

#-----

# see https://github.com/Mottie/tablesorter/issues/83
# see http://jsfiddle.net/Mottie/abkNM/163/
checkSort =
  id     : "checkSort"
  type   : "numeric"
  is     : (s) -> false
  format : (s, table, cell, cellIndex) ->
    $t = $(table)
    $c = $(cell)

    unless $t.hasClass("hasCheckbox")
      $t.addClass("hasCheckbox")   # don't run this twice...
      $t.find("tbody tr").each ->
        $(this).find("td:eq(" + cellIndex + ")").find("input[type=checkbox]").bind "change", ->
          $t.trigger "updateCell", [ $(this).closest("td")[0], false ]
    # return 1 for true, 2 for false, so true sorts before false
    if ($c.find("input[type=checkbox]")[0].checked) then 1 else 2

# -----

setupTableSorter = ->
  $.tablesorter.addParser dataSort
  $.tablesorter.addParser checkSort
  $("table").tablesorter
    headers:
      0: {sorter: 'dataSort'}
      1: {sorter: 'dataSort'}
      2: {sorter: 'dataSort'}
      3: {sorter: 'dataSort'}
      4: {sorter: 'checkSort'}
    theme          : "bootstrap"
    widthFixed     : true
    headerTemplate : '{content} {icon}'
    widgets        : [ "uitheme", "filter", "zebra" ]
    widgetOptions  :
      filter_hideFilters : true
      zebra              : ["even", "odd"]

window.sorted   = false
window.filtered = false

resetTableSorter = ->
  $('table').trigger('sortReset').trigger('filterReset')
  sorted   = false
  filtered = false
  hideResetButton()

onSort = ->
  sorted = true
  showResetButton()

onFilter = ->
  filtered = true
  showResetButton()

clearFilter = ->
  filtered = false
  $('table').trigger('filterReset')
  hideResetButton()

showResetButton = ->
  $('#clearSort').show()

hideResetButton = ->
  $('#clearSort').blur().hide() if sorted == false && filtered == false

$(document).ready ->
  setupTableSorter()
  $('#clearSort').click resetTableSorter
  #$('#rightCol').click  clearFilter
  $('table').bind "sortEnd"   , onSort
  $('table').bind "filterEnd" , onFilter