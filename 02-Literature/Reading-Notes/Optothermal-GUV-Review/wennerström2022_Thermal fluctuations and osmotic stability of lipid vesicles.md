---
title: "Thermal fluctuations and osmotic stability of lipid vesicles"
authors: Håkan Wennerström, Emma Sparr, Joakim Stenhammar
citekey: wennerstrom2022
year: 2022
journal: Physical Review E
date_read: 2026-02-13
status: "reviewed"
key_topics: [osmotic-pressure, thermal-fluctuations, vesicle-stability, membrane-permeability]
related_projects: [Temperature shape changes GUVs]
tags:
  - literature-note
  - membrane-biophysics
  - osmotic-response
  - thermal-effects
---

# Thermal fluctuations and osmotic stability of lipid vesicles

## Summary
Statistical-mechanical analysis of how thermal fluctuations and osmotic pressure together determine vesicle stability. The authors derive a critical osmotic pressure $\Pi_c$ for vesicle collapse using the Helfrich Hamiltonian with spherical harmonic expansion. A key finding is that thermal fluctuations make vesicle deformation continuous rather than abrupt, but do not shift the critical pressure. The paper provides water permeability values for POPC and volume change rate estimates crucial for understanding osmotic equilibration timescales.

## Key Findings
- Critical osmotic pressure for GUVs: $\Pi_c = 2\kappa / R_0^3 (6 - H_0 R_0)$, with $H_0 = 0$ for symmetric bilayers
- Theory predicts collapse at $\sim 8$ mPa for $R_0 = 5\,\mu$m, but experiments show collapse at $\sim 0.15$ atm (150× larger)
- Thermal fluctuations cause $\sim 4\%$ volume reduction for $\hat{\kappa} \approx 20$ at $R_0 = 5\,\mu$m
- Inclusion of thermal fluctuations makes deformation continuous, not abrupt

## Important Equations
Helfrich free energy with osmotic pressure:
$$F = \frac{\kappa}{2} \oint (2H - C_0)^2 \, dA + \Delta\Pi \cdot V$$

Volume change rate:
$$\dot{V}/V_0 \approx 10\%\text{ per minute for } \Delta c = 10\,\text{mM}, \; R_0 = 5\,\mu\text{m}$$

## Physical Scales

| Type | Value | Description |
|------|-------|-------------|
| Length | $R_0 = 5\,\mu$m | Typical GUV radius |
| Time | $\sim 6$ min | Osmotic relaxation ($10\%$ equilibration/min) |
| Energy | $\kappa \approx 20\,k_BT$ | DOPC bending modulus |
| Permeability | $P \approx 16\,\mu$m/s | Water permeability for POPC |

## Methodology

### Theoretical Approach
- Key assumptions: Helfrich Hamiltonian, quasi-spherical approximation, impermeable membrane
- Mathematical framework: Spherical harmonic expansion with $\ell_{\max} = 1000$ modes
- Approximations used: Configuration integral analysis, Gaussian fluctuation theory

### Experimental Methods
- Techniques: Literature values compiled for osmotic experiments
- Equipment: N/A (theoretical paper)
- Resolution/Precision: Analytical results

## Results and Analysis
- Key result: Water permeability $P \approx 16\,\mu$m/s sets the timescale for osmotic equilibration
- Supporting evidence: Consistent with experimental GUV deflation studies
- Limitations: Quasi-spherical assumption breaks down for strongly deflated vesicles ($v < 0.8$)

## Relevance to My Research

### Direct Applications
- Water permeability value ($P \approx 16\,\mu$m/s) can be used to estimate expected osmotic response timescales in my heated GUVs
- Volume change rate formula can predict deflation kinetics given known osmotic gradients
- The discrepancy between theoretical and experimental collapse pressures suggests additional mechanisms (like the permeability spike I observe)

### Questions Raised
- [ ] Does rapid heating create transient osmotic gradients large enough to reach $\Pi_c$?
- [ ] Can the 150× discrepancy between theory and experiment be explained by temperature-dependent permeability?
- [ ] How does the permeability spike timescale ($\sim 2.7$ s) compare to the $10\%$/min equilibration predicted here?

### Future Directions
- [ ] Calculate expected $\Delta c$ from temperature-dependent solubility of sucrose/glucose
- [ ] Compare my observed $\dot{v}/v$ with predictions from this model

## References to Check
- Olbrich et al. (2000) — water permeability measurements for various lipids
- Evans & Needham (1987) — physical properties of SOPC vesicles

## Notes History
- Created: 2026-02-13
- Last reviewed: 2026-02-13
