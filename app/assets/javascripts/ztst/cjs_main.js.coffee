Ann = require('ztst/cjs_module')

kk = new Ann("blunderbus")

console.log "NAME IS", kk.name

$(document).ready ->
  $('#dropZone').text("NAME IS #{kk.name}")