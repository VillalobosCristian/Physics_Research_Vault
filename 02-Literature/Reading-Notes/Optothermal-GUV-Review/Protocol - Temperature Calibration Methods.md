---
title: Protocol - Temperature Calibration Methods for Optothermal GUV Systems
date: 2026-02-16
tags: [protocol, temperature-calibration, experimental-method, optothermal, GUV]
aliases: [Temperature Measurement Protocol, Optothermal Temperature Calibration]
status: active
---

## Overview

Temperature calibration is the **#1 experimental priority** for optothermal GUV manipulation. Accurate temperature measurement is essential for:
- Correlating membrane deformation with thermal input
- Verifying theoretical predictions of area expansion
- Ensuring reproducibility across experimental sessions
- Separating thermal effects from osmotic or mechanical effects

This protocol compiles three complementary methods suitable for your experimental setup: DOPC GUVs on 10 nm Au + 3 nm Cr substrate, heated by blue LED (non-coherent, broad illumination), observed by phase contrast microscopy at 40×.

---

## Method A: Rhodamine B Fluorescent Thermometry (RECOMMENDED)

### Principle

Rhodamine B (RhB) fluorescence intensity decreases with temperature at a rate of **1.6–3.4% per °C**, a relationship well-established in microfluidics and optothermal applications. This temperature-dependent quenching is due to enhanced non-radiative deexcitation pathways at higher temperatures. RhB is:
- Highly photostable
- Compatible with aqueous glucose/sucrose buffers
- Excitable with standard 532 nm or 561 nm lasers
- Provides both spatial and temporal resolution

### Protocol

#### Step 1: Prepare Rhodamine B Solution
- Dissolve Rhodamine B in the **same external buffer solution** as your experiments (e.g., glucose solution, sucrose solution, or Tris-buffered saline)
- Final concentration: **50 μM RhB**
- Prepare fresh aliquots weekly; store in dark at 4°C

#### Step 2: Calibration Curve Construction
- Use a **calibrated Peltier stage** (e.g., Linkam LTS420 or equivalent) with temperature control ±0.1°C
- Mount a coverslip with RhB solution on the Peltier stage
- Record a reference fluorescence image at **T_ref = 25°C**
- Systematically record fluorescence at **T = 20, 22, 24, 26, 28, 30, 35, 40, 45, 50°C** (2°C steps recommended)
- At each temperature:
  - Wait 2–3 minutes for thermal equilibration
  - Acquire 5–10 consecutive images (to assess photobleaching)
  - Use identical laser power, gain, and exposure across all temperatures
  - Measure mean fluorescence intensity over a region of interest (avoid substrate surface if possible)

#### Step 3: Build Calibration Curve
- Plot normalized fluorescence **I(T)/I(T_ref)** vs. temperature **T (°C)**
- Fit data to:
  - **Polynomial:** I/I₀ = a + bT + cT²
  - **Arrhenius (preferred for wider range):** I = I₀ exp(−E_a/kT)
- Report **R²** and fit coefficients
- Expected result: smooth, monotonic decrease; slope ≈ −0.016 to −0.034 per °C

#### Step 4: Measurement in Experimental Setup
- **During experiments:** Replace the external solution with **RhB-glucose solution** (50 μM RhB, same ionic strength as control)
- Acquire fluorescence images:
  - **Baseline** (LED off, ambient temperature)
  - **During heating** (LED on, various power levels)
  - At the same imaging settings used for calibration
- Compute fluorescence intensity at each position and time

#### Step 5: Spatial Mapping of Temperature
- Acquire fluorescence image **with LED on** over the full field of view
- Map intensity at each pixel or region of interest
- Convert pixel-wise intensity to temperature using your calibration curve
- Generate a **2D temperature map** T(x, y) showing spatial gradient around GUV
- Repeat at multiple time points to assess temporal dynamics

#### Step 6: Temporal Resolution
- Frame rate: **≥10 fps** achievable with most cameras
- Temperature fluctuations can be resolved on timescales of **~100 ms**
- For faster dynamics, use **fluorescence lifetime imaging (FLIM)** instead of intensity (see Photobleaching Correction below)

### Photobleaching Correction

Photobleaching is the primary artifact in prolonged RhB imaging. Three approaches:

