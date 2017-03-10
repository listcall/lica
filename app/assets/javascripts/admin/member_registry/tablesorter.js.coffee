$ ->
  $.extend $.tablesorter.themes.bootstrap,
    table      : 'table table-bordered'
    caption    : 'caption'
    header     : 'bootstrap-header'
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
  id: 'dataSort'
  is: (s) -> false
  type: 'text'
  format: (s, table, cell) -> $(cell).attr('data-sort')

setupTableSorter = ->
  $.tablesorter.addParser dataSort
  $("table").tablesorter
    headers:
      0: {sorter: false}
      1: {sorter: 'dataSort'}
      2: {sorter: 'dataSort'}
      3: {sorter: 'dataSort'}
      4: {sorter: 'dataSort'}
      5: {sorter: false}
    theme          : "bootstrap"
    widthFixed     : true
    headerTemplate : '{content} {icon}'
    widgets        : [ "uitheme", "filter", "zebra" ]
    widgetOptions  :
      zebra        : ["even", "odd"]
      filter_reset : ".reset"

resetTableSorter = ->
  $('#tablesort').trigger('filterReset')
  $('#tablesort').trigger('sortReset')
  $('#clearSort').blur()

$(document).ready ->
  setupTableSorter()
  $('#clearSort').click resetTableSorter