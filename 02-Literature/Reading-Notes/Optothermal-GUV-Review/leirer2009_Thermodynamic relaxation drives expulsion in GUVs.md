---
title: "Thermodynamic relaxation drives expulsion in giant unilamellar vesicles"
authors: C.T. Leirer, B. Wunderlich, A. Wixforth, M.F. Schneider
citekey: leirer2009expulsion
year: 2009
journal: Physical Biology
date_read: 2026-02-13
status: "reviewed"
key_topics: [phase-transition, vesicle-deformation, thermal-relaxation, pore-formation, content-expulsion]
related_projects: [Temperature shape changes GUVs]
tags:
  - literature-note
  - membrane-biophysics
  - thermal-effects
  - shape-transitions
---

# Thermodynamic relaxation drives expulsion in giant unilamellar vesicles

## Summary
Demonstrates that rapid thermal quenching through the gel-fluid phase transition of DPPC ($T_m = 35°$C) triggers $\sim 25\%$ area decrease, pore opening at lysis tension ($\sigma_{\text{lysis}} \approx 1$ mN/m), and expulsion of vesicle contents. The relaxation follows an exponential timescale of $\tau \approx 4$-$5$ seconds — strikingly similar to the $2.7$ s permeability spike timescale observed in my optothermal experiments.

## Key Findings
- $\sim 25\%$ area decrease when quenching from fluid through gel phase transition
- Relaxation timescale: $\tau \approx 4$-$5$ seconds for membrane area relaxation
- Tension at pore formation: $\sigma_{\text{lysis}} \approx 1$ mN/m
- Content expulsion follows exponential relaxation with time constant $\tau$
- Volume efflux is driven by Onsager-type thermodynamic relaxation

## Important Equations
Volume efflux model:
$$Q \approx \frac{1}{16\sqrt{\pi}\tau}(A_g)^{3/2} \cdot \exp(-t/\tau)\left[1 + \frac{1}{4}\exp(-t/\tau)\right]$$

where $Q$ is volume efflux rate and $A_g$ is gel phase area.

## Physical Scales

| Type | Value | Description |
|------|-------|-------------|
| Length | $R \sim 10$-$20\,\mu$m | GUV diameter |
| Time | $\tau \approx 4$-$5$ s | Area relaxation time constant |
| Energy | $\sigma_{\text{lysis}} \approx 1$ mN/m | Lysis tension |
| Temperature | $T_m = 35°$C | DPPC phase transition |

## Methodology

### Theoretical Approach
- Onsager-type thermodynamic relaxation model
- Area change drives tension buildup → pore opening → content release

### Experimental Methods
- Techniques: Phase transition (DPPC) as trigger, fast cooling ($10°$C/s)
- Equipment: Temperature-controlled chamber, fluorescence microscopy
- Resolution/Precision: Real-time imaging of expulsion events

## Results and Analysis
- Key result: Thermal area changes drive transient pore opening with $\tau \approx 4$-$5$ s timescale
- Supporting evidence: Exponential volume loss fits Onsager model
- Limitations: Requires phase transition — DOPC is always in fluid phase at room temperature

## Relevance to My Research

### Direct Applications
- The $\tau \approx 4$-$5$ s timescale is remarkably close to my $\sim 2.7$ s permeability spike
- Suggests a similar mechanism: rapid area/permeability change → transient water efflux → exponential relaxation
- Even without a phase transition, DOPC may show analogous area expansion during heating → tension buildup → transient permeability increase

### Questions Raised
- [ ] Can DOPC show sub-phase-transition permeability spikes during rapid heating?
- [ ] Is my observed deflation timescale ($\sim 2.7$ s onset, $\sim 10$ s recovery) consistent with an Onsager relaxation process?
- [ ] Could thermal expansion of DOPC area ($\sim 0.5\%$/°C) create sufficient tension for transient pore formation?

### Future Directions
- [ ] Compare exponential fits to my volume recovery data with Leirer's Onsager model
- [ ] Estimate tension buildup from thermal expansion rate in my setup

## References to Check
- Needham & Hochmuth (1989) — electromechanical permeabilization
- Evans & Rawicz (1990) — entropy-driven tension measurements

## Notes History
- Created: 2026-02-13
- Last reviewed: 2026-02-13
