---
title: "MOC - Analysis Methods for Vesicle Fluctuations"
date: 2026-02-13
status: "active"
related_papers:
  - "[[pécréaux2004_Refined contour analysis of GUVs]]"
  - "[[faizi2020_Fluctuation spectroscopy of GUVs phase contrast and confocal]]"
  - "[[rautu2017_The role of optical projection in membrane fluctuation analysis]]"
  - "[[sciortino2025_Active membrane deformations of a minimal synthetic cell]]"
tags:
  - MOC
  - methods
  - fluctuation-analysis
  - contour-detection
---

# MOC — Analysis Methods for Vesicle Fluctuations

## Overview

This MOC reviews and organizes methodological literature for analyzing vesicle fluctuations, contour detection, and bending rigidity extraction from phase contrast microscopy. My analysis pipeline (hybrid radial search + dual-peak detection + Fourier decomposition + regime classification) extends standard approaches to handle highly deformed vesicles.

## Standard Fluctuation Spectroscopy Pipeline

```
Phase Contrast Video → Contour Detection → Polar Transform → Fourier Decomposition
     ↓                      ↓                    ↓                    ↓
30-50 fps            Intensity gradient      r(θ) coordinates      Mode amplitudes
                     or radial search        (PCA-aligned)         ⟨|u_n|²⟩
                                                                       ↓
                                                              Fit: σq² + κq⁴
                                                                       ↓
                                                              Extract κ, σ
```

## Key Methods from Literature

### Contour Detection

| Method | Resolution | Reference | Applicability to Deformed Vesicles |
|--------|-----------|-----------|----------------------------------|
| Intensity gradient (sigmoid fit) | $\sim 80$–$100$ nm | [[pécréaux2004_Refined contour analysis of GUVs]] | Limited — assumes smooth contour |
| Radial search with concentric ROI | $\sim 100$ nm | Genova et al. (2013) | Moderate — requires nearly spherical |
| Polynomial + quadratic interpolation | Pixel-level | Drabik et al. (2016) | Good for smooth deformations |
| **Hybrid radial search + dual-peak detection** | **Sub-pixel** | **This work** | **Designed for invaginated shapes** |

My innovation: the dual-peak detection handles cases where the radial intensity profile shows two membrane crossings (invaginated regions), which standard methods cannot resolve.

### Bending Rigidity Values (DOPC Reference)

| Method | $\kappa$ ($k_BT$) | Correction | Reference |
|--------|-------------------|------------|-----------|
| Phase contrast (raw) | $19 \pm 1$ | None | [[rautu2017_The role of optical projection in membrane fluctuation analysis]] |
| Phase contrast (corrected) | $27 \pm 1$ | Optical projection | [[rautu2017_The role of optical projection in membrane fluctuation analysis]] |
| Phase contrast + confocal | $22.3 \pm 2.2$ | Standard | [[faizi2020_Fluctuation spectroscopy of GUVs phase contrast and confocal]] |
| Flickering + viscosity | $20$ | Hydrodynamic | Faizi et al. (2024) |
| Active GUVs | $13.4 \pm 2.5$ | Active system | [[sciortino2025_Active membrane deformations of a minimal synthetic cell]] |
| Fluorescence | $17.5 \pm 8.8$ | Probe effects | Drabik et al. (2016) |
| **Consensus** | **$20$–$27$** | | |

### Essential Corrections

1. **Optical projection** ([[rautu2017_The role of optical projection in membrane fluctuation analysis]])
   - Effect: underestimates $\kappa$ by $\sim 30\%$
   - Fix: Bayesian posterior estimate; $\kappa_{\text{corrected}} \approx 1.4 \times \kappa_{\text{raw}}$

2. **Integration time** ([[pécréaux2004_Refined contour analysis of GUVs]])
   - Camera exposure $\tau_m$ averages fast fluctuations
   - Fix: mode-dependent correction factor

3. **White noise** (Genova et al. 2013)
   - Pixel jitter adds flat noise floor
   - Fix: estimate from high-mode plateau and subtract

4. **Focal depth** ([[rautu2017_The role of optical projection in membrane fluctuation analysis]])
   - Phase contrast: $\delta \approx 1$–$1.5\,\mu$m
   - Modes with wavelength $< \delta$ are averaged

## My Extensions to Standard Methods

### Reduced Volume from 2D Projections
- PCA alignment to find symmetry axis
- Axisymmetric assumption for revolution
- Validation needed: compare with known shapes

### Roughness as Deformation Metric
- Defined as mean deviation from best-fit ellipse
- Baseline: $\sim 0.004$ (thermal fluctuations)
- Peak during heating: $\sim 0.026$ ($6\times$ baseline)
- Captures both invagination depth and feature count

### Three-Regime Classification
1. **No heating:** Baseline fluctuations → extract $\kappa$, $\sigma$
2. **Shape deformation:** Active shape changes → measure roughness, $v(t)$
3. **Heating without deformation:** Steady-state heated → extract $\kappa_{\text{heated}}$, $\sigma_{\text{heated}}$

## Methodological Recommendations from Literature

- [ ] Apply optical projection correction to all $\kappa$ measurements
- [ ] Use $> 200$ frames per regime for statistical significance
- [ ] Validate reduced volume calculation against known prolate/stomatocyte shapes
- [ ] Compare roughness metric with standard mode amplitude analysis
- [ ] Apply integration time correction for 30-50 fps acquisition
- [ ] Check for non-Gaussian statistics during deformation (cf. Sciortino et al.)

---
*See also:* [[MOC - Temperature-Dependent Membrane Permeability]], [[MOC - Vesicle Shape Deformations]], [[Fluctuation spectroscopy]]
