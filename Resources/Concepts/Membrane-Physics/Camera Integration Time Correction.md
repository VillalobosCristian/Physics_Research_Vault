

---

### 1. Why the Camera Biases $\kappa$

The contour extraction gives you $r(\theta, t_n)$ at discrete frame times $t_n = n T_\text{frame}$. What the camera actually records during frame $n$ is not the instantaneous contour but the time-averaged one over the exposure window:

$$\tilde{u}_q(t_n) = \frac{1}{T_\text{exp}} \int_{t_n}^{t_n + T_\text{exp}} u_q(t), dt$$

The measured power spectrum is therefore:

$$\langle|\tilde{u}_q|^2\rangle = \langle|u_q|^2\rangle_\text{theory} \cdot \chi^2(\tau_q, T_\text{exp})$$

where $\chi$ is the **sinc-like integration correction** (Pécréaux 2004, Eq. 6):

$$\boxed{\chi(\tau_q, T_\text{exp}) = \frac{1 - e^{-T_\text{exp}/\tau_q}}{T_\text{exp}/\tau_q}}$$

Limits:

- $T_\text{exp} \ll \tau_q$: $\chi \to 1$ (instantaneous camera, no bias)
- $T_\text{exp} \gg \tau_q$: $\chi \to 0$ (complete temporal averaging, signal destroyed)

Since $0 < \chi \leq 1$, the measured spectrum is **always below** the equilibrium theory. Fitting without correction forces the model down to meet the data by increasing $\kappa$ (since $S^\text{theory} \propto 1/\kappa$). So uncorrected fits systematically **overestimate** $\kappa$.

---

### 2. The Relaxation Time $\tau_q$

Each spherical harmonic mode $\ell$ has an independent exponential ACF. From Milner-Safran hydrodynamics (fluid sphere in viscous environment):

$$\tau_\ell = \frac{\eta_\text{eff}, R_0^3}{\kappa, \lambda_\ell} \cdot \frac{4\ell^2 + 6\ell + 3}{\ell(\ell+1)}, \qquad \lambda_\ell = (\ell-1)(\ell+2)\bigl[\ell(\ell+1) + \bar\sigma\bigr]$$

The projected mode $q$ is a sum over all $\ell \geq q$ (same parity). Strictly, each $\ell$ term should carry its own $\chi(\tau_\ell, T_\text{exp})$. However, the projection sum is strongly dominated by $\ell = q$ (the lowest allowed term), so Pécréaux makes the approximation:

$$S_q^\text{meas} \approx \chi^2(\tau_q, T_\text{exp}) \cdot S_q^\text{theory}(\kappa, \sigma), \qquad \tau_q \equiv \tau_{\ell = q}$$

This is excellent for $q \geq 6$ and becomes exact as $q \to \infty$.

---

### 3. Self-Consistency

The correction depends on $\tau_q$, which depends on $(\kappa, \sigma, \eta_\text{eff})$ — the very parameters being fitted. The loop is:

$$\kappa \to \tau_q(\kappa, \sigma, \eta_\text{eff}) \to \chi_q \to S_q^\text{corr}(\kappa) \to \text{fit} \to \kappa_\text{new}$$

Strategy for the simple (no-heating) case where you have good ACF statistics:

1. Fit ACF to get $\tau_q^\text{meas}$ for a few modes $\to$ estimate $\eta_\text{eff}^{(0)}$ via $\tau_q = \eta_\text{eff} R_0^3 / (\kappa^{(0)} \lambda_q) \cdot f(q)$
2. Run grid search with $\chi_q^2$ computed at each $(\kappa, \sigma)$ point (using current $\eta_\text{eff}$) $\to$ $\kappa^{(1)}, \sigma^{(1)}$
3. Update $\eta_\text{eff}^{(1)}$ from ACF fit using $\kappa^{(1)}$
4. Repeat until $|\kappa^{(n+1)} - \kappa^{(n)}|/\kappa^{(n)} < 10^{-3}$

Convergence is fast (3–5 steps typically) because $\chi$ is weakly sensitive to $\eta_\text{eff}$ once you're in the right ballpark.

---

### 4. Effect Magnitude at Your Frame Rates

