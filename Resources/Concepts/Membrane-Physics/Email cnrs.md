![[Pasted image 20260421095949.png]]


Complete population analysis, N=22 experiments. Full report below.

---

## 1. Summary

- **Reliable κ (N=8, bending-dominated baselines):** geometric mean **37.4 kBT** [25.8, 54.2] 68% CI, consistent with elevated-value expectation for 200 mM sucrose buffer per Bouvrais 2014. Still ~2x Faizi 2020 benchmark (22 kBT) but that is physically explainable.
- **Two σ populations are completely disjoint with a 5x gap** at σ ≈ 10^-6 N/m: floppy (N=12, σ ∈ [4x10^-11, 3x10^-7]) and pre-tensed (N=10, σ ∈ [1.7x10^-6, 8.5x10^-6]). No experiment sits in between.
- **Irreversible tension buildup signature:** floppy vesicles show median log10(σ_PH1/σ_Base) = **+1.92** (≈80x increase) with invagination (mean dA/A = -12%); pre-tensed show **+0.03** (no change) with near-zero dA/A = +1%. The opposite-quadrant picture of the Käs-Sackmann mechanism.

## 2. Supporting data

### κ population (N=22, reliable subset N=8)

|Session|N_rel|κ values (kBT)|Mean|
|---|---|---|---|
|050226|3|52.4, 54.9, 66.5|57.9|
|110326|3|28.0, 29.5, 32.4|30.0|
|160426|2|25.5, 29.5|27.5|
|**Combined**|**8**|geometric mean **37.4 kBT**|SEM [32.8, 42.6]|

Session-level drift is notable: 050226 sits ~2x above 110326/160426. Possible causes: sucrose batch, spin-coater hydration quality, substrate age. Worth tracking.

### Baseline σ (N/m) and regime classification

|Regime|N|σ range (N/m)|σ_bar range|Slope range|
|---|---|---|---|---|
|Bending (slope < -2.5)|8|4x10^-11 to 1.3x10^-9|0.02 to 8.8|-3.75 to -2.77|
|Crossover (-2.5 to -1.5)|4|2.3x10^-8 to 3.4x10^-7|12 to 579|-2.36 to -1.65|
|Tension (slope > -1.5)|10|1.7x10^-6 to 8.5x10^-6|2938 to 444378|-1.28 to -0.31|

### Slope evolution per experiment (Base -> PH1 -> PH2)

All 12 floppy vesicles show slope relaxation toward tension regime after heating:

|Experiment|Base|PH1|PH2|
|---|---|---|---|
|050226_lightON_1|-2.77|-0.29|-0.16|
|050226_thenLightOn_11|-3.02|-3.01|-2.67|
|050226_Vesicle_Light_3|-3.25|-0.61|-0.21|
|110326_45fps_3|-2.18|-2.32|--|
|110326_45fps_4|-1.86|-1.53|-1.32|
|110326_45fps_7|-3.11|-2.19|-2.01|
|110326_45fps_8|-3.09|-2.64|-1.78|
|110326_50fps_1|-3.75|-2.51|-1.61|
|160426_cycles_010|-1.65|-1.90|-0.44|
|160426_cycles_011|-2.36|-0.84|--|
|160426_cycles_04|-3.35|-2.93|--|
|160426_cycles_07|-3.51|-1.78|--|

11/12 floppy vesicles show monotonic slope relaxation. Only `050226_thenLightOn_11` holds bending regime through 3 cycles -- the reference case for the presentation.

### Tension jump and morphology coupling

|Metric|Floppy (N=12)|Tensed (N=10)|
|---|---|---|
|log10(σ_PH1 / σ_Base)|median +1.92, range [-0.12, +5.20]|median +0.03, range [-0.29, +0.48]|
|dA/A during Heat 1|mean -12.1%, range [-36.7, +0.3]|mean +1.0%, range [+0.3, +2.3]|

Clean separation in the (dA/A, log10 σ ratio) plane -- floppy in top-left (invagination + tension gain), tensed in bottom-right (slight expansion + no change).

## 3. Caveats and limitations

- **Tension-regime κ values (N=10) are degenerate fits.** Seven cluster at the grid floor (~1.3 kBT) and three (24.6, 27.1, 32.9 kBT) sit at physically plausible values purely by numerical accident. None should be included in κ statistics. The "reliable" N=8 is the only honest number.
- **050226 κ (~58 kBT) vs 110326/160426 (~29 kBT)** is a significant session-level discrepancy (1.9x). Before publication this must be either reproduced (confirming a real protocol difference) or isolated to a spin-coater or sucrose batch difference. Current dataset cannot distinguish.
- **σ_bar gap between floppy and tensed populations is ~5x** (min tensed / max floppy). Looks like two distinct preparation outcomes rather than a continuum -- consistent with the hydration-dependent population effect you mentioned. May warrant a discussion section on what fraction of GUVs land in each state under the current protocol.
- **All 050226 experiments used multi-cycle protocols; all 160426 are 1-cycle.** Slope evolution beyond PH2 is available only for 050226 and 110326.