---
title: "Vesicle Fusion Triggered by Optically Heated Gold Nanoparticles"
status: "reviewed"
tags: 
- literature-note
- optothermal
- membrane-biophysics
- DOPC
- literature-note
topic:
project:
authors: Andreas Rørvig-Lund, Azra Bahadori, Szabolcs Semsey, Poul Martin Bendix, Lene B. Oddershede
citekey: rorviglund2015
date_read: 2026-02-13
journal: Nano Letters
key_topics: [vesicle-fusion, plasmonic-heating, DOPC, membrane-area-expansion, lipid-mixing]
related_projects: [Temperature shape changes GUVs]
year: 2015
---

# Vesicle Fusion Triggered by Optically Heated Gold Nanoparticles

## Summary
Demonstrates controlled fusion of DOPC/DOPS GUVs triggered by optically heated 80 nm AuNPs. Key quantitative finding: membrane area expansion of $\sim 0.5\%$/°C in the fluid phase, with fusion occurring at $\sim 75°$C. Lipid mixing timescale $\sim 10$ s. Directly relevant to my system as it uses DOPC membranes with plasmonic heating.

## Key Findings
- Area expansion: $\sim 0.5\%$ per °C in fluid phase DOPC membranes
- Fusion temperature: $\sim 75°$C achieved with 80 nm AuNP at $\sim 200$ mW
- Lipid mixing timescale (fluid-fluid): $\sim 10$ s
- Lipid diffusion: $D_{\text{TR}} = 6.5\,\mu$m$^2$/s, $D_{\text{DiO}} = 15\,\mu$m$^2$/s
- Successful fusion for GUVs $10$-$200\,\mu$m diameter

## Important Equations
Lipid diffusion on spherical surface:
$$\frac{\partial c}{\partial t} = D \frac{1}{r^2 \sin\theta} \frac{\partial}{\partial\theta}\left(\sin\theta \frac{\partial c}{\partial\theta}\right)$$

## Physical Scales

| Type | Value | Description |
|------|-------|-------------|
| Area expansion | $\sim 0.5\%$/°C | DOPC thermal area coefficient |
| Time | $\sim 10$ s | Lipid mixing (fluid phase) |
| Diffusion | $D = 6.5$-$15\,\mu$m$^2$/s | Lipid lateral diffusion |
| Temperature | $\sim 75°$C | Fusion threshold |

## Relevance to My Research

### Direct Applications
- **$0.5\%$/°C area expansion for DOPC** is a critical number for my analysis
- For $\Delta T = 10°$C: $5\%$ area increase → significant excess area → enables shape changes
- For $\Delta T = 5°$C: $2.5\%$ area increase → still enough to change reduced volume from 0.96 to $\sim 0.93$
- Lipid diffusion rates set the timescale for area redistribution ($\sim$ seconds for GUV-sized vesicles)

### Questions Raised
- [ ] Is my temperature rise sufficient to generate the $5$-$30\%$ volume loss I observe, or must permeability be invoked?
- [ ] Can thermal area expansion alone explain the initial invagination (Stage 1)?
- [ ] Does area expansion create enough excess area for the shapes I see at $v \approx 0.69$?

## Notes History
- Created: 2026-02-13
- Last reviewed: 2026-02-13
