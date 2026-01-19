---
title: "Contour Analysis"
aliases: [contour tracking, membrane contour analysis]
tags:
  - "#membrane-biophysics"
  - "#experimental-methods"
  - "#image-analysis"
---

# Contour Analysis

**Contour analysis** is the image processing technique used to extract membrane shape from microscopy images for [[fluctuation spectroscopy]].

## Pipeline

```
Image → Edge detection → Contour extraction → Center fitting → Fourier decomposition
```

## Step-by-Step

### 1. Edge Detection

Find the membrane position in each frame:
- Intensity gradient methods (Sobel, Canny)
- Thresholding for fluorescence images
- Sub-pixel interpolation for accuracy

### 2. Contour Parameterization

Express contour as $r(\theta)$ in polar coordinates:

$$r(\theta, t) = R_0(t) + u(\theta, t)$$

Where:
- $R_0$ = mean radius
- $u(\theta, t)$ = fluctuation (small)

### 3. Fourier Decomposition

Decompose fluctuations into modes:

$$u(\theta, t) = \sum_{n=-\infty}^{\infty} u_n(t) e^{in\theta}$$

### 4. Power Spectrum

Calculate time-averaged spectrum:

$$\langle |u_n|^2 \rangle = \frac{1}{T} \int_0^T |u_n(t)|^2 dt$$

## Corrections

### Optical Artifacts
- **Focus drift** — Correct for z-position changes
- **Projection effects** — 3D membrane projects to 2D (see rautu2017)
- **Optical resolution** — Convolution with PSF

### Statistical
- **Finite sampling** — Window effects in Fourier transform
- **Noise floor** — Camera noise contribution

## Software

Common tools:
- MATLAB custom scripts
- Python (scikit-image, OpenCV)
- ImageJ/FIJI plugins

## Related Concepts

- [[Fluctuation spectroscopy]]
- [[Membrane fluctuation spectrum]]
- [[Flickering]]

## Key Literature

- pécréaux2004 — Refined methods
- genova, vitkova2013 — Registration techniques
- rautu, orsi2017 — Projection corrections
