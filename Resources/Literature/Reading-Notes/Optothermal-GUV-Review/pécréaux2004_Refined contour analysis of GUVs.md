---
title: "Refined contour analysis of giant unilamellar vesicles"
status: "reviewed"
tags: 
- literature-note
- fluctuation-analysis
- methods
- contour-detection
- literature-note
topic:
project:
authors: J. Pécréaux, H.-G. Döbereiner, J. Prost, J.-F. Joaniny, P. Bassereau
citekey: pecreaux2004
date_read: 2026-02-13
journal: European Physical Journal E
key_topics: [contour-analysis, fluctuation-spectroscopy, bending-rigidity, phase-contrast, Fourier-analysis]
related_projects: [Temperature shape changes GUVs]
year: 2004
---

# Refined contour analysis of giant unilamellar vesicles

## Summary
Foundational methodology paper establishing refined contour analysis for GUVs using phase contrast microscopy. Achieves $\sim 80$ nm spatial resolution in contour detection, develops Fourier decomposition framework, and identifies critical corrections (integration time, pixelation, optical projection). The spectral slope transitions from $q^{-2}$ (tension-dominated) to $q^{-4}$ (bending-dominated), allowing simultaneous extraction of $\kappa$ and $\sigma$.

## Key Findings
- Contour detection resolution: $\sim 80$-$100$ nm with phase contrast
- Fourier modes: $n = 2$-$30$ analyzable range
- Spectral slope: $q^{-4}$ in bending regime, $q^{-2}$ in tension regime
- Integration time correction essential for CCD cameras ($\tau_m = 33$ ms)
- Pixelation cutoff at $q_{\max} \sim 4\,\mu$m$^{-1}$ (4-pixel wavelength)

## Important Equations
Fourier decomposition:
$$r(\theta) = R\left[1 + \sum_n (a_n \cos n\theta + b_n \sin n\theta)\right]$$

Fluctuation spectrum:
$$\langle |u(q)|^2 \rangle = \frac{k_BT}{4\pi(\sigma q^2 + \kappa q^4)}$$

Integration time correction:
$$\tau_m(q_l)^{-1} = \frac{1}{4\pi\eta_l^+}(\sigma q_l^2 + \kappa q_l^4)$$

## Relevance to My Research

### Direct Applications
- This is the foundational method my contour analysis pipeline builds on
- The $q^{-2}$ to $q^{-4}$ spectral transition is exactly what I should see in my Fourier analysis
- Integration time correction formula needed for my 30-50 fps acquisition
- My hybrid radial search algorithm extends this approach to handle invaginated shapes

### Questions Raised
- [ ] How does the spectral slope change during the deformation events?
- [ ] Can I detect the tension-bending crossover shifting during heating?
- [ ] Is my dual-peak detection for invaginated shapes introducing spectral artifacts?

## Notes History
- Created: 2026-02-13
- Last reviewed: 2026-02-13
