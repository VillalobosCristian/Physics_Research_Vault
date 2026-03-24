---
title: "Mean Curvature"
status: active
tags: 
- membrane-biophysics
- differential-geometry
topic: 
- membrane-physics
project:
aliases: [H, average curvature]
---

# Mean Curvature

The **mean curvature** $H$ is a local measure of membrane bending, central to the [[Helfrich model]].

## Definition

$$H = \frac{1}{2}(c_1 + c_2) = \frac{1}{2}(\kappa_1 + \kappa_2)$$

Where $c_1, c_2$ (or $\kappa_1, \kappa_2$) are the [[principal curvatures]].

## Geometric Interpretation

- $H > 0$: Surface curves toward normal (convex)
- $H < 0$: Surface curves away from normal (concave)
- $H = 0$: Minimal surface (soap films)

## Examples

| Surface | Mean Curvature |
|---------|----------------|
| Sphere (radius R) | $H = 1/R$ |
| Cylinder (radius R) | $H = 1/(2R)$ |
| Saddle point | $H = 0$ (if $c_1 = -c_2$) |
| Plane | $H = 0$ |

## In Helfrich Energy

The bending energy depends on mean curvature:

$$F_\kappa = \frac{\kappa}{2} \oint (2H - C_0)^2 \, dA$$

The membrane minimizes deviations from the [[spontaneous curvature]] $C_0$.

## Differential Geometry Expression

In terms of the metric ($g_{ij}$) and second fundamental form ($b_{ij}$):

$$H = \frac{1}{2} g^{ij} b_{ij}$$

## Related Concepts

- [[Gaussian curvature]]
- [[Principal curvatures]]
- [[Spontaneous curvature]]
- [[Helfrich free energy]]
- [[Bending rigidity]]

## Key Literature

- deserno2015 — Differential geometry treatment
- deserno_primer — Introduction
