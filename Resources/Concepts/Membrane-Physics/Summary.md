---
title: "2026-04-03"
date: 2026-04-03
tags:
  - daily
---

# 2026-04-03, Friday

## Today's Focus
<% tp.file.cursor(1) %>

## Lab Work
-

## Analysis / Code
-
## Pipeline Summary

---

### Stage 1 — Contour extraction (`hybrid_detectionmethod.m`)

For each frame, the vesicle contour is detected by radial gradient search in phase contrast. Output: `r(θ, t)` — the midline radius at 360 angles for every frame.

---

### Stage 2 — Event detection (`local_event_detection.m`)

**Input:** `contourExtraction_hybrid_fixed.mat`

Three shape descriptors computed per frame:

- **Circularity** $= 4\pi A/P^2$ — drops when vesicle deforms
- **Roughness** $= \sigma_r/\langle r \rangle$ — increases when membrane fluctuates strongly
- **Drift rate** — CM displacement per frame, spikes when vesicle moves during heating

Each descriptor is smoothed and compared to a 3σ threshold computed from the first 1000 frames (Baseline 0). A heating event is flagged when **any** descriptor exceeds its threshold. Events closer than 300 frames are merged, then filtered by minimum duration (≥30 frames) and minimum excursion.

The movie is then segmented into:

```
Baseline 0 | Heat 1 | Post-heat 1 | Heat 2 | Post-heat 2 | ...
```

For each segment the power spectrum $\langle|\hat{u}_q|^2\rangle$ and mode ACFs $C_q(\tau)$ are computed.

**Output:** `analysisWorkspace.mat`

---

### Stage 3 — Pécréaux spectral fit (`Fitting_Eventd.m`)

**Input:** `analysisWorkspace.mat`

**Heating segments are skipped** — they are non-equilibrium. Only `baseline` and `post_heat` segments with ≥150 frames are fitted.

The normalised displacement: $$u(\theta, t) = \frac{r(\theta,t)}{\langle r(t)\rangle_\theta} - 1$$

The power spectrum is fitted to the Pécréaux/Milner-Safran model:

$$\langle|\hat{u}_q|^2\rangle = \frac{k_BT}{\kappa} \sum_{\ell \geq q} \frac{c_{\ell q}}{\lambda_\ell(\bar\sigma)} \cdot \frac{1}{2}$$

with $\lambda_\ell = (\ell-1)(\ell+2)[\ell(\ell+1) + \bar\sigma]$ and $\bar\sigma = \sigma R_0^2/\kappa$.

Two free parameters: $\kappa$ (bending rigidity) and $\sigma$ (membrane tension). Grid search over $\log_{10}\kappa$ and $\log_{10}\sigma$, coarse 25×25 then fine 40×40, minimising $\sum(\log_{10}\text{data} - \log_{10}\text{model})^2$.

**Output:** `*_pecreaux_fit_results.mat`

---

### The reliability condition

The model has two regimes depending on which term dominates:

$$S_q \sim \begin{cases} k_BT/(\kappa, q^3) & \bar\sigma \ll q^2 \quad \text{(bending)} \ k_BT/(\sigma R_0^2, q) & \bar\sigma \gg q^2 \quad \text{(tension)} \end{cases}$$

In the **tension regime** both $\kappa$ and $\bar\sigma$ appear only through their ratio — the fit is degenerate in $\kappa$. The spectrum constrains $\sigma$ well but $\kappa$ can take almost any value while keeping $\bar\sigma$ fixed.

**In code**, the regime is classified by the **log-log slope of the data**:

```matlab
slope_bending = -2.5;   % steeper → bending dominated
slope_tension = -1.5;   % flatter → tension dominated

if data_slope < -2.5
    regime = 'bending';   kappa_reliable = true;
elseif data_slope > -1.5
    regime = 'tension';   kappa_reliable = false;
else
    regime = 'crossover'; kappa_reliable = false;
end
```

Physically: slope $\approx -3$ is the bending prediction ($S_q \propto q^{-3}$), slope $\approx -1$ is the tension prediction ($S_q \propto q^{-1}$). Only when the spectrum is clearly bending-dominated (slope $< -2.5$) does the fit return a meaningful $\kappa$. **$\sigma$ is reliable in all regimes.**

