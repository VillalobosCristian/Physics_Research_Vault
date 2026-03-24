---
date: 2026-02-16
status: active
tags: 
- [reference, quantitative, DOPC, mechanical-properties, controls]
- literature-note
topic:
project:
---

# Quantitative Reference: DOPC Mechanical Properties and Controls

This is the definitive quantitative reference table for the project — a single place to look up all mechanical properties of DOPC and comparison lipids.

## DOPC Mechanical Properties at Room Temperature (25°C)

| Property | Symbol | Value | Unit | Method | Reference |
|----------|--------|-------|------|--------|-----------|
| Bending rigidity (raw, phase contrast) | κ | 19.4 ± 2.1 | kBT | Flickering | Faizi 2020, Soft Matter |
| Bending rigidity (raw, confocal) | κ | 22.3 ± 2.2 | kBT | Flickering | Faizi 2020, Soft Matter |
| Bending rigidity (projection-corrected) | κ_corr | 27 ± 1 | kBT | Flickering + Rautu | Rautu 2017, Soft Matter |
| Bending rigidity (MD simulation) | κ | 18.3 | kBT | Real-space fluctuations | CMU Lipid Group |
| Bending rigidity (consensus range) | κ | 20-27 | kBT | Multiple | Literature consensus |
| Area compressibility modulus | K_A | 230 ± 10 | mN/m | Micropipette | Evans & Rawicz 1990 |
| Area compressibility (MD) | K_A | 285 ± 10 | dyn/cm | CHARMM36 | MD simulations |
| Area per lipid (30°C) | A_L | 72.4 | Å² | X-ray/neutron | Kučerka et al. 2011 |
| Area per lipid (15°C) | A_L | 69.1 | Å² | X-ray/neutron | Kučerka et al. 2011 |
| Area per lipid (45°C) | A_L | 75.5 | Å² | X-ray/neutron | Kučerka et al. 2011 |
| Area thermal expansion | α_A | 0.0029 | /°C | Thermal | At 30°C |
| Bilayer thickness (30°C) | d_B | ~3.67 | nm | X-ray | Kučerka et al. |
| Water permeability | P_f | 42 ± 6 | μm/s | Osmotic deflation | Olbrich et al. 2000 |
| Water permeability (micropipette) | P_f | 70-75 | μm/s | Micropipette aspiration | Various |
| Edge tension (pore line tension) | γ | 27.7 | pN | AFM | Various |
| Lysis tension | σ_lysis | ~10 | mN/m | Micropipette | Evans et al. |
| Phase transition temperature | T_m | -17 | °C | DSC | Standard |
| Viscosity (2D) | η_m | ~10⁻⁹ | Pa·m·s | Diffusion | Various |

## Temperature Dependence of DOPC Properties

### Bending Rigidity vs Temperature

Bending rigidity follows an Arrhenius-type temperature dependence:

$$\kappa(T) = \kappa_0 \exp\left(\frac{\Delta \varepsilon_K}{k_B T}\right)$$

with $\Delta \varepsilon_K = 7 \times 10^{-21}$ J

| T (°C) | κ (kBT, estimated) | κ (×10⁻²⁰ J) | Source |
|--------|-------------------|--------------|--------|
| 15 | ~24 | 9.5 | CMU Lipid Group extrapolation |
| 20 | ~22 | 9.1 | Estimated |
| 25 | ~21 | 8.6 | Consensus |
| 30 | ~20 | 8.2 | Flickering |
| 37 | ~18 | 7.5 | MD/estimated |
| 45 | ~16 | 6.9 | Estimated |

**Rate:** approximately -0.15 to -0.2 kBT per °C

**Practical magnitudes:**
- For ΔT = 5 K heating: κ decreases by ~1 kBT (~5% drop)
- For ΔT = 10 K heating: κ decreases by ~2 kBT (~10% drop)

### Area per Lipid vs Temperature

Linear thermal expansion:

$$A_L(T) = A_L(T_0) \left[1 + \alpha_A (T - T_0)\right]$$

where $\alpha_A = 0.0029 \text{ °C}^{-1} \approx 0.29\%\text{/°C}$

**Practical magnitudes:**
- For ΔT = 5 K: ΔA/A = 1.5%
- For ΔT = 10 K: ΔA/A = 2.9%

