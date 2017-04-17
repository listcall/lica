reloadPage = -> window.location.reload()

unless lclData.rails_env == "development"
  $(document).ready -> setInterval(reloadPage, 30000)  # every 30 seconds...