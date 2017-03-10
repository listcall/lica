
RC = require("svc_cals/re_view/components")
RA = require("svc_cals/re_view/actions")
RS = require("svc_cals/re_view/stores")

FC     = $.fullCalendar          # a reference to FullCalendar's root namespace
View   = FC.View                 # the class that all views must inherit from
ReView = View.extend(
  type:  "resource"
  title: "RESOURCE TITLE"

  # called once when view is instantiated, when the user switches to the view.
  # initialize member variables or do other setup tasks.
  initialize: (args)->
    return

  # display the skeleton of the view within the already-defined
  # this.el, a jQuery element.
  render: ->
    opts = {start: this.intervalStart}
    React.render(React.createFactory(RC.ResTable)(opts), this.el[0])

  # adjust the pixel-height of the view. if isAuto is true, the
  # view may be its natural height, and `height` becomes merely a suggestion.
  setHeight: (height, isAuto) ->
    return

  # render the given Event Objects
  renderEvents: (events) ->
    RA.eventLoad.trigger(events)
    return

  # undo everything in renderEvents
  destroyEvents: ->
    return

  # accepts a {start,end} object made of Moments, and must render the selection
  renderSelection: (range) ->
    return

  # undo everything in renderSelection
  destroySelection: ->
    return
)

FC.views.custom = ReView              # register our class with the view system
