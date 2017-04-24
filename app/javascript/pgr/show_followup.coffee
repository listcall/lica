window.LC = {}

#LC.ra = require("pgr/select/actions")
#LC.rs = require("pgr/select/stores")
#LC.rc = require("pgr/select/components")

console.log "LOADED"

$('document').ready ->
  $('#followupBtn').click  -> $('#followupModal').modal()
#  React.render React.createElement(LC.rc.OptionList)    , $('#LCrcOptionList')[0]
#  React.render React.createElement(LC.rc.OptionDisplay) , $('#LCrcOptionDisplay')[0]
#  React.render React.createElement(LC.rc.SaveButton)    , $('#LCrcSaveButton')[0]
#  React.render React.createElement(LC.rc.CloseButton)   , $('#LCrcCloseButton')[0]

