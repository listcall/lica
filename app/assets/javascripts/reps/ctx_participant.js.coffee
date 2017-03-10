# javascripts/service_rep/ctx_participant_spec.js.coffee

window.Sctx ||= {}

class Sctx.Participant
  constructor: (@ctx, @id)->
  participant: -> @participantObj ||= @ctx.participants[@id]
  present:     -> @participant() != undefined
  member:      ->
    @memberObj ||= @participant() && @ctx.members[@participant().membership_id]
  first_name:  ->
    @firstName ||= @member() && @member().first_name
  last_name:   ->
    @lastName ||= @member() && @member().last_name
  full_name:   ->
    @fullName ||= "#{@first_name()} #{@last_name()}"
  start_time:       ->
    @participant() && @participant().start.split(' ')[1]
  finish_time: ->
    @participant() && @participant().finish.split(' ')[1]
  service: ->
    @serviceObj ||= @participant() && @ctx.services[@participant().service_id]
  service_color: ->
    @service() && @service().color

  avatar_url:  ->
    @avatarUrl ||= @member() && @member().avatar_url