### Bilayer Thickness vs Temperature

Thickness decreases as area increases (approximately constant volume per lipid):

$$d(T) \propto \frac{1}{A_L(T)}$$

**Practical magnitude:**
- For ΔT = 10 K: ~3% thickness decrease

---

## Comparison Lipids for Controls

### POPC (1-Palmitoyl-2-oleoyl-PC)

| Property | Value | Unit | Reference |
|----------|-------|------|-----------|
| κ (flickering) | 25.5 ± 2.6 | kBT | Multiple |
| κ (range) | 19-28 | kBT | Various methods |
| P_f | ~16 | μm/s | Wennerström 2022 |
| P_f (with 10% Chol) | 15.7 ± 5.5 | μm/s | Various |
| T_m | -2 | °C | DSC |
| A_L (30°C) | 68.3 | Å² | Kučerka et al. |
| K_A | 254 | mN/m | Micropipette |

**Rationale:** Similar fluid-phase lipid with one saturated tail. Lower permeability than DOPC. If deformation is similar → mechanism is not permeability-specific. If deformation is reduced → supports permeability-dependent mechanism.

### DPPC (1,2-Dipalmitoyl-PC, gel phase below 41°C)

| Property | Value | Unit | Condition | Reference |
|----------|-------|------|-----------|-----------|
| κ (gel) | ~50-90 | kBT | T < 41°C | Various |
| κ (fluid) | ~20-25 | kBT | T > 41°C | Various |
| P_f (gel) | ~5 | μm/s | T < T_m | Leirer 2009 |
| P_f (fluid) | ~50 | μm/s | T > T_m | Leirer 2009 |
| T_m | 41.3 | °C | DSC | Standard |
| K_A (gel) | ~850 | mN/m | Micropipette | Evans et al. |
| K_A (fluid) | ~240 | mN/m | Micropipette | Evans et al. |

**Rationale:** If heated above T_m, undergoes massive area change at phase transition. This is the mechanism studied by Leirer 2009 and Kyrsting 2011. Comparison shows whether our DOPC results are phase-transition-like or a distinct mechanism.

### DOPC + Cholesterol Mixtures

| Cholesterol mol% | κ (kBT) | K_A (mN/m) | P_f effect | Reference |
|-----------------|---------|-----------|------------|-----------|
| 0% | 20-27 | 230 | Baseline | Multiple |
| 15% | ~28-35 | 258 | Reduced ~30% | Multiple |
| 30% | ~35-50 | 308 | Reduced ~50% | Multiple |
| 40% | ~50-70 | 342 | Reduced ~60% | Multiple |

**Rationale:** Cholesterol condenses the membrane, increases κ, and decreases permeability. If deformation is abolished at 30% Chol → mechanism requires both membrane flexibility AND permeability. Strong control experiment.

---

## My Values vs Literature: Assessment

| Parameter | My Value | Literature | Status |
|-----------|----------|-----------|--------|
| κ_baseline | (to be measured) | 20-27 kBT | Pending |
| κ_heated | (to be measured) | ~18-20 kBT for +5K | Pending |
| v_baseline | 0.96 | ~0.95-1.0 (floppy) | Consistent |
| v_minimum | 0.69 | 0.59-0.75 (stomatocyte) | Deeper than most |
| Volume loss | 5-30% | 6-25% (Käs, Leirer) | Consistent |
| Deformation timescale | 2.7 s (peak roughness) | 4-5 s (Leirer relaxation) | Consistent |
| Recovery timescale | ~10 s | Minutes (osmotic) | Much faster |
| Onset/offset asymmetry | 5× | No precedent | Novel observation |

---

## Related Notes

- [[MOC - Temperature-Dependent Membrane Permeability]]
- [[MOC - Analysis Methods for Vesicle Fluctuations]]
- [[Deep Dive - DOPC Permeability Dynamics]]
- [[Deep Dive - Fourier Analysis Validation and Best Practices]]
- [[faizi2020_Fluctuation spectroscopy of GUVs phase contrast and confocal]]
- [[rautu2017_The role of optical projection in membrane fluctuation analysis]]
- [[wennerström2025_Coupling between membrane bending and stretching]]
