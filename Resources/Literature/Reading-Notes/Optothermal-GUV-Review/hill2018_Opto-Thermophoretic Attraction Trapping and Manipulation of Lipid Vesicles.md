---
title: "Opto-Thermophoretic Attraction, Trapping, and Dynamic Manipulation of Lipid Vesicles"
authors: Esteban H. Hill, Jingang Li, Linhan Lin, Yuebing Zheng
citekey: hill2018
year: 2018
journal: Langmuir
date_read: 2026-02-13
status: "reviewed"
key_topics: [optothermal-trapping, thermophoresis, lipid-vesicles, plasmonic-heating, DOPC]
related_projects: [Temperature shape changes GUVs]
tags:
  - "#literature-note"
  - "#optothermal"
  - "#thermophoresis"
  - "#vesicle-manipulation"
---

# Opto-Thermophoretic Attraction, Trapping, and Dynamic Manipulation of Lipid Vesicles

## Summary
First demonstration of opto-thermophoretic trapping and manipulation of lipid vesicles (including DOPC-based) on plasmonic gold substrates using a focused 532 nm laser. Reports Soret coefficients for DOPC vesicles ($S_T = -0.2$ to $-0.4$ K$^{-1}$, thermophobic), trapping stiffnesses, and identifies a critical power threshold ($\sim 1.3$ mW) above which photodamage and microbubble formation occur. Directly comparable to my experimental geometry.

## Key Findings
- DOPC vesicles are thermophobic ($S_T < 0$): they migrate away from hot regions
- Temperature gradient at plasmonic surface: $0.5$-$3 \times 10^6$ K/m
- Trapping stiffness: $\sim 0.6$ pN/$\mu$m$^2$ at 110 $\mu$W for 2 $\mu$m vesicles
- Stiffness scales linearly with optical power
- Critical power: $> 1.3$ mW causes vesicle rupture and microbubble formation
- Long-range collection possible (over hundreds of micrometers)
- Dynamic manipulation: vesicles can be moved at controlled speeds

## Important Equations
Thermophoretic drift velocity:
$$v_T = -D_T \nabla T = -S_T D \nabla T$$

where $D_T$ is the thermophoretic mobility, $S_T$ the Soret coefficient, $D$ the diffusion coefficient.

## Physical Scales

| Type | Value | Description |
|------|-------|-------------|
| Length | 1-4 $\mu$m | Vesicle diameter range tested |
| Temperature | $\nabla T \sim 10^6$ K/m | Thermal gradient at gold surface |
| Force | $\sim 0.6$ pN/$\mu$m$^2$ | Trapping stiffness at 110 $\mu$W |
| Power | $< 1.3$ mW | Safe operating range |

## Methodology

### Experimental Methods
- Techniques: 532 nm laser focused on plasmonic gold substrate, inverted microscope
- Equipment: Gold nanostructured substrate, CCD camera tracking
- Resolution/Precision: Single-vesicle tracking with sub-micron precision

## Results and Analysis
- Key result: DOPC vesicles can be stably trapped and manipulated using mild optothermal fields
- Supporting evidence: Linear power-stiffness relationship confirms thermophoretic mechanism
- Limitations: Only tested vesicles 1-4 $\mu$m; GUVs (10-40 $\mu$m) may behave differently

## Relevance to My Research

### Direct Applications
- Direct precedent for DOPC vesicles on gold substrate — my exact system
- Soret coefficient ($S_T = -0.2$ to $-0.4$ K$^{-1}$) explains thermophoretic drift I observe
- Temperature gradient scale ($10^6$ K/m) provides reference for my blue light heating
- Critical power threshold helps interpret when I see vesicle rupture vs. deformation

### Questions Raised
- [ ] How does Soret coefficient scale with vesicle size (my GUVs are 10-40 $\mu$m vs. 1-4 $\mu$m here)?
- [ ] Does thermophobic drift compete with or assist the deflation I observe?
- [ ] What is the effective $\nabla T$ in my blue light + Au/Cr setup?

### Future Directions
- [ ] Measure thermophoretic drift velocity in my system and extract effective $S_T$
- [ ] Compare trapping stiffness predictions with observed vesicle behavior

## References to Check
- Lin et al. (2017) — opto-thermophoretic assembly of colloidal matter
- Braun & Libchaber (2002) — DNA trapping by thermophoretic depletion

## Notes History
- Created: 2026-02-13
- Last reviewed: 2026-02-13
