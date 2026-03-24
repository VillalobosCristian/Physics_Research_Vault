---
title: "Weekly Research Prompt — Optothermal GUV Project"
date: 2026-02-16
status: "active"
tags:
  - "#weekly-prompt"
  - "#optothermal"
  - "#GUV"
  - "#research-summary"
---

# Weekly Research Prompt — 16 February 2026

## What was accomplished this week

### Literature review (16 papers, 4 topic syntheses)

Forty research articles from the vault were screened and the 16 most relevant were converted into structured Obsidian notes following the Paper_Notes template. Four Maps of Content were created covering membrane permeability, optothermal manipulation, vesicle shape deformations, and fluctuation analysis methods. A quantitative comparison table and a publication strategy document were also produced.

Key take-aways from the literature survey:

- The 2.7 s permeability-spike timescale we observe matches Leirer et al.'s 4–5 s relaxation timescale for thermodynamic expulsion at a lipid phase transition, even though our system (fluid-phase DOPC, no phase transition) operates through a completely different mechanism. This hints at a universal membrane water-transport timescale set by bilayer kinetics rather than the perturbation type.
- Our 10 s recovery time is far faster than the passive osmotic equilibration predicted by Wennerström (minutes). This suggests an active or enhanced re-sealing process.
- No one has reported GUV shape deformations driven by non-coherent optothermal heating. The closest works are Hill 2018 (opto-thermophoretic trapping of small vesicles with focused lasers) and Talbot 2019 (tubule growth in thermal gradients). Our combination of blue LED + Au/Cr thin film + full shape analysis on GUVs is genuinely novel.
- The reduced volume reaching v ≈ 0.69 reversibly is deeper than most reported reversible deformations. Käs & Sackmann 1991 report comparable deflation but in a different (temperature-sweep) context.
- The 5× onset/offset asymmetry has no clear precedent in equilibrium shape-transition studies.

### MATLAB analysis pipeline (vesicle_analysis_v2.m)

The original code was reviewed, 10 physics and numerics corrections were identified, and a complete rewrite was produced. Runtime errors from the first test run were then diagnosed and fixed. The current state of the pipeline:

**Working correctly:**

- Area centroid (shoelace-weighted) instead of geometric mean of contour vertices.
- Fourier mode indexing n = 2..N (excluding n = 0 volume and n = 1 translation).
- Reduced volume with left-right asymmetry flagging for frames where axisymmetric assumption breaks down.
- Adaptive heating detection via Gaussian mixture model on drift rates.
- Unified smoothing windows based on the 2.7 s permeability-spike timescale.
- Integration time correction (Pécréaux 2004) now capped at 10× to prevent noise amplification; highest reliable mode is computed and reported.
- White noise floor estimated from raw (uncorrected) high modes, subtracted before applying integration correction.
- Helfrich spectrum fitting reparameterised in kBT units (kappa_hat ≈ 20, sigma_bar ≈ 10), so both parameters are O(1)–O(100) and the optimizer converges cleanly.
- Log-space fitting with multiple initial-guess restarts.
- Optical projection correction ×1.4 applied to kappa (Rautu 2017).
- Non-Gaussian kurtosis check per mode and per regime (Sciortino 2025).
- Shape-change detection threshold raised to 3σ, with a heating-proximity filter that discards spurious events occurring well before any heating onset.
- Plotting with n_plot, h_fit1, h_fit3 properly scoped outside conditionals.

**Not yet tested on data** (needs a fresh run):

- The fit_helfrich_regime helper function was the missing piece that caused the last runtime error. It is now defined. The script should run end-to-end.

### First data set observations

Running the pipeline on the first data file revealed:

- v₀ = 1.0009 — essentially a perfect sphere. Volume loss was only 0.1%. This is much less than the 5–30% loss seen in other vesicles. This particular vesicle may not be the best candidate for showcasing the deformation phenomenon.
- Two heating cycles were detected: t = 45–65 s and t = 87–140 s.
- Shape-change events were originally flagged at t = 20–35 s (before heating). After raising the threshold to 3σ and adding the heating-proximity filter, these should be eliminated.
- Regime 1 (no heating) fit failed with the old parameterisation (complex Jacobian from log of zero bounds). The reparameterised version should now succeed.
- Regime 3 fit hit upper bounds (kappa = 100 kBT, sigma_bar = 1000) with the old code, which is clearly unphysical. With the new parameterisation and restricted mode range, this should produce realistic values.

---

## Open questions and ideas for further analysis

### Immediate (this coming week)

1. **Re-run vesicle_analysis_v2.m** on the first data set and confirm all errors are resolved. Record the fitted kappa and sigma values for regimes 1 and 3, and compare with DOPC literature values (20–27 kBT).

2. **Run on multiple vesicles.** The first data set showed v ≈ 1 with negligible deformation. Process at least 3–5 additional vesicles that exhibit the dramatic deflation (v dropping to 0.69) to verify the pipeline handles large deformations correctly and to begin building statistics.

