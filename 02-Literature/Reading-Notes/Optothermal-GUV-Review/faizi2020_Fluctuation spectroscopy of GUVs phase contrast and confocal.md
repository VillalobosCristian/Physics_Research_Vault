---
title: "Fluctuation spectroscopy of giant unilamellar vesicles using confocal and phase contrast microscopy"
authors: Hammad A. Faizi, Cody J. Reeves, Vasil N. Georgiev, Petia M. Vlahovska, Rumiana Dimova
citekey: faizi2020
year: 2020
journal: Soft Matter
date_read: 2026-02-13
status: "reviewed"
key_topics: [fluctuation-spectroscopy, bending-rigidity, DOPC, phase-contrast, confocal-microscopy]
related_projects: [Temperature shape changes GUVs]
tags:
  - "#literature-note"
  - "#fluctuation-analysis"
  - "#bending-rigidity"
  - "#microscopy-methods"
---

# Fluctuation spectroscopy of GUVs using confocal and phase contrast microscopy

## Summary
Benchmark comparison of fluctuation spectroscopy using confocal vs. phase contrast microscopy on the same DOPC vesicles. Establishes that both methods yield consistent bending rigidity values: $\kappa = 22.3 \pm 2.16\,k_BT$ for DOPC, with tension $\sigma = 3.1 \pm 1.2 \times 10^{-7}$ N/m. Identifies critical artifacts to avoid (pinhole size, optical projection, out-of-focus effects) and validates phase contrast as reliable for $\kappa$ measurements.

## Key Findings
- **DOPC bending rigidity:** $\kappa = 22.3 \pm 2.16\,k_BT$ (phase contrast)
- **DOPC tension:** $\sigma = 3.1 \pm 1.2 \times 10^{-7}$ N/m
- Phase contrast and confocal give consistent results on same vesicle
- Confocal with low NA suffers from 8-10 mode underestimation
- Phase contrast more resilient to resolution artifacts
- Mode range: $n = 2$-$30$; crossover at mode $\sim 20$

## Important Equations
Fluctuation spectrum:
$$\langle |u_n|^2 \rangle = \frac{k_BT}{(n-1)(n+2)\left[\sigma + \kappa(n-1)(n+2)/R^2\right]}$$

## Physical Scales

| Type | Value | Description |
|------|-------|-------------|
| Bending | $\kappa = 22.3 \pm 2.16\,k_BT$ | DOPC bending rigidity |
| Tension | $\sigma = 3.1 \times 10^{-7}$ N/m | DOPC membrane tension |
| Length | $> 15\,\mu$m radius | Minimum for reliable measurements |

## Relevance to My Research

### Direct Applications
- **Gold standard $\kappa$ value for DOPC:** my fluctuation analysis should recover $\kappa \approx 22\,k_BT$ in the no-heating regime
- Phase contrast methodology at 40× validated — matches my setup
- Spectral crossover at mode $\sim 20$ sets my analysis range
- Tension values provide baseline for pre-heating state

### Questions Raised
- [ ] Does $\kappa$ change during/after heating? (Should measure in all three regimes)
- [ ] Can I detect tension changes from the spectral crossover shift?
- [ ] How do my highly deformed vesicles ($v \approx 0.69$) affect mode analysis?

## Notes History
- Created: 2026-02-13
- Last reviewed: 2026-02-13
