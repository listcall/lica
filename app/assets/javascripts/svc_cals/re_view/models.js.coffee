#= require moment

[tst_start, tst_end] = [moment(), moment().add(2, 'hours')]
eventList = [{ id: 22, title: "johnm", start: tst_start, end: tst_end }]
memList   = [{ avatar: "/test/path", user_name: "johnm", value: "John Man" }]
unavails  = {}

RM = {}

class RM.Grid
  pv = { start: moment() }
  constructor: (args = {})->
    pv = {}
    pv.filter   = ""
    pv.dates    = new RM.Dates
    pv.members  = new RM.Members
    pv.cursor   = new RM.Cursor(@)
    pv.catalog  = new RM.Catalog(@)
    pv.unavails = {}
    pv.rows     = new RM.Rows(@)
    pv = _.extend(pv, args)
  @property 'events',
    get: -> pv.events || []
    set: (events)->
      pv.events = events
      pv.unavails = @getUnavails()
      pv.catalog.generate()
  @property 'filter' ,
    get: -> pv.filter
    set: (newFilt)-> pv.filter = newFilt; pv.catalog.generate()
  @property 'today'    , get: -> moment().format("ddd M/D")
  @property 'cursor'   , get: -> pv.cursor
  @property 'rows'     , get: -> pv.rows
  @property 'catalog'  , get: -> pv.catalog
  @property 'unavails' , get: -> pv.unavails
  @property 'members'  , get: -> pv.members.list
  @property 'memFilt'  , get: -> pv.members.filtered(pv.filter)
  @property 'dates'    , get: -> pv.dates.startingOn(pv.start)
  @property 'wkStart'  , get: -> pv.start.clone().local()
  numRows: -> _.max([0, pv.members.filtered(pv.filter).length])
  getUnavails: ->
    unavails = {}
    $.ajax
      url:    "/avail/days.json"
      method: "GET"
      async:  false
      data:   {}       # TODO: add start/finish
      success: (data)-> unavails = data
    unavails

class RM.Dates
  startingOn: _.memoize (start = moment())->
    _.map [0..6], (offset)-> genDate(start, offset)
  # ----- private -----
  genDate = (start, offset)->
    start.clone().add(offset, 'days').local().format("ddd M/D")

class RM.Members
  constructor: ->
    @list = defaultMembers()
  filtered: (filter)->
    return @list if filter == ""
    reg = new RegExp(filter, 'i')
    _.select @list, (mem)-> mem.value.match(reg)
  # ----- private -----
  defaultMembers = -> _.sortBy (lclData?.memList || memList), (mem)->
    "#{mem.last_name} #{mem.first_name}"

class RM.Cursor
  constructor: (@grid = {}, @position = undefined)->
    return unless @position == undefined
    if (oldPos = $.cookie(@positionKey()))
      @position = oldPos
    else
      @position = "0_0"
  @property 'coords' , get: -> @position.split('_')
  @property 'row'    , get: -> parseInt(@coords[0])
  @property 'col'    , get: -> parseInt(@coords[1])
  @property 'date'   , get: -> @grid.wkStart.add(@col, 'days')
  @property 'cell'   , get: -> @grid.rows.list[@row]?.cells[@col]
  @property 'dateStr', get: -> @date.format('YYYY-MM-DD')
  positionKey: -> "cursorPosition_#{@numRows()}_#{lclData?.teamId}"
  updatePosition: ->
    @setPosition("0_#{@col}") if (@row + 1) > @numRows()
  setPosition: (newPos)->
    $.cookie(@positionKey(), newPos, {expires:1, path: '/'})
    @position = newPos
  events   : -> @grid.rows.getCell(@row, @col)?.events
  member   : -> @grid.memFilt[@row]
  avatarUrl: -> if @hasRows() then @grid.memFilt[@row].avatar else ""
  label    : ->
    return "" unless @hasRows()
    name = @grid.memFilt[@row].value.split(' ')[1]
    date = @grid.dates[@col]
    "#{name} : #{date}"
  hasRows   : -> @numRows() > 0
  numRows   : -> if @grid.numRows? then @grid.numRows() else 0
  moveLeft  : -> @setPosition "#{@row}_#{_.max([0, @col-1])}"
  moveRight : -> @setPosition "#{@row}_#{_.min([6, @col+1])}"
  moveUp    : -> @setPosition "#{_.max([0, @row-1])}_#{@col}"
  moveDown  : -> @setPosition "#{_.min([@numRows()-1, @row+1])}_#{@col}"
  arrowKey  : (direction)->
    switch direction
      when "Left"  then @moveLeft()
      when "Right" then @moveRight()
      when "Up"    then @moveUp()
      when "Down"  then @moveDown()
  ajaxInOut : (data, action, callback) ->
    opts =
      user_name: data.grid.cursor.member().user_name
      date     : data.grid.cursor.dateStr
      perform  : action
    console.log "AjaxInOut", opts, data
    $.ajax
      method : 'put'
      url    : "/ajax/avail_day"
      data   : opts
      success: -> console.log "ajaxInOut SUCCESS"; callback()
      failure: -> console.log "ajaxInOut FAILURE"; callback()
  signIn    : (data, callback) -> @ajaxInOut(data, 'signIn' , callback)
  signOut   : (data, callback) -> @ajaxInOut(data, 'signOut', callback)


