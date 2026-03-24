---
title: Heating detection code
date: '2026-03-24'
status: active
tags: 
- code
topic:
project:
---
Let me read the current file carefully before explaining.---

## Section 1 — Load

```matlab
S           = load('contourExtraction_hybrid_fixed.mat', 'allContours', 'angles');
allContours = S.allContours;
angles      = S.angles;
numFrames   = length(allContours);
t_sec       = (1:numFrames)' / fps;
```

`allContours` is a struct array of length `numFrames`. Each element contains the contour data for one frame: `x_midline`, `y_midline` (Cartesian coordinates of the midline contour), and `r_midline_smooth`, `r_inner_smooth`, `r_outer_smooth` (radial profiles in polar coordinates, already smoothed by the contour extraction pipeline). `angles` is the shared angular grid, length `N_th` — the same vector for every frame. `t_sec` is a column vector of time stamps in seconds, used as the x-axis for all timeline plots.

---

## Section 2 — Shape descriptors

**First loop: circularity and center of mass**

```matlab
xc = [x; x(1)];  yc = [y; y(1)];   % close the polygon
A  = polyarea(xc, yc);
P  = sum(sqrt(dx.^2 + dy.^2));
circularity(iFrame) = 4*pi*A / P^2;
```

`polyarea` uses the shoelace formula on the closed polygon. `P` is the perimeter computed from the Cartesian contour. `circularity` is the isoperimetric ratio: exactly 1 for a perfect disk, drops toward 0 for elongated or irregular shapes. For a quiet DOPC vesicle you expect values tightly clustered around 0.98–0.99.

```matlab
cross       = xc(1:end-1).*yc(2:end) - xc(2:end).*yc(1:end-1);
xCM(iFrame) = sum((xc(1:end-1) + xc(2:end)) .* cross) / (6*A);
yCM(iFrame) = sum((yc(1:end-1) + yc(2:end)) .* cross) / (6*A);
```

This is the exact centroid of the filled polygon, not the average of contour points. The `cross` vector is the signed area element of each edge from the shoelace formula. Using this rather than `mean(x)` avoids bias from non-uniform angular sampling of the contour.

```matlab
drift_magnitude = sqrt((xCM - xCM(1)).^2 + (yCM - yCM(1)).^2);
```

Cumulative displacement from the first frame, in pixels. This is monotonically growing if the vesicle drifts steadily in one direction (thermophoresis), or oscillatory if it diffuses. The key quantity for event detection is its _rate of change_, computed later.

**Second loop: radial statistics**

```matlab
r = allContours(iFrame).r_midline_smooth;
roughness(iFrame) = std(r) / mean(r);
```

`r` is the radial profile at one instant — a vector of length `N_th`. `roughness` is the coefficient of variation $\sigma_r / \langle r \rangle_\theta$, computed purely in real space per frame. It captures how non-circular the instantaneous shape is: thermal fluctuations produce a small but nonzero value, a heating-induced shape change produces a transient spike. This is distinct from `sigma_dh` computed later — roughness is one scalar per frame, `sigma_dh` is one value per angle averaged over a whole segment.

`radius_midline_mean(iFrame) = mean(r)` is used later to track slow changes in mean vesicle size, which could indicate osmotic imbalance developing over the experiment.

---

## Section 3 — Smoothing

```matlab
sw = 50;   % frames = 1 second at 50 fps
circularity_smooth = smoothdata(circularity, 'gaussian', sw);
roughness_smooth   = smoothdata(roughness,   'gaussian', sw);
drift_smooth       = smoothdata(drift_magnitude, 'gaussian', 100);
drift_rate         = gradient(drift_smooth);
drift_rate_smooth  = smoothdata(drift_rate, 'gaussian', 30);
drift_rate_smooth_s = drift_rate_smooth * fps;
```

The Gaussian window of `sw=50` (1 s) averages over individual thermal fluctuation cycles, which have timescales of 0.1–2 s. What remains after smoothing is the slow mean-state trajectory, which is what you want for event detection. Faster signals (individual fluctuations) would produce constant false positives if left unsmoothed.

