# javascripts/service_rep/ctx_member_spec.js.coffee

window.Sctx ||= {}

class Sctx.Member
  constructor: (@ctx, @id)->
  member:      -> @memberObj ||= @ctx.members[@id]
  present:     -> @member() != undefined
  first_name:  ->
    @firstName ||= @member() && @member().first_name
  last_name:   ->
    @lastName ||= @member() && @member().last_name
  full_name:   ->
    @fullName ||= "#{@first_name()} #{@last_name()}"
  avatar_url:  ->
    @avatarUrl ||= @member() && @member().avatar_url
