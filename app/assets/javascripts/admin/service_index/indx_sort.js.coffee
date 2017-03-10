# old_serv

$(document).ready ->
  $(document).ajaxSend (e, xhr, options) ->
    token = $("meta[name='csrf-token']").attr('content')
    xhr.setRequestHeader('X-CSRF-Token', token)

ajaxSort = ->
  doAjax = ->
    $.ajax
      url     :  "/admin/service_index/sort"
      type    : 'post'
      data    : {"target" : JSON.stringify(serializeIndex())}
      dataType: 'script'
  setTimeout doAjax, 100

serializeType = (child)->
  _.map $(child).find('.svc'), (child)-> child.id

window.serializeIndex = ->
  $idx = $('#serviceIndex')
  _.map $idx.children(".singleton, .type"), (child)->
    $child = $(child)
    return $child.children()[0].id if $child.hasClass('singleton')
    obj = {}
    obj[child.id] = serializeType(child)
    obj

singletonOpts =
  axis        : 'y'
  connectWith : '.dz'
  opacity     : 0.4
  dropOnEmpty : true
  update: (e, ui)->
    clearEmptySingletons()
    refreshIndexSort()
    ajaxSort() if ui.sender == null

indexOpts =
  axis        : 'y'
  opacity     : 0.4
  dropOnEmpty : true
  update : (e, ui)->
    wrapStandaloneCase()
    refreshIndexSort()
    ajaxSort() if ui.sender == null

caseOpts =
  axis        : 'y'
  opacity     : 0.4
  dropOnEmpty : true
  connectWith : '.dz'
  update      : (e, ui)->
    ajaxSort() if ui.sender == null

clearEmptySingletons = ->
  _.each $('#serviceIndex').children('.singleton'), (el)->
    $el = $(el)
    $el.remove() if $el.is(':empty')

wrapStandaloneCase = ->
  $('#serviceIndex').children('li').wrap("<div class='singleton'></div>")
  $('.singleton:not(.ui-sortable)').disableSelection().sortable singletonOpts

refreshIndexSort = -> $('#serviceIndex').sortable("refresh")

createSort = ->
  $('#serviceIndex').disableSelection().sortable indexOpts
  $('.singleton').disableSelection().sortable    singletonOpts
  $('.cases').disableSelection().sortable        caseOpts

$(document).ready ->
  createSort()

#  $('#serviceBody').sortable
#    axis: 'y'
#    opacity: 0.4
#    handle:  '.fa-arrows-v'
#    dropOnEmpty: true,
#    update: ->
#      $.ajax
#        url:  "/admin/service_list/sort"
#        type: 'post'
#        data: $('#serviceBody').sortable('serialize')
#        dataType: 'script'
#  $('#serviceBody').disableSelection()