`drift_magnitude` uses a longer window (100 frames = 2 s) because it is already a cumulative integral — it varies slowly by construction. `gradient` of the smoothed drift gives velocity in px/frame. This is then smoothed again with 30 frames (0.6 s) to suppress numerical noise from the discrete gradient. The final `* fps` converts to px/s only for the display panel — all threshold comparisons use px/frame to avoid rounding inconsistencies.

---

## Section 4 — Baseline stats and thresholds

```matlab
baseline0_win = min(500, numFrames);   % up to 10 s
baseline0_idx = 1:baseline0_win;
mu0_drift_rate  = median(drift_rate_smooth(baseline0_idx));
mu0_roughness   = mean(roughness_smooth(baseline0_idx));
mu0_circularity = mean(circularity_smooth(baseline0_idx));
```

`median` for drift rate (rather than mean) because the first few frames may contain a transient as the vesicle settles, and the median is robust to those outliers. `mean` for roughness and circularity because these are already smoothed and their distributions over 10 s of equilibrium fluctuations are close to Gaussian.

```matlab
sig0_drift_rate  = max(std(drift_rate_smooth(baseline0_idx)), 0.005);
sig0_roughness   = max(std(roughness_smooth(baseline0_idx)),  0.0005);
sig0_circularity = max(std(circularity_smooth(baseline0_idx)),0.0005);
thr_drift_rate   = max(mu0_drift_rate + 3*sig0_drift_rate, 0.03);
thr_roughness    = mu0_roughness   + 3*sig0_roughness;
thr_circularity  = mu0_circularity - 3*sig0_circularity;
```

The `max(..., floor_value)` on each `sig0` prevents an unrealistically quiet baseline from collapsing the threshold to zero — the floors encode the minimum expected noise level of your imaging system. The second `max(..., 0.03)` on `thr_drift_rate` ensures that even for a perfectly still vesicle you require at least 0.03 px/frame = 1.5 px/s of drift to flag a heating event, avoiding false positives from numerical noise in `gradient`.

`thr_circularity` is a _lower_ bound (the signal must _drop below_ it to trigger), while `thr_roughness` and `thr_drift_rate` are upper bounds — that asymmetry reflects the physics: deformation reduces circularity, increases roughness, and increases drift rate.

---

## Section 5 — Event detection

```matlab
active_drift = drift_rate_smooth  > thr_drift_rate;
active_rough = roughness_smooth   > thr_roughness;
active_circ  = circularity_smooth < thr_circularity;
active_combined = active_drift | active_rough | active_circ;
active_combined_smooth = smoothdata(double(active_combined), 'gaussian', 20) > 0.5;
```

The three binary channels are combined with OR: any single sensor flagging is sufficient. Smoothing the combined boolean with a 20-frame Gaussian and thresholding at 0.5 implements a morphological closing — gaps shorter than ~20 frames between two active regions are filled in, preventing one physical heating event from being reported as multiple fragments.

```matlab
heat_starts = find(diff([0; active_combined_smooth]) ==  1);
heat_ends   = find(diff([active_combined_smooth; 0]) == -1);
```

Padding with 0 before and after ensures that an event starting at frame 1 or ending at the last frame is still detected by `diff`.

```matlab
ok = (durations >= 100) & ((total_drift_cyc >= 10) | (rough_excursion > 2*sig0_roughness));
```

Quality filter: an event must last at least 2 s AND have either >10 px total drift (≈0.87 μm, above diffusion noise but below a clear thermophoretic displacement) OR a roughness excursion exceeding 2σ₀. This eliminates transient artifacts — focus drift, a passing dust particle — that trigger the binary detector momentarily.

```matlab
if zones_drift(k,1) - merged(end,2) < 300   % < 6 s gap → merge
```

If two surviving events are separated by less than 300 frames (6 s), they are merged into one. This handles the case where a vesicle drifts out of the heating zone and briefly re-enters during the same LED pulse.

---

## Section 6 — Segment definitions

```matlab
segments = struct('label',{},'start',{},'stop',{},'type',{},'index',{});
```

