---
title: "Vesicle Shapes"
aliases: [vesicle morphology, membrane shapes]
tags:
  - membrane-biophysics
  - morphology
  - guv
---

# Vesicle Shapes

Vesicle shapes are determined by minimizing the [[Helfrich free energy]] subject to constraints on area and volume.

## Shape Parameters

### Reduced Volume
$$v = \frac{V}{(4\pi/3)R_0^3} = \frac{6\sqrt{\pi}V}{A^{3/2}}$$

Where $R_0 = \sqrt{A/4\pi}$ is the radius of a sphere with the same area.

- $v = 1$: Sphere
- $v < 1$: Deflated shapes

### Area Difference
$$\Delta a = \frac{\Delta A}{8\pi h R_0}$$

Describes the difference in area between the two monolayers.

## Shape Classes

### Axisymmetric Shapes

| Shape | v range | Description |
|-------|---------|-------------|
| **Sphere** | 1 | Minimal area for given volume |
| **Prolate** | < 1 | Elongated, cigar-like |
| **Oblate** | < 1 | Flattened, disc-like |
| **Stomatocyte** | < 0.6 | Invaginated, cup-like |
| **Discocyte** | ~0.6 | Biconcave (RBC shape) |

### Non-axisymmetric
- **Starfish** — Multiple arms
- **Budded** — Small bud connected by neck

## Phase Diagram

The shape phase diagram maps shapes as function of $(v, \Delta a)$ or $(v, c_0)$:

```
         ↑ Δa
         |
 Prolate |  Pear → Budded
         |    ↗
 --------+--------- → v
         |    ↘
 Oblate  | Stomatocyte
         |
```

## Shape Transitions

- **Budding transition** — Continuous neck formation
- **Prolate-oblate** — First-order transition
- **Limiting shapes** — Self-intersecting boundaries

## Experimental Control

Shape can be tuned via:
1. **Osmotic deflation** — Reduce v
2. **Temperature** — Change lipid area
3. **Lipid asymmetry** — Modify Δa
4. **Spontaneous curvature** — Inclusions, asymmetric lipids

## Related Concepts

- [[Helfrich free energy]]
- [[Spontaneous curvature]]
- [[Budding]]
- [[Shape phase diagram]]
- [[Reduced volume]]

## Key Literature

- seifert, lipowsky1995 — Morphology classification
- seifert1997 — Comprehensive review
- kraus, seifert1995 — Gravity effects
- gueguen2017 — Shape transitions
