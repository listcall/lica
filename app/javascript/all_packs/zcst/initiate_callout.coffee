D = React.DOM

initiateCallOut = ->
  D.div {},
    D.h2 {}, "Immediate callout"
    D.ul {},
       D.li {}, "Create an event on bamru.net: bamru.net/events/net"
       D.li {}, "IMMEDIATELY PAGE THE UNIT, via \"invite\" on the event page. DO NOT WAIT. Text: \"Immediate callout. OL needed. Standby for details.\" Use RSVP"
       D.li {}, "Begin a log (example), consider a CAD (example). Share with UL, OL, AHC, OO, XO, Secretary, and timekeeper"
       D.li {}, "Log into instant messaging"
       D.li {}, "Determine CP location, callout purpose, deployment duration. Email to unit"
       D.li {}, "Check availability on bamru.net pages"
       D.li {}, "Update status line and check for messages: (650) 858-4618, then #, password BAMRUS"
       D.li {}, "Contact the OO"
       D.li {}, "If an OL is readily available, quickly discuss with the OO and (with OO's approval) appoint the OL"
       D.li {}, "Contact all members who you haven't heard from"
       D.li {}, "Recheck bamru.net availability and status line messages and determine the responding team with the OL and OO. If you still don't have an OL and AHC, appoint one in consultation with the OO. Page the team to the unit"
       D.li {}, "Report the number of responding members and the names of the OL and AHC to the OESL"
       D.li {}, "Arrange logistics. Consider: BAMRU truck, SO vehicle, technical gear, cache equipment, additional gas cards, drivers, cache keys, the satellite phone, if borrowing personal gear amongst the membership is needed, and other issues. Consider appointing a temporary logistics head"
       D.li {}, "Collect relevant data and email it to the responding team: weather, maps, terrain, avy forecast, expected equipment needs, contact information for the CP, news, and other information. Resources: Google Maps, CalTopo, NOAA, SAC, and ESAC"
       D.li {}, "Create an event on bamru.net/events if you haven't already"
       D.li {}, "Talk to the OL and OO and see if further steps are necessary."

    D.h2 {}, "Delayed callout"
    D.ul {},
       D.li {}, "Follow all of the steps above for an immediate callout; initial page: \"Delayed callout for <age> yo <sex> <up to 3 word description>. OL needed.\""

    D.h2 {}, "Mutual aid callout"
    D.ul {},
       D.li {}, "Find the mission number"
       D.li {}, "Follow all of the steps above for an immediate or delayed callout as appropriate"
       D.li {}, "Begin thinking about logistics immediately, strongly consider appointing a logistics head within the first 5  10 minutes."

    D.h2 {}, "Callout conclusion"
    D.ul {},
       D.li {}, "Confirm that it is concluded with the OL"
       D.li {}, "Page the unit: \"10-22 <callout name>. <disposition>. <field team status>\""
       D.li {}, "Change the status line back to the standard stand-by message"
       D.li {}, "When people are expected to have arrived home, page the attendees \"Transit status\" Use the \"Home?\" feature"
       D.li {}, "Ensure that everyone is accounted for and repage those that aren't. Follow up as necessary"
       D.li {}, "Ensure all hours are logged in the bamru.net event for everyone that participated in the search"
       D.li {}, "Once everyone has returned safe and is off duty, notate in the log that the operation has concluded and the time. Save the log."

    D.h2 {}, "Heads up"
    D.ul {},
       D.li {}, "Call the OO"
       D.li {}, "If approved, page the unit: \"Heads up for a <time> search for a <age> yo <sex> <up to 3 word description>.\" Use RSVP."

    D.h2 {}, "Contacting dispatch to reach the OESL"
    D.ul {},
       D.li {}, "Rarely do this. Make sure you know what you're doing and that this is necessary"
       D.li {}, "Call the dispatch center at (650) 363-4915"
       D.li {}, "Say, \"This is <V9 number>. I need to page the OES On Call Liaison.\""


$(document).ready ->
  React.render initiateCallOut(), $('#content')[0]
