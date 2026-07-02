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