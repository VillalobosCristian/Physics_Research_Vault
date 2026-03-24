---
title: 02_Helfrich_Hamiltonian_GUV
date: '2026-03-24'
status: active
tags:
topic: 
- membrane-physics
project:
---
# Helfrich Hamiltonian for a Quasi-Spherical GUV

Tags: #GUV #Helfrich #statistical-mechanics #membrane

---

## Shape Parameterization

The 3D shape of a vesicle fluctuating around a sphere of radius $R_0$ is expanded in real spherical harmonics:

$$r(\theta,\phi) = R_0 \left[1 + \sum_{l=2}^{\infty}\sum_{m=-l}^{l} u_{lm}\, Y_l^m(\theta,\phi)\right]$$

where $u_{lm}$ are dimensionless complex amplitudes with the reality condition $u_{l,-m} = (-1)^m u_{lm}^*$ for a real surface. The $l=0,1$ modes are excluded (translation and rotation), so the sum starts at $l=2$.

---

## Free Energy

The Helfrich free energy (bending + tension) evaluated to quadratic order in $u_{lm}$:

$$\mathcal{H} = \frac{\kappa}{2R_0^2} \sum_{l,m} \lambda_l\, |u_{lm}|^2$$

with the eigenvalue:

$$\boxed{\lambda_l = l(l+1)\left[(l-1)(l+2) + \bar{\sigma}\right]}$$

where $\bar{\sigma} = \sigma R_0^2/\kappa$ is the dimensionless (reduced) tension. Equivalently:

$$\lambda_l = l^2(l+1)^2 - (2-\bar{\sigma})\,l(l+1)$$

This is exactly `lambda = l^2*(l+1)^2 - (2-sbar)*l*(l+1)` in the code.

> **Note on eigenvalue convention:** The Milner-Safran form used in `pecreaux_fit_free.m` writes this as $\lambda_l = (l-1)(l+2)[l(l+1) + \bar\sigma]$ — algebraically identical after expanding.

---

## Equipartition

The Hamiltonian is diagonal in $(l,m)$: each mode is an independent harmonic oscillator. By equipartition:

$$\frac{\kappa}{2R_0^2}\,\lambda_l\, \langle|u_{lm}|^2\rangle = \frac{k_BT}{2} \implies \boxed{\langle|u_{lm}|^2\rangle = \frac{k_BT\,R_0^2}{\kappa\,\lambda_l}}$$

Note that $\lambda_l$ is dimensionless, so $\langle|u_{lm}|^2\rangle$ has units of $R_0^2$... but the observed 2D spectrum $\langle|\hat{u}_q|^2\rangle$ is dimensionless because $u_{lm}$ itself is dimensionless (see [[04_Flickering_Spectrum_Computation]]).

**Why the variance diverges at low $l$:** for $\bar\sigma \to 0$ and $l=2$, $\lambda_2 = 4 \cdot 3 \cdot (1 \cdot 4) = 48$, which is finite. But as $\bar\sigma$ grows negatively (unphysical — membrane instability), $\lambda_l$ can vanish. This is the stability condition: $\lambda_l > 0$ for all $l$ in the fit range.

---

## Dimensionless Tension

$$\bar\sigma = \frac{\sigma R_0^2}{\kappa}$$

Physical scales:
- $\sigma \sim 10^{-8}$ N/m (typical GUV baseline)
- $R_0 \sim 10\;\mu\text{m} = 10^{-5}$ m
- $\kappa \sim 20\;k_BT \approx 8 \times 10^{-21}$ J

So $\bar\sigma \sim 10^{-8} \cdot 10^{-10} / 8 \times 10^{-21} \approx 12$. Values in the range 1–400 are physically encountered.

---

## No Explicit $R_0$ in the Final Spectrum

The factor $R_0^2$ in $\langle|u_{lm}|^2\rangle = k_BT R_0^2 / (\kappa \lambda_l)$ is exactly cancelled by the factor of $1/R_0^2$ from the curvature eigenvalue (which enters through the area element in the curvature integral). The projected 2D spectrum $\langle|\hat{u}_q|^2\rangle$ therefore has **no explicit $R_0$ dependence**, even though the physical problem involves the vesicle size. $R_0$ enters only implicitly through $\bar\sigma = \sigma R_0^2/\kappa$.

---

## Related Notes

- [[01_Flickering_Spectroscopy_Overview]]
- [[03_Pecreaux_Projection_Formula]]
- [[07_Bending_Tension_Regimes]]
