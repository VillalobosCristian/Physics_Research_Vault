---
title: "Vault Guide"
date: 2026-03-24
tags:
  - meta
  - guide
---

# Vault Guide — Physics Research Second Brain

> How this vault is organized and how to use it day-to-day.

## Folder Structure (PARA)

```
Physics_Research_Vault/
├── Projects/           Active research projects
│   ├── GUVs/
│   ├── Cooling-by-Heating/
│   ├── Chlamy-Vesicle-Interaction/
│   ├── Frontier-of-Life/
│   └── MSCA-Proposal-2025/
├── Areas/              Ongoing responsibilities (career, lab mgmt)
│   ├── Career/
│   └── Lab-Management/
├── Resources/          Reference material (the knowledge base)
│   ├── Literature/     Papers (PDFs) + reading notes
│   ├── Concepts/       Atomic concept notes by topic
│   ├── Data/           Experiments, codes, protocols
│   └── Clippings/      Web clippings, seminar notes
├── Archive/            Completed or inactive material
├── MOCs/               Maps of Content (vault navigation)
├── Templates/          Note templates for Templater
├── Attachments/        Images, Excalidraw, misc files
├── Dashboard.md        Vault entry point
└── Vault Guide.md      This file
```

## Navigation Philosophy

**Links over folders.** The folder structure is for storage. For navigation, use Maps of Content (MOCs). Start from the [[Dashboard]] and drill into topic MOCs. Every note should be reachable from at least one MOC.

**Atomic notes.** Each concept note should capture one idea. If a note covers two distinct concepts, split it. Link generously between notes.

## Note Types & Templates

| Type | Template | When to Use |
|------|----------|-------------|
| Literature Note | `Literature_Note` | Reading a new paper |
| Concept Note | `Concept_Note` | Capturing a single physics concept |
| Theory Note | `Theory_Note` | Working through a derivation |
| Experiment Log | `Experiment_Log` | Recording an experiment |
| Meeting Note | `Meeting_Note` | Meetings, discussions |
| Daily Note | `Daily_Note` | Daily log |
| Project Note | `Project_Note` | New project overview |

To use: `Ctrl+T` (Templater) or `Cmd+T` on macOS.

## YAML Frontmatter

Every note should have:

```yaml
---
title: "Note Title"
date: YYYY-MM-DD
status: "active"      # active | draft | archived | reading | unread
tags:
  - concept-note       # or: literature-note, project, protocol, etc.
topic:
  - membrane-physics   # topic area
project:
  - GUVs              # related project(s)
---
```

Literature notes additionally have: `authors`, `citekey`, `year`, `journal`, `doi`, `date_read`.

## Workflow: Adding a New Paper

1. **Save the PDF** to `Resources/Literature/PDFs/` with naming: `author_year_short-title.pdf`
2. **Create a literature note** using the `Literature_Note` template in `Resources/Literature/Reading-Notes/`
3. **Name the note** as `authorYEAR_Short title.md` (e.g., `faizi2020_Fluctuation spectroscopy of GUVs.md`)
4. **Fill in the template** while reading:
   - Summary (one paragraph)
   - Key figures (table)
   - Methods
   - Important equations (LaTeX)
   - Your comments and critique
   - Related notes (link to concepts and other papers)
5. **Add the note** to the relevant MOC (usually [[MOC - Literature]] and a topic MOC)
6. **Create links** to concept notes for any key terms (e.g., `[[Bending rigidity]]`, `[[Helfrich model]]`)
7. **Update the citation plugin** `.bib` file if using Zotero integration

## Workflow: Adding a New Concept

1. **Create a concept note** using the `Concept_Note` template in the appropriate `Resources/Concepts/` subfolder
2. **Write the definition** concisely (one or two sentences)
3. **Add equations** and typical values
4. **Link** to related concepts and literature notes
5. **Add to** the relevant MOC (e.g., [[MOC - Membrane Biophysics]])

## Workflow: Starting a New Project

1. **Create a folder** under `Projects/`
2. **Create a project overview note** using the `Project_Note` template
3. **Add to** [[MOC - Projects]]
4. **Link** to relevant literature, concepts, and data notes

## Workflow: Daily Research Log

1. Use `Daily_Note` template (Templater auto-names with date)
2. Jot down lab work, analysis progress, reading, ideas
3. Link to relevant project/concept notes as you write

## Dataview Queries

The [[Dashboard]] includes live queries for:
- Active projects
- Recently modified notes
- Reading queue
- Notes missing tags

Custom queries you can add anywhere:

**All notes for a project:**
```
dataview
TABLE topic, status
FROM ""
WHERE contains(project, "GUVs")
```

**All concept notes on a topic:**
```
dataview
LIST
FROM "Resources/Concepts"
WHERE contains(topic, "membrane-physics")
```

## Maintenance

- **Weekly:** Review [[Dashboard]] queries. Tag any untagged notes.
- **Monthly:** Check for orphan notes (not linked from any MOC). Archive completed projects.
- **When reading:** Always create a literature note, even if brief. A one-paragraph summary is better than nothing.

## Plugins Used

- **Templater:** Note templates
- **Dataview:** Dynamic queries
- **Citations:** Zotero/.bib integration
- **Linter:** Formatting consistency
- **Obsidian Git:** Version control
- **Excalidraw:** Diagrams
- **PDF Plus:** PDF annotation
- **Tags Overview:** Tag management

---
*Vault reorganized: 2026-03-24. Structure based on PARA method adapted for academic research.*
