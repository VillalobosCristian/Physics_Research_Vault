---
title: "MOC - Optothermal Vesicle Manipulation"
date: 2026-02-13
status: "active"
related_papers:
  - "[[hill2018_Opto-Thermophoretic Attraction Trapping and Manipulation of Lipid Vesicles]]"
  - "[[nalupurackal2022_Hydro-thermophoretic trap for microparticles near gold substrate]]"
  - "[[talbot2019_Directed tubule growth from GUVs in thermal gradient]]"
  - "[[villalobos-concha_Optothermal assembly via non-coherent light]]"
  - "[[fränzl2022_Hydrodynamic manipulation by optically induced thermo-osmotic flows]]"
  - "[[kyrsting2011_Heat Profiling of Gold Nanoparticles using Vesicle Cargo Release]]"
  - "[[rørvig-lund2015_Vesicle Fusion Triggered by Optically Heated Gold Nanoparticles]]"
tags:
  - MOC
  - optothermal
  - thermophoresis
  - vesicle-manipulation
---

# MOC — Optothermal/Thermophoretic Manipulation of Vesicles

## Overview

This MOC maps the landscape of optothermal and thermophoretic manipulation of vesicles and soft matter on plasmonic substrates. My system (blue LED + Au/Cr thin film + DOPC GUVs) sits at the intersection of these approaches, uniquely combining non-coherent illumination with GUV shape analysis.

## Experimental Approaches Compared

### Heating Sources

| Method | Laser/Light | Substrate | $\Delta T$ | Reference |
|--------|-------------|-----------|------------|-----------|
| Focused laser + AuNPs | 1064 nm, 200 mW | AuNPs (80 nm) | $\sim 75°$C (surface) | [[kyrsting2011_Heat Profiling of Gold Nanoparticles using Vesicle Cargo Release]] |
| Focused laser + Au film | 532 nm | Au film (50 nm) | $5$–$8$ K | [[fränzl2022_Hydrodynamic manipulation by optically induced thermo-osmotic flows]] |
| Dual IR hotspots | 975+1064 nm | Au film (30 $\mu$m) | $4.6$–$5.6$ K | [[nalupurackal2022_Hydro-thermophoretic trap for microparticles near gold substrate]] |
| Focused laser + Au substrate | 532 nm | Au nanostructures | $\nabla T \sim 10^6$ K/m | [[hill2018_Opto-Thermophoretic Attraction Trapping and Manipulation of Lipid Vesicles]] |
| Thermal gradient plates | Heating/cooling | None (bulk gradient) | $\nabla T = 0.1$ K/$\mu$m | [[talbot2019_Directed tubule growth from GUVs in thermal gradient]] |
| **Non-coherent LED + Au/Cr film** | **Blue LED** | **10 nm Au + 3 nm Cr** | **$\sim 5$–$8$ K** | **[[villalobos-concha_Optothermal assembly via non-coherent light]], This work** |

### Key Distinction: My System

My system is **unique** in the field for combining:
1. **Non-coherent illumination** (no laser, just microscope LED with blue filter)
2. **GUV shape analysis** (not just trapping/manipulation, but detailed morphological characterization)
3. **Au thin film** (not nanoparticles — uniform, extended heating)
4. **DOPC membranes** (fluid phase, no phase transition involvement)
5. **Closed chamber** with sucrose/glucose asymmetry

No other group has reported detailed GUV shape deformations induced by non-coherent optothermal heating.

## Transport Mechanisms

### Thermophoresis
- DOPC vesicles are thermophobic: $S_T = -0.2$ to $-0.4$ K$^{-1}$ ([[hill2018_Opto-Thermophoretic Attraction Trapping and Manipulation of Lipid Vesicles]])
- Drift toward cold regions (away from heated substrate)
- Drift velocity: $v_T = -S_T D \nabla T$

### Thermo-osmotic Slip
- Dominant mechanism near gold surfaces ([[fränzl2022_Hydrodynamic manipulation by optically induced thermo-osmotic flows]], [[villalobos-concha_Optothermal assembly via non-coherent light]])
- Slip coefficient: $\chi \sim 10^{-10}$ m$^2$s$^{-1}$K$^{-1}$
- Creates inward flow at substrate level → confines particles/vesicles

### Thermal Convection
- Buoyancy-driven (Rayleigh-Bénard) convection in confined geometry
- Relevant for larger illumination areas and stronger heating
- Creates circulation cells that can transport vesicles

## Novelty of My Approach

| Aspect | Existing Literature | My Contribution |
|--------|-------------------|-----------------|
| Heating method | Focused lasers, AuNPs | Non-coherent LED on Au film |
| Object | Small vesicles (1-4 $\mu$m), colloids | GUVs (10-40 $\mu$m) |
| Analysis | Trapping stiffness, drift | Full shape analysis + fluctuation spectroscopy |
| Observation | Steady-state trapping | Transient deformation dynamics |
| Deformation | Tubule growth (Talbot), fusion (Rørvig-Lund) | Invagination + deflation + recovery |
| Permeability | Phase transition triggered | Fluid-phase, sub-transition spike |

## Temperature Calibration

From our colloidal work ([[villalobos-concha_Optothermal assembly via non-coherent light]]):
- $\Delta T \sim 5$–$8$ K for typical illumination conditions
- This means DOPC area expansion: $\sim 2.5$–$4\%$ (at $0.5\%$/°C)
- Sufficient to change reduced volume significantly for slightly floppy vesicles

---
*See also:* [[MOC - Temperature-Dependent Membrane Permeability]], [[MOC - Vesicle Shape Deformations]], [[Temperature shape changes GUVs]]
