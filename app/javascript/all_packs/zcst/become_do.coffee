D = React.DOM

#import Checkbox from "react-bootstrap/lib/Checkbox"


becomeDO = ->

  D.div {},

    D.h2 {}, "Starting your shift"
    D.ul {},
      D.li {}, "Page BAMRU via email and SMS: \"BAMRU DO from <time date> until <time date> is John Doe. <contact info>\""
      D.li {}, "Update the BAMRU status line and check for messages, (650) 858-4618, password BAMRUS (#226787)"
      D.li {}, "Notify the SMCSO via the county status line, (650) 599-2162"
      D.li {}, "Check the BAMRU calendar and unit availability"
      D.li {}, "Contact the previous DO for a report"
      D.li {}, "Exchange contact info with the SMC SAR duty officer: email dutyofficer@sanmateosar.org; or text the SMC SAR status line: 650-564-4727, cc the operations officer."

    D.h2 {}, "Leaving your shift"
    D.ul {},
       D.li {}, "Make sure the oncoming DO transitions"
       D.li {}, "Give the oncoming DO a report."

$(document).ready ->
  React.render becomeDO(), $('#content')[0]
