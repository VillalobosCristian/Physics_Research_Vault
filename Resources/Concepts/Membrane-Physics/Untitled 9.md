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

Confirm those two and I'll move to Part 2, the fast area forcing $A(t)$.