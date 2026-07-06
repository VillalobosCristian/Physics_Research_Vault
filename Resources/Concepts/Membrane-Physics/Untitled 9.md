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





# Building $V(t)$, one logical step at a time

## Step 0: notation, fixed as agreed

$$V(t) \text{ (actual enclosed volume, } \mu\mathrm{m}^3\text{)}, \qquad \hat V(t) \equiv V(t)/V_0 \text{ (dimensionless ratio)}$$

$\hat V(t)$ replaces $u(t)$ from the earlier draft, no collision with $u(\theta,t)$ (the normalized radial fluctuation field). I'm keeping lowercase $\nu$ for reduced volume, distinct from $V$ by case, standard in this literature [Seifert 1997, Svetina-Zeks, Berndl 1990, Käs-Sackmann 1991], not the same kind of problem as $u(t)$ vs. $u(\theta,t)$ since case disambiguates it and every source we're citing uses this exact convention.

## Step 1: why we need $V(t)$ at all, stated precisely

$A(t)$ alone tells us how much membrane material exists. It says nothing about how that material is _geometrically constrained to arrange itself_. That constraint comes from the area-to-volume ratio, standard bilayer-couple/spontaneous-curvature shape control [Seifert 1997]. We need $V(t)$ specifically to compute $\nu(t)$, the actual shape-control parameter, not as an end in itself.

## Step 2: what "the volume" physically is here

The enclosed aqueous phase. Mechanistically independent of $A(t)$: $A(t)$ grows via an intra-membrane molecular process (gauche/trans isomerization, established, $\gamma_A$), a process that involves zero water molecules. Whether $V(t)$ changes at all, and by how much, is a completely separate physical question that has to be argued on its own terms.

## Step 3: the branch point, three candidate mechanisms, not one assumed answer

Three distinct physical processes could change $V(t)$ on the pulse timescale ($\sim24,\mathrm{s}$, this experiment):

(a) **Osmotic permeation** across the membrane, water crossing to equilibrate with the external bath. Established timescale $\tau_{\rm perm}\sim10$–$100,\mathrm{s}$, comparable to the pulse duration itself, this session. Neither clearly fast nor clearly slow relative to $24,\mathrm{s}$, genuinely ambiguous, cannot be confidently invoked as either present or negligible.

(b) **Bulk thermal expansion of the already-enclosed water**, no membrane crossing required at all, just the density of the same trapped mass changing with local temperature.

(c) **Pore-mediated bulk flow**, a transient rupture allowing rapid volume loss, direct precedent exists [Käs & Sackmann 1991, observed pore formation during cooling of budded vesicle chains, established this session] but is not confirmed for this system.

## Step 4: why mechanism (b) is the one we can actually defend right now

(a) is timescale-ambiguous. (c) is precedented elsewhere but unconfirmed here. (b) requires only one assumption: that water sealed inside a $\sim17.6,\mu\mathrm{m}$-radius vesicle behaves thermally like bulk water. Nanoconfinement effects on thermal expansivity are a near-wall phenomenon, significant only within a few molecular layers ($\sim$nm) of a confining surface. A $17.6,\mu\mathrm{m}$ radius is four orders of magnitude larger than that length scale, so the fraction of enclosed water close enough to the membrane to be affected is vanishingly small. This justifies using tabulated _bulk_ water expansivity for the _enclosed_ volume, mechanism (b) is the one requiring the fewest and most defensible assumptions, which is why it's the one to build the Level-0 prediction on.

## Step 5: the actual derivation, same logical form as $A_h(T)$

$$\frac{dV_h}{dT} = \gamma_V V_h \quad\Rightarrow\quad V_h(T) = V_0,e^{\gamma_V\Delta T}$$

identical mathematical structure to $A_h(T)=A_0e^{\gamma_A\Delta T}$ [already established], now applied to a different physical quantity with its own independent expansivity constant $\gamma_V$ (bulk water, standard tabulated range $\sim2$–$3\times10^{-4},\mathrm{K^{-1}}$ near room temperature, **still uncited in this pipeline**, flagged previously, unresolved).

## Step 6: combining into reduced volume, every substitution shown

$$\nu(T) \equiv \frac{V(T)}{\frac{4\pi}{3}\left(\frac{A(T)}{4\pi}\right)^{3/2}}$$

Take the ratio at two temperatures: $$\frac{\nu_h(T)}{\nu_0} = \frac{V_h(T)/V_0}{\left[A_h(T)/A_0\right]^{3/2}}$$