Every contiguous region of the recording is assigned to a segment. The sequence is always: `baseline` → `heating` → `post_heat` → `heating` → `post_heat` → ... The `index` field on heating and post_heat segments links them: `heating` with `index=k` is paired with `post_heat` with `index=k`, so you can always find the recovery period for a given event.

```matlab
mask_baseline  = false(numFrames,1);
mask_heating   = false(numFrames,1);
mask_post_heat = false(numFrames,1);
```

These three boolean vectors of length `numFrames` are the frame-level version of the segment classification. They are saved to `analysisWorkspace.mat` so that `flickeringSpectroscopy.m` can select frames by condition without needing to loop over the `segments` struct.

**`heatingCycles` struct** computes the _response_ of each event: `rough_change`, `circ_change`, `rad_change` are the differences between a `post` window (frames `offset + transient_skip + 1` to `offset + transient_skip + window_size`, i.e. 50 frames = 1 s after the event ends, skipping the relaxation transient) and a `pre` window (the 50 frames immediately before onset, bounded to not exceed the preceding segment start). The `active_drift/rough/circ` booleans record which sensor was actually triggered, useful for classifying event type.

---

## Section 7 — Baseline z-score tracking

```matlab
baselines(1) ... % Baseline 0: frames 1 to baseline0_win
```

`baselines` is an array of structs, one per usable post-heat segment. `baselines(1)` is always Baseline 0 — the pre-heat reference. Each subsequent entry corresponds to one post-heat segment whose usable length (after `transient_skip`) exceeds `min_baseline_frames = 200` frames. Segments that are too short are skipped with `continue`.

For each qualifying post-heat segment, two types of z-score are computed:

```matlab
bk.z_rough_vs0    = (mu_r - baselines(1).mu_rough) / baselines(1).sig_rough;
bk.z_rough_vsprev = (mu_r - prev.mu_rough) / prev.sig_rough;
```

`z_rough_vs0` asks: how many standard deviations away from the pre-heat baseline is this recovery period? A sustained shift of $|z| > 3$ across multiple post-heat baselines would indicate irreversible membrane remodeling — the vesicle never fully recovers. `z_rough_vsprev` asks the incremental question: did this heating event change things relative to the previous baseline? This is more sensitive for detecting cumulative drift across many heating cycles.

`baselines` is plotted in Fig 1 panels 1 and 4 as dashed horizontal lines, one per baseline, color-coded by the Okabe-Ito palette through `quickPlot` autocolor.

---

## Section 8 — Per-segment computation (single pass)

This is the core of the refactoring. Previously `R_mat` was built twice and the FFT was called twice per frame per segment. Now one loop does everything.

**Plottability check:**

```matlab
N_fr = segments(s).stop - segments(s).start + 1;
if strcmp(segments(s).type, 'post_heat') && (N_fr - transient_skip) < min_baseline_frames
    segments(s).plot_ok = false;
```

A post-heat segment is excluded if, after discarding `transient_skip=50` frames, fewer than 200 usable frames remain. Baseline and heating segments are always plotted. `segs_to_plot = find([segments.plot_ok])` gives the index list; `n_plot = numel(segs_to_plot)` is the total number of panels in Figs 3, 4b, and 5.

**Frame range:**

```matlab
f0 = segments(s).start + transient_skip;   % for post_heat only
frames_s = f0:f1;
N_fr = numel(frames_s);
```

The `transient_skip` offset is applied here once, and `frames_s` is the definitive list of frames used for all computations of this segment — `R_mat`, `sigma_dh`, `spectrum`, and `C_q` all use the same `frames_s`.

**R_mat construction:**

```matlab
R_mat = zeros(N_fr, N_th);
for fi = 1:N_fr
    R_mat(fi,:) = allContours(frames_s(fi)).r_midline_smooth(:)' * pxSize_um;
end
```

`R_mat` is `[N_fr × N_th]` in μm. This is the only place in the entire script where `allContours` is accessed for Fourier/flickering purposes — previously it was accessed in two separate figure sections.

**sigma_dh:**

```matlab
dh = R_mat - mean(R_mat, 1);       % subtract time-mean per angle: [N_fr x N_th]
segments(s).R_mean   = mean(R_mat, 1)';   % [N_th x 1], mean contour
segments(s).sigma_dh = sqrt(mean(dh.^2, 1))';  % [N_th x 1], RMS fluctuation
```

