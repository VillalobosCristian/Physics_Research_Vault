---
title: 05_Flickering_Fitting_Procedure
date: '2026-03-24'
status: active
tags:
topic: 
- membrane-physics
project:
---
# Flickering Spectroscopy — Fitting Procedure

Tags: #GUV #flickering #fitting #MATLAB #code

---

## What We're Fitting

Two free parameters:
- $\kappa$ — bending rigidity [J]  
- $\sigma$ — membrane tension [N/m]

These control the _shape_ of $S_\text{model}(q)$ through $\lambda_l$ and its _amplitude_ through $k_BT/4\kappa$.

---

## Cost Function

$$\mathcal{L}(\kappa,\sigma) = \sum_{q=q_{\min}}^{q_{\max}} \left[\log_{10} S_\text{data}(q) - \log_{10} S_\text{model}(q)\right]^2$$

Log-space gives equal relative weight to all modes regardless of the four-decades dynamic range in $S(q)$. Linear-space fitting would be dominated by the largest values (low-$q$ modes).

The fit range is $q \in [6, 20]$:
- $q \leq 5$: contaminated by rigid-body translation/rotation
- $q > 20$: pixel noise and PSF effects

---

## Two-Level Structure of the Computation

**The sum over $l$** is _inside_ the model — it evaluates $S_\text{model}(q)$ for one mode:

$$S_\text{model}(q) = \frac{k_BT}{4\kappa} \sum_{\substack{l \geq q \\ l+q\;\text{even}}} \frac{n_{lq}}{\lambda_l(\kappa,\sigma)}$$

**The cost sum is over $q$** — comparing data vs model at each measured mode:

```
cost(kappa, sigma):
    for each q in [6,...,20]:          ← outer sum: defines cost
        S_model(q) = kBT/(4*kappa)
                   * sum over l >= q:  ← inner sum: evaluates one model point
                         n_lq / lambda_l(kappa, sigma)
        cost += (log10 S_data(q) - log10 S_model(q))^2
```

The Milner-Safran eigenvalue:

$$\lambda_l = (l-1)(l+2)\left[l(l+1) + \bar\sigma\right], \qquad \bar\sigma = \frac{\sigma R_0^2}{\kappa}$$

---

## Stage 1 — Coarse Grid (25×25)

Parameters in **log-space** (spans several physical decades):

```matlab
lkap_c = linspace(0.5, 2.5, 25);   % log10(kappa/kBT): 3 to 316 kBT
lsig_c = linspace(-10, -4, 25);    % log10(sigma):     1e-10 to 1e-4 N/m
```

For each of the 625 candidate pairs:

```matlab
kap  = 10^lkap_c(ci) * kBT;
sig  = 10^lsig_c(cj);
sbar = sig * R0^2 / kap;
```

The `ok = false` guard skips parameter pairs where $\lambda_l \leq 0$ for any $l$ — physically these correspond to membrane instability.

---

## Stage 2 — Fine Grid (40×40)

Zooms into a ±0.4 log-unit window around the coarse best:

```matlab
hw     = 0.4;
lkap_f = linspace(best_lk_c - hw, best_lk_c + hw, 40);
lsig_f = linspace(best_ls_c - hw, best_ls_c + hw, 40);
```

Step size ~2% per step (vs ~25% in coarse). Identical loop structure.

---

## Output and Reliability Flag

```matlab
data_slope    = polyfit(log10(nFit), log10(spectrum(fitMask)), 1);
kappa_reliable = (data_slope(1) < -2.5);
```

| `data_slope` | `regime` | `kappa_reliable` |
|---|---|---|
| < −2.5 | `'bending'` | `true` |
| −2.5 to −1.5 | `'crossover'` | `false` |
| > −1.5 | `'tension'` | `false` |

In the crossover and tension regimes, $\kappa$ and $\sigma$ become degenerate — the spectrum slope is insensitive to $\kappa$ alone. See [[07_Bending_Tension_Regimes]] for the quantitative crossover condition.

---

## Expected Output

```
Coarse grid (25x25 = 625 points)... best: kappa=~34 kBT, sigma=~1e-8, cost=~0.05
Fine grid (40x40 = 1600 points)... done.

=== FIT RESULTS ===
kappa     = ~34 kBT
sigma     = ~2e-8 N/m
sigma_bar = ~small
cost      = ~0.004
```

Good fit quality: cost < 0.05 for baselines.

---

## Saved Output (`fit_results` struct)

| Field | Description |
|---|---|
| `kappa`, `kappa_kBT` | Bending rigidity [J] and [kBT] |
| `sigma`, `sigma_bar` | Tension [N/m] and dimensionless |
| `data_slope`, `model_slope` | Log-log spectral slopes |
| `kappa_reliable` | Logical: true if slope < −2.5 |
| `regime` | `'bending'`, `'crossover'`, or `'tension'` |
| `cost` | Final grid search cost |
| `spectrum`, `sem` | Full spectrum and error [180×1] |

---

## Related Notes

- [[03_Pecreaux_Projection_Formula]]
- [[04_Flickering_Spectrum_Computation]]
- [[07_Bending_Tension_Regimes]]