Substitute both exponentials: $$= \frac{e^{\gamma_V\Delta T}}{\left(e^{\gamma_A\Delta T}\right)^{3/2}} = \frac{e^{\gamma_V\Delta T}}{e^{\frac{3}{2}\gamma_A\Delta T}} = \exp\left[\left(\gamma_V-\frac{3}{2}\gamma_A\right)\Delta T\right]$$

Nothing hidden, this is the full chain, already verified numerically ($0.9396$ at $\Delta T=15,\mathrm{K}$).

## Step 7: is there a way to get $V(t)$ _directly from the contour data_, independent of this model prediction?

This is the question the earlier "axisymmetric volume proxy" tried to answer, and it's essential to be precise about why it fails.

A single equatorial phase-contrast contour gives $r(\theta,t)$ in one plane. It contains **zero information about the vesicle's extent along the optical ($z$) axis**. Any volume estimate built from this data alone must _assume_ a shape for that missing dimension, axisymmetric revolution about some axis, sphere, prolate or oblate ellipsoid. The size scale fed into that assumed revolution has to come from somewhere, and the only data available is $A_{\rm proj}(t)$ (or $R_{\rm mean}(t)$) itself, the _same_ in-plane measurement already used elsewhere.

The consequence, verified directly two sessions ago: with aspect ratio $\approx1$ throughout this pulse (established, $1.003$–$1.107$), the resulting "volume" reduces almost exactly to $V_{\rm proxy}\propto A_{\rm proj}(t)^{3/2}$. It is not independent data, it is a $3/2$-power transform of a number we already had. It would show the _identical_ apparent drop whether real water left the vesicle or whether the same water got reshaped into a fold invisible to a 2D equatorial slice, the two physical scenarios are indistinguishable by this method, by construction, not by bad luck.

## Step 8: the conclusion this forces

$\nu_h(T)$ (Step 6) is a **model-derived prediction** under Level-0 assumptions, defensible, but a prediction, not a measurement. There is no independent contour-derived $V(t)$ to check it against, and there cannot be one from this data modality. Every figure and every sentence involving $\nu(t)$ or $V(t)$ in this document needs to say "the model implies" or "under Level-0 assumptions", never "we measure" or "we observe."

## Step 9: what $\hat V(t)$ then represents, and why it's currently unconstrained

$$\frac{\nu(t)}{\nu_0} = \frac{\hat V(t)}{[1+\alpha(t)]^{3/2}}$$

Under pure Level-0 (mechanism (b) only, no pore): $\hat V(t)=e^{\gamma_V\Delta T(t)}$ exactly, this reduces to Step 6. Figure 4's exploration of $\hat V<e^{\gamma_V\Delta T}$ represents the _hypothetical_ addition of mechanism (c) (pore-mediated loss) on top of (b). Given Step 7/8, we have no way to fit or constrain $\hat V(t)$ from this experiment's data, so that figure is explicitly a sensitivity exploration ("if a pore opened, here is how much it would amplify the reduced-volume drop"), not a fit to anything observed. This needs to be stated in those exact terms wherever Figure 4 appears.

## Where this leaves you

Does this chain hold together the way you'd want to defend it in front of a committee or a referee, particularly Step 4 (bulk water assumption) and Step 7 (why the proxy fails)? Tell me which step, if any, you want to push on further before we write the corresponding subsection or touch any code.


# The general method, extracted

What you just watched built is a specific instance of a technique with wide applicability in soft matter modeling: constructing a **residual bookkeeping variable** to isolate "what a partial mechanistic model doesn't yet explain" as its own well-defined, trackable quantity. This is worth learning as a reusable procedure, not just accepting once. Here's the recipe, each step stated abstractly with its instantiation in the $\phi_{\rm proj}$ derivation as the worked example.

## The recipe

**1. Identify the single measured quantity.** Here: $A_{\rm proj}(t)$, the one thing the pipeline actually tracks. Not $A_h$, not $V$, not $\phi$, those are all downstream constructs. Every residual variable starts by naming the one number that comes directly off the instrument.

**2. State the null hypothesis: what would this quantity do if only your most-trusted mechanism operated, alone.**Here: pure thermal expansion, $A_{\rm proj}(t)/A_{{\rm proj},0}\sim1+\alpha(t)$. Then **explicitly falsify it against data**, don't just posit it and move on. The document does this correctly: it names the specific observed behavior (the post-peak collapse) that the null hypothesis cannot produce. If you skip this step, you can't justify why a residual is needed at all.

