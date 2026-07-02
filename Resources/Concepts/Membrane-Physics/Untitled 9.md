## Part 1 (clean restart): Kinematic definitions

### 1.1 What is measured, per frame

From the equatorial contour $r(\theta,t)$:

$$R_{\rm mean}(t) = \langle r(\theta,t)\rangle_\theta, \qquad \text{roughness}(t) = \frac{\mathrm{std}_\theta[r(\theta,t)]}{R_{\rm mean}(t)}$$

$$A_{\rm proj}(t) = \frac{1}{2}\oint r^2,d\theta, \qquad P(t) = \oint\sqrt{r^2+r'^2},d\theta, \qquad \text{circularity}(t) = \frac{4\pi A_{\rm proj}}{P^2}$$

$$\text{aspect ratio}(t) = \sqrt{\lambda_{\max}/\lambda_{\min}} \text{ (inertia tensor)}, \qquad \phi_{\rm orient}(t) \text{ (elongation axis)}$$

Per-mode, only on stationary windows for the full $\kappa,\sigma$ decomposition, but the raw power itself is valid everywhere: $$P_l(t) = 2|u_l(t)|^2, \qquad S_{2-5}(t) = \sum_{l=2}^5 P_l(t), \qquad \mathrm{Var}[\text{roughness}(t)]\big|_{\rm window}$$

### 1.2 Why roughness, $S_{2-5}$, and $P_l(t)$ survive the driven transient

This is the Parseval argument, worth restating cleanly since it's what licenses using these channels inside the heating pulse itself, exactly where your $\kappa,\sigma$ fit cannot go: $$\mathrm{std}_\theta[r(\theta,t)]^2 = \sum_l P_l(t)$$ This is a geometric identity, true frame by frame, equilibrium or not. What requires stationarity is not the sum, it's decomposing that sum into $(\kappa,\sigma)$ via the closed Boltzmann mode shape, which only holds once the system has stopped being driven. So: roughness$(t)$, $S_{2-5}(t)$, $A_{\rm proj}(t)$, $P(t)$, aspect ratio$(t)$ are all valid **throughout** a pulse, including the ~9 s intra-pulse re-tensing window. Only $\kappa,\sigma$ extraction is restricted to quasi-stationary segments.

### 1.3 The corrected physical picture these observables need to capture

This is the part that changed since the first pass, and it's the reason Part 1 is worth redoing rather than just resuming: within a single ~10 s pulse, the vesicle deforms almost immediately (sub-second, heat-diffusion-limited), then **re-tenses over the remaining ~9 s while the light is still on**, not after light-off. So roughness$(t)$ and $S_{2-5}(t)$ inside one pulse should show a fast rise then a slower fall, and that fall has a real, measurable rate, not a step. That rate is the direct empirical handle on the folding kinetics we'll need for $\phi(t)$ in Part 4.

### 1.4 The visible/hidden area split, restated

Everything in 1.1 lives in **projected, visible geometry**. None of it can see area folded into a sub-resolution invagination neck directly, that's the whole point of why it "disappears." What these channels detect is the **consequence**: $A_{\rm fluc}=A_{\rm tot}(1-\phi)$ shrinking relative to $A_{\rm tot}$, showing up as roughness and $S_{2-5}$ dropping while $A_{\rm tot}$ (thermally, hence $T(t)$) is still elevated. $\phi(t)$ itself remains a latent, inferred variable unless you have direct morphological confirmation of a visible pocket in the raw images.

### 1.5 Complete variable dictionary

|Symbol|Meaning|Directly measured?|Blocked by normalization?|Valid during driven transient?|
|---|---|---|---|---|
|$R_{\rm mean}(t)$|mean radius|Yes|No|Yes|
|roughness$(t)$|$\mathrm{std}_\theta[r]/R_{\rm mean}$|Yes|No|Yes|
|$A_{\rm proj}(t)$, $P(t)$|projected area, perimeter|Yes|No|Yes|
|aspect ratio$(t)$, axis|elongation + orientation|Yes|No|Yes|
|$P_l(t)$, $S_{2-5}(t)$|mode power, low-$l$ band|Yes (rolling window)|No|Yes|
|$\mathrm{Var}[\text{roughness}]$|temporal variance, per segment|Yes|No|Yes|
|$\kappa(t),\sigma(t)$|spectral fit|Only stationary windows|Yes, now resolved (`Fitting_event_corrected.m`)|No|
|$A_{\rm tot}(t)$|true lipid area|No, inferred from $T(t)$|No|(forcing, not measured)|
|$\phi(t)$|sequestered area fraction|No, latent|No|(the ratchet variable)|
|$V(t)$|enclosed volume|No unless z-stack available|No|(latent unless proxy exists)|

This table is the complete, corrected foundation. Two things from before are still open and now matter more given 1.3:

1. **Rolling-window size for $P_l(t)/S_{2-5}(t)$**: with a real ~9 s process to resolve at 50 fps, I'd fix this at 10 to 20 frames (0.2 to 0.4 s) as a starting point, that's fast enough to resolve the intra-pulse rise/fall shape without being dominated by shot noise. Confirm or override.
2. **Volume proxy**: still need to know if $V(t)$ is genuinely latent (z-stack/confocal absent) or if there's any independent handle, this gates how strongly Part 3 can be written.


## 1.1: what each definition actually says, mechanically

**$r(\theta,t)$** is the one raw quantity everything else is built from: the contour radius sampled at 360 fixed lab-frame angles, once per frame. Every other symbol in Part 1 is a functional of this single object.

**$R_{\rm mean}(t)=\langle r(\theta,t)\rangle_\theta$** is the zeroth angular Fourier mode, the DC component. It's the "equivalent circle radius" of whatever shape exists at time $t$. Note this is subtly different from Faizi's $R=(3V/4\pi)^{1/3}$ (an equivalent-sphere radius from volume), the two coincide for a near-circular contour but diverge once the vesicle deforms strongly, worth remembering if we ever compare numbers directly against their formalism.

**roughness$(t)=\mathrm{std}_\theta[r]/R_{\rm mean}$** is the normalized variance of the contour around its own instantaneous mean. Unwrap $r(\theta)$ into a 1D periodic signal in $\theta$, its variance over one period, normalized, is roughness$^2$. Zero for a perfect circle, grows as the contour departs from circular, broadband, mixes every wavelength together into one number. This is exactly the quantity we've been plotting and debugging for the last dozen turns.

**$A_{\rm proj}(t)$, $P(t)$**: these are just calculus, not physics. $\tfrac12\oint r^2d\theta$ sums infinitesimal circular sectors, each of area $\tfrac12r^2d\theta$, to get enclosed area. $\oint\sqrt{r^2+r'^2},d\theta$ comes from Pythagoras on the arc element in polar coordinates, $ds^2=dr^2+r^2d\theta^2\Rightarrow ds=\sqrt{r^2+(dr/d\theta)^2},d\theta$. No thermodynamics anywhere in either formula.

**circularity$(t)=4\pi A/P^2$**: the isoperimetric ratio. The isoperimetric inequality says for fixed perimeter, a circle encloses the maximum possible area, $4\pi A\le P^2$ always, equality exactly for a circle. So circularity $\in(0,1]$ by construction, capped at 1. It's sensitive to _any_ departure from circular, elongation, wiggliness, both mixed together, unlike aspect ratio below which isolates one specific mode.

**aspect ratio$(t)$, $\phi_{\rm orient}(t)$**: built from the area's second-moment (inertia) tensor, a $2\times2$ symmetric matrix. Its two eigenvalues describe how "spread out" the enclosed mass is along two perpendicular axes; $\sqrt{\lambda_{\max}/\lambda_{\min}}$ is elongation, and the corresponding eigenvector's angle is $\phi_{\rm orient}$. This isolates specifically the $l=2$-like elliptical deformation and, critically, its **direction**, which circularity throws away entirely. We confirmed earlier that because the angular grid is lab-frame-fixed (not vesicle-frame-rotating), $\phi_{\rm orient}$ is directly comparable across frames and pulses, which is what makes the leaflet-couple vs. spatial-gradient test possible later.

**$P_l(t)$, $S_{2-5}(t)$**: per-frame power in Fourier/Legendre mode $l$, and the sum restricted to $l=2$–$5$. This is literally what the mode-power section of the script computes, one $|U_l|^2$ per frame, no time-averaging.

**$\mathrm{Var}[\text{roughness}(t)]$**: the temporal variance of the roughness _signal itself_ within a window. This is a stationarity diagnostic, not a shape descriptor, a genuinely settled process should have roughness fluctuating around a fixed mean with small, stable variance once you're averaging over enough frames; a still-evolving process shows elevated variance because the mean itself is drifting under you.

## 1.2: the Parseval argument, in full, since this is the load-bearing claim of the whole document

Write the normalized contour as a Fourier series in $\theta$ at fixed $t$: $$u(\theta,t) \equiv \frac{r(\theta,t)}{R_{\rm mean}(t)} - 1 = \sum_l u_l(t),e^{il\theta}$$

Parseval's theorem for Fourier series states, with no physics content whatsoever, purely a statement about periodic functions: $$\frac{1}{2\pi}\int_0^{2\pi}|u(\theta,t)|^2,d\theta = \sum_l|u_l(t)|^2$$

The left side is exactly $\mathrm{roughness}(t)^2$ by definition (since $u$ has zero angular mean by construction). So: $$\mathrm{roughness}(t)^2 = \sum_l|u_l(t)|^2 \propto \sum_l P_l(t)$$

**This is exactly the identity your script's Parseval check tested**, `roughness_from_modes = sqrt(sum(P_l,1))`, and why it had to match roughness to floating-point precision (which it now does, once the Nyquist double-counting bug was fixed). It's not a physical prediction being verified, it's a mathematical tautology: break a periodic signal into harmonics, its variance is the sum of the harmonics' squared magnitudes. True for any $u(\theta)$, thermally equilibrated or violently driven, doesn't matter.

**Contrast this with equipartition**, which is where the physics, and the stationarity requirement, actually enters: $$\langle|u_l|^2\rangle = \frac{k_BT}{\kappa}\times[\text{function of }l,\bar\sigma]$$

This formula requires two things Parseval doesn't: (1) the mode amplitudes are Boltzmann-distributed, i.e. genuine thermal equilibrium, and (2) $\langle\cdot\rangle$ is a time-average over many frames taken while $\kappa,\sigma$ are _constant_. Neither holds mid-pulse. That's the whole reason roughness$(t)$ and $S_{2-5}(t)$, single-frame or short-rolling-window quantities, survive the driven transient, while $\kappa(t),\sigma(t)$, which require exactly that long stationary average to beat down noise via the equipartition relation, do not. Same underlying data, different question being asked of it.

## 1.3: what changed, grounded in the real trace you already pulled

The original picture (sub-second rise, then slow fall) came from a verbal description before we had real numbers. Your actual data from the 20.72–46.44 s heating segment showed roughness climbing continuously from the segment start, peaking near $t\approx23.7$ s, then falling. So "fast rise then slow fall" survives as the _qualitative_ shape, but the specific "~9 s" figure doesn't, the real rise phase alone was already several seconds, and total pulse duration in that experiment was closer to 35 s than 10 s. I flagged this explicitly rather than quietly keep repeating the old number, worth stating the same way in the presentation: the rise/fall structure is established, the specific timescale is experiment-dependent and still under investigation (we were mid-way through disentangling ordinary $l=2$ hydrodynamic relaxation from a genuine folding process when we paused for script debugging).

## 1.4: the fabric analogy, if it helps for the slides

Think of the membrane as a fixed length of fabric, total area is nearly conserved (the stretching modulus $K_A\sim0.2,\mathrm{N/m}$ is orders of magnitude stiffer than anything else in play, so lipids aren't being created or destroyed, just rearranged). The "visible, fluctuating" fabric is whatever's laid flat enough for the phase-contrast contour to trace it. As folding proceeds, some fabric gets tucked into a fold too fine or too steep to resolve, it hasn't disappeared, $A_{\rm tot}$ is unchanged, but the _visible_ reservoir $A_{\rm fluc}=A_{\rm tot}(1-\phi)$ has shrunk. That's why roughness and $S_{2-5}$ can fall even while $T(t)$, and therefore $A_{\rm tot}(t)$, are still elevated, and why $\phi(t)$ itself never shows up directly in any of these observables, only its footprint on the visible geometry. Important for the document: label $\phi(t)$ explicitly as inferred, not measured, every time it appears, unless you eventually get direct image confirmation of a visible pocket.

## 1.5: table, one line each

$R_{\rm mean}$, roughness, $A_{\rm proj}$, $P$, aspect ratio: all direct functionals of $r(\theta,t)$, computed and plotted, no fitting, hence available everywhere and untouched by the normalization issue, since none of them ever call `S_mod`. $P_l,S_{2-5}$: same, just noisier per-frame so needs the rolling window. $\mathrm{Var}[\text{roughness}]$: same family, a diagnostic rather than a shape descriptor. $\kappa,\sigma$: the one row that needs stationarity and was gated by the normalization bug, now resolved in `Fitting_event_corrected.m`. $A_{\rm tot},\phi,V$: the three latent variables, never measured, only inferred, this is the boundary between "what the data shows" (everything above the line) and "what the model proposes" (everything below it), worth drawing as a literal line in a presentation slide.

## Still open, gating Part 2

Two things from before never got answered once we moved to the script:

1. **Rolling window for $S_{2-5}(t)$**: still sitting at a provisional 15 frames in the script. Confirm or adjust now that you've seen real traces, does 15 look right, too smoothed, or too jagged against the actual rise/fall shape you're seeing?
2. **Volume proxy**: still don't know if $V(t)$ is genuinely latent (no z-stack/confocal) or if there's an independent handle. This determines whether Part 3 can be written as something checkable against data or has to stay purely inferential.

Answer those and we move to Part 2, the fast area forcing $A(t)$, next.I

## Part 2: Area forcing $A(t)$, and why it isn't the whole story

I'm not going to just restate the original algebraic slaving relation, because the real data from a few turns ago exposed something the first pass missed: even if $A_{\rm tot}(t)$ responds instantly to $T(t)$, that does **not** mean the observable shape variables (roughness, $S_{2-5}$) respond instantly too. Those are two different timescales, and conflating them is exactly what made the original "almost instant" picture fail against your actual trace. This section separates them properly.

### 2.1 The forcing itself: two competing hypotheses, both still open

**Case A, default: algebraic, fast.** Heat diffuses to the vesicle in $\tau_{\rm diff}\sim1$–6 ms (established earlier from $R_0^2/D_{\rm th}$), lipid conformational response is sub-ns. Under this hypothesis: $$A_{\rm tot}(t) = A_0\left[1+\gamma_A,\Delta T(t)\right], \qquad \Delta T(t) \approx \Delta T_{\max}\cdot\Theta(t) \text{ (step)}$$

**Case B, competing: slow thermal ramp.** If the gold film itself doesn't equilibrate to its steady-state temperature within milliseconds, e.g. if there's a genuine multi-second thermal mass effect in the substrate, then: $$\Delta T(t) \approx \Delta T_{\max}\left(1-e^{-t/\tau_{\rm ramp}}\right)$$ with $\tau_{\rm ramp}$ an unmeasured parameter, not yet distinguished from Case A by anything in hand.

I'm carrying both forward rather than picking one, because Section 2.2 below gives us a way to test Case A on its own terms before reaching for Case B.

### 2.2 The distinction that actually matters: forcing timescale vs. response timescale

This is the piece that was missing before. Suppose Case A holds, $A_{\rm tot}(t)$ genuinely jumps like a step. The vesicle's shape does **not** jump with it. Each mode amplitude $f_l(t)$ obeys overdamped Langevin dynamics around a moving target set by the instantaneous $\bar\sigma(t)$: $$\frac{df_l}{dt} = -\omega(l)\left[f_l(t) - f_l^{\rm eq}(t)\right] + \text{noise}$$ where $\omega(l)$ is exactly the Faizi/Pécréaux relaxation rate we already validated (Eq. 32, confirmed against their Table S1). If the equilibrium target itself steps at $t=0$ (a step in $A_{\rm tot}\Rightarrow$ step in $\bar\sigma$), the deterministic part of the trajectory is a clean exponential relaxation: $$\langle f_l(t)\rangle - f_l^{\rm eq} = \left[\langle f_l(0)\rangle - f_l^{\rm eq}\right]e^{-\omega(l)t}, \qquad \tau(l) \equiv 1/\omega(l)$$

Since roughness$(t)^2=\sum_lP_l(t)$ (Part 1.2, exact) and the low-$l$ band dominates that sum (your own band-fraction check, baseline mean $0.93$), the aggregate roughness signal should relax at a rate close to the **slowest**, rate-limiting mode, $l=2$: $$\tau_{\rm predicted} \approx \tau(l{=}2) = \frac{1}{\omega(2)} = 0.382,\frac{\eta R_0^3}{\kappa}\qquad(\bar\sigma\approx0,\ \chi_s\approx0)$$

**This means: even under the simplest possible forcing (Case A, instant step), the observable rise can still take several seconds, no folding kinetics, no exotic mechanism, required.** For your ballpark parameters ($R_0\sim15,\mu\mathrm{m}$, $\kappa\sim20,k_BT$), this lands in the 10-second range, the right order of magnitude for what you measured. This is testable directly: $\tau(l{=}2)\propto R_0^3/\kappa$, so if the rise time scales with vesicle size across your other experiments the way this formula predicts, that's strong evidence the rise phase is ordinary hydrodynamics, not a new process, and Case A stands without needing Case B at all.

### 2.3 Why this framework does _not_ explain the fall, and that's informative, not a failure

Here's where it gets interesting rather than just being a clean derivation. If $\bar\sigma$ is genuinely rising during the pulse (which your data says it is, roughness falls, meaning tension is increasing), then $\omega(l)$, which increases with $\bar\sigma$, should make relaxation **faster** as the pulse progresses, not slower. That predicts the fall should be quicker than the rise. Your actual measurement showed the opposite: fall ($17.76$ s) longer than rise ($12.16$ s).

That mismatch is the real physical content of Part 4. It says the simple relaxation picture above, sufficient to explain the rise, is **not** sufficient to explain the fall. Something rate-limits the fall beyond ordinary mode relaxation, which is exactly the territory where a genuine folding/sequestration process ($\phi(t)$, irreversible on the pulse timescale) earns its place in the model rather than being an assumption bolted on for convenience. This gives Part 2 and Part 4 a clean division of labor: **rise phase, candidate explanation is ordinary hydrodynamic relaxation under fast forcing (this section, testable, no new mechanism needed); fall phase, needs a genuinely new kinetic term (next section).**

### 2.4 What Part 2 hands to Part 3/4

$$A_{\rm tot}(t) = A_0\left[1+\gamma_A\Delta T(t)\right] \quad\text{(Case A, pending the }R_0^3\text{ scaling test)}$$ $$\frac{df_l}{dt} = -\omega(l)\left[f_l(t)-f_l^{\rm eq}(\bar\sigma(t))\right] + \text{noise}, \qquad \omega(l) \text{ from Faizi Eq. (32)}$$

This second equation is not just decoration, it's a real building block: Part 4's $\phi(t)$ dynamics will sit on top of this relaxation framework rather than replacing it, since the fall phase is presumably some combination of ordinary relaxation _and_ the new trapping process, not trapping alone.

### Before Part 3

Still need, unchanged from before: rolling-window confirmation for $S_{2-5}(t)$, and whether $V(t)$ has any proxy at all. But more useful right now, since Section 2.2 makes a sharp, falsifiable prediction: **run the kinematic descriptor script on 2–3 more experiments and check whether rise time scales with $R_0^3/\kappa$.** That single check tells us whether Case A's simplest form survives, before Part 3 (volume) commits to building on top of it.



## Physics-only estimate, no fitted data used

### Step 1: direct area injection from thermal expansion

$$\frac{\Delta A}{A} = \gamma_A,\Delta T$$

|$\gamma_A$|$\Delta A/A$|
|---|---|
|$3\times10^{-3},\mathrm{K^{-1}}$|4.50%|
|$3.5\times10^{-3},\mathrm{K^{-1}}$|5.25%|
|$4\times10^{-3},\mathrm{K^{-1}}$|6.00%|

Taking the midpoint, $\Delta A/A\approx5.25%$. In absolute terms:

|$R_0$|$A_0$|$\Delta A$|
|---|---|---|
|10 $\mu$m|1256.6 $\mu\mathrm{m}^2$|66.0 $\mu\mathrm{m}^2$|
|15 $\mu$m|2827.4 $\mu\mathrm{m}^2$|148.4 $\mu\mathrm{m}^2$|
|20 $\mu$m|5026.5 $\mu\mathrm{m}^2$|263.9 $\mu\mathrm{m}^2$|

Nothing here uses your measurements, just $\Delta T=15,\mathrm{K}$ and a literature-order $\gamma_A$.

### Step 2: the first real physics content, where does this area go?

The membrane has exactly two conventional channels for absorbing excess area, both described by the standard area-tension relation [Evans-Rawicz 1990]: $$\frac{\Delta A}{A} = \underbrace{\frac{k_BT}{8\pi\kappa}\ln!\frac{\sigma}{\sigma_0}}_{\text{entropic (undulations)}} + \underbrace{\frac{\sigma}{K_A}}_{\text{direct elastic stretch}}$$

**Test the elastic channel first, it's the cleaner calculation.** If $5.25%$ had to be absorbed entirely by direct stretching, the required tension is $\sigma_{\rm required}=K_A\times(\Delta A/A)$. Using literature $K_A\approx200$–$265,\mathrm{mN/m}$ for PC bilayers:

|$K_A$|$\sigma_{\rm required}$ (4.5%)|$\sigma_{\rm required}$ (5.25%)|$\sigma_{\rm required}$ (6.0%)|
|---|---|---|---|
|200 mN/m|9.0 mN/m|10.5 mN/m|12.0 mN/m|
|230 mN/m|10.4 mN/m|12.1 mN/m|13.8 mN/m|
|265 mN/m|11.9 mN/m|13.9 mN/m|15.9 mN/m|

**This is the striking result.** Typical lysis (rupture) tension for PC bilayers is reported in the literature at roughly a few mN/m up to $\sim10,\mathrm{mN/m}$, corresponding to a critical areal strain around $3$–$5%$. Your $\Delta A/A\approx4.5$–$6%$ from a single heating pulse is already **at or above that critical strain**, before any tension-based accounting even happens. If the membrane could only respond by direct elastic stretching, every single pulse would put it at serious risk of rupture.

### Step 3: confirming the elastic channel is really the relevant one here, not the entropic one

The two terms in the Evans-Rawicz relation cross over (become comparable) at: $$\sigma^* \sim \frac{K_A,k_BT}{8\pi\kappa}$$

|$K_A$|$\kappa=15,k_BT$|$\kappa=20,k_BT$|$\kappa=25,k_BT$|$\kappa=30,k_BT$|
|---|---|---|---|---|
|200 mN/m|0.53 $\mu$N/m|0.40 $\mu$N/m|0.32 $\mu$N/m|0.27 $\mu$N/m|
|265 mN/m|0.70 $\mu$N/m|0.53 $\mu$N/m|0.42 $\mu$N/m|0.35 $\mu$N/m|

The crossover sits around $0.3$–$0.7,\mu\mathrm{N/m}$ ($\sim10^{-3},\mathrm{mN/m}$), while $\sigma_{\rm required}$ from Step 2 is in the $9$–$16,\mathrm{mN/m}$ range, roughly **20,000 to 40,000 times above the crossover**. At that scale the entropic (undulation) term is completely saturated and negligible by comparison, the elastic $K_A$ channel is the only one that matters for accounting purposes, so Step 2's estimate isn't an oversimplification, it's the physically relevant regime.

### The argument this gives you, entirely independent of any measured $\sigma(t)$

1. A $15,\mathrm{K}$ pulse injects $\Delta A/A\approx4.5$–$6%$ of real, new lipid area (molecular thermal expansion, established mechanism, order-of-magnitude literature $\gamma_A$).
2. That much area is comparable to or exceeds the typical lysis strain of a PC bilayer (literature $K_A$, literature lysis strain).
3. Therefore, ordinary Helfrich elasticity (undulations + direct stretch) **cannot plausibly absorb the full injected area without approaching rupture tension**, this follows from $\gamma_A$, $K_A$, and $\Delta T$ alone.
4. Since the vesicles are observed to survive many heating cycles (an experimental fact, not a fitted number), something other than uniform elastic stretching must be handling most of this area. Folding into invaginations, energetically neutral by Bahrami's result, is a mechanism that sidesteps this problem entirely: it stores area without paying the $K_A$ elastic cost or building toward lysis tension.

This is a genuinely useful addition to the document: it motivates the folding mechanism from pure mechanics and a survival observation, with zero dependence on your spectral fits, your normalization fix, or any $\sigma(t)$ trace. It sits cleanly in Section 4/5 (minimal model / literature grounding) as an independent line of support alongside the kinematic evidence.

## What needs verification before this goes in

Every number here is a literature-typical value I'm carrying, not something derived or cited to a specific source in this conversation: $\gamma_A\sim3$–$4\times10^{-3},\mathrm{K^{-1}}$, $K_A\sim200$–$265,\mathrm{mN/m}$, lysis strain $\sim3$–$5%$. All three need real citations (Evans-Rawicz 1990 for $K_A$, Needham/Evans-type work for $\gamma_A$ and lysis strain) before this argument is stated as fact rather than order-of-magnitude reasoning. Worth doing that check before this becomes a document paragraph.

**Natural next step, entirely optional and only when you're ready:** once this physics-only prediction exists, comparing it against your actual measured post-heat $\sigma$ values becomes a real, sharp test, if measured $\sigma$ turns out far below the $9$–$16,\mathrm{mN/m}$ this argument says would be needed for pure elastic accommodation, that's direct confirmation the area really did go somewhere else. But that's data-dependent and for later, this section stands on its own without it.