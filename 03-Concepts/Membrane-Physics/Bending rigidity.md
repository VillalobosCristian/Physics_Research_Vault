---
title: "Bending Rigidity"
aliases: [bending modulus, κ, kappa]
tags:
  - "#membrane-biophysics"
  - "#elasticity"
  - "#guv"
---

# Bending Rigidity

The **bending rigidity** (κ) is the fundamental elastic modulus characterizing the energy cost of bending a lipid membrane.

## Definition

The bending energy per unit area for a membrane with principal curvatures $c_1$ and $c_2$:

$$F_b = \frac{\kappa}{2}(c_1 + c_2 - C_0)^2 + \kappa_G c_1 c_2$$

Where:
- $\kappa$ = bending rigidity (~10-25 $k_BT$ for lipid bilayers)
- $C_0$ = [[Spontaneous curvature]]
- $\kappa_G$ = [[Gaussian curvature modulus]]

## Typical Values

| Lipid | κ (kBT) | Reference |
|-------|---------|-----------|
| DOPC | 20 ± 2 | Dimova 2014 |
| DPPC (fluid) | 25 ± 3 | Gracià 2010 |
| POPC | 19 ± 1 | Faizi 2020 |

## Measurement Methods

1. **[[Fluctuation spectroscopy]]** — Power spectrum analysis of thermal undulations
2. **Micropipette aspiration** — Mechanical response to suction
3. **Electrodeformation** — Electric field induced shape changes
4. **Tether pulling** — Force-extension of membrane tubes

## Physical Interpretation

The bending rigidity sets:
- The **persistence length**: $\xi_p \sim \kappa / k_BT$
- The **fluctuation amplitude**: $\langle u^2 \rangle \propto k_BT / \kappa$
- The **wrapping transition**: particle engulfment threshold

## Related Concepts

- [[Helfrich model]]
- [[Helfrich free energy]]
- [[Gaussian curvature modulus]]
- [[Membrane fluctuation spectrum]]
- [[Thermal fluctuations]]

## Key Literature

- helfrich1973 — Original theory
- dimova2014 — Measurement review
- bouvrais2012 — Detailed methods
- faizi2020 — Modern spectroscopy