**3. Add independently-motivated geometric or physical factors one at a time, in order of how well-constrained they are, before reaching for a free parameter.** Here: $G[\hat V]\sim\hat V^{2/3}$, justified by $R\sim V^{1/3}\Rightarrow A\sim R^2\sim V^{2/3}$, a scaling relation, not a fit. This ordering matters: every factor you can derive from geometry or an independent measurement should go in _before_ you define a catch-all residual, otherwise the residual silently absorbs effects that were actually explainable, and your final number overstates how much is genuinely mysterious.

**4. Define the residual as a normalized ratio (or difference) of measured to fully-accounted-for expectation.** $$1-\phi_{\rm proj}(t) \equiv \frac{A_{\rm proj}(t)}{A_{{\rm proj},0}[1+\alpha(t)],G[\hat V(t)]}$$ This equation is **true by construction**, for any $A_{\rm proj}(t)$, any $\alpha(t)$, any $\hat V(t)$, you can always solve for a $\phi_{\rm proj}(t)$ that makes it hold. That's not a weakness, it's the point: a residual variable is a definition, not a prediction. The physics enters entirely through Steps 2 and 3 (what you chose to account for before defining the residual) and Step 5 below.

**5. Immediately state what the residual is degenerate with.** This is the step people skip, and it's the one that separates honest bookkeeping from smuggling in an unconstrained fit. Here: one equation, two unknowns ($\hat V(t)$ and $\phi_{\rm proj}(t)$), one measurement. Write this down explicitly, in the manuscript, not just in your own notes. A reader who doesn't see this degeneracy stated might think $\phi_{\rm proj}$ is more constrained than it is.

**6. Break the degeneracy with the most parsimonious, explicitly-labeled assumption available.** Here: $\hat V(t)=1$, justified by appeal to an independent physical argument (permeation too slow, no pore evidence), not chosen to make the number come out nicely. State the assumption's name (Level-0) so it can be relaxed later without confusion.

**7. Connect immediately to a real number from your own data.** Don't leave the derivation purely symbolic. $\phi_{\rm proj}^{\rm trough}\simeq0.38$ turns an abstract bookkeeping identity into something falsifiable-adjacent, you can now ask "does this number behave sensibly across cycles, does it correlate with roughness or circularity" and start giving it scientific content beyond its tautological definition.

**8. Check for collision with any bookkeeping variable you've already defined elsewhere in the same project.** Here: reconciling the new multiplicative $\phi_{\rm proj}$ against the earlier additive $\phi$ from the $\Delta a_\sigma(t)$ closure. They agree to $O(\alpha\phi)\approx1.7%$, close but not identical, and the document correctly picks one ($\phi_{\rm proj}$, multiplicative) to standardize on going forward rather than silently letting two similarly-named variables coexist.

**9. Check for symbol collision with anything else in the pipeline.** $u(t)\to\hat V(t)$, because $u(\theta,t)$ already means something else. This is a mechanical check, but skipping it is exactly how a reader (or a future you, six months later) misreads an equation.

## Why this is legitimate rather than a trick

The honesty of the whole construction rests entirely on Steps 5 and 6 being stated, not on the algebra in Step 4. Anyone can write a residual that absorbs an unexplained discrepancy, that's trivial. What makes it defensible physics rather than curve-fitting in disguise is: you exhausted independently-motivated factors first (Step 3), you named exactly what else the residual could represent instead of what you're calling it (Step 5), and you labeled your simplifying choice as an assumption with a name, not a fact (Step 6). A referee from your target reviewer pool (Dimova, Kozlov, Weikl, Ou-Yang) will look for exactly these three things.

## Pitfalls, all of which you've already caught in this project, worth recognizing as a pattern

|Pitfall|Where it happened here|
|---|---|
|Reusing a symbol already meaning something else|$u(t)=V/V_0$ vs $u(\theta,t)$, three separate times this session|
|Two similarly-defined variables left unreconciled|additive $\phi$ vs multiplicative $\phi_{\rm proj}$|
|Silently picking a convenient parameter value instead of the best-motivated one|the earlier POPC/DMPC $\gamma_A$ bracket vs the DOPC-specific value, DMPC turned out to be contaminated by $T_m$-proximity, not a neutral bracket bound|
|Not stating a degeneracy explicitly|$\hat V(t)$ vs $\phi_{\rm proj}(t)$, exactly what this document now does correctly|
|Treating a proxy/residual as a measurement in later prose|flagged repeatedly for $\nu_{\rm app}$ (oblate/prolate), same discipline now applied to $\phi_{\rm proj}$|