**Approach 1: Pre-photobleaching**
- Before experiments, expose the full field of view to intense illumination (100 W arc lamp) for 5–10 seconds
- This establishes a "photobleached baseline"
- Subsequent measurements are taken in the pre-saturated state, reducing further photobleaching
- *Reference:* Glawdel et al., Lab Chip 2009

**Approach 2: Ratio Method**
- Always image a **reference region** far from the heating zone (e.g., >100 μm away from LED focus)
- Normalize local intensity to the reference: **I_local(t) / I_ref(t)**
- This ratiometric approach corrects for global photobleaching while preserving spatial temperature variations
- *Recommended for most experiments*

**Approach 3: Fluorescence Lifetime**
- Measure fluorescence lifetime **τ** instead of intensity I
- Lifetime is **insensitive to photobleaching** and dye concentration
- Requires time-correlated single-photon counting (TCSPC) or pulsed laser
- More complex instrumentation but provides absolute temperature without calibration curve
- Temperature sensitivity: ~0.5–1% per °C in lifetime

### Expected Results

For estimated ΔT ≈ **5–8 K** (based on colloidal literature):
- **Fluorescence drop:** 8–27% (easily detectable above noise)
- **Signal-to-noise ratio:** Excellent for ΔT > 2 K
- **Spatial resolution:** ~1–2 μm (limited by diffraction)
- **Temporal resolution:** ~100 ms for ratiometric approach

### Limitations

- **Au surface adsorption:** Rhodamine B adsorbs on uncoated Au surfaces, creating an artifactual signal from the substrate rather than the solution. *Mitigation:* Block Au with bovine serum albumin (BSA) coating, or measure fluorescence at least 5 μm away from the substrate surface
- **pH sensitivity:** RhB fluorescence decreases at pH < 6. Ensure buffer pH ≥ 6.0 (OK for most glucose/sucrose/Tris buffers)
- **Vesicle-interior measurement:** Cannot measure temperature inside GUV without encapsulating RhB during vesicle preparation (more complex)
- **Osmotic effects:** RhB in external solution does not directly report on osmotic pressure or area expansion; it only reports solution temperature

### Key References

- **Ross et al., Anal. Chem. (2001)** — Generalized calibration equations for Rhodamine B fluorescence as a function of temperature and pH; provides data for 20–50°C range
- **Glawdel et al., Lab Chip (2009)** — Detailed photobleaching correction protocol using pre-exposure and reference regions in microfluidic devices
- **Mapping 3D temperature in microfluidic chips, Sci. Rep.** — Spatial temperature mapping using fluorescent tracers

---

## Method B: Brownian Motion Thermometry

### Principle

The diffusion coefficient **D** of suspended particles is related to temperature via the Stokes-Einstein equation:

$$D = \frac{k_B T}{6 \pi \eta r}$$

where **k_B** is Boltzmann's constant, **T** is temperature, **η** is viscosity, and **r** is particle radius. By tracking the Brownian motion of tracer particles (polystyrene beads), you can extract local temperature from the mean square displacement (MSD):

$$\text{MSD}(\tau) = 4 D \tau$$

This method is **independent of fluorescence** and provides an absolute temperature without requiring a calibration curve. However, it is more labor-intensive and requires high-speed video.

### Protocol

#### Step 1: Prepare Tracer Particles
- Add **polystyrene microspheres** (diameter: 200–500 nm) to external solution
- Concentration: **~0.01% w/v** (enough for 5–10 particles per field of view without crowding)
- Ensure particles are negatively charged (standard sulfate-coated beads) to minimize adhesion to substrate

#### Step 2: Record High-Speed Video
- Mount GUV on substrate with LED heating
- Acquire bright-field video at **≥100 fps** (frames per second)
- Exposure time: <1/fps to avoid motion blur
- Duration: 5–10 seconds per condition (to accumulate enough data)
- Record with and without LED heating

#### Step 3: Particle Tracking
- Use standard particle tracking software (e.g., TrackMate in Fiji, Icy, or Python-based tracpy)
- Identify particle centroids in each frame
- Construct **trajectories** linking each particle across frames
- Extract 2D positions (x, y) as a function of time

