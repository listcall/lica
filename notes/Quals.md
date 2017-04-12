Qualification Notes
===================

# Qualifications
- Qualifications are a collection of certs
- Each Qual has access control

Examples:
- Technical Member
- Field Member
- Trainee
- Applicant

Long Term:
- quals organized hierarchically
- you can generate a training manual from a qual

# Cert Assignments

- certs are assigned to quals
- assigned certs may be "required" or "optional"

# Cert Types

A Cert-Type has:
- Name
- ResourceID
- Evidence [link, file(subtype), attendance(rule)]
- Title [free_text(title), distinct_list,  fixed_list(list)
- Commentable [true/false]
- Expirable [true/false]

Cert Status:
- green  - current
- yellow - expires in 3 months
- orange - expires in one month
- red    - expired

# Attendance Cert

At least X events
with title (match)
with type (match)
with tag (match)
in the past (Y) months

# Questions

- how to handle quals with many certs?
- what is the right UI for tree-structured quals?
- secretary/TL review and approval
- printing training manuals

# Roadmap

1. Improve performance
   - better use of joins and sub-queries
   - better use of rails caching

2. Add Qual Hierarchy

3. Add Qual Printing

4. Add Qual Versioning