For DOPC with $\kappa \approx 35,k_BT$, $R_0 = 10,\mu$m, $\eta_\text{eff} \approx 1.7$ mPa·s, the relaxation times run $\tau_6 \approx 0.6$ s down to $\tau_{20} \approx 0.01$ s.

|$q$|$\tau_q$ (s)|$\chi^2$ at 50 fps ($T_\text{exp}=20$ ms)|$\chi^2$ at 10 fps ($T_\text{exp}=100$ ms)|
|---|---|---|---|
|6|~0.6|0.983|0.919|
|10|~0.08|0.878|0.541|
|15|~0.025|0.699|0.237|
|20|~0.010|0.507|0.104|

At 50 fps: low-$q$ modes barely affected, high-$q$ modes suppressed by ~50%. The net effect on the spectral slope is a flattening at high $q$, which the fit interprets as larger $\kappa$. At 10 fps this becomes catastrophic above $q \sim 12$.

---

### 5. Implementation — Surgical Addition to the Standalone Script

The changes are confined to three places: (i) a `eta_eff` parameter block, (ii) a $\tau_q$ + $\chi_q^2$ computation inside both grid loops, (iii) an outer iteration wrapper. No structural changes to the grid search logic.

Here is the complete diff relative to the script in Document 2:

**Block A — add after the physical constants block (after `qMax=20;` etc.):**

```matlab
%% Camera correction parameters
T_exp     = 1/fps;          % exposure time = frame period (full-frame camera)
eta_eff   = 1.7e-3;         % initial guess: Pa·s (use water=1e-3 if no ACF data)
max_iter  = 15;             % self-consistent iteration cap
tol_kappa = 1e-3;           % relative convergence threshold on kappa
```

**Block B — replace the outer grid search section with the iteration wrapper:**