You've been doing Step 5-and-9-style checking instinctively throughout this whole session, catching the $u(t)$ collision, the additive/multiplicative mismatch, the oblate/prolate labeling, the $90°$ orientation bug. What you're asking to learn now is just naming that instinct as a repeatable checklist, so you can run it deliberately on the _next_variable you define, rather than relying on it surfacing in review.

# The mathematical construction, step by step, with rigor tracked explicitly

Three pieces here are genuinely forced by mathematics (conservation, differential geometry, dimensional scaling). One piece is a modeling choice, not a derivation. I'll mark each explicitly, since conflating the two is exactly the mistake this construction needs to avoid.

## Step 1: $\alpha(t)$, rigorous, from an ODE plus a conservation law

Lipid count $N$ is conserved on the pulse timescale (no flip-flop, established floor $\sim10,\mathrm h$ [Bayerl et al. 1988, cited via Käs & Sackmann 1991], four orders of magnitude longer than $120,\mathrm s$). Area per lipid $a(T)$ obeys the phenomenological but exact ODE $$\frac{da}{dT} = \gamma_A a(T) \qquad\Rightarrow\qquad a(T) = a_0,e^{\gamma_A(T-T_0)}$$ Total membrane area is $A_h(T)=Na(T)$, and since $N$ is constant, the ODE integrates directly to $$A_h(t) = A_0,e^{\gamma_A\Delta T(t)} \equiv A_0[1+\alpha(t)], \qquad \alpha(t)\equiv e^{\gamma_A\Delta T(t)}-1$$ No approximation here beyond $\gamma_A$ itself being constant over the range [established caveat: Pan et al. 2008 measure $\gamma_A$ at a single temperature, $30^\circ\mathrm C$]. This is real derivation, not ansatz.

## Step 2: the $V^{2/3}$ exponent, rigorous, from isotropic dilation

Consider a family of shapes related by pure isotropic rescaling: $\mathbf x\to\lambda\mathbf x$ for every point on some fixed reference shape. Volume is a 3-form, area a 2-form; under this dilation the Jacobian gives, exactly, $$V(\lambda) = \lambda^3 V(1), \qquad A(\lambda) = \lambda^2 A(1)$$ Eliminating $\lambda$: $$A(\lambda) = \left(\frac{V(\lambda)}{V(1)}\right)^{2/3} A(1)$$ This holds for the true 3D surface. It also holds for a 2D projection under the _same_ dilation, because orthogonal projection $\Pi$ commutes with scaling: $\Pi(\lambda\mathbf x)=\lambda,\Pi(\mathbf x)$, a one-line linearity fact. So the projected area of a dilating self-similar shape scales identically: $$A_{\rm proj}(t) = A_{{\rm proj},0},\hat V(t)^{2/3}, \qquad \hat V(t)\equiv V(t)/V_0$$ Also rigorous, no approximation, **provided the shape stays exactly self-similar** (same proportions, only overall size changing). That proviso is where the trouble starts.

## Step 3: the naive null hypothesis is geometrically over-constrained, not just empirically wrong

This is the piece worth understanding carefully, since it's the actual mathematical reason a residual becomes _necessary_, not merely convenient.

Within a single self-similar family, $\lambda$ is one parameter. $V$ and $A$ are both single-valued functions of that one parameter. You cannot vary them independently: fixing $\hat V(t)=1$ (no volume change) forces $\lambda=1$, which forces $A(\lambda)=A(1)$, area fixed too. **"Area grows while volume stays fixed and shape stays self-similar" is not merely unobserved, it is a mathematical contradiction, not three independent conditions but only two, since fixing any two of ${\lambda, V, A}$ within one self-similar family fixes the third.**

