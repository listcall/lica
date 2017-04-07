##= require reflux
#
## Creating an Action
#textUpdate   = Reflux.createAction()
#statusUpdate = Reflux.createAction()
#
## Creating a Data Store - Listening to textUpdate action
#textStore = Reflux.createStore
#  init:     -> @listenTo(textUpdate, @output)
#  output:   (param)-> @trigger(param)
#  writeOut: (text)-> @trigger(text)
#
## Creating a DataStore
#statusStore = Reflux.createStore
#  init: -> @listenTo(statusUpdate, @output)
#  output: (flag)->
#    status = flag ? 'ONLINE' : 'OFFLINE'
#    @trigger(status)
#
## Creating an aggregate DataStore that is listening to textStore and statusStore
#storyStore = Reflux.createStore
#  init: ->
#    @listenTo(statusStore, @statusChanged)
#    @listenTo(textStore, @textUpdated)
#    @storyArr = []
#  statusChanged: (flag)->
#    if (flag == 'OFFLINE')
#      @trigger('User action: ' + @storyArr.join(', '))
#      empty storyArr
#      @storyArr.splice(0, @storyArr.length)
#  textUpdated: (text)-> @storyArr.push(text)
#
## Fairly simple view component that outputs to console
#ConsoleComponent = ->
#  textStore.listen (text)-> console.log('text: ', text)
#  statusStore.listen (status)-> console.log('status: ', status)
#  storyStore.listen (story)-> console.log('story: ', story)
#
#new ConsoleComponent()
#
## Invoking the action with arbitrary parameters
#statusUpdate(true)
#textUpdate("testing", 1337,  {"test": 1337})
#statusUpdate(false)

#/** Will output the following:
# *
# * status:  ONLINE
# * text:  testing
# * text:  1337
# * text:   test: 1337
# * story:  User action: testing, 1337, [object Object]
# * status:  OFFLINE
# */