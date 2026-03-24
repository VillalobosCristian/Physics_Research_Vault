---
title: "MOC - Temperature-Dependent Membrane Permeability"
date: 2026-02-13
status: "active"
related_papers:
  - "[[wennerström2022_Thermal fluctuations and osmotic stability of lipid vesicles]]"
  - "[[leirer2009_Thermodynamic relaxation drives expulsion in GUVs]]"
  - "[[kyrsting2011_Heat Profiling of Gold Nanoparticles using Vesicle Cargo Release]]"
  - "[[rørvig-lund2015_Vesicle Fusion Triggered by Optically Heated Gold Nanoparticles]]"
  - "[[sahu2025_Osmotic forces modify lipid membrane fluctuations]]"
  - "[[wennerström2025_Coupling between membrane bending and stretching]]"
tags:
  - "#MOC"
  - "#membrane-permeability"
  - "#thermal-effects"
  - "#osmotic-response"
---

# MOC — Temperature-Dependent Membrane Permeability

## Overview

This Map of Content organizes literature on how temperature affects the permeability of lipid bilayer membranes, with focus on DOPC GUVs and rapid heating scenarios. The central question: **does a transient permeability spike during rapid heating explain the massive volume loss ($5$–$30\%$) observed in our optothermal experiments?**

## Key Physical Picture

```
Rapid Heating → Membrane Area Expansion (~0.5%/°C)
     ↓
Tension Buildup (area increases faster than volume adjusts)
     ↓
Transient Permeability Increase (pore formation or enhanced water transport)
     ↓
Water Efflux (driven by osmotic + thermal gradients)
     ↓
Volume Recovery (osmotic equilibration, ~10 s timescale)
```

## Literature Map

### Water Permeability Coefficients

| Lipid | $P_f$ ($\mu$m/s) | Temperature | Method | Reference |
|-------|-------------------|-------------|--------|-----------|
| POPC | $\sim 16$ | RT | Osmotic swelling | [[wennerström2022_Thermal fluctuations and osmotic stability of lipid vesicles]] |
| DOPC | $25$–$50$ (estimated) | $25$–$40°$C | Extrapolation | Various |
| DPPC (gel) | $\sim 5$ | $< T_m$ | Phase transition | [[leirer2009_Thermodynamic relaxation drives expulsion in GUVs]] |
| DPPC (fluid) | $\sim 50$ | $> T_m$ | Phase transition | [[leirer2009_Thermodynamic relaxation drives expulsion in GUVs]] |
| DC$_{15}$PC | Permeability switch at $T_m = 33°$C | | Cargo release | [[kyrsting2011_Heat Profiling of Gold Nanoparticles using Vesicle Cargo Release]] |

### Timescales of Osmotic Response

| Process | Timescale | Source |
|---------|-----------|--------|
| Membrane area relaxation (phase transition) | $\tau \approx 4$–$5$ s | [[leirer2009_Thermodynamic relaxation drives expulsion in GUVs]] |
| Osmotic equilibration ($10\%$/min) | $\sim 6$ min | [[wennerström2022_Thermal fluctuations and osmotic stability of lipid vesicles]] |
| Lipid mixing post-fusion | $\sim 10$ s | [[rørvig-lund2015_Vesicle Fusion Triggered by Optically Heated Gold Nanoparticles]] |
| **My permeability spike** | **$\sim 2.7$ s** | **This work** |
| **My osmotic recovery** | **$\sim 10$ s** | **This work** |

### Mechanisms for Permeability Enhancement

1. **Phase transition permeabilization** — permeability increases dramatically at $T_m$ ([[leirer2009_Thermodynamic relaxation drives expulsion in GUVs]], [[kyrsting2011_Heat Profiling of Gold Nanoparticles using Vesicle Cargo Release]])
   - Not directly applicable to DOPC ($T_m \approx -20°$C), but the physical mechanism (area mismatch → pore formation) may operate sub-critically

2. **Thermal area expansion** — $\sim 0.5\%$/°C for DOPC fluid phase ([[rørvig-lund2015_Vesicle Fusion Triggered by Optically Heated Gold Nanoparticles]])
   - Creates excess area → tension reduction → enables shape changes
   - For $\Delta T = 10°$C: $5\%$ area increase

3. **Bending-stretching coupling** — membrane softens as it stretches ([[wennerström2025_Coupling between membrane bending and stretching]])
   - Positive feedback: heating → stretching → softer → more deformation
   - $\kappa \propto h^{2\text{-}3}$ where $h$ is bilayer thickness

4. **Osmotic force modification** — solute gradients modify membrane fluctuation modes ([[sahu2025_Osmotic forces modify lipid membrane fluctuations]])
   - Critical tension $\lambda_c^* \approx 0.06$ pN/nm for mode suppression
   - Sucrose/glucose asymmetry creates osmotic coupling

## Comparison with My Findings

| Parameter | Literature | My Data | Assessment |
|-----------|-----------|---------|------------|
| Permeability timescale | $4$–$5$ s (Leirer) | $2.7$ s (peak roughness) | **Consistent** — same order of magnitude |
| Recovery timescale | $\sim 6$ min (Wennerström) | $\sim 10$ s | **Faster** — suggests active mechanism, not passive diffusion |
| Volume loss | $6$–$25\%$ (Käs, Leirer) | $5$–$30\%$ | **Consistent** — same range |
| Area expansion | $0.5\%$/°C (Rørvig-Lund) | Not directly measured | **Need to estimate** from temperature rise |

## Open Questions

- [ ] What is the DOPC water permeability at elevated temperature ($T = 30$–$40°$C)?
- [ ] Does DOPC show a pre-transition permeability increase during rapid heating?
- [ ] Can the $10$ s recovery be explained by osmotic equilibration or does it require active re-sealing?
- [ ] Is the asymmetric onset/offset consistent with a permeability spike that is rate-dependent (fast heating → spike, slow cooling → no spike)?

## Key Insight for Paper

The $\sim 2.7$ s permeability spike timescale is remarkably consistent with Leirer et al.'s $4$–$5$ s relaxation timescale for thermodynamic expulsion, despite the completely different mechanism (phase transition vs. rapid heating of fluid membrane). This suggests a **universal membrane response timescale** set by water transport kinetics through the bilayer, not by the specific perturbation mechanism.

---
*See also:* [[MOC - Optothermal Vesicle Manipulation]], [[MOC - Vesicle Shape Deformations]], [[MOC - Analysis Methods for Vesicle Fluctuations]]
