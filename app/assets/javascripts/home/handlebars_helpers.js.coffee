Handlebars.registerHelper 'ifZero', (val, opts)->
  if val == 0 || val == "0"
    return opts.fn(this)
  else
    return opts.inverse(this)