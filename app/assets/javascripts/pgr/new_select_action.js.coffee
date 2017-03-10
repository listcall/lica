window.VT = {}

VT.ra = require("pgr/select/actions")
VT.rs = require("pgr/select/stores")
VT.rc = require("pgr/select/components")

$('document').ready ->
  $('#actionBtn').click  -> $('#actionModal').modal()