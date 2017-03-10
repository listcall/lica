# this was an experiment in using ReactJS to create the participant/roster table.
# the experiement failed - React was WAY slower to use the rails/ruby/javascript.

# Learnings:
# - ReactJS is a great fit for JavaScript
# - JSX sucks - way better to work with raw javascript
# - hard to 'freestyle' with react
# - react would be a good fit for building reusable components,
#   but not for one-off pages

# Alt approach:
# - jquery, rails partials, etc.

#{ th, td, tr, table, thead, tbody, div, b, i, li, br, p} = React.DOM
#
#TableHeaders = React.createClass
#
#  firstHdrs: -> [ th({key: 'a'}, "Role")      , th({key: 'b'}, "Name")       ]
#  lastHdrs:  -> [ th {key: 'c'}                                              ]
#  transHdrs: -> [ th({key: 'd'}, "Departed")  , th({key: 'e'}, "Returned")   ]
#  signHdrs:  -> [ th({key: 'f'}, "Signed In") , th({key: 'g'}, "Signed Out") ]
#
#  genHdrs: ->
#    midHdrs = switch @props.showTime
#      when "transit" then @transHdrs()
#      when "signin"  then @signHdrs()
#      else []
#    @firstHdrs().concat(midHdrs, @lastHdrs())
#
#  render: -> thead {key: 'x'}, [tr({key: 'y'}, @genHdrs())]
#
#TableRow = React.createClass
#
#  rankCell: ->
#    td {key: "rank_#{@prop.part.id}"},
#      """
#      <i id='rankCx_#{@prop.part.id}' class="fa fa-plus-circle"></i>
#      """
#
#  nameCell: ->
#    td {key: "name_#{@prop.part.id}"},
#      @prop.part.full_name
#
#  delCell: ->
#    td {key: "del_#{@prop.part.id}"},
#       """
#      <i id='partDel_#{@prop.part.id}' class="fa fa-times-circle"></i>
#      """
#
#
#
#  firstHdrs: -> [ @rankCell(), @nameCell()]
#  lastHdrs:  -> [ td {key: 'xc'}, "X"                                                ]
#  transHdrs: -> [ td({key: 'xd'}, "depart time")  , td({key: 'xe'}, "return time")   ]
#  signHdrs:  -> [ td({key: 'xf'}, "sign in")      , td({key: 'xg'}, "sign out")      ]
#
#  genRow: ->
#    midHdrs = switch @props.showTime
#      when "transit" then @transHdrs()
#      when "signin"  then @signHdrs()
#      else []
#    @firstHdrs().concat(midHdrs, @lastHdrs())
#
#  render: ->
#    tr {}, @genRow()
#
#Table = React.createClass
#
#  tableRows: ->
#    genRow = (part)->  TableRow({showTime: @props.showTime, part: part})
#    @props.participants.map genRow
#
#  render: ->
#    table {className: "table table-condensed"},
#      TableHeaders({showTime: @props.showTime})
#      tbody {}, @tableRows()
#
#window.renderTable = (id) ->
#  React.renderComponent Table({showTime: id, participants: lclData.participants}), $('#reactor')[0]
