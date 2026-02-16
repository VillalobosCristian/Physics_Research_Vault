---
title: "Quantitative Comparison - My Findings vs Literature"
date: 2026-02-13
status: "active"
tags:
  - "#comparison"
  - "#quantitative"
  - "#literature-review"
---

# Quantitative Comparison: My Findings vs Literature

## 1. Deformation Amplitudes

| Parameter                         | My Value                          | Literature Value                              | Reference               | Agreement                                   |
| --------------------------------- | --------------------------------- | --------------------------------------------- | ----------------------- | ------------------------------------------- |
| Reduced volume (baseline)         | $v_0 \approx 0.95$–$0.98$         | $v = 0.95$–$1.0$ (floppy vesicles)            | Käs & Sackmann 1991     | Good                                        |
| Reduced volume (peak deformation) | $v \approx 0.69$                  | $v \approx 0.75$–$0.85$ (stomatocytes)        | Seifert & Lipowsky 1995 | **My value is lower** — deeper invagination |
| Volume loss (transient)           | $5$–$30\%$                        | $6$–$25\%$ (thermal transitions)              | Käs 1991, Leirer 2009   | Consistent                                  |
| Roughness (baseline)              | $\sim 0.004$                      | $\Delta R/R \sim 0.01$–$0.02$ (thermal)       | Sciortino et al. 2025   | Similar order                               |
| Roughness (peak)                  | $\sim 0.026$ ($6\times$ baseline) | $\Delta R/R \sim 0.2$ ($10\times$ for active) | Sciortino et al. 2025   | Comparable enhancement factor               |

## 2. Timescales

| Process | My Value | Literature Value | Reference | Agreement |
|---------|----------|-----------------|-----------|-----------|
| Permeability spike | $\sim 2.7$ s | $\tau \approx 4$–$5$ s (phase transition) | Leirer et al. 2009 | **Same order** |
| Osmotic recovery | $\sim 10$ s | $\sim 6$ min ($10\%$/min) | Wennerström et al. 2022 | **My value is much faster** |
| Gold/substrate heating | $< 1$ s | ms timescale | Tsuji et al. 2024 | Consistent |
| Volume efflux rate | $\Delta v/\Delta t \approx -0.02$ s$^{-1}$ | Not directly reported | — | **Novel measurement** |
| Active deformation timescale | — | $2.5$–$10$ s | Sciortino et al. 2025 | Brackets my values |
| Lipid mixing (post-fusion) | — | $\sim 10$ s | Rørvig-Lund et al. 2015 | Comparable to my recovery |

## 3. Temperature and Heating Parameters

| Parameter | My Value | Literature Value | Reference | Notes |
|-----------|----------|-----------------|-----------|-------|
| Substrate temperature rise | $\Delta T \sim 5$–$8$ K (est.) | $\Delta T \sim 5$–$8$ K | Villalobos-Concha et al., Fränzl 2022 | Same setup calibration |
| Thermal gradient | Unknown (extended heating) | $\nabla T \sim 10^6$ K/m (focused) | Hill et al. 2018 | My gradient likely weaker (unfocused) |
| Thermal area expansion | $\sim 2.5$–$4\%$ (est.) | $0.5\%$/°C | Rørvig-Lund et al. 2015 | Consistent for $\Delta T = 5$–$8$ K |
| Critical power for damage | Not measured | $> 1.3$ mW (focused) | Hill et al. 2018 | My power is higher but unfocused |

## 4. Membrane Mechanical Properties

| Parameter | My Value | Literature Value | Reference | Notes |
|-----------|----------|-----------------|-----------|-------|
| $\kappa$ (no heating) | To measure | $22.3 \pm 2.2\,k_BT$ | Faizi et al. 2020 | Benchmark for DOPC |
| $\kappa$ (projection-corrected) | To measure | $27 \pm 1\,k_BT$ | Rautu et al. 2017 | Apply correction |
| $\sigma$ (baseline) | To measure | $3.1 \times 10^{-7}$ N/m | Faizi et al. 2020 | Expected for floppy GUVs |
| $\kappa$ change with T | To measure | $\kappa \propto h^{2\text{-}3}$ (decreases) | Wennerström 2025 | Expect softening during heating |

## 5. Transport Parameters

| Parameter | My Value | Literature Value | Reference | Notes |
|-----------|----------|-----------------|-----------|-------|
| Soret coefficient (DOPC) | Drift observed | $S_T = -0.2$ to $-0.4$ K$^{-1}$ | Hill et al. 2018 | Thermophobic |
| Thermo-osmotic slip | Drift observed | $\chi \sim 10^{-10}$ m$^2$s$^{-1}$K$^{-1}$ | Fränzl 2022 | At gold interface |
| Water permeability | Inferred from $\Delta v$ | $P_f \sim 16\,\mu$m/s (POPC) | Wennerström 2022 | Baseline value |
| Osmotic timescale | $\sim 10$ s (recovery) | Minutes (passive diffusion) | Wennerström 2022 | My recovery is faster |

## 6. Key Asymmetries

| Comparison | Onset (Heating) | Offset (Cooling) | Ratio | Literature Context |
|-----------|----------------|------------------|-------|-------------------|
| Roughness peak | $0.026$ | $0.005$ | $5\times$ | No direct comparison — **novel finding** |
| Volume change rate | $\Delta v/\Delta t \approx -0.02$ s$^{-1}$ | Slower recovery | Asymmetric | Leirer 2009 shows similar asymmetry for phase transitions |
| Deformation complexity | Multiple invagination features | Simple relaxation | Different | Consistent with rate-dependent permeability |

## Summary Assessment

### What is consistent with literature:
- Volume loss magnitude ($5$–$30\%$) matches thermal shape transition studies
- Permeability spike timescale ($\sim 2.7$ s) is same order as Leirer's phase-transition relaxation
- Temperature rise ($\sim 5$–$8$ K) is well-calibrated from our colloidal work
- DOPC bending rigidity should be $\sim 20$–$27\,k_BT$ at baseline

### What is novel:
- Reduced volume reaching $v \approx 0.69$ — deeper than most reversible deformations
- $5\times$ onset/offset asymmetry — not reported in equilibrium studies
- $10$ s recovery timescale — much faster than passive osmotic equilibration
- Fluid-phase DOPC showing phase-transition-like behavior without actual transition
- Non-contact, non-coherent light-induced shape changes

### What needs additional data:
- Direct temperature measurement during heating
- $\kappa$ measurement in all three regimes (no heat, deformation, heated equilibrium)
- Systematic power dependence
- Lipid composition dependence (to test phase transition hypothesis)
- Permeability coefficient during and after heating

---
*See also:* [[MOC - Temperature-Dependent Membrane Permeability]], [[MOC - Vesicle Shape Deformations]], [[MOC - Analysis Methods for Vesicle Fluctuations]]
