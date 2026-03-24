---
title: 07_Bending_Tension_Regimes
date: '2026-03-24'
status: active
tags:
topic: 
- membrane-physics
project:
---
# Bending vs Tension Regimes — Crossover Derivation

Tags: #GUV #flickering #Helfrich #crossover #theory

---

## Two Limiting Cases

Starting from the full spectrum (see [[03_Pecreaux_Projection_Formula]]):

$$\langle|\hat{u}_q|^2\rangle = \frac{k_BT}{4\kappa} \sum_{\substack{l \geq q \\ l+q \text{ even}}} \frac{n_{lq}}{(l-1)(l+2)[l(l+1) + \bar\sigma]}$$

The dimensionless tension $\bar\sigma = \sigma R_0^2/\kappa$ controls which term dominates the denominator.

---

## Limit 1 — Pure Bending ($\bar\sigma \to 0$)

When $l(l+1) \gg \bar\sigma$ for all modes:

$$\lambda_l \approx (l-1)(l+2)\,l(l+1) \approx l^4$$

The spectrum scales as $\langle|\hat{u}_q|^2\rangle \propto k_BT/(\kappa\, q^4)$ in 3D, but after equatorial projection (which integrates over $q_y$, costing one power of $q$):

$$\boxed{\langle|\hat{u}_q|^2\rangle \propto q^{-3}}$$

**Practical implication:** slope = −3 in log-log. Both $\kappa$ and $\sigma$ are independently measurable — $\kappa$ controls amplitude, $\sigma$ is consistent with zero.

---

## Limit 2 — High Tension ($\bar\sigma \gg l(l+1)$)

When tension dominates, $l(l+1) + \bar\sigma \approx \bar\sigma$:

$$\lambda_l \approx \bar\sigma\,(l-1)(l+2) \approx \bar\sigma\,l^2$$

The spectrum becomes:

$$\langle|\hat{u}_q|^2\rangle \propto \frac{k_BT}{\sigma R_0^2}\,\frac{1}{q^2}$$

After equatorial projection:

$$\boxed{\langle|\hat{u}_q|^2\rangle \propto q^{-1}}$$

**Critical consequence:** $\kappa$ cancels out of the formula (it appears only through $\bar\sigma = \sigma R_0^2/\kappa$). Only $\sigma$ is measurable. This is the **degeneracy problem** for post-heat tension-dominated segments.

---

## Exact Crossover Mode

The crossover mode $l^*$ is where $l(l+1) = \bar\sigma$:

$$(l^*)^2 + l^* - \bar\sigma = 0$$

Exact solution (positive root):

$$\boxed{l^* = \frac{-1 + \sqrt{1 + 4\bar\sigma}}{2}}$$

For $\bar\sigma \gg 1$, expanding the square root:

$$l^* \approx \sqrt{\bar\sigma} = R_0\sqrt{\frac{\sigma}{\kappa}}$$

---

## Spectral Slope as a Function of Regime

Let $x = l^2 + l$ (scales as $l^2$). Then $\lambda_l = (x-2)(x+\bar\sigma) \approx x(x+\bar\sigma)$. Effective power of $l$:

$$\lambda_l \sim \begin{cases} l^4 & l \ll l^* \quad \Rightarrow \text{slope} = -3 \\ l^2 \bar\sigma & l \gg l^* \quad \Rightarrow \text{slope} = -1 \\ \sim l^2 & l \approx l^* \quad \Rightarrow \text{slope} \approx -2 \end{cases}$$

---

## Sensitivity Window of the Fit Range $q = 6$–$20$

Crossover affects the fit range when $6 \lesssim l^* \lesssim 20$, i.e.:

$$36 \lesssim \bar\sigma \lesssim 400$$

| Segment | $\bar\sigma$ | $l^*$ (exact) | Slope observed | Regime |
|---|---|---|---|---|
| Baseline (exp 1) | 0.87 | 0.56 | −3.11 | Bending |
| Post-heat 1 (exp 1) | 134 | 11.1 | −2.19 | Crossover |
| Post-heat 2 (exp 1) | 223 | 14.4 | −2.01 | Crossover |
| Baseline (exp 3) | 296 | 16.7 | −1.87 | Tension |

**Interpretation:** when $l^*$ is below q=6, the entire fit range sees pure bending (slope ≈ −3). When $l^*$ is inside [6, 20], you see the crossover (slope ≈ −2). When $l^*$ is above 20, the window sees pure tension (slope ≈ −1) and $\kappa$ is unmeasurable.

---

## Summary Table

| Regime | Condition | Slope | What you can measure |
|---|---|---|---|
| Pure bending | $\bar\sigma \ll q^2$ | −3 | $\kappa$ and $\sigma$ independently |
| Crossover | $\bar\sigma \sim q^2$ | −2 to −3 | Both, but degenerate |
| High tension | $\bar\sigma \gg q^2$ | −1 | $\sigma$ only, $\kappa$ drops out |

This is why $\kappa$ is reported only from bending-dominated baselines, and $\sigma$ from all segments.

---

## Related Notes

- [[02_Helfrich_Hamiltonian_GUV]]
- [[03_Pecreaux_Projection_Formula]]
- [[05_Flickering_Fitting_Procedure]]
