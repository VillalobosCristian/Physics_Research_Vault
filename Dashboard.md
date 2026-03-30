---
title: "Dashboard"
date: 2026-03-24
tags:
  - dashboard
status: "active"
---

# Research Dashboard

> Entry point to the vault. Navigate by topic, not by folder.

## Start Here
- [[Workflow]] — Daily routine, how to add papers, weekly maintenance
- [[Vault Guide]] — Full system documentation

## Maps of Content

| MOC | Scope |
|-----|-------|
| [[MOC - Membrane Biophysics]] | Theory, concepts, flickering pipeline |
| [[MOC - Statistical Mechanics & Transport]] | Stat mech, diffusion, thermophoresis |
| [[MOC - Literature]] | All paper reading notes |
| [[MOC - Projects]] | Active research projects |
| [[MOC - Experimental Protocols]] | Lab protocols and analysis codes |

## Quick Links
- [[INDEX - Optothermal GUV Literature Review]] — Optothermal GUV master index
- [[08_GUV_Analysis_Pipeline]] — MATLAB flickering pipeline
- [[Quantitative Reference - DOPC Mechanical Properties and Controls]] — DOPC property tables

---

## Active Projects

```dataview
TABLE status
FROM "Projects"
WHERE contains(tags, "project") AND status = "active"
SORT file.name ASC
```

## Recently Modified Notes

```dataview
TABLE file.mtime as "Modified"
FROM -"Templates" AND -".obsidian" AND -"Attachments"
SORT file.mtime DESC
LIMIT 10
```

## Literature Reading Queue

```dataview
TABLE authors, year
FROM "Resources/Literature/Reading-Notes"
WHERE status = "unread" OR status = "reading"
SORT date_read DESC
LIMIT 10
```

## Notes Without Tags

```dataview
LIST
FROM -"Templates" AND -".obsidian" AND -"Attachments"
WHERE length(tags) = 0
LIMIT 10
```

---
*Vault reorganized: 2026-03-24. See [[Vault Guide]] for system documentation.*
