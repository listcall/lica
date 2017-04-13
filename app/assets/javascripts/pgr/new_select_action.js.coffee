console.log "BLINGGGGG"

window.LC = {}

console.log "BING"

LC.ra = require("pgr/select/actions")
console.log "BANG"
LC.rs = require("pgr/select/stores")
console.log "BUNG"
LC.rc = require("pgr/select/components")
console.log "PUNG"

console.log "BDKDKDKDKDKDKD"

$('document').ready ->
  console.log "ASDF"
  $('#actionBtn').click  -> $('#actionModal').modal()
  React.render LC.rc.OptionList(), $('#LCrcOptionList')[0]
  React.render LC.rc.OptionDisplay(), $('#LCrcOptionDisplay')[0]
  React.render LC.rc.SaveButton(), $('#LCrcSaveButton')[0]
  React.render LC.rc.CloseButton(), $('#LCrcCloseButton')[0]
