---
title: 08_GUV_Analysis_Pipeline
date: '2026-03-24'
status: active
tags:
topic: 
- membrane-physics
project:
---
# GUV Analysis Pipeline — Architecture and Workflow

Tags: #GUV #pipeline #MATLAB #workflow #lab-management

---

## Folder Structure

```
/Volumes/SSD samsung/Vesicles2026/
│
├── raw/                            ← never touch after acquisition
│   └── 20260324_DOPC_thermal_40x_50fps_01/
│       └── frame_0001.tif, ...
│
├── processed/                      ← run scripts here
│   └── 20260324_DOPC_thermal_40x_50fps_01/
│       ├── contourExtraction_hybrid_fixed.mat
│       ├── analysisWorkspace.mat
│       ├── 20260324_DOPC_thermal_40x_50fps_01_pecreaux_fit_results.mat
│       └── figures/
│
└── Data_reviewed/                  ← population analysis lives here
    ├── *_pecreaux_fit_results.mat   (copies auto-saved by scripts 2 & 3)
    ├── *_analysisWorkspace.mat
    └── figures/
```

Raw images stay untouched. If contour extraction fails you re-run on raw without overwriting anything.

---

## Naming Convention

```
YYYYMMDD_LIPID_CONDITIONS_OBJ_FPS_NCYCLES_NN
```

**Examples:**
```
20260424_DOPC_thermal_40x_50fps_3cycles_01
20260424_DOPC_thermal_40x_50fps_5cycles_01
20260424_DOPC_CHOL20_thermal_40x_50fps_3cycles_01
20260424_DOPC_thermal_gap30s_40x_50fps_3cycles_01
```

**Why zero-padded `_01` not `_1`:** `dir()` and Finder sort `_1, _10, _11, _2` instead of `_01, _02, ..., _10`.

The `population_analysis.m` group detection parses the name:
```matlab
if contains(name, 'CHOL')
    grp = 'DOPC/CHOL';
elseif contains(name, 'gap')
    grp = 'Long gap';
else
    grp = 'DOPC standard';
end
```

---

## Scripts — Summary

| Script | Run from | Reads | Writes |
|---|---|---|---|
| `hybrid_detectionmethod.m` | exp folder | raw `.tif` | `contourExtraction_hybrid_fixed.mat` |
| `eventDetection.m` | exp folder | contour `.mat` | `analysisWorkspace.mat` + copy to Data_reviewed |
| `pecreaux_fit_free.m` | exp folder | `analysisWorkspace.mat` | `expName_pecreaux_fit_results.mat` + copy |
| `diagnostics.m` | exp folder | `analysisWorkspace.mat` | figures only |
| `folder_diagnostic.m` | Data_reviewed | all `*_pecreaux_fit_results.mat` | console only |
| `population_analysis.m` | Data_reviewed | all `*_pecreaux_fit_results.mat` | figures + console |
| `population_figures.m` | Data_reviewed | all `*_pecreaux_fit_results.mat` | 5 figures |

---

## Key Variables in `analysisWorkspace.mat`

| Variable | Description |
|---|---|
| `allContours` | Full contour struct array from script 1 |
| `segments` | Struct: label, start, stop, type, index |
| `heatingCycles` | Per-event metrics: onset, offset, drift, roughness |
| `fourier_segs` | Per-segment spectrum, ACF, τ_q |
| `fps`, `pxSize_um`, `expName` | Calibration + experiment identity |
| `roughness_smooth`, `circularity_smooth`, `drift_smooth`, `t_sec` | Smoothed time traces |
| `q_range = 6:20`, `q_acf = [6 8 10 12 15]` | Mode ranges |

Segment types: `'baseline'`, `'heating'`, `'post_heat'`.

---

## Key Fields in `fit_results` struct

| Field | Description |
|---|---|
| `kappa`, `kappa_kBT` | Bending rigidity [J] and [kBT] |
| `sigma`, `sigma_bar` | Tension [N/m] and dimensionless |
| `data_slope`, `model_slope` | Log-log spectral slopes |
| `kappa_reliable` | `true` if slope < −2.5 |
| `regime` | `'bending'`, `'crossover'`, `'tension'` |
| `cost` | Final grid search cost |
| `spectrum`, `sem` | Full spectrum and error [180×1] |

---

## Run Order Checklist

