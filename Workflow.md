---
title: "Workflow"
date: 2026-03-30
tags:
  - meta
  - workflow
status: "active"
---

# Workflow — How to Use This Vault

> Pin this note. Reference it until the habits become automatic.

---

## Daily Routine (5 min)

1. Open the vault. Start from **[[Dashboard]]**.
2. Create today's **Daily Note** (`Cmd+T` → Daily_Note template).
3. As you work, log briefly: what you did in the lab, what you analyzed, what you read.
4. Every time you mention a concept or paper, **make it a link**: `[[Bending rigidity]]`, `[[faizi2024...]]`. Even if the note doesn't exist yet — Obsidian tracks unresolved links, and you create the note later.

That's it. The daily note is your research diary. Don't overthink it.

---

## When You Read a Paper

This is the most important workflow. Do it consistently and your vault compounds in value.

### Step-by-step

1. **Save the PDF** to `Resources/Literature/PDFs/`
   - Naming: `author, coauthor_year_Short title.pdf`
   - Example: `faizi, granek2024_Curvature fluctuations of fluid vesicles.pdf`

2. **Create the reading note** in `Resources/Literature/Reading-Notes/`
   - `Cmd+N` → name it `authorYEAR_Short title`
   - `Cmd+T` → apply **Literature_Note** template

3. **Fill in while reading** (not after — you'll forget):
   - **Summary**: one paragraph, what is the main result and why it matters
   - **Key Figures**: table with figure number, what it shows, relevance to you
   - **Methods**: system, technique, key parameters
   - **Equations**: copy the 2–3 equations you'll actually use ($\LaTeX$)
   - **My Comments**: your honest assessment — strengths, weaknesses, what you'd do differently
   - **Related Notes**: link to concepts (`[[Helfrich model]]`) and other papers

4. **Register the note**:
   - Add it to **[[MOC - Literature]]** under the right topic heading
   - If it's relevant to a specific project, also link from the project note

### The 80/20 rule

A one-paragraph summary with 3 links is infinitely better than no note at all. Don't let the template intimidate you — fill what you can, leave the rest blank. You can always come back.

---

## When You Learn or Derive Something

### New concept

1. Create in the appropriate `Resources/Concepts/` subfolder
2. Apply **Concept_Note** template
3. Write: definition (1–2 sentences), key equation, typical values, connection to your research
4. Link to related concepts and papers
5. Add to the relevant MOC

### New derivation

1. Use **Theory_Note** template
2. State the problem, assumptions, step-by-step derivation
3. Include numerical checks and limiting cases
4. Link to the concept notes it builds on

### Rule: one idea per note

If you're writing about bending rigidity and spontaneous curvature in the same note, split it. Short, atomic notes that link to each other are more useful than long monolithic ones.

---

## When You Run an Experiment

1. Create in `Resources/Data/Experiments/` with **Experiment_Log** template
2. Fill in: objective, parameters table, procedure, raw data location
3. Link to the relevant project and protocol notes
4. After analysis, add results and link to any new concept notes

---

## When You Start a New Project

1. Create a folder under `Projects/`
2. Add a project overview note with **Project_Note** template
3. Register it in **[[MOC - Projects]]**
4. As the project develops, link to literature notes, concept notes, experiment logs

---

## Weekly Maintenance (15 min, Friday)

Open **[[Dashboard]]** and check the live queries:

1. **Notes Without Tags** query → tag them properly (add `topic`, `project` in frontmatter)
2. **Recently Modified** → scan for notes you touched but didn't link from a MOC
3. **Reading Queue** → update `status` field: `"unread"` → `"reading"` → `"read"`
4. Quick scan of `Resources/Literature/PDFs/` → any new PDFs without reading notes? Create a stub note at minimum (just the summary paragraph)

### Quick Dataview check

Paste this in any note to find orphans (notes not linked from anywhere):

```dataview
LIST
FROM -"Templates" AND -"Attachments" AND -"Archive"
WHERE length(file.inlinks) = 0 AND length(file.outlinks) > 0
LIMIT 15
```

---

## Monthly Review (30 min)

1. **Archive completed projects**: move folder to `Archive/`, update status to `"archived"` in frontmatter
2. **Review MOCs**: are they up to date? Any new topic clusters emerging that deserve their own MOC?
3. **Check concept coverage**: open [[MOC - Membrane Biophysics]] — are there concepts you use daily that don't have notes? Create stubs.
4. **Prune Clippings**: anything in `Resources/Clippings/` worth promoting to a proper concept or literature note? Do it. The rest can stay or go to Archive.

---

## Key Habits

### Do

- **Link aggressively**. Every time you type a physics term, wrap it in `[[ ]]`. Links are the backbone of the vault.
- **Write for your future self**. In 6 months you won't remember why a paper matters. The "My Comments" section is the most valuable part of a literature note.
- **Use the MOCs as entry points**, not folder browsing. `Cmd+O` → type "MOC" → pick a topic.
- **Update frontmatter status**. It takes 2 seconds and makes Dataview queries useful.
- **Create stub notes**. A note with just a title and one sentence is better than no note. You'll fill it in later when you need it.

### Don't

- Don't create deep folder hierarchies. If you feel the urge to make `Projects/GUVs/Analysis/Flickering/Mode-Selection/`, stop. Make a note with links instead.
- Don't duplicate information. If two notes say the same thing, merge them or link one to the other.
- Don't treat this as a file archive. The PDFs folder is storage. The reading notes are the knowledge. A PDF without a reading note is invisible to your future self.
- Don't spend time on formatting and organization instead of actual research. The system should serve you, not the other way around. 15 min/week maintenance is enough.

---

## Frontmatter Cheat Sheet

```yaml
---
title: "Note Title"
date: YYYY-MM-DD
status: "active"       # active | draft | reading | unread | archived
tags:
  - concept-note       # or: literature-note, project, protocol, code, meeting, daily
topic:
  - membrane-physics   # differential-geometry, statistical-mechanics, experimental-methods
project:
  - GUVs              # Cooling-by-Heating, MSCA-2025, Chlamy-Vesicle, Frontier-of-Life
---
```

Literature notes add: `authors`, `citekey`, `year`, `journal`, `doi`, `date_read`.

---

## Template Quick Reference

| Situation | Template | Location |
|-----------|----------|----------|
| Reading a paper | Literature_Note | `Resources/Literature/Reading-Notes/` |
| Physics concept | Concept_Note | `Resources/Concepts/{subfolder}/` |
| Derivation | Theory_Note | `Resources/Concepts/{subfolder}/` |
| Experiment | Experiment_Log | `Resources/Data/Experiments/` |
| Meeting/discussion | Meeting_Note | `Projects/{project}/` or `Areas/` |
| Daily log | Daily_Note | root or a `Daily/` folder if you prefer |
| New project | Project_Note | `Projects/{new-folder}/` |

---

*The goal: every piece of knowledge you generate or consume gets a note, a link, and a home. Not perfectly — consistently.*
