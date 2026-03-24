---
title: "Heat Profiling of Three-Dimensionally Optically Trapped Gold Nanoparticles using Vesicle Cargo Release"
status: "reviewed"
tags: 
- literature-note
- optothermal
- plasmonic-heating
- membrane-permeability
- literature-note
topic:
project:
authors: Anders Kyrsting, Poul M. Bendix, Dimitrios G. Stamou, Lene B. Oddershede
citekey: kyrsting2011
date_read: 2026-02-13
journal: Nano Letters
key_topics: [plasmonic-heating, gold-nanoparticles, temperature-profiling, membrane-permeability, vesicle-leaking]
related_projects: [Temperature shape changes GUVs]
year: 2011
---

# Heat Profiling of Gold Nanoparticles using Vesicle Cargo Release

## Summary
Quantifies the temperature profile around optically trapped gold nanoparticles (60-100 nm) by using vesicle membrane phase transitions as nanoscale thermometers. As the heated AuNP approaches a DC$_{15}$PC GUV ($T_m = 33°$C), it triggers membrane permeabilization at a characteristic distance, allowing temperature profiling. Key result: 80 nm AuNP at $\sim 200$ mW generates $\sim 75°$C locally. This is a direct demonstration that plasmonic heating can trigger membrane permeability changes.

## Key Findings
- Temperature coefficient: 371-523 K/W depending on AuNP size (60-100 nm)
- 80 nm AuNP at $\sim 200$ mW: surface temperature $\sim 75°$C above ambient
- Critical leaking distance depends linearly on laser power
- Membrane permeability to cargo (Alexa Hydrazide) switches on at $T_m = 33°$C
- Temperature profile follows $\Delta T(D) = AR^3 / (3K_w D)$

## Important Equations
Temperature rise at distance $D$ from AuNP:
$$\Delta T(D) = \frac{C_{\text{abs}} I}{4\pi \kappa_w D}$$

where $C_{\text{abs}}$ is absorption cross-section, $I$ is laser intensity, $\kappa_w$ is water thermal conductivity.

## Physical Scales

| Type | Value | Description |
|------|-------|-------------|
| Length | 0.5-2.5 $\mu$m | Critical leaking distance |
| Temperature | 371-523 K/W | Heating efficiency per AuNP size |
| Energy | $C_{\text{abs}} \sim 10^{-15}$-$10^{-14}$ m$^2$ | Absorption cross-section |
| Time | $< 1$ s | Thermal equilibration |

## Relevance to My Research

### Direct Applications
- Proves that plasmonic heating triggers membrane permeability changes — exactly what I observe
- Temperature profiles provide calibration for my Au/Cr thin film heating (different geometry but same physics)
- Phase transition-based permeabilization is the clearest demonstration of temperature-dependent permeability
- My system likely achieves more modest but spatially uniform heating across the substrate

### Questions Raised
- [ ] Can I estimate my substrate temperature rise by analogy with these AuNP measurements?
- [ ] Is there a sub-phase-transition permeability increase for DOPC (which has no gel transition at RT)?
- [ ] How does the extended Au thin film geometry differ from localized AuNP heating?

## Notes History
- Created: 2026-02-13
- Last reviewed: 2026-02-13
