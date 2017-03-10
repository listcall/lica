# javascripts/service_rep/ctx_day_spec.js.coffee

#= require ./ctx_participant

window.Sctx ||= {}

class Sctx.Day
  constructor: (@ctx, @id)->
  day:          => @dayObj ||= @ctx.days[@id]
  present:      -> @day() != undefined
  participantIds: ->
    @participantIdsVal ||= @day() && @day().participant_ids
  participants:   ->
    @participantsVal   ||= @day() && _.map @participantIds(), (pid)=>
      new Sctx.Participant(@ctx, pid)


