---
title: "MOC - Vesicle Shape Deformations and Invaginations"
date: 2026-02-13
status: "active"
tags: 
- MOC
- shape-transitions
- vesicle-deformation
- invagination
- literature-note
topic:
project:
related_papers: - "[[käs1991_Shape transitions of giant vesicles induced by area-to-volume changes]]"
  - "[[sciortino2025_Active membrane deformations of a minimal synthetic cell]]"
  - "[[leirer2009_Thermodynamic relaxation drives expulsion in GUVs]]"
  - "[[wennerström2022_Thermal fluctuations and osmotic stability of lipid vesicles]]"
  - "[[talbot2019_Directed tubule growth from GUVs in thermal gradient]]"
---

# MOC — Vesicle Shape Deformations and Invaginations

## Overview

This MOC organizes literature on vesicle shape changes, focusing on invaginations, deflation-driven morphology, and transient deformation processes. My key observation — a two-stage transient deflation with massive volume loss ($v: 0.96 \to 0.69$) and asymmetric onset/offset dynamics — sits in a surprisingly underexplored region of parameter space.

## Shape Transition Phase Diagram

The theoretical framework from [[seifert1997_Configurations of fluid membranes and vesicles]] and Seifert & Lipowsky (1995) maps vesicle shapes in the $(v, \Delta a)$ plane:

```
Reduced Volume v
1.0  ──── Sphere
0.95 ──── Slightly floppy (my vesicles, pre-heating)
0.85 ──── Prolate/oblate ellipsoids
0.75 ──── Discocytes, stomatocytes
0.69 ──── Deep stomatocytes, invaginated shapes (my peak deformation!)
0.60 ──── Extreme shapes, possible budding
```

**My experimental trajectory:** $v \approx 0.96 \to 0.69 \to 0.85$ (heating → peak → partial recovery)

## Two-Stage Deformation Process

### Stage 1: Initial Invagination (0–2 s)
**Literature support:**
- Käs & Sackmann (1991): Type 2 transitions show continuous discocyte → stomatocyte pathway
- Seifert & Lipowsky (1995): Predicted from bilayer-coupling model when $\Delta a$ decreases
- Gueguen et al. (2017): Fluctuation tension reduction enables shape instability

**Physical mechanism:**
- Rapid area expansion ($0.5\%$/°C × $\Delta T$) creates excess area
- Osmotic gradient from temperature-dependent solubility creates $\Delta\Pi$
- Asymmetric thermal expansion of inner vs. outer leaflet changes $\Delta a$

### Stage 2: Progressive Complexification (2–4 s)
**Literature support:**
- Litschel et al. (2018): Active deformations show periodic budding and merging
- Sciortino et al. (2025): Non-Gaussian deformation statistics at longer timescales
- Leirer et al. (2009): Content expulsion with $\tau \approx 4$–$5$ s relaxation

**Physical mechanism:**
- Continued water efflux through permeabilized membrane
- Multiple invagination features form as excess area accumulates
- Bending energy distributes deformation across vesicle surface

### Recovery Phase ($> 4$ s)
**Literature support:**
- Wennerström et al. (2022): Osmotic equilibration at $\sim 10\%$/min
- Sahu (2025): Membrane fluctuation modes recover as osmotic stress relaxes

**Physical mechanism:**
- Permeability returns to baseline (membrane reseals or cools)
- Osmotic equilibration gradually restores volume
- Excess area accommodated by shape relaxation

## Comparison of Deformation Amplitudes

| System | Volume Change | Timescale | Mechanism | Reference |
|--------|--------------|-----------|-----------|-----------|
| DMPC GUVs (temperature) | $6$–$20\%$ | Seconds-minutes | Area-to-volume ratio | [[käs1991_Shape transitions of giant vesicles induced by area-to-volume changes]] |
| DPPC GUVs (phase transition) | $\sim 25\%$ | $\tau \sim 4$–$5$ s | Gel-fluid area change | [[leirer2009_Thermodynamic relaxation drives expulsion in GUVs]] |
| Active DOPC GUVs (microtubules) | $\Delta R/R \sim 20\%$ | $2.5$–$10$ s | Internal forces | [[sciortino2025_Active membrane deformations of a minimal synthetic cell]] |
| DOPC/DPPC/Chol (thermal gradient) | Tubule growth | Minutes | Phase domain migration | [[talbot2019_Directed tubule growth from GUVs in thermal gradient]] |
| **DOPC GUVs (optothermal)** | **$5$–$30\%$** | **$2.7$ s spike, $10$ s recovery** | **Permeability spike** | **This work** |

## What Makes My Observations Novel

1. **Magnitude:** $v$ drops to $0.69$ — deeper than most literature reports for reversible deformations
2. **Reversibility:** $\sim 75\%$ recovery during continued heating — not seen in osmotic stress experiments
3. **Asymmetric dynamics:** 5× stronger onset than offset — not predicted by equilibrium phase diagrams
4. **Mechanism:** Fluid-phase DOPC with no phase transition — cannot invoke gel-fluid mechanism
5. **Control:** Simple, reproducible, non-contact (just blue light!)
6. **Timescale:** $2.7$ s peak and $10$ s recovery are characteristic and reproducible

## Possible Interpretations

### Hypothesis 1: Thermal Permeability Spike
Rapid heating creates transient membrane permeability enhancement (not a full phase transition, but enhanced water transport through area defects created by thermal expansion mismatch). The spike is rate-dependent: fast heating → large spike, slow cooling → no spike.

### Hypothesis 2: Thermoosmotic Water Transport
Temperature gradient across the membrane creates thermoosmotic water flux (Soret effect for water). The flux is proportional to $\nabla T$, which is maximal at heating onset and zero at steady state.

### Hypothesis 3: Differential Thermal Expansion
Inner and outer leaflets expand at different rates due to different composition (sucrose vs. glucose solutions). This creates spontaneous curvature change $\Delta C_0$ that drives invagination.

---
*See also:* [[MOC - Temperature-Dependent Membrane Permeability]], [[MOC - Analysis Methods for Vesicle Fluctuations]], [[Temperature shape changes GUVs]]