```
□ 1. Acquire images → save to raw/YYYYMMDD_LIPID_CONDITIONS_OBJ_FPS_NCYCLES_NN/
□ 2. cd processed/same_name/
□ 3. hybrid_detectionmethod.m    → check contour quality in live plot
□ 4. eventDetection.m            → check fig1_overview: events detected correctly?
□ 5. pecreaux_fit_free.m         → check console: slopes and costs reasonable?
□ 6. cd Data_reviewed/
□ 7. folder_diagnostic.m         → STATUS: OK for new experiment?
□ 8. population_figures.m        → updated population plots
```

---

## Quality Gates

**After `hybrid_detectionmethod.m`:**
- Mean detection success > 90%
- Midline smooth in live plot — no jumps or outlier spikes
- `nOutliersRejected` < 5% of angles per frame

**After `eventDetection.m`:**
- `fig1_overview` shows heating events shaded correctly
- Baseline 0 has ≥ 500 frames before first event
- Roughness and circularity return to near-baseline after each event

**After `pecreaux_fit_free.m`:**
- Baseline cost < 0.05
- Baseline slope between −2.5 and −4
- $\sigma_\text{baseline} < 10^{-8}$ N/m (not pre-stressed)
- $\sigma$ increases monotonically across post-heat segments

---

## Adding a New Population Figure

In `population_figures.m`, the pattern is always:

```matlab
fig_new = figure(...);
[~, ax, ~, qleg] = quickPlot('Parent', axes(fig_new), 'Grid','on');

for i = 1:n_exp
    mask = strcmp({cycle_tbl.expName}, baseline_tbl(i).expName);
    rows = cycle_tbl(mask);
    ci   = [rows.cycle_idx];
    yv   = [rows.YOUR_FIELD];      % <-- change this line
    [ci, ord] = sort(ci); yv = yv(ord); rows = rows(ord);
    draw_traj(ax, ci, yv, rows, col_bl, col_ph, mk_from_cycle);
end

xlabel(ax, '...'); ylabel(ax, '...');
qleg(ax, make_legend_entries(ax, col_bl, col_ph, col_leg));
savefigures_new(fig_new, 'pop_figN_name');
```

---

## Provenance Metadata

Save alongside every `fit_results`:

```matlab
metadata.expName    = expName;
metadata.date       = datestr(now, 'yyyy-mm-dd HH:MM:SS');
metadata.fps        = fps;
metadata.pxSize_um  = pxSize_um;
metadata.qMin       = qMin;
metadata.qMax       = qMax;
metadata.lmax       = lmax;
metadata.n_frames   = numFrames;
metadata.matlab_ver = version;
```

This means every `.mat` file carries its own provenance — when you open a file a year from now you know when it was processed, with what parameters, and which MATLAB version.

---

## Future Directions

### Short Term (from existing data)
- **Camera integration time correction** $\chi(\tau_l, T_\text{exp})$ for $\kappa$ — infrastructure already in `fourier_segs`, adds one loop in `pecreaux_fit_free.m`
- **Osmotic recovery timescale** — fit exponential to $\sigma(t)$ between heating events → $\tau_\text{osm}$, compare to $\tau_\text{perm} = V/(P_f \cdot A \cdot R_T \cdot \Delta c)$
- **Angular anisotropy of fluctuations** — `std(sigma_dh)/mean(sigma_dh)` per segment, flag localized substrate adhesion
- **Fixed-$\kappa$ fit for post-heat** — lock $\kappa$ at baseline value, fit only $\sigma$ → cleaner tension estimate

### Medium Term (new experiments)
- **Vary inter-cycle gap systematically** — 10, 65, 200, 600 s gaps → map osmotic recovery vs waiting time
- **Vary heating duration and power** — shorter pulses (2–5 s) may allow area measurement without noise floor
- **Temperature-controlled baseline** — slow bath ramp (0.1°C/min) → equilibrium $d\kappa/dT$, $d\sigma/dT$ for DOPC
- **Cholesterol mixtures** — DOPC/CHOL has $\kappa$ up to 4×; test if stiffer membrane shows smaller $\sigma$ buildup per cycle

### Longer Term
- **Active membrane during heating** — fit heating-segment spectra to effective temperature $T_\text{eff}$ model (Prost, Ramaswamy), quantify energy injection per mode
- **Population statistics** — 20+ experiments needed for proper statistical testing
- **Irreversibility threshold** — map heating power threshold below which deformation is elastic vs irreversible area expulsion; function of $\kappa$, initial $\sigma$, heating rate

---

## Related Notes

- [[01_Flickering_Spectroscopy_Overview]]
- [[05_Flickering_Fitting_Procedure]]
- [[06_ACF_Viscosity_Extraction]]