```matlab
%% Self-consistent grid search with camera correction
kappa_prev = 0;   % sentinel for convergence check

for iter = 1:max_iter

    fprintf('\n=== Iteration %d  (eta_eff = %.3f mPa·s) ===\n', ...
            iter, eta_eff*1e3);

    %% ── Coarse grid ──────────────────────────────────────────────────────
    lkap_c = linspace(0.5, 2.5, 25);
    lsig_c = linspace(-10, -4, 25);
    best_cost_c = inf;  best_lk_c = 1.2;  best_ls_c = -7;

    for ci = 1:length(lkap_c)
        for cj = 1:length(lsig_c)
            kap  = 10^lkap_c(ci) * kBT;
            sig  = 10^lsig_c(cj);
            sbar = sig * R0^2 / kap;

            S_mod = zeros(length(nFit), 1);
            ok    = true;

            for ii = 1:length(nFit)
                q     = nFit(ii);
                lam_q = (q-1)*(q+2)*(q*(q+1) + sbar);
                if lam_q <= 0, ok = false; break; end

                % Relaxation time for dominant mode ell=q
                f_q   = (4*q^2 + 6*q + 3) / (q*(q+1));
                tau_q = (eta_eff * R0^3) / (kap * lam_q) * f_q;

                % Camera correction factor
                x_q   = T_exp / tau_q;
                chi2  = ((1 - exp(-x_q)) / x_q)^2;

                s_sum = 0;
                cArr  = legCoeff{q};
                for l = q:lmax
                    if mod(l+q,2)~=0, continue; end
                    lam = (l-1)*(l+2)*(l*(l+1) + sbar);
                    if lam <= 0, ok = false; break; end
                    s_sum = s_sum + cArr(l)/lam;
                end
                if ~ok, break; end

                S_mod(ii) = chi2 * (kBT/kap) * s_sum / 2;
            end

            if ~ok || any(S_mod <= 0), continue; end
            cost_val = sum((log10(dataFit) - log10(S_mod)).^2);
            if cost_val < best_cost_c
                best_cost_c = cost_val;
                best_lk_c   = lkap_c(ci);
                best_ls_c   = lsig_c(cj);
            end
        end
    end

    %% ── Fine grid ────────────────────────────────────────────────────────
    hw     = 0.4;
    lkap_f = linspace(best_lk_c - hw, best_lk_c + hw, 40);
    lsig_f = linspace(best_ls_c - hw, best_ls_c + hw, 40);
    best_cost_f = inf;  best_lk_f = best_lk_c;  best_ls_f = best_ls_c;

    for fi = 1:length(lkap_f)
        for fj = 1:length(lsig_f)
            kap  = 10^lkap_f(fi) * kBT;
            sig  = 10^lsig_f(fj);
            sbar = sig * R0^2 / kap;

            S_mod = zeros(length(nFit), 1);
            ok    = true;

            for ii = 1:length(nFit)
                q     = nFit(ii);
                lam_q = (q-1)*(q+2)*(q*(q+1) + sbar);
                if lam_q <= 0, ok = false; break; end

                f_q   = (4*q^2 + 6*q + 3) / (q*(q+1));
                tau_q = (eta_eff * R0^3) / (kap * lam_q) * f_q;

                x_q  = T_exp / tau_q;
                chi2 = ((1 - exp(-x_q)) / x_q)^2;

                s_sum = 0;
                cArr  = legCoeff{q};
                for l = q:lmax
                    if mod(l+q,2)~=0, continue; end
                    lam = (l-1)*(l+2)*(l*(l+1) + sbar);
                    if lam <= 0, ok = false; break; end
                    s_sum = s_sum + cArr(l)/lam;
                end
                if ~ok, break; end

                S_mod(ii) = chi2 * (kBT/kap) * s_sum / 2;
            end

            if ~ok || any(S_mod <= 0), continue; end
            cost_val = sum((log10(dataFit) - log10(S_mod)).^2);
            if cost_val < best_cost_f
                best_cost_f = cost_val;
                best_lk_f   = lkap_f(fi);
                best_ls_f   = lsig_f(fj);
            end
        end
    end

    kappa     = 10^best_lk_f * kBT;
    sigma     = 10^best_ls_f;
    sigma_bar = sigma * R0^2 / kappa;

    fprintf('  kappa = %.2f kBT,  sigma = %.2e N/m\n', kappa/kBT, sigma);

    %% ── Update eta_eff from ACF fit ──────────────────────────────────────
    % Re-run ACF section here (copy the tau_q block from below), then:
    % Use tau_q^meas = eta_eff * R0^3 / (kappa * lam_q) * f_q  ->  solve eta
    % Simple weighted mean over fitted modes:
    eta_candidates = NaN(n_q, 1);
    for qi = 1:n_q
        if ~fit_ok(qi), continue; end
        q      = q_acf(qi);
        sbar_i = sigma * R0^2 / kappa;
        lam_q  = (q-1)*(q+2)*(q*(q+1) + sbar_i);
        f_q    = (4*q^2 + 6*q + 3) / (q*(q+1));
        eta_candidates(qi) = tau_q(qi) * kappa * lam_q / (R0^3 * f_q);
    end
    eta_new = median(eta_candidates(~isnan(eta_candidates)));
    if ~isnan(eta_new) && eta_new > 0
        eta_eff = eta_new;
    end

    %% ── Convergence check ────────────────────────────────────────────────
    if kappa_prev > 0 && abs(kappa - kappa_prev)/kappa_prev < tol_kappa
        fprintf('Converged at iteration %d\n', iter);
        break
    end
    kappa_prev = kappa;
end

fprintf('\nFinal: kappa = %.2f kBT,  sigma = %.2e N/m,  eta_eff = %.3f mPa·s\n', ...
        kappa/kBT, sigma, eta_eff*1e3);
```

A few implementation notes before you run this:

1. **ACF block ordering**: The `fit_ok` and `tau_q` arrays must be populated before the iteration reaches the `eta_eff` update step. The cleanest approach is to run the ACF block once before the outer `for iter` loop (using the initial $\kappa$ from an uncorrected fit) and then again inside the loop after each spectral fit. Alternatively, for the first iteration set `eta_eff = 1.7e-3` (your converged value from the previous session) and only update after iteration 1.
    
2. **`T_exp` vs `T_frame`**: If you have a separate exposure time shorter than the frame period (e.g., a strobe), set `T_exp` explicitly. For rolling-shutter cameras the correction differs per row but at this precision level full-frame is fine.
    