---

### What each output file contains

|File|Key variables|What it tells you|
|---|---|---|
|`analysisWorkspace.mat`|`segments`, `fourier_segs`, `heatingCycles`, `baselines`|When events occurred, spectra, ACFs, shape changes|
|`*_pecreaux_fit_results.mat`|`fit_results` struct array|$\kappa$, $\sigma$, $\bar\sigma$, regime, reliability flag per segment|

---


> We track GUV contour fluctuations at 50 fps, detect LED-induced heating events from three shape descriptors, segment the movie into baseline and post-heat periods, and fit the equilibrium power spectrum of each period to the Pécréaux/Milner-Safran model to extract bending rigidity $\kappa$ and membrane tension $\sigma$ — with $\kappa$ reliable only when the spectrum is steeper than $q^{-2.5}$ (bending-dominated) and $\sigma$ reliable in all regimes.
## Reading
- [[]]

## Ideas & Questions
-

## Tomorrow
- [ ]
The contour gives you the mean radius $R_0$ at baseline and the change $\Delta R$ during heating. Under the thin-shell approximation the vesicle is a sphere, so:

$$A = 4\pi R^2 \implies \frac{\Delta A}{A} = \frac{4\pi(R_0 + \Delta R)^2 - 4\pi R_0^2}{4\pi R_0^2} = \frac{2\Delta R}{R_0} + \left(\frac{\Delta R}{R_0}\right)^2$$

The second term is negligible when $\Delta R \ll R_0$. In your data $\Delta R \sim 1$--$2,\mu$m against $R_0 \sim 10$--$15,\mu$m, so $(\Delta R / R_0)^2 \lesssim 0.02$. The working approximation is:

$$\boxed{\frac{\Delta A}{A} \approx \frac{2,\Delta R}{R_0}}$$

which in the script is:

```matlab
dAA_pct = 2 * dR_cyc1 ./ R0_base_um * 100;   % [%]
```

where `dR_cyc1 = hc.rad_change * pxSize_um` is the difference between the post-heat and pre-heat window mean radii in µm, and `R0_base_um = baselines(1).mu_rad * pxSize_um` is the baseline mean radius in µm.

One caveat worth stating to your advisor: $\Delta R$ here is the change in the **equatorial mean radius** extracted from the 2D phase contrast projection, not a direct 3D measurement. For a sphere the equatorial radius equals $R_0$, but during invagination the vesicle is non-spherical. The quantity you are computing is therefore the projected area change, which underestimates the true membrane area change if the invagination is deep and axisymmetric. It is a lower bound on $\Delta A / A$.



The slide is clean and the hypothesis is well stated. Three candidate equations worth adding, in order of impact:

**Most useful -- the reduced volume:**

$$\nu = \frac{V}{\frac{4\pi}{3}\left(\frac{A}{4\pi}\right)^{3/2}}$$

This is the key quantity that changes irreversibly. Adding it makes explicit what "expels area as volume" means -- $\nu$ drops permanently after each cycle. Käs-Sackmann use it as the central observable.

**Second -- the tension jump:**

$$\sigma_{PH1} \approx \sigma_0 \exp!\left(\frac{8\pi\kappa}{k_BT},\frac{\Delta A}{A}\right)$$

This directly connects your two measured quantities and makes the slide testable. It is the quantitative prediction you can verify from the $\Delta A/A$ vs $\log_{10}(\sigma_{PH1}/\sigma_0)$ plot.

**Third -- osmotic recovery timescale:**

$$\tau_{perm} \sim \frac{R_0}{3 P_f v_w c_s}$$

Explains the "Recovery?" arrow physically -- roughness recovers on this timescale as water slowly re-enters.

**My recommendation:** add only the tension jump equation. It bridges the left panel (you see $\Delta R$ in the drift) with the right panel (you measure $\sigma$), making the hypothesis quantitative without cluttering the slide. The reduced volume and $\tau_{perm}$ are better placed on a dedicated discussion/interpretation slide.