`mean(R_mat, 1)` averages over frames (dimension 1) for each angle separately, giving the time-averaged contour shape. `dh` is the fluctuation around that mean. `sigma_dh(j)` is then $\sigma_{\delta h}(\theta_j) = \sqrt{\langle \delta h(\theta_j, t)^2 \rangle_t}$ — the RMS amplitude of radial fluctuations at angle $\theta_j$, the fundamental observable that goes into Fig 3 and Fig 5.

**Dimensionless deformation:**

```matlab
R0    = mean(R_mat(:));            % global mean radius [μm]
u_mat = (R_mat - mean(R_mat,1)) / R0;   % [N_fr x N_th], dimensionless
```

`mean(R_mat(:))` is the mean over all frames and all angles — the single scalar $R_0$ used to normalize. `mean(R_mat,1)` in the numerator subtracts the time-averaged shape per angle before dividing, so $u(\theta,t) = [r(\theta,t) - \langle r(\theta)\rangle_t] / R_0$. This means $u$ is zero-mean in time at every angle, which is the correct input for the Fourier decomposition.

**Single FFT pass:**

```matlab
c_n_re = zeros(N_fr, N_q);
U_sq   = zeros(N_fr, N_q);
for fi = 1:N_fr
    Uf = fft(u_mat(fi,:)) / N_th;
    for q = 1:N_q
        c_n_re(fi,q) = real(Uf(q+1));
        U_sq(fi,q)   = abs(Uf(q+1))^2;
    end
end
spectrum = 2 * mean(U_sq, 1);
```

`fft(u_mat(fi,:)) / N_th` gives the properly normalized DFT coefficients. The `q+1` indexing is because MATLAB's `fft` returns DC at index 1, so mode $q=1$ is at index 2, mode $q$ is at index $q+1$. `c_n_re(fi,q)` is the real part of the complex coefficient $\hat{u}_q(t)$ at frame `fi` — this is the time series fed into the ACF. `U_sq(fi,q)` is $|\hat{u}_q(t)|^2$ at that frame. `spectrum = 2 * mean(U_sq, 1)` time-averages and folds the two-sided power: the factor 2 accounts for the fact that for a real signal the power at $-q$ equals the power at $+q$, so the one-sided spectrum has twice the power. The result `spectrum` is a `[1 × N_q]` vector: `spectrum(q)` = $\langle|\hat{u}_q|^2\rangle$ in μm² (normalized by $R_0$ but $R_0$ is in μm here, so units work out).

**ACF:**

```matlab
max_lag_fr = min(400, floor(N_fr/3));
u_re = c_n_re(:,q) - mean(c_n_re(:,q));
[acf, lags] = xcorr(u_re, max_lag_fr, 'normalized');
C_q(:,qi) = acf(lags >= 0);
```

`max_lag_fr` is capped at $N_{fr}/3$ to ensure each lag estimate is based on at least $2N_{fr}/3$ pairs, keeping variance bounded. `mean(c_n_re(:,q))` should be near zero by construction (since `u_mat` is already zero-mean in time) but subtracting it explicitly is a safety against numerical drift. `'normalized'` divides by the zero-lag value so $C_q(0) = 1$. `lags >= 0` selects only the causal half — the ACF is symmetric for a stationary signal, so you only need positive lags. `C_q` is `[(max_lag_fr+1) × length(q_acf)]`.

The `fourier_segs` struct stores all computed quantities for the `si`-th plottable segment. Crucially, `fourier_segs(si)` maps to `segments(segs_to_plot(si))` — the index correspondence is `si` in `fourier_segs` ↔ `segs_to_plot(si)` in `segments`.

**Colorbar limits:**

```matlab
valid_sigma = vertcat(segments(segs_to_plot).sigma_dh);
clim_hi = prctile(valid_sigma(:), 98);
```

