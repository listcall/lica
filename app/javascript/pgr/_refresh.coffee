reloadPage = -> window.location.reload()

unless lclData.railsEnv == "development"
  $(document).ready -> setInterval(reloadPage, 30000)  # every 30 seconds...