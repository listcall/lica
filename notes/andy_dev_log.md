# Aug 29

Actions:
- rewrote the migration for cert tables (see `db/migrate/*`)
- restructured cert classes (see `models/certs*`)
- ERD diagram generates properly (`script/erd/certs2`)
- got all specs working
- wrote a cert data-loading script (see `script/c2/*`)
- added an `admin/team_certs` page
- rendered the generated certs on the admin page

TODO: cleanup cert classes and specs

NEXT ACTIONS:
- design the admin page for certs

# Aug 30

Learnings:
- Table sorting
-- Craig is using datatables.net for table sorting
-- datatables.net support for NPM/Webpack is not great
- Table responsive views
-- Craig uses bootstrap responsive views
-- it shows table values only - popup list is not configurable

Design Decisions:
- use datatables.net with a script tag for now
- use a modal or inline form (react?) for cert editing

Next Steps:
- test datatables.net and list sorting
- implement admin/team_certs