#### Step 4: Compute Mean Square Displacement
- For each particle trajectory, compute:
$$\text{MSD}(\tau) = \langle [x(t+\tau) - x(t)]^2 + [y(t+\tau) - y(t)]^2 \rangle$$
where the average is over all time windows of duration **τ**
- Compute MSD for lag times **τ** from 10 ms to ~1 second
- Plot MSD vs. τ

#### Step 5: Extract Diffusion Coefficient
- At short times (where motion is purely Brownian), MSD is linear in τ:
$$\text{MSD}(\tau) = 4 D \tau$$
- Fit the linear portion (typically τ = 10–500 ms)
- Extract slope: **slope = 4D**
- Therefore: **D = slope / 4**

#### Step 6: Convert Diffusion to Temperature
- Use the **Stokes-Einstein equation** with known viscosity-temperature relationship for glucose solution
- For glucose solution at standard concentration:
  - **η(T)** follows: $\eta(T) = \eta_0 \exp(B/T)$ or tabulated values
  - Lookup viscosity at reference temperature (e.g., η(25°C) = 1.0 mPa·s for 30% glucose)
- Rearrange to solve for T:
$$T = \frac{k_B T}{6 \pi \eta(T) r} \implies T = \text{numerically solve}$$
- Or, more directly, use:
$$\frac{T_2}{T_1} = \frac{D_2}{D_1} \times \frac{\eta(T_1)}{\eta(T_2)}$$

### Separating Thermophoretic Drift

Particles experience both Brownian diffusion and **thermophoretic drift** (motion toward cooler regions). The thermophoretic velocity is:

$$v_T = -S_T D \nabla T$$

where **S_T** is the thermophoretic coefficient (~0.1 for PS beads on Au). This drift is typically **a few μm/s** for your temperature gradients.

**To avoid contaminating MSD:**
- Subtract the linear drift from each trajectory:
$$x_{\text{corrected}}(t) = x(t) - v_T t$$
- Recompute MSD from drift-subtracted positions
- Verify that Brownian MSD >> drift displacement² at lag times >100 ms

### Spatial Resolution

- Each tracked particle provides T at its location
- Need **5–10 particles per region** to average noise
- Spatial resolution: **~2 μm** (typical particle separation)
- Temporal resolution: **~1 second** (time window for MSD averaging)

### Key References

- **Nalupurackal et al., Soft Matter (2022)** — Temperature measurement of Au substrates using nanoscale particles; demonstrates 4.97%/K sensitivity for NaYF₄:Er³⁺,Yb³⁺ particles
- **Baffou et al., Lab Chip (2016)** — General framework for optical heating and thermometry in microfluidics

---

## Method C: Laurdan Generalized Polarization (Membrane-Specific)

### Principle

**Laurdan** is a fluorescent lipid probe that partitions into biological membranes. Its fluorescence emission is highly sensitive to the **local environment** of the membrane. Two emission bands are typically resolved:

- **~440 nm (blue):** Ordered, low-hydration environment (gel phase or raft-like domains)
- **~490 nm (red):** Disordered, high-hydration environment (liquid phase)

The **Generalized Polarization (GP)** is computed as:

$$\text{GP} = \frac{I_{440} - I_{490}}{I_{440} + I_{490}}$$

GP increases when membrane order increases (i.e., when temperature decreases or when phase transitions occur). GP can be calibrated against temperature for a **specific lipid composition** and used as a thermometer. **Key advantage:** Temperature is measured directly at the membrane, not in bulk solution, allowing you to confirm that thermal stress actually changes membrane fluidity.

### When to Use

- You want to measure **local temperature at the GUV membrane itself** (not bulk solution)
- You want to confirm **membrane fluidity actually changes** during heating
- Your GUVs are made from lipids known to have rich phase behavior (e.g., DOPC near transition)
- You have UV excitation available (350 nm excitation)

### Protocol

#### Step 1: Incorporate Laurdan into GUVs
- Add Laurdan to the lipid stock solution at **1 mol% or less** (higher concentrations lead to quenching and unreliable signals)
- Prepare GUVs normally (electroformation, gentle hydration, etc.)
- Laurdan will automatically partition into the lipid bilayer during GUV formation

