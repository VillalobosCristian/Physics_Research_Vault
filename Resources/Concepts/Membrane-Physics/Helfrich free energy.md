---
title: "Helfrich Free Energy"
aliases: [curvature energy, bending energy, Helfrich Hamiltonian]
tags:
  - "#membrane-biophysics"
  - "#elasticity"
  - "#theory"
---

# Helfrich Free Energy

The **Helfrich free energy** describes the elastic energy of a lipid membrane based on its curvature.

## Full Expression

$$F = \frac{\kappa}{2} \oint (2H - C_0)^2 \, dA + \kappa_G \oint K \, dA + \sigma \oint dA$$

Where:
- $H = \frac{1}{2}(c_1 + c_2)$ = [[Mean curvature]]
- $K = c_1 c_2$ = [[Gaussian curvature]]
- $\kappa$ = [[Bending rigidity]]
- $\kappa_G$ = [[Gaussian curvature modulus]]
- $C_0$ = [[Spontaneous curvature]]
- $\sigma$ = [[Surface tension]]

## Terms Explained

### Bending Term
$$F_\kappa = \frac{\kappa}{2} \oint (2H - C_0)^2 \, dA$$
- Penalizes deviation from spontaneous curvature
- Dominates GUV shape at low tension

### Gaussian Term
$$F_G = \kappa_G \oint K \, dA$$
- Constant for fixed topology (Gauss-Bonnet)
- Important for fission/fusion

### Tension Term
$$F_\sigma = \sigma \oint dA$$
- Area constraint or reservoir coupling
- High tension → spherical shapes

## Shape Equation

Minimizing the Helfrich energy yields the shape equation:

$$\Delta_s H + 2H(H^2 - K) - \frac{C_0}{2}(2H - C_0) + \frac{\sigma}{\kappa}H = 0$$

## Related Concepts

- [[Helfrich model]]
- [[Bending rigidity]]
- [[Vesicle shapes]]
- [[Shape phase diagram]]

## Key Literature

- helfrich1973 — Original paper
- zhong-can, helfrich1989 — Variational analysis
- seifert, lipowsky1995 — Shape solutions