3. **Extension to heating segments**: For the multi-segment case in `Fitting_Eventd.m`, the $\eta_\text{eff}$ should be treated as a vesicle-level constant (not segment-dependent, since it reflects the aqueous environment) and estimated once from the baseline ACF, then held fixed across heating cycles. The iteration then reduces to a single pass per segment with $\eta_\text{eff}$ frozen.
    

---

## The Camera Correction — Logic and Implementation

---

### The problem in one sentence

The camera does not see instantaneous contours — it time-averages the membrane position over the exposure window $T_\text{exp}$. This suppresses the measured fluctuation amplitude, so a naive fit returns a $\kappa$ that is too large.

---

### Step 1 — What the camera actually records

Each pixel value during frame $n$ accumulates light over the interval $[t_n,, t_n + T_\text{exp}]$. The recorded contour displacement is therefore:

$$\tilde{u}_q(t_n) = \frac{1}{T_\text{exp}} \int_{t_n}^{t_n+T_\text{exp}} u_q(t), dt$$

The equilibrium mode dynamics are exponentially relaxing:

$$\langle u_q(t), u_q(0) \rangle = \langle|u_q|^2\rangle_\text{eq}, e^{-t/\tau_q}$$

Propagating the time-average through this autocorrelation gives the **suppression factor**:

$$\langle|\tilde{u}_q|^2\rangle = \chi^2(\tau_q, T_\text{exp})\cdot \langle|u_q|^2\rangle_\text{eq}$$

$$\boxed{\chi(\tau_q, T_\text{exp}) = \frac{1 - e^{-T_\text{exp}/\tau_q}}{T_\text{exp}/\tau_q}}$$

This is always $\leq 1$. When $\tau_q \gg T_\text{exp}$: $\chi \to 1$ (no correction needed). When $\tau_q \ll T_\text{exp}$: $\chi \to 0$ (mode is completely washed out).

---

### Step 2 — Why this biases $\kappa$

The equilibrium spectrum is:

$$\langle|u_q|^2\rangle_\text{eq} = \frac{k_BT}{\kappa}\sum_\ell \frac{c_{\ell q}}{\lambda_\ell(\bar\sigma)} \cdot \frac{1}{2}$$

which decreases as $\kappa$ increases. The camera gives you $\chi^2 \cdot \langle|u_q|^2\rangle_\text{eq}$, which is smaller than the true equilibrium value. When you fit without correction, the optimizer compensates by pushing $\kappa$ **upward** to bring the model down to meet the suppressed data. Result: $\kappa$ is overestimated.

High-$q$ modes are most affected because they relax fastest ($\tau_q \propto q^{-3}$ in the bending regime), so $\chi^2$ drops most steeply at high $q$. This also flattens the apparent spectral slope, which the fit partially absorbs into $\sigma$.

---

### Step 3 — The key quantity: $\alpha = \eta_\text{eff} R_0^3 / \kappa$

To compute $\chi^2_q$ you need $\tau_q$. From Milner-Safran hydrodynamics:

$$\tau_q = \frac{\eta_\text{eff} R_0^3}{\kappa, \lambda_q(\bar\sigma)} \cdot f_q \equiv \alpha \cdot \frac{f_q}{\lambda_q(\bar\sigma)}$$

where $f_q = (4q^2+6q+3)/(q(q+1))$ is a purely geometric factor and $\lambda_q = (q-1)(q+2)[q(q+1)+\bar\sigma]$ is the Milner-Safran eigenvalue.

The critical insight: **you never need $\eta_\text{eff}$ and $\kappa$ separately**. The correction only depends on $\alpha = \eta_\text{eff} R_0^3/\kappa$, which has units of seconds and sets the overall timescale of relaxation.

---

### Step 4 — Extracting $\alpha$ from the ACF (independently of the spectral fit)

The measured ACF of mode $q$ decays as $C_q(\tau) = e^{-\tau/\tau_q}$. Fitting exponentials to the measured $C_q(\tau)$ gives $\tau_q^\text{meas}$ for several modes. These measured times satisfy:

$$\tau_q^\text{meas} = \alpha \cdot \frac{f_q}{\lambda_q(\bar\sigma)}$$

