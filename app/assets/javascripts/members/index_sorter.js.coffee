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
      2: {sorter: 'dataSort'}
      3: {sorter: 'dataSort'}
    theme: "bootstrap"
    widthFixed: true
    headerTemplate: "{content} {icon}"
    widgets: ["uitheme", "filter", "zebra"]
    widgetOptions:
      zebra: ["even", "odd"]
      filter_reset: ".reset"

setupTablePager = ->
  $("table").tablesorterPager
    container: $(".pager")  # target the pager markup - see the HTML block below
    cssGoto: ".pagenum"     # target the pager page select dropdown - choose a page
    removeRows: false       # remove rows from the table to speed up the sort of large tables.
    output: "{startRow} - {endRow} / {filteredRows} ({totalRows})"

setupTableFilter = ->
  $.tablesorter.setFilters $('table'), filterVar, true
    # output string - default is '{page}/{totalPages}';
    # possible variables: {page}, {totalPages}, {filteredPages}, {startRow}, {endRow}, {filteredRows} and {totalRows}

$(document).ready ->
  setupTableSorter()
  setupTablePager()
  setupTableFilter()
