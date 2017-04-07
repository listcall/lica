R = React.DOM
F = {}

App = React.createClass
  getDefaultProps: ->
    val: "HELLO DEFAULT TXT"
  update: ->
    alert "Button was clicked"
  render : ->
    console.log "RENDERING"
    R.button onClick: @update, @props.val
  componentWillMount: ->
    console.log "MOUNTING"
  componentDidMount: -> console.log "MOUNTED"
  componentWillUnmount: -> console.log "UNMOUNTED"

F.App = React.createFactory(App)

$(document).ready ->
  console.log "loading mount"
  React.render F.App( val: "wazzup"), $('#mount1')[0]