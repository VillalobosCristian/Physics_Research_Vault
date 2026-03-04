
Since i change the way to store data from simple .mat variables to structures all the data from the edge detection code is store in `allContours` 
`allContours(iFrame)` has fields:

- `.x_midline`, `.y_midline` — contour points (pixel coordinates)
- `.r_midline_smooth`, `.r_inner_smooth`, `.r_outer_smooth` — radial profiles (already smoothed, presumably from a polar decomposition in the extraction step)

`angles` — the angular sampling used during contour extraction (not actually used in this script beyond being loaded).

## Basic metric 

Circularity: The ratio $C= 4\pi A/P^2$, is $1$ for a perfect circle.  And is computed by closing the contour polygon and using polyarea+perimeter sum. 

Center of mass drift: $\Delta (t)=\sqrt{(x-x_0)^2+(y-y_0)}^2$ with $y=y_{CM}$. cumulative displacement from the first frame. Since CM is computed as the mean of contour points (not area-weighted), this is an approximation, but good enough for qusi spherical vesicles.

**Radii:** Mean of the smoothed inner/mid/outer radial profiles per frame. **Roughness** is the coefficient of variation of the midline radius: $\sigma_r / \langle r \rangle$ — a shape-agnostic measure of contour irregularity.

All time series are Gaussian-smoothed. The drift rate $\dot{\Delta}$ is estimated via `gradient`  on the pre-smoothed drift, then re-smoothed  a double smoothing that trades temporal resolution for noise suppression. Window `sw=50` frames at 50 fps = 1 s.

## Event Detection — Drift Only

Heating events are identified purely from **drift rate** exceeding a threshold:

$$\text{thr} = \max!\left(\tilde{\dot\Delta} + 3,\sigma_{\dot\Delta}^{(0)}, ; 0.03 \text{ px/fr}\right)$$

where $\tilde{\cdot}$ is the median. of $\dot{\Delta}(t)$ is its discrete time derivative $\sigma^{(0)}$ is estimated from the first 100 frames (assumed quiet). The `0.03` floor prevents false positives when baseline noise is very low.

Binary mask → Gaussian-blurred → thresholded at 0.5 → rising/falling edges give `heat_starts/ends`. Short events ($<100$ fr) and low-drift events ($<10$ px total) are rejected. Adjacent events separated by $<300$ fr are merged.
detection uses _drift rate_ (sensitivity to motion onset) rather than drift magnitude or roughness. This means it's detecting _translation_ events, not necessarily membrane fluctuation events — a distinction that matters for interpretation.

Once heating events are identified, the pipeline builds a chronological ordered array `segments` with the pattern:

$$\text{Baseline} \to \text{Heat}_1 \to \text{Post-heat}_1 \to \text{Heat}_2 \to \text{Post-heat}_2 \to \cdots$$

Each entry carries `.label`, `.start`, `.stop`, `.type` (`'baseline'` | `'heating'` | `'post_heat'`), and `.index`. The baseline segment always runs from frame 1 to the frame immediately before the first detected heating event. Post-heat segments fill the inter-event gaps; if two heating events are adjacent with no gap, no post-heat segment is created between them. Three boolean frame-level masks (`mask_baseline`, `mask_heating`, `mask_post_heat`) are derived from this list for downstream per-regime averaging.

This segment scaffold is the central organizing structure of the pipeline — all subsequent per-condition analyses (Fourier spectra, autocorrelations) iterate over `segments` rather than handling heating/baseline cases separately.

**Per-event Summary: `heatingCycles`**

For each detected event $i$, a `heatingCycles(i)` struct records scalar summary statistics. Pre- and post-event windows are defined as the 50 frames immediately before onset and after offset respectively. The quantities stored are: total drift accumulated during the event $\Delta_\text{off} - \Delta_\text{on}$, and the changes in smoothed roughness, circularity, and mean radius between the post- and pre-windows:

$$\delta X_i = \langle X \rangle_\text{post} - \langle X \rangle_\text{pre}, \qquad X \in {\sigma_r/\langle r\rangle,, C,, \langle r \rangle}$$

These are used to characterize whether each heating cycle induces a persistent morphological change in the vesicle.

**Fourier Decomposition**

For each frame, the midline radial profile $r(\phi_j)$ is decomposed into Fourier modes. The fluctuation field is defined as $u(\phi_j) = r(\phi_j) - \langle r \rangle$, and the DFT coefficients are:

$$c_n = \frac{1}{N}\sum_{j=0}^{N-1} u(\phi_j), e^{-2\pi i n j / N}$$

The one-sided power spectrum stored per frame is:

$$\langle |u_n|^2 \rangle_\text{frame} = 2|c_n|^2 \cdot \delta^2 \quad [\mu\text{m}^2]$$

where $\delta = 1/11.5; \mu\text{m/px}$ converts to physical units and the factor of 2 accounts for the two-sided spectrum. Modes $n = 1, \ldots, 30$ are retained. It is important to note that this is the **2D projected** fluctuation spectrum computed from the equatorial contour, not the full 3D spherical harmonic decomposition — the relationship to the Helfrich spectrum requires a projection correction (not applied here), so this is appropriate for relative comparisons across segments but not for direct $\kappa$ extraction.

The real part of each mode coefficient is also stored separately in `u_real_mid` for use in the autocorrelation analysis.

**Per-segment Fourier Spectra — Figure 2**

For each segment, the power spectrum is time-averaged over all constituent frames: $\langle |u_n|^2 \rangle_\text{seg} = \langle \langle |u_n|^2 \rangle_\text{frame} \rangle_t$. Segments with fewer than 5 frames are NaN-flagged. The spectra are plotted on a log-log scale with two power-law reference lines anchored to the baseline spectrum at $n=10$: $\sim n^{-4}$ (Helfrich bending-dominated) and $\sim n^{-2}$ (tension-dominated).

**Mode Relaxation Autocorrelations — Figure 6**

For each segment and each mode of interest $n \in {2,3,4,5,6,8}$, the normalized autocorrelation of the real part of $c_n(t)$ is computed:

$$C_n(\tau) = \frac{\langle u_n^R(t+\tau), u_n^R(t) \rangle}{\langle [u_n^R(t)]^2 \rangle}$$

using `xcorr(...,'normalized')`, with maximum lag $\tau_\text{max} = \min(400, \lfloor N_\text{seg}/3 \rfloor)$ frames. For a membrane in thermal equilibrium (Helfrich), each mode relaxes as $C_n(\tau) \sim e^{-\tau/\tau_n}$ with $\tau_n \propto \eta/(\kappa q_n^3)$, giving mode-number scaling $\tau_n \sim n^{-3}$ in the projected 2D geometry. Deviations from single-exponential decay or anomalous mode-number dependence would signal non-equilibrium driving during heating.
