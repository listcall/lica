RA = require("svc_cals/re_view/actions")
RM = require("svc_cals/re_view/models")
RS = {}

console.warn = ->

RS.grid = Reflux.createStore
  listenables : RA
  getInitialState: -> @data
  setup          : (start)-> @data = new RM.Grid({start: start})
  init           : -> @data = new RM.Grid
  onEventLoad    : (events)->
    @data.events = events
    @trigger(@data)
  onCellArrowKey : (event)->
    @data.cursor.arrowKey(event.keyIdentifier)
    @trigger(@data)
    $('button.fc-state-active').focus()
  onCellClick    : (newPosition)->
    @data.cursor.setPosition(newPosition)
    @trigger(@data)
  onEventClick   : (newPosition, newIdx)->
    @data.cursor.setPosition(newPosition)
    @trigger(_.extend(@data, {eventIdx: newIdx}))
  onUpdateFilter : (newFilter)->
    @data.filter = newFilter
    @trigger(@data)

RS.form = Reflux.createStore
  listenables : RA
  getInitialState    : -> @data
  init               : ->
    @listenTo(RS.grid, @resetGrid)
    @data =
      event     : undefined
      eventId   : 0
      oldMode   : ""  # null, nullNew, base, baseEdit, baseNew
      newMode   : ""
      oldIdx    : 0
      newIdx    : 0
      oldTime   : ""
      newTime   : ""
      oldSvc    : ""
      newSvc    : ""
      oldRepeat : ""
      newRepeat : ""
      oldRule   : {}
      newRule   : {}
      newFocus  : "input"
      oldFocus  : "input"
      validTime : false
  resetGrid:  (grid)->
    return if grid.memFilt.length == 0
    numEvents = grid.cursor.events()?.length
    @data.oldMode = @data.newMode = if numEvents > 0 then 'base' else 'null'
    @data.oldIdx  = @data.newIdx  = if numEvents > 0 then 0 else -1
    @data.oldIdx  = @data.newIdx  = grid.eventIdx if grid.eventIdx?
    @data.oldSvc  = @data.newSvc  = lclData.svcList[0]?.id
    @updateGrid(grid)
  updateGrid: (grid)->
    grid.cursor.updatePosition()
    @grid      = grid
    @cursor    = @grid.cursor
    @events    = @cursor.events()
    @numEvents = @events.length
    @maxEvent  = @numEvents - 1
    @event     = @events[@data.newIdx]
    @data.event     = @event
    @data.eventId   = @event?.id
    @data.newRule   = @data.oldRule = @event?.rule
    @data.newTime   = @data.oldTime = @event?.timeStr
    @data.newSvc    = @data.oldSvc  = @event.svc_id    if @event?
    @data.validTime = @isTimeValid()
  isTimeValid: ->
    return false unless @data.newTime?
    [beg, fin] = @data.newTime?.replace(/\ /g,"").replace(/\:/g,'.').split('-')
    return false unless beg? && fin?
    return false if beg == fin
    reg1 = /^[01]?\d(\.(00|15|30|45))?$/
    reg2 = /^2[0-4](\.(00|15|30|45))?$/
    okBeg = beg.match(reg1) || beg.match(reg2)
    okFin = fin.match(reg1) || fin.match(reg2)
    okBeg && okFin && (parseFloat(beg) < parseFloat(fin))
  onBtnNew     : (data)->
    @data.newTime   = ""
    @data.newMode   = "#{@data.oldMode}New"
    @data.newIdx    = -1
    @data.validTime = false
    @trigger(@data)
  onBtnCancel     : (data)->
    @data.newTime   = @data.oldTime
    @data.newSvc    = @data.oldSvc
    @data.newMode   = @data.oldMode
    @data.newRule   = @data.oldRule
    @data.newIdx    = @data.oldIdx
    @data.validTime = @isTimeValid()
    @trigger(@data)
  onBtnCycle      : (data)->
    newIdx = if (idx = @data.newIdx + 1) > @maxEvent then 0 else idx
    @data.newIdx  = @data.oldIdx  = newIdx
    @data.newMode = @data.oldMode = 'base'
    @updateGrid(@grid)
    @trigger(@data)
  onModTime    : (data)->
    @data.newMode   = "baseEdit" if @data.newMode == "base"
    @data.newTime   = data
    @data.validTime = @isTimeValid()
    @trigger(@data)
  onModService : (data)->
    @data.newMode = "baseEdit" if @data.newMode == "base"
    @data.newSvc  = data
    @trigger(@data)
  onModRepeat  : (data)->
    @data.newRule = data
    @data.newMode = "baseEdit" if @data.newMode == "base"
    @trigger(@data)
  onBtnCreate  : (data)->
    date = data.grid.cursor.dateStr
    [beg, fin] = new RM.TimeParse(data.form.newTime).range()
    resourcePicker.resetState()
    args =
      names  : data.grid.cursor.member().user_name
      start  : "#{date} #{beg}"
      finish : "#{date} #{fin}"
      rule   : JSON.stringify resourcePicker.toHash()
      svc_id : data.form.newSvc
    RM.Event.create args, -> location.reload()
  onBtnUpdate : (data)->
    date = data.grid.cursor.dateStr
    [nBeg, nFin] = new RM.TimeParse(data.form.newTime).range()
    [xBeg, xFin] = new RM.TimeParse(data.form.oldTime).range()
    args =
      start  : "#{date} #{nBeg}"
      xstart : "#{date} #{xBeg}"
      finish : "#{date} #{nFin}"
      xfinish: "#{date} #{xFin}"
      svc_id : data.form.newSvc
      rule   : JSON.stringify resourcePicker.toHash()
    data.form.event.update(args, -> location.reload())
  onBtnDelete  : (data)-> data.form.event.delete(-> location.reload())
  onBtnSignIn  : (data)-> data.grid.cursor.signIn(data , -> location.reload())
  onBtnSignOut : (data)-> data.grid.cursor.signOut(data, -> location.reload())

module.exports = RS