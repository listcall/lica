# javascripts/service_rep/ctx_participant_spec.js.coffee

#= requrie lodash
#= require ./ctx_day
#= require ./ctx_participant

window.Sctx ||= {}

class Sctx.ParticipantFor
  constructor: (@ctx, @dayId, @memId)->
  day:         -> @dayObj ||= new Sctx.Day(@ctx, @dayId)
  participations: ->
    @participantObj ||= _.select @day().participants(), (part)=>
      memid = part.member().id
      memid == @memId
  present:     -> @participations() != undefined && @participations() != []