`vertcat` stacks all `sigma_dh` vectors (each `[N_th × 1]`) from all plottable segments into one long column, then takes the 98th percentile as the shared upper color limit. Using a percentile rather than the maximum prevents one outlier angle (e.g., at the contour fitting boundary) from collapsing the color scale for all panels.

---

## Section 9 — Figures

**Fig 1** is a 5×1 `tiledlayout` (26×34 cm). Each panel overlays three layers: the smoothed signal in light gray (`[0.75 0.75 0.75]`), the heating event intervals highlighted in Okabe-Ito autocolor at `LineWidth=3`, and threshold/baseline reference lines via `yline`. The `qleg` call places the legend using `quickPlot`'s built-in formatter (LaTeX interpreter, FontSize 18, box off).

**Fig 3** has `n_cols3 = ceil(sqrt(n_plot))` columns and `n_rows3 = ceil(n_plot/n_cols3)` rows, so the layout is approximately square regardless of how many segments you have. Each panel draws an annular `patch` object. The quadrilateral for angular bin $j$ has four corners:

```matlab
j2 = mod(j1, N_th_s) + 1;   % next angle (wraps around)
w  = 5 * sig;                % visual amplification
ri1 = R_mean(j1) - w(j1);   % inner edge, this angle
ro1 = R_mean(j1) + w(j1);   % outer edge, this angle
ri2 = R_mean(j2) - w(j2);   % inner edge, next angle
ro2 = R_mean(j2) + w(j2);   % outer edge, next angle
```

The four columns of `xv` and `yv` are the x/y coordinates of these four corners in Cartesian space. `cv = (sig(j1) + sig(j2))/2` is the face color value, linearly interpolated between adjacent bins for visual smoothness. The shared colorbar is placed after the loop using `cb.Layout.Tile = 'east'`, which docks it to the right edge of the entire `tiledlayout`.

**Fig 5** loops over `segs_to_plot`, retrieves `segments(s).sigma_dh`, centers it: `sig_c = sig - mean(sig)`, estimates the density with `ksdensity` at bandwidth `0.5*std(sig_c)`, renormalizes with `trapz`, and plots. The centering is essential for comparison across segments: absolute values of `sigma_dh` differ because $R_0$ and segment length differ, but the angular heterogeneity (the width and shape of the distribution) is what you are comparing.

**Fig 4a** plots `fourier_segs(k).spectrum(q_range)` for each segment on a log-log scale. Reference slopes are anchored at `q=10` using `S_ref = fourier_segs(1).spectrum(10)` — the first segment's value at mode 10 sets the amplitude for all three reference lines, so they pass through the data rather than floating in an arbitrary position.

**Fig 4b** is a `n_rows4 × n_cols4` grid of ACF panels, one per `fourier_segs` entry. `tau_s = (0:fourier_segs(k).max_lag_fr)' / fps` converts lag indices to seconds. Two horizontal reference lines are added: `yline(0)` (decorrelation) and `yline(exp(-1))` (dashed, the $1/e$ level for reading off $\tau_q$ by eye). The `ylabel` is only printed for panels in the first column via `mod(k-1, n_cols4) == 0` to avoid label clutter.

---

## Section 10 — Save

```matlab
save('analysisWorkspace.mat', ...
    'allContours', 'angles', 'numFrames', 'fps', 'pxSize_um', ...
    'segments', 'num_segs', 'segs_to_plot', 'n_plot', ...
    'heatingCycles', 'num_events', ...
    'mask_baseline', 'mask_heating', 'mask_post_heat', ...
    'baselines', 'num_baselines', ...
    'fourier_segs', 'n_fs', 'q_range', 'q_acf', ...
    'roughness_smooth', 'circularity_smooth', 'drift_smooth', 't_sec');
```

Everything a downstream script needs. `flickeringSpectroscopy.m` needs `allContours`, `angles`, `mask_baseline/heating/post_heat`, `pxSize_um`, `fps`. The `segments` struct with its `.R_mean`, `.sigma_dh`, `.plot_ok` fields is needed if you want to re-plot Fig 3 or Fig 5 without re-running. `q_range` and `q_acf` are saved explicitly so downstream scripts use identical mode ranges without hardcoding them again.
## Quick reference