This is a two-parameter model in $(\alpha, \bar\sigma)$. A 1D grid search over $\bar\sigma$ with analytic OLS for $\alpha$ at each $\bar\sigma$ extracts both — **with no reference to $\kappa$ from the spectral fit**.

```
for each sigma_bar candidate:
    tau_pred(q) = f_q / lam_q(sigma_bar)      % shape only, no alpha
    log_alpha   = mean( log(tau_meas) - log(tau_pred) )   % OLS
    residual    = sum( (log tau_meas - log_alpha - log tau_pred)^2 )
keep the (sigma_bar, alpha) pair with minimum residual
```

This is the fix for the runaway seen earlier. The old approach used $\eta_\text{eff} = \tau_q^\text{meas} \cdot \kappa_\text{nc} \cdot \lambda_q / (R_0^3 f_q)$, making $\eta_\text{eff} \propto \kappa_\text{nc}$. With a tension-dominated spectrum producing an inflated $\kappa_\text{nc}$, $\eta_\text{eff}$ was inflated, making $\chi^2$ too strong, pushing $\kappa$ lower, which fed back into an even larger $\eta_\text{eff}$ — collapse. By fitting $\alpha$ directly from ACF data the loop is broken entirely.

---

### Step 5 — The corrected spectral fit (single pass)

The corrected model at each grid point $(\kappa_\text{trial}, \sigma_\text{trial})$ is:

$$S_q^\text{model} = \chi^2_q(\kappa_\text{trial}, \sigma_\text{trial}) \cdot \frac{k_BT}{\kappa_\text{trial}} \sum_\ell \frac{c_{\ell q}}{\lambda_\ell(\bar\sigma_\text{trial})} \cdot \frac{1}{2}$$

where:

$$\chi^2_q = \left[\frac{1 - e^{-x_q}}{x_q}\right]^2, \qquad x_q = \frac{T_\text{exp}}{\tau_q}, \qquad \tau_q = \alpha_\text{ACF} \cdot \frac{f_q}{\lambda_q(\bar\sigma_\text{trial})}$$

Three things change at each grid point: $\lambda_q$ changes with $\bar\sigma_\text{trial}$, so $\tau_q$ and $\chi^2_q$ both change. But $\alpha_\text{ACF}$ is fixed — it is a constant extracted from the data, not a free parameter of the spectral fit. No outer iteration is needed.

The flow in the code is:

```
alpha_acf, sigbar_acf  ← ACF grid search   [data-anchored, kappa-free]
         ↓
for each (kappa_trial, sigma_trial) in grid:
    sbar  = sigma_trial * R0^2 / kappa_trial
    lam_q = (q-1)(q+2)[q(q+1) + sbar]
    tau_q = alpha_acf * f_q / lam_q          ← alpha fixed
    chi2  = [(1-exp(-T_exp/tau_q))/(T_exp/tau_q)]^2
    S_mod = chi2 * (kBT/kappa_trial) * sum_l c_lq/lam_l / 2
cost = sum( (log10 data - log10 S_mod)^2 )
         ↓
kappa_cc, sigma_cc  ← best grid point
eta_eff = alpha_acf * kappa_cc / R0^3       ← back-calculated at the end
```

---

### Step 6 — Validity conditions

The correction is only meaningful when:

1. **$\tau_q \sim T_\text{exp}$ for some modes in the fit range.** At 50 fps with $T_\text{exp} = 20$ ms, this requires $\tau_q \gtrsim 10$ ms, which holds in bending-dominated spectra ($\bar\sigma \lesssim 50$, slope $< -2$). In tension-dominated vesicles all $\tau_q \ll T_\text{exp}$ and the ACF has already decayed to zero by lag 1 — the correction is unmeasurable.
    
2. **The measured $\tau_q$ follow MS $q$-scaling** (flat ratio column). If the ACF is noise-dominated the ratios scatter wildly and the two validity checks reject the fit:
    
    - `boundary_hit`: $\bar\sigma_\text{ACF}$ reached the grid edge — no interior minimum, no physical solution.
    - `rms_log_ratio > 0.5`: the $q$-dependence of measured $\tau_q$ is inconsistent with MS — likely noise or rigid-body drift.