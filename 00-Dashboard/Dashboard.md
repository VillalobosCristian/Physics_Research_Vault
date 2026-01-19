# 🎯 Research Dashboard

## Quick Navigation

| Area | Link |
|------|------|
| 📚 **Literature** | [[02-Literature/Reading-Notes\|Reading Notes]] |
| 🔬 **Projects** | [[01-Projects\|Active Projects]] |
| 🧠 **Concepts** | [[00-Dashboard/Concepts MOC\|Concepts Map]] |
| 📊 **Papers** | [[00-Dashboard/Papers Tracker\|Papers Tracker]] |
| 🧪 **Protocols** | [[04-Data/Protocols\|Lab Protocols]] |

---

## 🚀 Active Projects

```dataview
TABLE status, file.mtime as "Last Modified"
FROM "01-Projects"
WHERE file.name != "01-Projects"
SORT file.mtime DESC
LIMIT 10
```

---

## 📖 Recent Reading Notes

```dataview
TABLE WITHOUT ID
  file.link as "Paper",
  dateread as "Date Read"
FROM "02-Literature/Reading-Notes"
SORT file.mtime DESC
LIMIT 10
```

---

## 🧠 Concept Areas

- [[03-Concepts/Membrane-Physics|Membrane Physics]] - Bending elasticity, curvature, GUVs, lipids
- [[03-Concepts/Differential-Geometry|Differential Geometry]] - Metric tensors, Gaussian curvature, Christoffel symbols
- [[03-Concepts/Statistical-Mechanics|Statistical Mechanics]] - Fluctuations, Brownian motion, thermophoresis
- [[03-Concepts/Experimental-Methods|Experimental Methods]] - Protocols, analysis techniques

---

## 📁 Vault Structure

```
Physics_Research_Vault/
├── 00-Dashboard/      ← You are here
├── 01-Projects/       ← Active research projects
├── 02-Literature/     ← Papers and reading notes
├── 03-Concepts/       ← Knowledge base by topic
├── 04-Data/           ← Protocols, code, experiments
├── 05-Resources/      ← Clippings, diagrams, attachments
└── Templates/         ← Note templates
```

---

## 🏷️ Tag Cloud

#membrane-biophysics #lipids #bilayer-properties #differential-geometry #statistical-mechanics #vesicle-formation #guv-formation #fluctuation-analysis