3. **Phase-diagram trajectory.** For vesicles that deform significantly, plot (v(t), Δa(t)) on the theoretical Seifert-Lipowsky shape diagram. This connects the dynamic observations to the classic equilibrium predictions and could be a strong figure for the paper.

4. **Time-resolved kappa(t) and sigma(t).** Instead of computing a single spectrum per regime, use a sliding window (e.g. 100-frame blocks) to extract kappa and sigma as functions of time. This would reveal whether the membrane softens during heating (as Wennerström 2025 predicts via bending-stretching coupling) and whether tension changes precede or follow the shape deformation.

5. **Power dependence.** If multiple data sets exist at different LED intensities, compare deformation amplitude vs. heating power. This is a critical experiment identified in the gap analysis — even a qualitative trend (more power → deeper deflation) strengthens the paper.

### Medium-term analysis improvements

6. **Confocal validation of reduced volume.** The 2D projection assumes axisymmetry. For a few representative vesicles, acquire a confocal z-stack during the deformation and compute the true 3D volume. This calibrates how much the 2D projection overestimates or underestimates v.

7. **Spectral crossover mode.** The Helfrich spectrum transitions from tension-dominated (n⁻²) at low modes to bending-dominated (n⁻⁴) at high modes. The crossover mode n* = sqrt(sigma_bar) shifts during heating. Tracking n* vs. time or temperature would be a clean way to quantify tension changes.

8. **Non-Gaussian statistics during deformation.** The kurtosis check is implemented but needs interpretation. If regime 2 (shape change) shows excess kurtosis while regimes 1 and 3 are Gaussian, that supports an active or non-equilibrium mechanism (cf. Sciortino 2025). If all regimes are Gaussian, the deformation is consistent with purely equilibrium thermal fluctuations on a changing energy landscape.

9. **Permeability coefficient extraction.** From the time derivative of the reduced volume dv/dt and the osmotic pressure difference, back-calculate the effective membrane permeability P_f during each phase. Compare with the POPC baseline of ~16 μm/s (Wennerström 2022). If P_f spikes by an order of magnitude during the first 2–3 s of heating, that directly supports the transient-permeability hypothesis.

10. **Fourier mode dynamics.** Instead of looking only at the time-averaged spectrum per regime, examine the autocorrelation time of individual modes. Modes that slow down during heating (longer autocorrelation) indicate membrane softening. Modes that speed up indicate increased tension. This is a richer observable than the static spectrum.

### Experimental priorities (from the gap analysis)

11. **Temperature calibration** is the single most critical missing experiment. Without a direct measurement of ΔT at the GUV location, the mechanism remains speculative. Options: fluorescent thermometry with Rhodamine B, or Brownian motion analysis of nearby tracer particles (Nalupurackal 2022).

12. **Statistics.** The publication strategy document recommends N ≥ 10–15 vesicles with complete heating-cycle data. Prioritise acquiring more vesicles under identical conditions.

13. **Fluorescent permeability assay.** Encapsulate a small dye (calcein, carboxyfluorescein) and measure fluorescence loss during heating. This would directly prove transient permeabilisation.

14. **Lipid composition controls.** Test POPC (similar fluid phase, different permeability), a gel-phase lipid like DPPC at T < T_m, and a cholesterol-containing mixture. If the shape deformation disappears in gel-phase or cholesterol-rich membranes, that points to a fluid-phase-specific mechanism.

---

## Publication framing (current thinking)

Three framing options were identified in the strategy document. The strongest appears to be either:

**Option B — "Transient permeability spike in fluid-phase vesicles under rapid heating"** — positions the work as a fundamental membrane biophysics discovery. Requires the strongest mechanistic evidence (temperature calibration + permeability assay). Targets Biophysical Journal or Physical Review Letters.

**Option C — "Dynamic shape transitions driven by optothermal heating"** — positions the work as real-time observation of theoretically predicted shape pathways. Requires the phase-diagram trajectory analysis. Targets Soft Matter or Physical Review E.

A pragmatic approach: write the paper with Option C framing (shape dynamics on Au substrates), targeting Soft Matter. If the temperature calibration and permeability assay come through, upgrade the framing to Option B and target a higher-impact journal.

Estimated timeline: additional experiments (2–3 months), analysis completion (1–2 months), writing (1–2 months), submission target 4–7 months from now.

---

## Files produced this week

**Literature notes** (in 02-Literature/Reading-Notes/Optothermal-GUV-Review/):

- INDEX — master hub linking all notes
- 4 Maps of Content (permeability, optothermal manipulation, shape deformations, analysis methods)
- 16 individual paper notes
- Quantitative comparison table
- Publication strategy and gap analysis

**Code** (in 04-Data/Codes/):

- vesicle_analysis_v2.m — complete corrected MATLAB pipeline (10 physics corrections, runtime errors fixed)

---

*Next review: 23 February 2026*