#### Step 2: Set Up Dual-Emission Imaging
- Excite GUVs with **UV light (350 nm)** using a mercury lamp or pulsed UV laser
- Detect emission simultaneously at two wavelengths:
  - **Channel 1:** 440 nm (bandpass filter, ~20 nm width)
  - **Channel 2:** 490 nm (bandpass filter, ~20 nm width)
- Use a **dichroic beamsplitter** (e.g., 460 nm) to split the two channels
- Acquire images at the same frame rate as heating (e.g., 1–10 fps)

#### Step 3: Compute GP at Each Pixel
- For each pixel in the GUV membrane region:
$$\text{GP}(x,y,t) = \frac{I_{440}(x,y,t) - I_{490}(x,y,t)}{I_{440}(x,y,t) + I_{490}(x,y,t)}$$
- Generate a **GP map** showing spatial variations in membrane order
- Repeat over time to track changes during LED heating

#### Step 4: Correlate GP to Temperature (Optional)
- To convert GP directly to temperature, perform a separate **calibration experiment**:
  - Prepare DOPC-Laurdan vesicles
  - Mount on a Peltier stage
  - Measure GP at known temperatures (20–50°C)
  - Fit GP vs. T
- Typically, dGP/dT ≈ −0.001 to −0.003 per °C (order of magnitude)
- Once calibrated, you can use GP to estimate absolute temperature at the membrane

### Limitations

- **UV excitation phototoxicity:** Prolonged 350 nm illumination can cause lipid peroxidation and generate reactive oxygen species (ROS). Use **short exposure times** and **argon purging** if performing extended experiments.
- **Photobleaching:** Laurdan photobleaches faster than RhB under UV. May require the pre-photobleaching or ratiometric correction described in Method A.
- **Indirectness:** GP is a proxy for membrane order, not temperature directly. The relationship GP ↔ T depends on lipid composition and may shift if the membrane undergoes a phase transition or if lipid oxidation occurs.
- **Calibration complexity:** Each lipid system requires its own GP-vs-T calibration; cannot reuse calibration from the literature without validation.

---

## Recommended Strategy

For your **optothermal GUV system** (DOPC on 10 nm Au, blue LED heating, phase contrast microscopy at 40×), the recommended approach is:

### Primary Method: Rhodamine B Fluorescent Thermometry (Method A)
- **Why:** Easiest to implement; uses standard 532/561 nm lasers (likely already available on your microscope)
- **Setup time:** ~2 hours (build calibration curve)
- **Spatial resolution:** ~1–2 μm (diffraction-limited)
- **Temporal resolution:** ~100 ms (ratiometric approach)
- **Pros:** Established protocol; good signal-to-noise; compatible with phase contrast
- **Cons:** Requires external fluorescence channel; RhB does not report membrane properties directly

### Validation Method: Brownian Thermometry (Method B)
- **Why:** Independent check using completely different physical principle; also provides flow information from particle drift
- **Setup time:** ~4 hours (write particle tracking code)
- **Spatial resolution:** ~2–5 μm (particle separation)
- **Temporal resolution:** ~1 second (MSD window)
- **Pros:** No calibration curve needed; absolute temperature from physics constants
- **Cons:** Requires high-speed video; more sensitive to optical artifacts and particle interactions

### Complementary Method: Laurdan GP (Method C)
- **When to use:** Only if you want direct evidence that **membrane fluidity changes** during heating, or if you suspect a membrane phase transition
- **Pros:** Direct measurement at membrane; sensitive to lipid-specific effects
- **Cons:** Requires UV excitation; slower temporal resolution; system-specific calibration

---

## Expected ΔT for Your System

Based on literature for similar optothermal Au thin film systems:

- **Fränzl et al. (2022):** 50 nm Au film with focused 532 nm laser → ΔT ≈ 5–8 K
- **Your system:** 10 nm Au + 3 nm Cr, blue LED (non-coherent, broad illumination, lower power) → **estimated ΔT ≈ 3–10 K** depending on LED power and substrate thermal coupling
- **Villalobos-Concha et al. (colloidal work):** Optothermal assembly of colloidal particles → ΔT ≈ 5–8 K observed

### Predicted Area Expansion

