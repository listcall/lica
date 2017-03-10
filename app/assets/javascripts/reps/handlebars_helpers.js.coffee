# ----- utility stuff ----------------------------------------------------------

Handlebars.registerHelper "log", (context)->
  console.log(context)

# ----- utility stuff ----------------------------------------------------------

Handlebars.registerHelper "allMembers", ->
  list = _.map(context['members'], (mem)->
    "#{mem.first_name} #{mem.last_name}")
  list.join(', ')

# ----- table headers ----------------------------------------------------------

Handlebars.registerHelper "dayLbl", (day)->
  return "" if day==""
  """
  #{context.days[day].wday_s}
  <br/>
  #{context.days[day].month_s} #{context.days[day].mday_s}
  """

# ----- member loop ------------------------------------------------------------

Handlebars.registerHelper "memberLoop", (memberIds, options)->
  sortedMems = _.sortBy memberIds, (id)->
    new Sctx.Member(context, id).last_name()
  sortedMems = [0] if sortedMems.length == 0
  rfunc = (acc, memId)->
    acc + options.fn(memId)
  _.reduce sortedMems, rfunc, ""

# ----- participant labels -----------------------------------------------------

Handlebars.registerHelper "memberLbl", (memId)->
  return "[NA]" if memId == 0
  obj = new Sctx.Member(context, memId)
  """
  <div style='float:right; margin: 1px;'>
  #{obj.first_name()}<br/>#{obj.last_name()}
  </div>
  """

# ----- cell values ------------------------------------------------------------

Handlebars.registerHelper 'dayCell',  (day, memId)->
  part = new Sctx.ParticipantFor(context, day, memId)
  return "" unless part.present()
  qq = _.map part.participations(), (pp)->
    color = pp.service_color()
    """
    <div style='padding: 2px; background: ##{color};'>
      #{pp.start_time()}-#{pp.finish_time()}
    </div>
    """
  qq.join('')

# ----- footer stuff -----------------------------------------------------------

$(window).load ->
  func = ->
    window.scrollTo 0, 1  if $(window).scrollTop() <= 0 and not location.hash
  setTimeout(func, 250)

