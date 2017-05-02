window.LC = {}

LC.ra = require("pgr/new_select/actions")
LC.rs = require("pgr/new_select/stores")
LC.rc = require("pgr/new_select/components")

$('document').ready ->
  $('#actionBtn').click  -> $('#actionModal').modal()
  React.render React.createElement(LC.rc.OptionList)    , $('#LCrcOptionList')[0]
  React.render React.createElement(LC.rc.OptionDisplay) , $('#LCrcOptionDisplay')[0]
  React.render React.createElement(LC.rc.SaveButton)    , $('#LCrcSaveButton')[0]
  React.render React.createElement(LC.rc.CloseButton)   , $('#LCrcCloseButton')[0]