class RM.Catalog
  constructor: (@grid)-> @list = {}
  generate   : ->
    rowIdx = 0
    list   = {}
    _.each @grid.memFilt, (mem)->
      list[mem.user_name] = {cells: {}, member: mem, rowIdx: rowIdx}
      rowIdx += 1
    _.each @grid.events, (event)->
      _.each event.title.split(', '), (user_name)->
        if list[user_name]
          list[user_name]["events"] ?= []
          list[user_name]["events"].push(event)
    @list = list
    @grid.rows.generate() unless list == {}

class RM.Rows
  constructor: (@grid)   -> @list = []
  getRow     : (row)     -> @list[row]
  getCell    : (row, col)-> @list[row]?.cells[col]
  generate   : ->
    console.log "GC", @grid.catalog
    @list = _.map(_.values(@grid.catalog.list), (obj)=> new RM.Row(@grid, obj))

class RM.Row
  constructor: (@grid, @rowData)->
    @memUser  = @rowData.member.user_name
    @memFirst = @rowData.member.first_name
    @memLast  = @rowData.member.last_name
    @memName  = @rowData.member.value
    @cells    = @generate()
  userName   : -> @memUser
  isSelected : -> @grid.cursor.row == @rowData.rowIdx
  generate   : ->
    _.map [0..6], (count)=>
      day      = @grid.dates[count]
      cellRef  = "#{@rowData.rowIdx}_#{count}"
      events   = _.select @rowData.events, (event)-> day == event.start.format("ddd M/D")
      new RM.Cell(@grid, cellRef, events, @)

class RM.Cell
  constructor: (@grid, @cellRef, @eventsData, @row)-> @events = @generate()
  userName   : -> @row.userName()
  cellDate   : -> @grid.dates[parseInt(@cellRef.split('_')[1])]
  cellMD     : -> @cellDate().split(' ')[1]
  rowUnavails: -> @grid.unavails[@userName()]
  isUnavail  : -> _.find @rowUnavails(), (date)=> date == @cellMD()
  isAvail    : -> ! @isUnavail()
  isSelected : -> @grid.cursor.position == @cellRef
  isToday    : -> @grid.today == @cellDate()
  selectKlas : (string = "selected")-> if @isSelected() then string else ""
  todayKlas  : (string = "today")-> if @isToday() then string else ""
  hasEvents  : -> @eventsData.length > 0
  generate   : ->
    _.map @eventsData, (eventData)=> new RM.Event(@grid, eventData)

class RM.Event
  constructor: (@grid, {@id, @svc_id, @backgroundColor, @rule, @title, @start, @xstart, @end, @xend})->
  @property 'timeStr', get: -> "#{@xstart.split(' ')[1]}-#{@xend.split(' ')[1]}"
  @create: (data, callback)->
    $.ajax
      method : 'post'
      url    : "/svc_periods"
      data   : data
      success: -> console.log "CREATE SUCCESS"; callback()
      failure: -> console.log "CREATE FAILURE"; callback()
  update : (data, callback)->
    $.ajax
      method : 'put'
      url    : "/svc_periods/#{@id}"
      data   : data
      success: -> console.log "UPDATE SUCCESS"; callback()
      failure: -> console.log "UPDATE FAILURE"; callback()
  delete : (callback)      ->
    $.ajax
      method : 'delete'
      url    : "/svc_periods/#{@id}"
      success: -> console.log "DELETE SUCCESS"; callback()
      failure: -> console.log "DELETE FAILURE"; callback()

class RM.TimeParse
  constructor: (@input)->
  range: -> [@beg(), @fin()]
  beg:   -> fmt @input.split('-')[0].split(/\:|\./)
  fin:   -> fmt @input.split('-')[1].split(/\:|\./)
  fmt = ([hour, min])->
    newHour = "0#{hour}"[-2..-1]
    newMin  = if min == undefined then "00" else "0#{min}"[-2..-1]
    "#{newHour}:#{newMin}"

module.exports = RM