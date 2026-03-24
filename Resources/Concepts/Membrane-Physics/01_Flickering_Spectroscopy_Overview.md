# Flickering Spectroscopy — Overview

Tags: #GUV #flickering #membrane #biophysics

---

## Physical Setup

A GUV in thermal equilibrium undergoes shape fluctuations driven by $k_BT$. The membrane resists bending (cost $\kappa$) and stretching (cost parametrized by $\sigma$, the effective tension). The goal is to extract $\kappa$ and $\sigma$ from the _statistics_ of those fluctuations as seen in a 2D equatorial cross-section.

---

## What the Pipeline Extracts

$$\text{Spectrum} \xrightarrow{\text{Pécréaux fit}} (\kappa,\;\sigma) \qquad \text{ACF per mode} \xrightarrow{\text{OLS log-fit}} \tau_q \xrightarrow{\text{compare}} \eta_\text{eff}$$

The spectrum fit is **equilibrium** (time-averaged) → elastic parameters.  
The ACF fit is **dynamical** → viscous dissipation timescale.  
Consistency between $(\kappa, \sigma)$ and the location of $\tau_q$ relative to Milner-Safran curves is an internal self-consistency check.

---

## Logic Flow

```
Raw contour r(φ,t)
    │
    ▼
Normalize by ⟨r⟩_φ(t) → u(φ,t)   [remove breathing mode]
    │
    ▼
DFT → Û_q(t),  multiply by 2 for ±q
    │
    ├──► Time-average → ⟨|û_q|²⟩ ──► fit Pécréaux theory → κ, σ
    │
    └──► ACF C_q(τ) ──► OLS log-linear fit → τ_q ──► compare to Milner-Safran
```

---

## Key Approximations and Their Validity

| Approximation | Condition | Risk if violated |
|---|---|---|
| Quasi-spherical expansion | $\langle u^2 \rangle \ll 1$ | Mode coupling, nonlinear corrections |
| Equatorial contour = 3D projection | Vesicle stays in focal plane | Systematic bias in all modes |
| $l_{\max} = 200$ truncation | $l_{\max} \gg q_{\max}$ | Underestimate spectrum at high $q$ |
| $A=1$ in ACF fit | No slow drift in $\hat{U}_q$ | `detrend(c_re,1)` mitigates this |
| Fit range $q \in [6,15]$ | Rigid-body modes excluded | Low-$\kappa$ bias if $q_{\min}$ too small |

**Dominant correction not always included:** the camera integration time correction $\chi(\tau_l, T_{\exp})$ — finite exposure time blurs fast modes and suppresses the high-$q$ spectrum, causing $\kappa$ to be _overestimated_. This correction reduced a $\kappa$ bias from ~63 to ~35 $k_BT$ in practice.

---

## Related Notes

- [[02_Helfrich_Hamiltonian_GUV]]
- [[03_Pecreaux_Projection_Formula]]
- [[04_Flickering_Spectrum_Computation]]
- [[05_Flickering_Fitting_Procedure]]
- [[06_ACF_Viscosity_Extraction]]
- [[07_Bending_Tension_Regimes]]
- [[08_GUV_Analysis_Pipeline]]
