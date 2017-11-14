# Aug 29

- [x] rewrote the migration for cert tables (see `db/migrate/*`)
- [x] restructured cert classes (see `models/certs*`)
- [x] ERD diagram generates properly (`script/erd/certs2`)
- [x] got all specs working
- [x] wrote a cert data-loading script (see `script/c2/*`)
- [x] added an `admin/team_certs` page
- [x] rendered the generated certs on the admin page

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

# Mon Nov 13

- [x] refactor cert classes
- [x] design the admin pages for certs
- [x] test x-editable with BootStrap4

- [ ] build out cert-loading scripts

- [ ] display cert-units and cert-groups on the admin page

- [ ] cleanup cert classes and specs 
- [ ] implement admin/team_certs
- [ ] prototype React-based x-editable replacement
