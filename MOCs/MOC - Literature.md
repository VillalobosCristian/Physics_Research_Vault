---
title: "MOC - Literature"
date: 2026-03-24
status: "active"
tags:
  - MOC
  - literature
---

# MOC — Literature Notes

> Index of all paper reading notes, organized by topic.

## By Topic

### Membrane Fluctuations & Bending Rigidity
- [[faizi2020_Fluctuation spectroscopy of giant unilamellar vesicles using confocal and phase contrast microscopy]]
- [[faizi2024_Curvature fluctuations of fluid vesicles reveal hydrodynamic dissipation within the bilayer]]
- [[pécréaux2004_Refined contour analysis of GUVs]]
- [[rautu2017_The role of optical projection in membrane fluctuation analysis]]
- [[meleard2011_Advantages of statistical analysis of giant vesicle flickering for bending elasticity measurements]]
- [[bouvrais2012_Bending Rigidities of Lipid Bilayers]]
- [[sahu2025_Osmotic forces modify lipid membrane fluctuations]]

### Optothermal & Thermophoretic Effects
- [[hill2018_Opto-Thermophoretic Attraction Trapping and Manipulation of Lipid Vesicles]]
- [[nalupurackal2022_Hydro-thermophoretic trap for microparticles near gold substrate]]
- [[fränzl2022_Hydrodynamic manipulation by optically induced thermo-osmotic flows]]
- [[kyrsting2011_Heat Profiling of Gold Nanoparticles using Vesicle Cargo Release]]
- [[rørvig-lund2015_Vesicle Fusion Triggered by Optically Heated Gold Nanoparticles]]
- [[talbot2019_Directed tubule growth from GUVs in thermal gradient]]
- [[villalobos-concha_Optothermal assembly via non-coherent light]]

### Vesicle Shape & Deformations
- [[käs1991_Shape transitions of giant vesicles induced by area-to-volume changes]]
- [[sciortino2025_Active membrane deformations of a minimal synthetic cell]]
- [[leirer2009_Thermodynamic relaxation drives expulsion in GUVs]]
- [[wennerström2022_Thermal fluctuations and osmotic stability of lipid vesicles]]
- [[wennerström2025_Coupling between membrane bending and stretching]]

### Membrane Theory & Reviews
- [[seifert1997_Configurations of fluid membranes and vesicles]]
- [[Deserno (2015) – Fluid Lipid Membranes]]
- [[dimova2020_The giant vesicle book]]
- [[gupta2021_The dynamic face of lipid membranes]]
- [[Study Guide Lipid Membranes and Vesicles]]

### Particle–Membrane Interactions
- [[fessler2024_Autonomous Engulfment of Active Colloids by Giant Lipid Vesicles]]
- [[ayala2023_Thermal fluctuations of the lipid membrane determine particle uptake into Giant Unilamellar Vesicles]]
- [[vanderwel2017_Microparticle Assembly Pathways on Lipid Membranes]]
- [[wel2016_Lipid membrane-mediated attractions between curvature inducing objects]]

### GUV Preparation & Methods
- [[morales-penningston2010_GUV preparation and imaging_ Minimizing artifacts]]
- [[karal2020_Electrostatic interaction effects on the size distribution of self-assembled giant unilamellar vesicles]]
- [[imai2022_From vesicles toward protocells and minimal cells]]

### Active Matter & Colloids
- [[ginot2018_Aggregation-fragmentation and individual dynamics of active clusters]]
- [[gao2025_Direct observation of colloidal quasicrystallization]]
- [[anderson_Colloid Transport by Interfacial Forces]]

## Literature Dataview

### Recently Read
```dataview
TABLE authors, year, status
FROM "Resources/Literature/Reading-Notes"
WHERE status != null
SORT date_read DESC
LIMIT 15
```

### Unread Papers
```dataview
TABLE authors, year
FROM "Resources/Literature/Reading-Notes"
WHERE status = "unread"
SORT file.name ASC
```

---
*See also:* [[INDEX - Optothermal GUV Literature Review]], [[MOC - Membrane Biophysics]]
