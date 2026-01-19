---
title: "Membrane Wrapping"
aliases: [particle wrapping, engulfment, endocytic wrapping]
tags:
  - "#membrane-biophysics"
  - "#particle-interactions"
  - "#guv"
---

# Membrane Wrapping

**Membrane wrapping** is the process by which a lipid membrane bends around and engulfs a particle (colloid, nanoparticle, or cell).

## Energy Balance

The wrapping transition is governed by competition between:

$$\Delta F = F_{\text{bending}} + F_{\text{adhesion}} + F_{\text{tension}}$$

### Bending Cost
$$F_{\text{bend}} = 8\pi\kappa \left(\frac{R_p}{R_m}\right)^2 f(w)$$

Where $w$ is the wrapping fraction and $f(w)$ depends on geometry.

### Adhesion Gain
$$F_{\text{adh}} = -W \cdot A_{\text{wrapped}}$$

Where $W$ is the adhesion energy per unit area.

## Wrapping Transition

**Critical adhesion energy** for full wrapping of a sphere:

$$W_c = \frac{2\kappa}{R_p^2}$$

- $W < W_c$: No wrapping or partial wrapping
- $W > W_c$: Full engulfment possible

## Wrapping States

| State | Wrapping Fraction | Energy |
|-------|-------------------|--------|
| Free | 0 | 0 |
| Partial | 0 < w < 1 | Metastable |
| Full | 1 | Depends on W |

## Factors Affecting Wrapping

1. **Particle size** — Larger particles easier to wrap (lower curvature)
2. **Membrane tension** — High tension suppresses wrapping
3. **Adhesion strength** — Must exceed critical value
4. **Particle shape** — Non-spherical particles wrap differently
5. **Membrane fluctuations** — Can assist or hinder wrapping

## Kinetics

Wrapping dynamics depend on:
- [[Membrane viscosity]]
- Adhesion kinetics
- Solvent viscosity

## Related Concepts

- [[Bending rigidity]]
- [[Adhesion energy]]
- [[Endocytosis]]
- [[Membrane deformation]]
- [[Wrapping transition]]

## Key Literature

- deserno, bickel2003 — Theoretical framework
- deserno2004 — Elastic deformation
- lipowsky, döbereiner1998 — Nanoparticle contact
- mirigian, muthukumar2013 — Kinetics
- bahrami, raatz2014 — Comprehensive analysis
- spanke, style2020 — Floppy vesicle wrapping
- fessler2024 — Active particle engulfment
- ayala2023 — Fluctuation-assisted uptake