**Data in:** `allContours` — struct array, one entry per frame. Each has `x_midline`, `y_midline` (Cartesian contour), `r_midline_smooth`, `r_inner_smooth`, `r_outer_smooth` (polar radial profiles). `angles` is the shared angular grid, length `N_th`.

---

**Shape descriptors** — computed per frame, all length `numFrames`:

- `circularity` — isoperimetric ratio $4\pi A/P^2$, exact 1 for a circle, drops on deformation
- `drift_magnitude` — cumulative CM displacement from frame 1, in px
- `roughness` — $\sigma_r/\langle r\rangle_\theta$ per frame in real space, not Fourier
- `radius_midline_mean` — mean radius per frame, tracks osmotic drift over time

All passed through `smoothdata(...,'gaussian', sw)` with `sw=50` frames (1 s) to suppress thermal fluctuation noise before detection.

---

**Detection** — three independent binary channels, data-driven 3σ thresholds from the first 500 frames:

- `active_drift` — drift rate exceeds `thr_drift_rate` (≥ 0.03 px/frame floor)
- `active_rough` — roughness exceeds `thr_roughness`
- `active_circ` — circularity drops below `thr_circularity`

Combined with OR → smoothed → thresholded at 0.5 (morphological closing). Events shorter than 100 frames or without sufficient drift/roughness excursion are discarded. Events separated by < 300 frames are merged.

---

**Segments** — `segments` struct array, fields `label`, `start`, `stop`, `type`, `index`. Three types: `baseline`, `heating`, `post_heat`. Paired by `index`: `heating(k)` ↔ `post_heat(k)`. Three boolean frame masks derived from this: `mask_baseline`, `mask_heating`, `mask_post_heat`.

`heatingCycles(i)` stores per-event response: `drift_total`, `rough_change`, `circ_change`, `rad_change` computed over 50-frame pre/post windows around onset/offset.

`baselines` struct tracks mean roughness/circularity/radius per post-heat segment. `z_rough_vs0` and `z_rough_vsprev` are z-scores relative to Baseline 0 and the previous baseline — detect irreversible changes across multiple heating cycles.

---

**Per-segment computation (single pass)** — one loop over `segs_to_plot`:

- `R_mat` `[N_fr × N_th]` in μm — built once, used for everything
- `sigma_dh` `[N_th × 1]` — $\sqrt{\langle \delta h(\theta,t)^2\rangle_t}$, RMS fluctuation per angle → Fig 3, Fig 5
- `R0 = mean(R_mat(:))` — global mean radius for normalization
- `u_mat = (R_mat - mean(R_mat,1)) / R0` — dimensionless deformation, zero-mean in time per angle
- Single FFT pass fills `c_n_re(fi,q) = real(Uf(q+1))` and `U_sq(fi,q) = |Uf(q+1)|²` simultaneously
- `spectrum(q) = 2 * mean(U_sq(:,q))` — time-averaged two-sided power spectrum → Fig 4a
- `C_q` `[(max_lag+1) × n_q_acf]` — normalized ACF per mode from `xcorr(c_n_re(:,q), ..., 'normalized')` → Fig 4b

All results stored in `fourier_segs(si)` and `segments(s).sigma_dh`. After this block, figures are pure plotting — no `allContours` access.

---

**Figures at a glance:**

| Figure | What it shows                                                            | Key variable                               |
| ------ | ------------------------------------------------------------------------ | ------------------------------------------ |
| Fig 1  | 5-panel timeline: circularity, drift, drift rate, roughness, flags       | `circularity_smooth`, `drift_smooth`, etc. |
| Fig 3  | Annular heatmap of $\sigma_{\delta h}(\theta)$ per segment               | `segments(s).sigma_dh`                     |
| Fig 5  | PDF of $\sigma_{\delta h} - \langle\sigma_{\delta h}\rangle$ per segment | same, centered                             |
| Fig 4a | Log-log power spectrum $\langle\|u_q\|^2\rangle$ vs $q$                  | `fourier_segs(k).spectrum`                 |
| Fig 4b | Mode ACFs $C_q(\tau)$ per segment                                        | `fourier_segs(k).C_q`                      |