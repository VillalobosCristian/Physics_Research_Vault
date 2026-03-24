---
title: "Membrane Fluctuation Spectrum"
aliases: [fluctuation power spectrum, undulation spectrum]
tags:
  - "#membrane-biophysics"
  - "#fluctuations"
  - "#spectroscopy"
---

# Membrane Fluctuation Spectrum

The **membrane fluctuation spectrum** describes the amplitude of thermal undulations as a function of wavelength (or mode number).

## Planar Membrane

For a quasi-planar membrane with height fluctuations $h(\mathbf{r})$:

$$\langle |h_q|^2 \rangle = \frac{k_B T}{\kappa q^4 + \sigma q^2}$$

Where:
- $q$ = wavevector magnitude
- $\kappa$ = [[Bending rigidity]]
- $\sigma$ = [[Surface tension]]

### Limiting Cases

**Low tension** ($\sigma \ll \kappa q^2$):
$$\langle |h_q|^2 \rangle \approx \frac{k_B T}{\kappa q^4}$$

**High tension** ($\sigma \gg \kappa q^2$):
$$\langle |h_q|^2 \rangle \approx \frac{k_B T}{\sigma q^2}$$

## Spherical Vesicle

For a quasi-spherical vesicle with radius $R$, decompose shape in spherical harmonics:

$$r(\theta, \phi) = R \left[1 + \sum_{l,m} u_{lm} Y_l^m(\theta, \phi)\right]$$

The fluctuation spectrum:

$$\langle |u_{lm}|^2 \rangle = \frac{k_B T}{\kappa (l-1)(l+2)[l(l+1) + \bar{\sigma}]}$$

Where $\bar{\sigma} = \sigma R^2 / \kappa$ is the reduced tension.

## Measurement

From [[fluctuation spectroscopy]]:
1. Record time series of vesicle contours
2. Decompose into Fourier/spherical harmonic modes
3. Calculate power spectrum $\langle |u_l|^2 \rangle$
4. Fit to extract $\kappa$ and $\sigma$

## Related Concepts

- [[Bending rigidity]]
- [[Thermal fluctuations]]
- [[Fluctuation spectroscopy]]
- [[Flickering]]
- [[Contour analysis]]

## Key Literature

- milner, safran1987 — Theory
- faucon, mitov1989 — Experimental requirements
- pécréaux2004 — Contour analysis
- faizi2020 — Modern methods