Assuming **ΔT = 5 K** and **areal thermal expansion coefficient for DOPC α_A ≈ 2.9 × 10⁻³ K⁻¹:**

$$\Delta A / A = \alpha_A \times \Delta T = 0.0029 \times 5 = 0.015 = 1.5\% \text{ excess area}$$

This is **sufficient for observable shape deformation** (morphological transitions from sphere → prolate ellipsoid or formation of membrane tethers), particularly if combined with local osmotic pressure changes.

---

## Experimental Checklist

Before implementing temperature measurement:

- [ ] **Rhodamine B:** Prepare stock solution (50 μM); confirm pH ≥ 6.0
- [ ] **Calibration stage:** Verify Peltier controller; perform independent temperature check with thermocouple
- [ ] **Optical setup:** Confirm 532/561 nm excitation laser power stable; set reference PMT gain
- [ ] **Microscopy:** Verify phase contrast alignment; check for LED stray light contaminating fluorescence channel
- [ ] **Software:** Prepare image analysis pipeline (intensity extraction, curve fitting, spatial mapping)
- [ ] **Photobleaching test:** Expose RhB solution to LED + fluorescence laser for 10 minutes; confirm <10% intensity loss
- [ ] **Substrate blocking (if using Method A):** Test BSA coating protocol; confirm reduced Au surface autofluorescence

---

## Links

- [[MOC - Optothermal Vesicle Manipulation]]
- [[MOC - Temperature-Dependent Membrane Permeability]]
- [[villalobos-concha_Optothermal assembly via non-coherent light]]
- [[nalupurackal2022_Hydro-thermophoretic trap for microparticles near gold substrate]]
- [[kyrsting2011_Heat Profiling of Gold Nanoparticles using Vesicle Cargo Release]]

---

**Last updated:** 2026-02-16
**Status:** Active / In preparation for experiments
Let me read the full transcript to make sure I have complete context before diving in.Good — I have full context. Let me walk through the code systematically, section by section, combining the implementation logic with the physics reasoning behind each design choice.

---

## Section 1 — Contour shape descriptors

```matlab
A = polyarea(xc, yc);
P = sum(sqrt(dx.^2 + dy.^2));
circularity = 4*pi*A / P^2;
```

**Circularity** is the isoperimetric ratio: it equals 1 for a perfect circle and drops toward 0 for elongated or irregular shapes. For a GUV in thermal equilibrium it fluctuates narrowly around ~0.98–0.99. During heating, if the membrane is strongly forced you see a sustained drop — the vesicle is transiently deformed. This is your most robust shape-change detector because it is a _global_ scalar that is insensitive to rigid-body motion.

**Center of mass** uses the shoelace formula applied to the closed polygon — not just the centroid of pixels, which would be biased by the interior filling. This gives you the true geometric centroid of the enclosed area. The drift is then $\sqrt{(\Delta x_{CM})^2 + (\Delta y_{CM})^2}$ in pixels, accumulated from the first frame.

**Roughness** is $\sigma_r / \langle r \rangle$: the coefficient of variation of the radial profile. This is what Pecreaux et al. call $\sigma_{\delta h}/R_0$ — it measures the RMS amplitude of all Fourier modes simultaneously. It is more sensitive to high-$q$ fluctuations (which dominate the sum) but also more susceptible to imaging noise.

The important design choice here is that these three observables are **complementary in failure mode**: circularity is noise-resistant but slow (integrated signal); roughness is fast but noisy; drift rate catches translation without deformation. You need all three because different events trigger different combinations.

---

## Section 2 — Smoothing strategy

```matlab
sw = 50;
circularity_smooth = smoothdata(circularity, 'gaussian', sw);
drift_smooth = smoothdata(drift_magnitude, 'gaussian', 100);
drift_rate = gradient(drift_smooth);
drift_rate_smooth = smoothdata(drift_rate, 'gaussian', 30);
```

The window `sw=50` at 50 fps = 1 second. This is a deliberate choice: membrane fluctuations happen on timescales of 0.1–2 s (depending on mode), so a 1-second Gaussian smoothing window averages over individual fluctuation cycles and tracks only the _mean_ shape state. It suppresses the thermal noise in circularity/roughness without masking genuine shape changes that evolve over several seconds.

