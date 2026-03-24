---
title: "Fluctuation Spectroscopy"
status: active
tags: 
- membrane-biophysics
- experimental-methods
- guv
topic: 
- membrane-physics
project:
aliases: [flicker spectroscopy, membrane spectroscopy]
---

# Fluctuation Spectroscopy

**Fluctuation spectroscopy** (or flicker spectroscopy) is a technique to measure membrane mechanical properties by analyzing [[thermal fluctuations]].

## Principle

1. Image GUV equatorial contour over time
2. Extract contour shape fluctuations
3. Decompose into Fourier modes
4. Analyze power spectrum to extract [[bending rigidity]] and [[surface tension]]

## Experimental Setup

### Microscopy Modes
- **Phase contrast** — High contrast, some optical artifacts
- **Confocal** — 3D information, slower
- **DIC** — Good contrast, quantification challenging
- **Fluorescence** — Direct membrane visualization

### Requirements
- Temperature control (fluctuations are thermal)
- High frame rate (>30 fps typically)
- Stable focal plane
- Low background flow

## Analysis Pipeline

```
Video → Contour extraction → Fourier decomposition → Power spectrum → Fitting
```

### Contour Analysis

1. **Edge detection** — Find membrane position
2. **Circle fitting** — Determine center and mean radius
3. **Angular decomposition** — $r(\theta) = R[1 + \sum_n u_n e^{in\theta}]$
4. **Power spectrum** — $\langle |u_n|^2 \rangle$

### Fitting Models

**For quasi-spherical vesicles:**
$$\langle |u_n|^2 \rangle = \frac{k_B T}{\kappa} \cdot f(n, \bar{\sigma})$$

## Corrections & Artifacts

- **Optical projection** — 3D→2D effects (rautu2017)
- **Integration time** — Temporal averaging
- **Pixelation** — Spatial resolution limits
- **Camera noise** — Baseline subtraction

## Related Concepts

- [[Membrane fluctuation spectrum]]
- [[Bending rigidity]]
- [[Contour analysis]]
- [[Flickering]]

## Key Literature

- döbereiner2003 — Advanced methods
- pécréaux2004 — Refined contour analysis
- méléard, pott2011 — Statistical advantages
- faizi, reeves2020 — Modern implementation
- rautu, orsi2017 — Projection corrections
- genova, vitkova2013 — Shape registration