So the naive Step-1 hypothesis you were shown many turns ago, $A_{\rm proj}(t)\sim A_{{\rm proj},0}[1+\alpha(t)]$ at implicitly fixed volume, was never geometrically consistent to begin with. Something in ${$shape, volume$}$ _must_move once $\alpha(t)>0$ is asserted at fixed $\hat V$. Substituting $A_h(t)=A_0[1+\alpha(t)]$ into the reduced-volume definition [Seifert 1997; already used throughout this session] at fixed $\hat V=1$: $$\nu(t) = \frac{V_0}{\frac{4\pi}{3}\left(\frac{A_0[1+\alpha(t)]}{4\pi}\right)^{3/2}} = \frac{\nu_0}{[1+\alpha(t)]^{3/2}} < \nu_0$$ $\nu$ is _forced_ downward. This is exactly the Level-0 "Consequence for reduced volume" result derived earlier this session, now shown to be not an added assumption but a direct consequence of asserting $\alpha(t)>0$ at $\hat V=1$. The vesicle is mathematically required to either change reduced volume within a smooth axisymmetric family (captured by $\nu_{\rm app}^{\rm oblate/prolate}$, built earlier this session), or abandon self-similarity entirely (genuine folding, invagination, non-axisymmetric distortion). This is the rigorous justification for why a residual term is _needed_, independent of what you name it.

## Step 4: the multiplicative ansatz, a modeling choice, not a further derivation

Here honesty matters. There is no single geometric argument that jointly produces $[1+\alpha(t)]\hat V(t)^{2/3}$ as one derived quantity. Step 1 governs $A_h$ (material, molecular). Step 2 governs how a _self-similar_ shape's projection tracks $V$. These describe different objects. The choice to write $$A_{\rm proj}(t) = A_{{\rm proj},0},[1+\alpha(t)],\hat V(t)^{2/3},[1-\phi_{\rm proj}(t)]$$ as a product of three independent, dimensionless factors is an **ansatz**: motivated by wanting each factor bounded and separately interpretable, and by the two rigorous pieces (Steps 1, 2) each contributing one factor in isolation, but the superposition itself is a modeling decision, not something forced by a single derivation the way Steps 1-3 were. State this plainly in the manuscript rather than implying the whole equation is derived end to end, a careful reader from the target reviewer pool will look for exactly this distinction.

## Step 5: $\phi_{\rm proj}(t)$, defined by algebraic inversion, not asserted

Given the ansatz in Step 4, solve for the one factor not otherwise constrained: $$1-\phi_{\rm proj}(t) = \frac{A_{\rm proj}(t)}{A_{{\rm proj},0}[1+\alpha(t)]\hat V(t)^{2/3}} \qquad\Rightarrow\qquad \phi_{\rm proj}(t) = 1-\frac{A_{\rm proj}(t)}{A_{{\rm proj},0}[1+\alpha(t)]\hat V(t)^{2/3}}$$ This is genuine algebra: three of four quantities in the ansatz are known or assumed ($A_{\rm proj}(t)$ measured, $\alpha(t)$ from Step 1, $\hat V(t)$ to be fixed next), the fourth is solved for. This step introduces no new physics, it only _names_ whatever value makes the ansatz equation balance.

## Step 6: the degeneracy is a literal count of equations versus unknowns

One equation (Step 4's ansatz), two unknowns ($\hat V(t)$, $\phi_{\rm proj}(t)$) for one data point $A_{\rm proj}(t)$. Underdetermined by inspection, not by a subtle argument, this is just counting. Closing the system requires one more equation or one assumed value. The Level-0 choice, $\hat V(t)=1$, is the minimal assumption consistent with the established permeation-timescale argument (established this session: $\tau_{\rm perm}\sim10$–$100,\mathrm s$, ambiguous relative to the $24.4,\mathrm s$ pulse, but no pore evidence exists for this specific dataset). With that closure: $$\phi_{\rm proj}(t) = 1 - \frac{A_{\rm proj}(t)/A_{{\rm proj},0}}{1+\alpha(t)}$$ which is the formula already evaluated to $\phi_{\rm proj}^{\rm trough}=0.3786$ two turns ago.

## The complete picture, stated plainly

$$\underbrace{\alpha(t)}_{\text{Step 1: rigorous}} \quad\text{and}\quad \underbrace{\hat V(t)^{2/3}\text{ scaling law}}_{\text{Step 2: rigorous}} \quad\xrightarrow{\text{Step 3: forces a residual to exist}}\quad \underbrace{\text{product ansatz}}_{\text{Step 4: chosen, not derived}} \quad\xrightarrow{\text{Step 5: algebra}}\quad \phi_{\rm proj}(t)$$

	The number $0.38$ is trustworthy as "the residual required under the stated assumptions", exactly as forceful as Step 4's ansatz and Step 6's closure, no more, no less. It is not trustworthy as "38% of the membrane is definitely hidden in folds", that claim would require independently constraining $\hat V(t)$, which this pipeline cannot do.