The drift magnitude uses a longer window (100 frames = 2 s) because the cumulative drift is already a slow-moving signal. The `gradient` is taken _after_ smoothing because differentiating a noisy signal amplifies high frequencies — you smooth first, differentiate second, then smooth again. This is a well-known numerical trick to get a stable velocity estimate from position data.

`drift_rate_smooth_s = drift_rate_smooth * fps` converts from px/frame to px/s for display only — all detection logic stays in px/frame units, which is correct.

---

## Section 3 — Threshold estimation from baseline

```matlab
baseline0_win = min(500, numFrames);
mu0_drift_rate = median(drift_rate_smooth(baseline0_idx));
sig0_drift_rate = max(std(drift_rate_smooth(baseline0_idx)), 0.005);
thr_drift_rate = max(mu0_drift_rate + 3*sig0_drift_rate, 0.03);
```

This is a **data-driven 3-sigma threshold** estimated from the first `baseline0_win` frames. Several choices deserve attention:

The `median` for the drift rate mean rather than `mean` — this is because the first few frames may have some transient as the vesicle settles into the field of view, and the median is more robust to those outliers.

The `max(..., 0.005)` floor on `sig0` prevents division-by-zero and also guards against an unrealistically quiet baseline giving a threshold so tight that thermal fluctuations trigger false positives. The physical floors (0.005 for drift rate, 0.0005 for roughness and circularity) encode prior knowledge about the expected noise floor of your microscope.

The second `max(mu0_drift_rate + 3*sig0_drift_rate, 0.03)` for drift rate does the same for the threshold itself: even if your baseline is extremely quiet, you require a minimum drift rate of 0.03 px/frame (= 1.5 px/s) to flag a heating event. This is important because for a perfectly still vesicle the 3-sigma threshold can be absurdly low.

---

## Section 4 — Event detection logic

```matlab
active_combined = active_drift | active_rough | active_circ;
active_combined_smooth = smoothdata(double(active_combined), 'gaussian', 20) > 0.5;
```

The OR combination means any single sensor flagging is enough to mark a frame as active. The subsequent Gaussian smoothing at 20 frames followed by a 0.5 threshold effectively implements a **morphological closing** — it fills gaps between flags that are separated by less than ~20 frames, preventing the same heating event from being split into multiple spurious sub-events.

The quality filter that follows:

```matlab
ok = (durations >= 100) & ((total_drift_cyc >= 10) | (rough_excursion > 2*sig0_roughness));
```

requires that an event lasts at least 2 seconds AND has either >10 px cumulative drift OR a roughness excursion exceeding 2σ. This removes false positives from momentary camera glitches or vesicle-object encounters. The choice of 10 px is system-specific — at 11.5 px/μm this is ~0.87 μm of total displacement, which is above thermal diffusion but well below a thermophoretic drift event.

The **merging step** (gaps < 300 frames = 6 s) handles cases where a single physical heating event produces a brief quiet period mid-event, e.g., when the vesicle drifts out of the heating zone and then back in.

---

## Section 5 — Segment structure

```matlab
segments(end+1) = struct('label','Baseline 0','start',1,'stop',pre_heat_end,'type','baseline','index',0);
```

Every gap between events becomes a labeled segment of type `baseline`, `heating`, or `post_heat`. The `post_heat` segments are the scientifically most interesting because they tell you whether the membrane recovers its pre-heat state. The `z_rough_vs0` etc. in the `baselines` struct are z-scores relative to Baseline 0 — any sustained shift after heating is a potential evidence of irreversible membrane remodeling (e.g., lipid redistribution, partial pore formation, or area change).

The `transient_skip = 50` (1 second) at the start of post-heat segments is important: immediately after the heat pulse the membrane is relaxing from a non-equilibrium state, and including these frames would contaminate both the roughness statistics and the Fourier spectrum with non-stationary data.

---

## Section 6 — Figure 3: the flickering heatmap

```matlab
w = w_scale * sig;   % w_scale = 5
xv = [ri1.*cos(th(j1)), ri2.*cos(th(j2)), ro2.*cos(th(j2)), ro1.*cos(th(j1))]';
```

This is an annular patch visualization. For each angular bin $j$, you draw a quadrilateral whose inner and outer radii are $R_{mean}(\theta) \pm w_{scale} \cdot \sigma_{\delta h}(\theta)$. The color encodes $\sigma_{\delta h}$ directly. The `w_scale = 5` amplification factor is purely for visual contrast — without it, the fluctuation amplitude (~0.05–0.2 μm) would be invisible next to the mean radius (~10–20 μm).

The physical content is $\sigma_{\delta h}(\theta) = \sqrt{\langle \delta h(\theta, t)^2 \rangle_t}$ — the RMS amplitude of radial fluctuations at each angular position, time-averaged over the segment. For an isotropic equilibrium vesicle this map should be angularly uniform (uniform ring width). Angular asymmetry during heating is your non-equilibrium signature, and this is exactly the figure that will resonate with the Šarić group: it is the direct spatial manifestation of the mode-coupling argument I described earlier.

---

## Section 7 — Figure 4: Fourier spectrum and ACF

```matlab
u_mat = (R_mat - mean(R_mat,1)) / R0;
U = fft(u_mat(fi,:)) / N_th;
spectrum(q) = 2 * mean(U_all);
```

The normalization chain: subtract the mean radius per frame (removes breathing mode), divide by $R_0$ (makes $u = \delta r / R_0$ dimensionless), FFT and divide by $N_\theta$ (proper DFT normalization so that Parseval holds), then multiply by 2 (fold two-sided spectrum). The result is $\langle |u_q|^2 \rangle$ in μm² (since $R_0$ is in μm), which connects directly to the Helfrich theory via the Pecreaux projection.

The ACF is computed on the **real part of the Fourier coefficient** $c_q(t) = \text{Re}[\hat{u}_q(t)]$. For an isotropic vesicle $\langle \hat{u}_q \rangle = 0$ and the real and imaginary parts have the same statistics, so this is fine and gives you twice the statistics compared to using the complex coefficient directly.

The `detrend` before `xcorr` is essential: any slow drift in the contour (e.g., focus drift, vesicle slowly drifting out of plane) appears as a low-frequency trend in $c_q(t)$ that, if not removed, creates a large positive bias at long lags and prevents the ACF from decaying to zero. After detrending, the `'normalized'` flag divides by the zero-lag value so $C_q(0) = 1$ by definition.

---

## Section 8 — Figure 5: PDF of $\sigma_{\delta h}$

```matlab
sig_c = sig - mean(sig);
[f, xi] = ksdensity(sig_c, 'Bandwidth', 0.5*std(sig_c));
f = f / trapz(xi, f);
```

Here `sig` is the angular vector $\sigma_{\delta h}(\theta_j)$, length $N_\theta$. Centering it removes the mean — you are plotting the _deviation_ of each angular position from the segment mean, which is the right quantity for comparing across segments because absolute amplitude differences between segments (due to different $R_0$ or fit state) don't conflate with the angular heterogeneity you care about.

The kernel bandwidth $0.5\sigma$ is a half-normal rule-of-thumb (Silverman's rule gives $\approx 1.06 \sigma N^{-1/5}$, which for $N_\theta = 360$ gives ~0.15σ — your 0.5σ gives slightly oversmoothed curves, which is fine for a comparison figure). The `trapz` renormalization after is paranoia — `ksdensity` should already return a properly normalized density, but numerical integration over the returned grid can be slightly off.

The physical interpretation: a narrow, symmetric PDF indicates a homogeneous isotropic membrane (all angles fluctuate equally). A broad or skewed PDF signals angular heterogeneity — the membrane has regions of higher and lower fluctuation amplitude. During heating this is expected to broaden asymmetrically because the heating zone is localized.

---

## Key variable to know for the meeting

When someone asks "how many frames per condition?" — that's `fourier_segs(k).N_fr`. When they ask "what's the time resolution?" — `1/fps = 20` ms. When they ask "what's the slowest mode you can reliably measure?" — you need $N_\text{fr} \gg \tau_{q_\text{min}} \cdot \text{fps}$, i.e., for $q=4$ with $\tau \sim 5$ s you need $\gg 250$ frames, and you have `min_baseline_frames = 200` — so $q=4$ is marginal at best, $q \geq 6$ is reliable. That's an honest limitation worth flagging proactively.