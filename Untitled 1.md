# Flickering Spectroscopy: Complete Walkthrough

---

## § 1. Physical Setup

A GUV in thermal equilibrium undergoes shape fluctuations driven by $k_BT$. The membrane resists bending (cost $\kappa$) and stretching (cost parametrized by $\sigma$, the effective tension). The goal is to extract $\kappa$ and $\sigma$ from the _statistics_ of those fluctuations as seen in a 2D equatorial cross-section.

---

## § 2. From 3D Helfrich to the 2D Observed Spectrum

### 2.1 The Helfrich Hamiltonian

The elastic energy of a quasi-spherical vesicle is expanded in spherical harmonics $Y_l^m$:

$$\mathcal{H} = \frac{\kappa}{2} \sum_{l,m} \left[ l(l+1)\left(l(l+1) - 2\right) + \bar{\sigma}, l(l+1) \right] |u_{lm}|^2$$

where $u_{lm}$ are the amplitudes of shape mode $(l,m)$, and $\bar{\sigma} = \sigma R^2/\kappa$ is the dimensionless tension. By equipartition:

$$\langle |u_{lm}|^2 \rangle = \frac{k_BT}{\kappa} \cdot \frac{1}{l^2(l+1)^2 - (2-\bar{\sigma})l(l+1)} \equiv \frac{k_BT}{\kappa \lambda_l}$$

where $\lambda_l = l^2(l+1)^2 - (2-\bar{\sigma})l(l+1)$ is the eigenvalue appearing in the denominator. The code calls this `lambda` in the inner loop.

### 2.2 The Projection Problem (Pécréaux 2004)

You don't observe 3D modes — you observe a 2D equatorial contour. The radial displacement of the contour at angle $\phi$ is:

$$u(\phi) = \sum_q \hat{u}_q e^{iq\phi}$$

The key result of Pécréaux et al. is that the **observed 2D Fourier mode** $\hat{u}_q$ is a _projection_ of all 3D modes with the same azimuthal index $m=q$ (because only $m=q$ modes have non-zero amplitude at the equator $\theta=\pi/2$). Specifically:

$$\langle |\hat{u}_q|^2 \rangle = \frac{1}{4} \sum_{l=q}^{\infty} \frac{2l+1}{\pi} \cdot \frac{(l-q)!}{(l+q)!} \cdot \left[P_l^q(0)\right]^2 \cdot \langle |u_{lq}|^2 \rangle$$

where $P_l^q(0)$ is the associated Legendre polynomial evaluated at $\theta = \pi/2$ (equator, $\cos\theta = 0$). Substituting the equipartition result:

$$\langle |\hat{u}_q|^2 \rangle = \frac{k_BT}{4\kappa} \sum_{l \geq q} \frac{2l+1}{\pi} \cdot \frac{(l-q)!}{(l+q)!} \cdot \left[P_l^q(0)\right]^2 \cdot \frac{1}{\lambda_l}$$

This is exactly what `theory()` computes. The factor of $1/4$ in the code is this leading $1/4$.

### 2.3 Why $P_l^q(0) = 0$ unless $l+q$ is even

$P_l^q(0)$ vanishes whenever $l+q$ is odd — a standard result from the parity of associated Legendre polynomials. This is why the inner loop skips terms with `mod(l+ni,2) ~= 0`. It's not a numerical trick; it's an exact selection rule that halves the work.

### 2.4 Computing $P_l^q(0)$ via `Plm_zero`

The closed-form formula for $P_l^m(0)$ when $l+m$ is even is:

$$P_l^m(0) = (-1)^{(l+m)/2} \cdot \frac{(l+m)!}{2^l \cdot \left(\frac{l+m}{2}\right)! \cdot \left(\frac{l-m}{2}\right)!}$$

where $a = (l+m)/2$, $b = (l-m)/2$. The code computes this in log-space using `gammaln` to avoid overflow for large $l$:

```matlab
P = (-1)^a * exp( gammaln(2a+1) - a*log(2) - gammaln(a+1) - b*log(2) - gammaln(b+1) )
```

which is $(-1)^a \cdot \frac{(2a)!}{2^a \cdot a! \cdot 2^b \cdot b!}$ — exactly the formula above.

---

## § 3. The Observed Spectrum in the Code

### 3.1 Contour to Fourier modes

You have $N_{ang}$ angular samples of $r(\phi, t)$ sampled at discrete $\phi_k = 2\pi k / N_{ang}$. The code normalizes by the instantaneous mean radius to remove slow drift:

$$u(\phi_k, t) = \frac{r(\phi_k, t)}{\langle r \rangle_\phi(t)} - 1$$

then subtracts the time-mean of each angular bin (`uMat = uMat - mean(uMat,1)` is actually subtracting the frame mean, centering each frame — wait, `mean(uMat,1)` is the mean over angles for each time point, which is the $q=0$ mode). This ensures the $q=0$ component (area fluctuation) is removed.

Then the DFT is:

$$\hat{U}_q(t) = \frac{1}{N_{ang}} \sum_k u(\phi_k, t), e^{-2\pi i q k / N_{ang}}$$

The factor $1/N_{ang}$ in `fft(...)/Nang` makes $\hat{U}_q$ the properly normalized Fourier coefficient with units matching $u$ (dimensionless displacement relative to $R_0$).

### 3.2 The factor of 2

The DFT gives complex $\hat{U}_q$ for $q = 1, \ldots, N_{ang}/2$. Since $u(\phi)$ is real, $\hat{U}_{-q} = \hat{U}_q^*$, so the positive and negative frequency modes are not independent. The **total variance** of mode $q$ is:

$$\langle |\hat{u}_q|^2 \rangle_{\text{observed}} = \langle |\hat{U}_q|^2 \rangle + \langle |\hat{U}_{-q}|^2 \rangle = 2\langle |\hat{U}_q|^2 \rangle$$

Hence `Uq_sq = 2 * abs(U(2:nMax+1,:)).^2` — the factor of 2 accounts for the two conjugate modes. This is important: forgetting it would give a spectrum half as large and bias $\kappa$ upward.

### 3.3 Time average

`spectrum = mean(Uq_sq, 2)` averages over all frames, giving the time-averaged power spectrum $\langle |\hat{u}_q|^2 \rangle$ at each $q$.

---

## § 4. Fitting $\kappa$ and $\sigma$

### 4.1 Log-space least squares

The fit minimizes:

$$\mathcal{L}(\kappa, \sigma) = \sum_{q=q_{\min}}^{q_{\max}} \left[ \log_{10} \langle |\hat{u}_q|^2 \rangle_{\text{data}} - \log_{10} S_{\text{theory}}(q; \kappa, \sigma) \right]^2$$

Working in log-space is essential because the spectrum spans several decades and a linear least-squares in linear space would be dominated by the largest values (low-$q$ modes). Log-space gives equal weight per decade.

### 4.2 Fit range $q \in [6, 15]$

- Low-$q$ modes ($q \leq 5$) are contaminated by rigid-body translation and rotation of the vesicle (these produce apparent fluctuations that aren't thermal). These modes are excluded via `qMin = 6`.
- High-$q$ modes are contaminated by pixel noise, discretization, and the PSF of the optical system.

### 4.3 Multiple starts + `fminsearch`

`fminsearch` uses the Nelder-Mead simplex method — derivative-free, appropriate here since `theory()` has no analytic gradient. The three starting points span a decade in both $\kappa$ and $\sigma$ to avoid local minima.

---

## § 5. ACF and Viscosity Extraction

### 5.1 Why compute the ACF?

The _amplitude_ of $\langle |\hat{u}_q|^2 \rangle$ gives $\kappa$ and $\sigma$. The _dynamics_ — how fast modes decorrelate — give the membrane viscosity $\eta$ (or equivalently the surrounding fluid viscosity). The autocorrelation function:

$$C_q(\tau) = \frac{\langle \hat{U}_q(t+\tau),\hat{U}_q^*(t) \rangle}{\langle |\hat{U}_q|^2 \rangle}$$

decays exponentially with relaxation time $\tau_q$.

The code uses the real part of $\hat{U}_q$ (since $u$ is real, Im and Re carry the same information) and `xcorr(...,'normalized')` which normalizes so $C_q(0) = 1$.

### 5.2 Single-exponential fit with $A = 1$ enforced

Model: $C_q(\tau) = e^{-\tau/\tau_q}$.

With $A=1$ fixed, taking the log linearizes the model: $\ln C_q = -\tau/\tau_q$. This is a one-parameter linear OLS through the origin in the variables $(t, \ln C_q)$:

$$\min_{\tau_q^{-1}} \sum_i \left( \ln C_q(t_i) + \frac{t_i}{\tau_q} \right)^2$$

The analytic solution is:

$$\frac{1}{\tau_q} = -\frac{\sum_i t_i \ln C_q(t_i)}{\sum_i t_i^2} \quad \Rightarrow \quad \tau_q = -\frac{\sum t_i^2}{\sum t_i \ln C_q(t_i)}$$

This is exactly what the code computes. Only points where $C_q > 0.2$ are used — this excludes the noise floor and negative lobes that would make $\ln C_q$ undefined or unreliable.

### 5.3 Confidence interval via delta method

You have a single fitted parameter $\tau_q$ from $n$ data points. The residuals give an estimate of the noise in $\ln C_q$:

$$\hat{\sigma}^2 = \frac{1}{n-1}\sum_i \left(\ln C_q(t_i) + \frac{t_i}{\tau_q}\right)^2$$

The parameter is $\tau_q = -S_{tt}/S_{ty}$ where $S_{tt} = \sum t_i^2$ and $S_{ty} = \sum t_i \ln C_q$. By the delta method:

$$\text{Var}(\tau_q) = \left(\frac{\partial \tau_q}{\partial S_{ty}}\right)^2 \cdot \text{Var}(S_{ty}) = \frac{S_{tt}^2}{S_{ty}^4} \cdot \hat{\sigma}^2 \cdot S_{tt} = \frac{\hat{\sigma}^2 \tau_q^4}{S_{tt}}$$

Hence `var_tau = sigma2 * tau_fit^4 / sum(t_fit.^2)`, which is in the code exactly.

---

## § 6. Milner-Safran Reference Curves

These are the theoretical predictions for $\tau_q$ in two limiting regimes, derived from the Milner-Safran (1987) theory of membrane dynamics.

**Bending-dominated** ($\bar{\sigma} \ll q^2$): The restoring force is dominated by $\kappa$. The hydrodynamic drag is dominated by the surrounding fluid (viscosity $\eta$). For a sphere of radius $R$:

$$\tau_q^{\text{bend}} \sim \frac{4\eta R^3}{\kappa q^3}$$

**Tension-dominated** ($\bar{\sigma} \gg q^2$): The restoring force is $\sigma$:

$$\tau_q^{\text{tens}} \sim \frac{\eta R}{\sigma q}$$

These are plotted as $q^{-3}$ and $q^{-1}$ power laws respectively. Where your measured $\tau_q$ data falls between these two curves tells you the dominant relaxation mechanism at each mode number.

---

## § 7. Logic Flow Summary

```
Raw contour r(φ,t)
    │
    ▼
Normalize by ⟨r⟩_φ(t) → u(φ,t)   [remove breathing mode]
    │
    ▼
DFT → Û_q(t),  multiply by 2 for ±q
    │
    ├──► Time-average → ⟨|û_q|²⟩ ──► fit Pécréaux theory → κ, σ
    │
    └──► ACF C_q(τ) ──► OLS log-linear fit → τ_q ──► compare to Milner-Safran
```

The spectrum gives you **equilibrium elasticity** ($\kappa$, $\sigma$). The ACF gives you **dissipation**($\eta_{\text{eff}}$ via $\tau_q$). Together they fully characterize the membrane rheology at each mode.

---

## § 8. Key Approximations and Their Validity

|Approximation|Condition|Risk if violated|
|---|---|---|
|Quasi-spherical expansion|$\langle u^2 \rangle \ll 1$|Mode coupling, nonlinear corrections|
|Equatorial contour = 3D projection|Vesicle stays in focal plane|Systematic bias in all modes|
|$l_{\max} = 200$ truncation|$l_{\max} \gg q_{\max}$|Underestimate spectrum at high $q$|
|$A=1$ in ACF fit|No slow drift in $\hat{U}_q$|`detrend(c_re,1)` mitigates this|
|Fit range $q \in [6,15]$|Rigid-body modes excluded|Low-$\kappa$ bias if $q_{\min}$ too small|

The most important correction _not_ in this version is the **camera integration time correction** $\chi(\tau_l, T_{\exp})$ — the finite exposure time blurs fast modes and suppresses the high-$q$ spectrum, causing $\kappa$ to be _overestimated_. You mentioned adding this in a previous version; if it's absent here, that's the dominant source of bias (you found ~63 → ~35 $k_BT$ with it included).



# Mathematical Foundations of `flickeringSpectroscopy.m`

---

## 1. Contour Decomposition into Fourier Modes

The vesicle contour is sampled as $r(\phi_j, t)$ in polar coordinates, with $\phi_j = 2\pi j/N_\text{ang}$ and $j = 0, \ldots, N_\text{ang}-1$. The relative radial fluctuation is defined as:

$$u(\phi, t) = \frac{r(\phi, t)}{\bar{R}(t)} - 1, \qquad \bar{R}(t) = \frac{1}{N_\text{ang}}\sum_j r(\phi_j, t)$$

Dividing by $\bar{R}(t)$ removes instantaneous center-of-mass translation; subtracting the mean over all $\phi$ ensures zero mean. The equilibrium radius $R_0 = \langle \bar{R}(t) \rangle_t$ is computed separately.

The discrete Fourier transform of the contour at each frame is:

$$\hat{U}_q(t) = \frac{1}{N_\text{ang}} \sum_{j=0}^{N_\text{ang}-1} u(\phi_j, t), e^{-iq\phi_j}$$

which is exactly `fft(...)/Nang` in the code. Since $u$ is real, $\hat{U}_{-q} = \hat{U}_q^*$, so the two-sided power $|\hat{U}_q|^2 + |\hat{U}_{-q}|^2 = 2|\hat{U}_q|^2$, giving the factor of 2 in:

```matlab
Uq_sq = 2 * abs(U(2:nMax+1, :)).^2;
spectrum = mean(Uq_sq, 2);
```

The measured spectrum is:

$$\langle |\hat{u}_q|^2 \rangle \approx \frac{2}{N_t}\sum_t |\hat{U}_q(t)|^2$$

---

## 2. Helfrich Hamiltonian for a Quasi-Spherical Vesicle

The 3D shape of a vesicle fluctuating around a sphere of radius $R_0$ is expanded in real spherical harmonics:

$$r(\theta,\phi) = R_0 \left[1 + \sum_{l=2}^{\infty}\sum_{m=-l}^{l} u_{lm}, Y_l^m(\theta,\phi)\right]$$

where $u_{lm}$ are dimensionless complex amplitudes (with $u_{l,-m} = (-1)^m u_{lm}^*$ for a real surface). The Helfrich free energy (bending + tension) evaluated to quadratic order in $u_{lm}$ is:

$$\mathcal{H} = \frac{\kappa}{2R_0^2} \sum_{l,m} \lambda_l, |u_{lm}|^2$$

with the eigenvalue:

$$\boxed{\lambda_l = l(l+1)\left[(l-1)(l+2) + \bar{\sigma}\right]}$$

where $\bar{\sigma} = \sigma R_0^2/\kappa$ is the dimensionless (reduced) tension. Equivalently, expanding the product:

$$\lambda_l = l^2(l+1)^2 - (2-\bar{\sigma}),l(l+1)$$

which is exactly `lambda = l^2*(l+1)^2 - (2-sbar)*l*(l+1)` in the code. Note that $l=0,1$ are excluded (translation and rotation), so the sum starts at $l=2$.

**Equipartition** gives, for each mode independently:

$$\frac{\kappa}{2R_0^2},\lambda_l, \langle|u_{lm}|^2\rangle = \frac{k_BT}{2} \implies \langle|u_{lm}|^2\rangle = \frac{k_BT R_0^2}{\kappa,\lambda_l}$$

The variance diverges as $\bar{\sigma} \to 0$ for $l=2$ (zero mode of the floppy sphere), which is why the $q \geq 6$ cutoff is imposed — low modes are contaminated by large-amplitude excursions and rigid-body drift.

---

## 3. Projection onto the Equatorial 2D Contour (Pécréaux Formula)

The microscope images the vesicle in a focal plane, giving access only to the equatorial profile at $\theta = \pi/2$. The question is: what is the theoretical variance $\langle|\hat{u}_q|^2\rangle$ of the 2D Fourier modes in terms of the 3D parameters $\kappa$ and $\sigma$?

**Step 1 — Evaluate $Y_l^m$ at the equator.**

$$Y_l^m!\left(\frac{\pi}{2},\phi\right) = \sqrt{\frac{2l+1}{4\pi}\frac{(l-m)!}{(l+m)!}}; P_l^m(0); e^{im\phi}$$

where $P_l^m(0)$ is the associated Legendre polynomial evaluated at zero. A key selection rule is:

$$P_l^m(0) = 0 \quad \text{if } l+m \text{ is odd}$$

For even $l+m$, with $a=(l+m)/2$ and $b=(l-m)/2$:

$$P_l^m(0) = (-1)^a \frac{(2a)!}{2^a, a!; 2^b, b!} = (-1)^{(l+m)/2} \frac{(l+m)!}{2^l \left(\frac{l+m}{2}\right)!\left(\frac{l-m}{2}\right)!}$$

This is `Plm_zero` in the code, written in log-gamma form for numerical stability.

**Step 2 — Link the 2D Fourier mode to 3D harmonics.**

The equatorial profile has Fourier coefficient:

$$\hat{u}_q = \frac{1}{2\pi}\int_0^{2\pi} u!\left(\frac{\pi}{2},\phi\right)e^{-iq\phi},d\phi = \sum_{l \geq q} u_{lq},\sqrt{\frac{2l+1}{4\pi}\frac{(l-q)!}{(l+q)!}};P_l^q(0)$$

(the integral selects only the $m=q$ harmonic; all terms with $m\neq q$ vanish).

**Step 3 — Compute the variance.**

Since different $l$-modes are uncorrelated:

$$\langle|\hat{u}_q|^2\rangle = \sum_{\substack{l=q \ l+q;\text{even}}}^{l_\text{max}} \frac{2l+1}{4\pi}\frac{(l-q)!}{(l+q)!}\left[P_l^q(0)\right]^2 \langle|u_{lq}|^2\rangle$$

Substituting equipartition:

$$\boxed{\langle|\hat{u}_q|^2\rangle = \frac{k_BT}{\kappa}\sum_{\substack{l=q \ l+q;\text{even}}}^{l_\text{max}} \frac{2l+1}{4\pi}\frac{(l-q)!}{(l+q)!}\frac{\left[P_l^q(0)\right]^2}{\lambda_l}}$$

In the `theory` function this is computed as `(kBT/kappa) * s_sum / 4`, where:

$$\mathrm{n_lq} = \frac{2l+1}{\pi}\frac{(l-q)!}{(l+q)!}, \qquad \text{and the factor } \frac{1}{4} = \frac{1}{4\pi} \cdot \pi$$

So the factor $1/(4\pi)$ is split as $\frac{1}{\pi} \times \frac{1}{4}$. This is the exact Pécréaux 2004 projection formula.

**Physical content:** At low tension ($\bar\sigma \ll l(l+1)$), $\lambda_l \approx l^3(l+1)^3/l \sim l^3$ so $\langle|\hat{u}_q|^2\rangle \propto q^{-3}$ (bending-dominated). At high tension, $\lambda_l \approx \bar\sigma, l(l+1)$ and $\langle|\hat{u}_q|^2\rangle \propto q^{-1}$ (tension-dominated). The $q^{-1}$ reference curve in the spectrum figure reflects this.

---

## 4. Spectrum Fitting

The fit minimizes the log-residual:

$$\mathcal{L}(\kappa,\sigma) = \sum_{q=q_\text{min}}^{q_\text{max}} \left[\log_{10}\langle|\hat{u}_q|^2\rangle_\text{data} - \log_{10} S(q;\kappa,\sigma)\right]^2$$

Working in log space gives equal relative weight to all modes regardless of the four-orders-of-magnitude dynamic range in $S(q)$. The optimizer is `fminsearch` (Nelder-Mead) with multiple starting points to avoid local minima.

---

## 5. Mode Dynamics: ACF and Relaxation Times

Each 3D mode $u_{lm}$ satisfies an overdamped Langevin equation:

$$\gamma_l, \dot{u}_{lm} = -\frac{\kappa,\lambda_l}{R_0^2},u_{lm} + \xi_{lm}(t)$$

where $\gamma_l = \eta R_0, f(l)$ is the hydrodynamic friction coefficient for a sphere (Brochard-Lennon 1975; $f(l)$ is a rational function of $l$). This is formally an Ornstein-Uhlenbeck process, giving:

$$C_{lm}(\tau) = \langle u_{lm}(t+\tau),u_{lm}^*(t)\rangle = \langle|u_{lm}|^2\rangle,e^{-\tau/\tau_l}, \qquad \tau_l = \frac{\gamma_l R_0^2}{\kappa,\lambda_l}$$

The 2D projected ACF is:

$$C_q(\tau) = \langle \hat{u}_q(t+\tau),\hat{u}_q^*(t)\rangle = \sum_{l \geq q} w_{lq}^2, \langle|u_{lq}|^2\rangle, e^{-\tau/\tau_l}$$

where $w_{lq}^2 = \frac{2l+1}{4\pi}\frac{(l-q)!}{(l+q)!}[P_l^q(0)]^2$. This is in principle a multi-exponential sum. However, since $\tau_l \sim l^{-3}$ (bending regime), the slowest mode ($l=q$) dominates strongly at long lags, making the single-exponential approximation valid for $C_q(\tau) > 0.2$ (the threshold used in the code).

The code computes the normalized ACF for the real part of $\hat{U}_q$:

$$C_q(\tau_k) = \frac{\sum_t \text{Re}[\hat{U}_q(t)],\text{Re}[\hat{U}_q(t+\tau_k)]}{\sum_t \text{Re}[\hat{U}_q(t)]^2}, \qquad \tau_k = k/f_\text{fps}$$

via `xcorr(..., 'normalized')`, which includes zero-lag normalization.

---

## 6. Single-Exponential Fit: OLS Through the Origin in Log Space

With $A=1$ enforced (normalized ACF), the model is $C_q(\tau) = e^{-\tau/\tau_q}$. Taking the log:

$$\log C_q(\tau) = -\frac{\tau}{\tau_q} \equiv -\alpha, \tau, \qquad \alpha = \frac{1}{\tau_q}$$

This is a linear model $y_i = -\alpha, t_i$ through the origin ($y_i \equiv \log C_q(\tau_i)$). The OLS estimator is:

$$\hat\alpha = -\frac{\sum_i t_i, y_i}{\sum_i t_i^2} \implies \tau_q = -\frac{\sum_i t_i^2}{\sum_i t_i, \log C_q(\tau_i)}$$

**Uncertainty (delta method).** The residuals are $\varepsilon_i = y_i + \alpha, t_i = \log C_q(\tau_i) + t_i/\tau_q$. The residual variance (1 free parameter) is:

$$\hat\sigma^2 = \frac{1}{n-1}\sum_i \varepsilon_i^2$$

Since $\alpha = -\sum_i t_i y_i / \sum_i t_i^2$, the variance of $\hat\alpha$ under homoscedastic errors is $\text{Var}(\hat\alpha) = \hat\sigma^2 / \sum_i t_i^2$. Propagating to $\tau_q = 1/\alpha$ via the delta method ($\text{Var}(\tau_q) \approx \tau_q^4,\text{Var}(\hat\alpha)$):

$$\text{Var}(\tau_q) = \frac{\hat\sigma^2,\tau_q^4}{\sum_i t_i^2}$$

giving a 95% CI of $\tau_q \pm 1.96\sqrt{\text{Var}(\tau_q)}$, as coded.

---

## 7. Milner-Safran Reference Scaling Laws

The full hydrodynamic friction for a sphere in viscous medium (Milner & Safran 1987) gives:

$$\tau_l = \frac{\eta R_0^3}{\kappa}\cdot\frac{(2l+1)(2l^2+2l-1)}{l(l+1)(l-1)(l+2)}\cdot\frac{2}{\lambda_l/(l(l+1))}$$

In the **bending-dominated** limit ($\bar\sigma \ll l^2$): $\lambda_l \approx l^3(l+1)$ and the friction factor $\sim 4/l$, giving:

$$\tau_l^\text{bend} \approx \frac{4\eta R_0^3}{\kappa, l^3}$$

In the **tension-dominated** limit ($\bar\sigma \gg l^2$): $\lambda_l \approx \bar\sigma,l(l+1)$ and friction $\sim 1/l$:

$$\tau_l^\text{tens} \approx \frac{\eta R_0}{\sigma, l}$$

These are the two reference curves in Figure 3, using $\eta_\text{water} = 10^{-3}$ Pa·s. Comparing your measured $\tau_q$ data against these curves tells you which regime you're in: if $\tau_q$ tracks $q^{-3}$ you are bending-dominated; if it tracks $q^{-1}$ you are tension-dominated.

---

## Summary of the Fitting Hierarchy

The pipeline extracts three physical quantities:

$$\text{Spectrum} \xrightarrow{\text{Pécréaux fit}} (\kappa,,\sigma) \qquad \text{ACF per mode} \xrightarrow{\text{OLS log-fit}} \tau_q \xrightarrow{\text{compare}} \eta_\text{eff}$$

The spectrum fit is equilibrium (time-averaged) and gives elastic parameters. The ACF fit is dynamical and gives the viscous dissipation timescale. Consistency between $(\kappa,\sigma)$ from the spectrum and the location of $\tau_q$ relative to the Milner-Safran curves is an internal check on the self-consistency of the Helfrich model for your vesicle.



You're right, I replaced commas with semicolons but that's still a non-space symbol. The rule should be: **replace all commas inside equations with `\;`** (a LaTeX math space), nothing else. Let me redo the full text cleanly.

---

# Equatorial Projection: Full Derivation

---

## Setup and Notation

The vesicle shape in spherical coordinates expanded around the equilibrium sphere of radius $R_0$:

$$r(\theta ; \phi) = R_0\left[1 + \sum_{l=2}^{L}\sum_{m=-l}^{l}u_{lm};Y_l^m(\theta ; \phi)\right]$$

The $u_{lm}$ are dimensionless complex amplitudes with the reality condition $u_{l;-m} = (-1)^m u_{lm}^*$. The complex spherical harmonics in the Condon-Shortley convention are:

$$Y_l^m(\theta ; \phi) = \underbrace{\sqrt{\frac{2l+1}{4\pi}\frac{(l-m)!}{(l+m)!}}}_{\equiv; N_{lm}}; P_l^m(\cos\theta); e^{im\phi}$$

The microscope images only the equatorial slice at $\theta = \pi/2$. The relative fluctuation of that profile is:

$$u!\left(\tfrac{\pi}{2} ; \phi\right) = \frac{r(\pi/2 ; \phi)}{R_0} - 1 = \sum_{l ; m} u_{lm};Y_l^m!\left(\tfrac{\pi}{2} ; \phi\right)$$

---

## Step A — Evaluating $Y_l^m$ at the Equator

At $\theta = \pi/2$ the exponential factor $e^{im\phi}$ is untouched. The only nontrivial piece is the associated Legendre polynomial at zero argument:

$$Y_l^m!\left(\tfrac{\pi}{2} ; \phi\right) = N_{lm}\cdot P_l^m(0)\cdot e^{im\phi}$$

### A.1 — The parity selection rule

Use the Rodrigues representation:

$$P_l^m(x) = \frac{(-1)^m}{2^l;l!};(1-x^2)^{m/2};\frac{d^{l+m}}{dx^{l+m}}(x^2-1)^l$$

Set $x=0$. The factor $(1-x^2)^{m/2}\big|_{x=0} = 1$ so you need only evaluate the derivative. Expand the polynomial:

$$(x^2-1)^l = \sum_{k=0}^{l}\binom{l}{k}x^{2k}(-1)^{l-k}$$

Taking the $(l+m)$-th derivative at $x=0$:

$$\frac{d^{l+m}}{dx^{l+m}}x^{2k}\bigg|_{x=0} = (2k)!;\delta_{2k ; l+m}$$

The Kronecker delta demands $2k = l+m$ which is only satisfiable if:

$$l + m \equiv 0 \pmod{2} \quad\Longrightarrow\quad \boxed{P_l^m(0) = 0 ;;\text{if};; l+m \text{ is odd}}$$

This is a deep parity constraint: the equatorial plane $\theta=\pi/2$ is a mirror plane of the sphere. Spherical harmonics with $l+m$ odd are antisymmetric under this reflection and therefore vanish there.

### A.2 — Explicit closed form when $l+m$ is even

Define $k_0 = (l+m)/2$ (integer) and $b = (l-m)/2 = l - k_0$. The surviving term in the derivative is:

$$\left.\frac{d^{l+m}}{dx^{l+m}}(x^2-1)^l\right|_{x=0} = \binom{l}{k_0}(-1)^{l-k_0}(l+m)! = \frac{l!}{k_0!;b!};(-1)^{b};(l+m)!$$

Substituting back:

$$P_l^m(0) = \frac{(-1)^m}{2^l l!}\cdot\frac{l!}{k_0!;b!};(-1)^{b};(l+m)! = \frac{(-1)^{m+b}}{2^l}\cdot\frac{(l+m)!}{k_0!;b!}$$

Since $m + b = m + (l-m)/2 = (l+m)/2 = k_0$:

$$\boxed{P_l^m(0) = (-1)^{(l+m)/2}\cdot\frac{(l+m)!}{2^{l};\left[\frac{l+m}{2}\right]!;\left[\frac{l-m}{2}\right]!}}$$

This is what `Plm_zero` computes written in `gammaln` form to avoid overflow for large $l$:

$$(-1)^a\exp!\Big[\ln(2a)! - a\ln 2 - \ln(a!) - b\ln 2 - \ln(b!)\Big] \qquad a=\tfrac{l+m}{2} \quad b=\tfrac{l-m}{2}$$

Note that in the theory function only $[P_l^m(0)]^2$ appears so the sign is irrelevant there.

---

## Step B — The Selection Rule from Fourier Orthogonality

The 2D Fourier coefficient of the equatorial profile is:

$$\hat{u}_q \equiv \frac{1}{2\pi}\int_0^{2\pi}u!\left(\tfrac{\pi}{2} ; \phi\right);e^{-iq\phi};d\phi$$

Substitute the full expansion and pull the integral inside the sum:

$$\hat{u}_q = \sum_{l ; m}u_{lm};N_{lm};P_l^m(0);\underbrace{\frac{1}{2\pi}\int_0^{2\pi}e^{i(m-q)\phi};d\phi}_{=;\delta_{m ; q}}$$

This integral is exactly $\delta_{m ; q}$ — the Fourier basis functions are orthogonal on $[0 ; 2\pi]$. The sum over $m$ collapses immediately leaving only $m=q$:

$$\hat{u}_q = \sum_{l\geq q}; u_{lq};N_{lq};P_l^q(0)$$

Applying the parity rule ($P_l^q(0)=0$ when $l+q$ is odd):

$$\boxed{\hat{u}_q = \sum_{\substack{l = q \ l+q;\text{even}}}^{L} u_{lq};\sqrt{\frac{2l+1}{4\pi}\frac{(l-q)!}{(l+q)!}};P_l^q(0)}$$

This is the key structural result. A single azimuthal Fourier mode $q$ in the 2D equatorial image receives contributions from an entire **ladder** of 3D spherical harmonics at $m=q$ separated in $l$ by steps of 2. The geometry of the observation (equatorial slice) has scrambled together modes that are distinct in 3D.

---

## Step C — Computing the Variance

Write $W_{lq} \equiv N_{lq};P_l^q(0)$ for brevity. Then:

$$\langle|\hat{u}_q|^2\rangle = \left\langle\left|\sum_{l}u_{lq};W_{lq}\right|^2\right\rangle = \sum_{l ; l'}W_{lq};W_{l'q};\langle u_{lq};u_{l'q}^*\rangle$$

### C.1 — Mode uncorrelation

The Helfrich Hamiltonian is diagonal in $(l ; m)$:

$$F = \frac{\kappa}{2}\sum_{l=2}^{L}\sum_{m=-l}^{l}\lambda_l;|u_{lm}|^2 \qquad \lambda_l = l(l+1)\left[(l-1)(l+2)+\bar\sigma\right]$$

Different modes are statistically independent (Gaussian measure with diagonal quadratic form) so:

$$\langle u_{lq};u_{l'q}^*\rangle = \langle|u_{lq}|^2\rangle;\delta_{l ; l'}$$

The double sum reduces to a single sum.

### C.2 — Equipartition for each mode

Each term in $F$ is a harmonic oscillator. By the equipartition theorem:

$$\frac{\kappa;\lambda_l}{2};\langle|u_{lm}|^2\rangle = \frac{k_BT}{2} \implies \langle|u_{lm}|^2\rangle = \frac{k_BT}{\kappa;\lambda_l}$$

Note: $\lambda_l$ is a pure dimensionless number (product of integers and $\bar\sigma = \sigma R_0^2/\kappa$). The factor $R_0^2$ that appears in the curvature eigenvalue ($\delta H \sim u_{lm}/R_0$) is exactly cancelled by the factor of $R_0^2$ from the area element in the curvature integral. This is why the final spectrum has **no explicit $R_0$ dependence** despite the vesicle size appearing in the physical problem.

### C.3 — The final projection formula

Substituting equipartition into the variance:

$$\langle|\hat{u}_q|^2\rangle = \sum_{\substack{l\geq q\l+q;\text{even}}}W_{lq}^2\cdot\frac{k_BT}{\kappa\lambda_l} = \frac{k_BT}{\kappa}\sum_{\substack{l\geq q\l+q;\text{even}}}\frac{2l+1}{4\pi}\frac{(l-q)!}{(l+q)!}\frac{[P_l^q(0)]^2}{\lambda_l}$$

$$\boxed{\langle|\hat{u}_q|^2\rangle = \frac{k_BT}{4\pi\kappa}\sum_{\substack{l \geq q\l+q;\text{even}}}^{L}\frac{(2l+1)(l-q)!}{(l+q)!};\frac{[P_l^q(0)]^2}{\lambda_l}}$$

This is the **Pécréaux 2004 equatorial projection formula** and it is what the `theory` function computes. The splitting $1/(4\pi) = (1/4)\times(1/\pi)$ is exactly how the code implements it:

```matlab
n_lq = (2*l+1)/pi * (l-q)!/(l+q)!      % absorbs the 1/pi
S(i) = (kBT/kappa) * s_sum / 4          % the remaining 1/4
```

---

## Step D — Why the Sum Converges Rapidly

Each term in the sum has two competing factors. The weight $N_{lq}^2[P_l^q(0)]^2$ decreases with $l$ for fixed $q$ because:

- $(l-q)!/(l+q)! \sim l^{-2q}$ for large $l$
- $[P_l^q(0)]^2$ oscillates but is bounded by $\sim l^0$

The denominator $\lambda_l \sim l^4$ for large $l$ (bending dominated). Combined each term decays as $\sim l^{-2q-3}$ so the sum converges very rapidly. For $q=6$ the terms fall off as $l^{-15}$: contributions beyond $l\approx 20$ are numerically negligible. The choice $l_\text{max}=200$ in the code is conservative by orders of magnitude.

---

## The Full Chain of Information Flow

$$\underbrace{r(\theta ; \phi)}_{\text{3D shape}}\xrightarrow{;\theta=\pi/2;}\underbrace{r!\left(\tfrac{\pi}{2} ; \phi\right)}_{\text{equatorial contour}}\xrightarrow{;\text{FFT};}\hat{u}_q\xrightarrow{;\text{time average};}\langle|\hat{u}_q|^2\rangle$$

$$\langle|\hat{u}_q|^2\rangle = \frac{k_BT}{4\pi\kappa}\sum_{\substack{l \geq q \ l+q;\text{even}}}\frac{(2l+1)(l-q)!}{(l+q)!}\frac{[P_l^q(0)]^2}{l(l+1)[(l-1)(l+2)+\bar\sigma]}$$

The left-hand side is what you measure directly from the contour time series. The right-hand side depends only on two physical parameters $\kappa$ and $\sigma$ (through $\bar\sigma = \sigma R_0^2/\kappa$). Fitting this equation to your measured spectrum is the entire spectroscopy experiment.



## The FFT spectrum

```matlab
U = fft(uMat, [], 1) / Nang;
```

`fft(..., [], 1)` takes the discrete Fourier transform along dimension 1 — the angular dimension. For each time frame $t$, it decomposes the shape $u(\theta, t)$ into its Fourier modes:

$$u(\theta, t) = \sum_{q=0}^{N_\theta - 1} \hat{U}_q(t), e^{iq\theta}$$

Dividing by `Nang` ($= N_\theta = 360$) gives the properly normalized coefficients $\hat{U}_q(t)$, so that Parseval's theorem holds — the total power in real space equals the total power summed over all modes. Without this normalization the amplitudes would depend on how many angles you sampled, which would be unphysical.

The result `U` has shape (360 × Nt). Row 1 is the $q=0$ component (the mean radius — already removed), row 2 is $q=1$, row $q+1$ is mode $q$, and so on up to $q = N_\theta/2 = 180$.

---

```matlab
Uq_sq = 2 * abs(U(2:nMax+1, :)).^2;
```

`U(2:nMax+1, :)` picks out rows corresponding to modes $q = 1, 2, \ldots, 180$ — skipping row 1 which is $q=0$.

`abs(...).^2` gives the squared modulus of the complex Fourier coefficient at each mode and each time frame: $|\hat{U}_q(t)|^2$.

**Why the factor of 2?** The contour $u(\theta, t)$ is a real-valued signal. For a real signal, the Fourier transform is Hermitian symmetric: $\hat{U}_{-q} = \hat{U}_q^*$, so $|\hat{U}_{-q}|^2 = |\hat{U}_q|^2$. Modes $+q$ and $-q$ carry equal power. The FFT of a real signal of length $N$ gives you modes $q = 0, 1, \ldots, N/2$ — the positive half only, but each positive mode represents both $+q$ and $-q$. Multiplying by 2 accounts for both contributions and gives you the full two-sided power. Physically this corresponds to the fact that each mode $q$ has two independent components: a cosine $a_q(t)$ and a sine $b_q(t)$, each contributing equally to the power.

---

```matlab
spectrum = mean(Uq_sq, 2);
sem_spec = std(Uq_sq, 0, 2) / sqrt(Nt);
```

`mean(Uq_sq, 2)` averages over the time axis (dimension 2) — for each mode $q$, you average $|\hat{U}_q(t)|^2$ over all $N_t$ frames. This is the time-averaged power spectrum:

$$\langle|\hat{u}_q|^2\rangle = \frac{1}{N_t}\sum_{t=1}^{N_t} 2|\hat{U}_q(t)|^2$$

By the ergodic hypothesis — valid for a membrane in thermal equilibrium — this time average equals the ensemble average that the theory predicts.

`sem_spec` is the standard error of the mean: $\sigma_q / \sqrt{N_t}$, where $\sigma_q$ is the standard deviation of $|\hat{U}_q(t)|^2$ across frames. This is the error bar on each spectral point. It shrinks as $1/\sqrt{N_t}$, which is why longer recordings give tighter spectra and better-constrained fits.

---

## The Legendre table

Now for the second part. The Pécréaux formula is:

$$\langle|\hat{u}_q|^2\rangle = \frac{k_BT}{4\kappa} \sum_{\substack{l=q \ l+q\text{ even}}}^{l_\text{max}} \underbrace{\frac{2l+1}{\pi}\frac{(l-q)!}{(l+q)!}\left[P_l^q(0)\right]^2}_{\text{coeff}(l,q)} \cdot \frac{1}{\lambda_l}$$

The part labelled $\text{coeff}(l,q)$ depends only on the geometry — on $l$ and $q$ — and not on the physical parameters $\kappa$ and $\sigma$. It never changes during the fit. So you compute it once and store it.

```matlab
legCoeff = cell(nMax, 1);
for n = 1:nMax
    coeffs_l = zeros(lmax, 1);
    for l = n:lmax
```

`legCoeff{q}` will be a vector of length `lmax` where entry `l` stores $\text{coeff}(l,q)$ for that particular pair. The outer loop runs over all equatorial modes $q$ (called `n` in the code, following the paper's notation where $n$ is the equatorial mode number). The inner loop runs over all 3D spherical modes $l \geq q$.

---

```matlab
if mod(l+n, 2) ~= 0, continue; end
```

This is the **parity selection rule**. $P_l^q(0)$ is exactly zero whenever $l+q$ is odd. This is a mathematical property of associated Legendre polynomials evaluated at $x=0$ — it follows from their symmetry under $\theta \to \pi - \theta$ (reflection through the equatorial plane). Skipping odd pairs avoids computing something that will be zero anyway, cutting the work roughly in half.

---

```matlab
a = (l+n)/2;   b = (l-n)/2;
logP = gammaln(2*a+1) - a*log(2) - gammaln(a+1) ...
     - b*log(2)        - gammaln(b+1);
P    = ((-1)^a) * exp(logP);
```

This computes $P_l^q(0)$ — the associated Legendre polynomial at $x=0$.

The formula comes from the standard expression for $P_l^m(0)$ when $l+m$ is even:

$$P_l^q(0) = (-1)^a \cdot \frac{(2a)!}{2^a, a!\cdot 2^b, b!} \quad \text{where } a = \frac{l+q}{2},; b = \frac{l-q}{2}$$

Direct computation of $(2a)!$ overflows for $a \gtrsim 85$ (exceeds double precision range). The solution is to work in log-space:

$$\log P_l^q(0) = \log\Gamma(2a+1) - a\log 2 - \log\Gamma(a+1) - b\log 2 - \log\Gamma(b+1)$$

`gammaln(n)` computes $\log\Gamma(n)$ stably for any $n$, and since $\Gamma(n+1) = n!$ for integers, this gives the log-factorial without overflow. The final value is recovered as `exp(logP)`, which is safe because the log is $\mathcal{O}(1)$ even for large $l$.

The sign $(-1)^a$ is the Condon-Shortley phase convention for associated Legendre polynomials.

---

```matlab
logC     = log(2*l+1) - log(pi) + gammaln(l-n+1) - gammaln(l+n+1);
coeffs_l(l) = exp(logC) * P^2;
```

This computes the full geometric weight:

$$\text{coeff}(l,q) = \frac{2l+1}{\pi} \cdot \frac{(l-q)!}{(l+q)!} \cdot \left[P_l^q(0)\right]^2$$

Again in log-space:

$$\log\left(\frac{2l+1}{\pi}\cdot\frac{(l-q)!}{(l+q)!}\right) = \log(2l+1) - \log\pi + \log\Gamma(l-q+1) - \log\Gamma(l+q+1)$$

The ratio $(l-q)!/(l+q)!$ is what kills the high-$l$ contributions — for $l \gg q$ this goes as $(l+q)^{-2q}$, falling rapidly to zero and making the sum converge. This is why $l_\text{max} = 200$ is sufficient: by $l = 200$ the coefficients are negligibly small for all $q \geq 6$.

Finally `exp(logC) * P^2` gives the full coefficient and stores it at position `l` in the vector for mode `q`.

---

The payoff: inside the cost function called hundreds of times by the optimizer, the inner loop reduces to just:

```matlab
s_sum = s_sum + cArr(l) / lam;
```

— a single division per $(l,q)$ pair, where `lam` is the only thing that changes between optimizer calls because it depends on $\sigma$ via $\bar{\sigma} = \sigma R_0^2/\kappa$. All the expensive geometry is already done.



Almost exactly right — just one thing to clarify about **what we sum the cost over**.

---

## The two sums are at different levels

**The sum over $l$** is _inside_ the model — it's how you compute $S_\text{model}(q)$ for one mode $q$:

$$S_\text{model}(q) = \frac{k_BT}{4\kappa} \sum_{\substack{l \geq q \ l+q \text{ even}}} \frac{n_{lq}}{\lambda_l(\kappa,\sigma)}$$

This is not what you minimize — this is just evaluating one number.

**The cost sum is over $q$** — comparing data vs model at each measured mode:

$$\text{cost}(\kappa,\sigma) = \sum_{q=6}^{20} \left(\log_{10} S_\text{data}(q) - \log_{10} S_\text{model}(q)\right)^2$$

---

## So the full structure is

```
cost(kappa, sigma):
    for each q in [6,7,...,20]:           <- outer sum: defines the cost
        S_model(q) = kBT/(4*kappa)
                   * sum over l>=q:       <- inner sum: evaluates one model point
                         n_lq / lambda_l(kappa, sigma)
        cost += (log10 S_data(q) - log10 S_model(q))^2
    return cost
```

Which maps exactly to the code:

```matlab
for ii = 1:length(nFit)       % <- loop over q: builds up the cost
    q     = nFit(ii);
    s_sum = 0;
    for l = q:lmax             % <- loop over l: evaluates S_model(q)
        lam    = (l-1)*(l+2)*(l*(l+1) + sbar);
        s_sum  = s_sum + cArr(l)/lam;
    end
    S_mod(ii) = (kBT/kap) * s_sum / 4;
end
cost = sum((log10(dataFit) - log10(S_mod)).^2);
```

---

## What you're really fitting

You're not fitting $\lambda_l$ directly — $\lambda_l$ is determined by $\kappa$ and $\sigma$ through:

$$\lambda_l = (l-1)(l+2)\left[l(l+1) + \bar\sigma\right] \quad \text{where} \quad \bar\sigma = \frac{\sigma R_0^2}{\kappa}$$

So the two free parameters $(\kappa, \sigma)$ control the _shape_ of $S_\text{model}(q)$ through $\lambda_l$, and the _amplitude_ through the $k_BT/4\kappa$ prefactor. The optimizer searches for the $(\kappa, \sigma)$ pair that makes $S_\text{model}(q)$ match $S_\text{data}(q)$ at all 15 modes simultaneously.

Does that clarify the structure? Ready to continue with Stage 2 of the grid?



## The fitting — equations, code, and explanation together

---

### Step 1: Select the data to fit

We only use modes $q = 6$ to $q = 20$. Below 6: rigid-body drift. Above 20: detection noise.

$$S_\text{data}(q), \quad q \in {6, 7, \ldots, 20}$$

```matlab
fitMask = (nVec >= qMin) & (nVec <= qMax);
nFit    = nVec(fitMask);      % [6;7;8;...;20] — 15 values
dataFit = spectrum(fitMask);  % measured S(q) at those 15 modes
```

`fitMask` is a logical vector — `true` at positions 6–20, `false` everywhere else. `nFit` and `dataFit` are just the 15 values we care about.

---

### Step 2: Define the parameter space

We search for two parameters in **log-space**:

$$p_1 = \log_{10}!\left(\frac{\kappa}{k_BT}\right), \qquad p_2 = \log_{10}(\sigma)$$

Why log-space? Because $\sigma$ spans 6 orders of magnitude. A step of 0.1 in log-space means a 26% change — same proportional sensitivity everywhere. In linear space a step of $10^{-9}$ near $\sigma = 10^{-9}$ is huge, but near $\sigma = 10^{-5}$ it's invisible.

```matlab
lkap_c = linspace(0.5, 2.5, 25);  % log10(kappa/kBT): covers 3 to 316 kBT
lsig_c = linspace(-10, -4, 25);   % log10(sigma):     covers 1e-10 to 1e-4 N/m
```

25 values each → $25 \times 25 = 625$ candidate pairs. Wide enough to cover all physically reasonable values.

---

### Step 3: Initialize the search

```matlab
best_cost_c = inf;    % best cost found so far — start at infinity
best_lk_c   = 1.2;   % will be overwritten on first valid point
best_ls_c   = -7;
```

`inf` guarantees the first valid point always becomes the initial best, no matter how bad it is.

---

### Step 4: The outer loops — candidate pairs

```matlab
for ci = 1:length(lkap_c)
    for cj = 1:length(lsig_c)

        kap  = 10^lkap_c(ci) * kBT;   % kappa in Joules
        sig  = 10^lsig_c(cj);          % sigma in N/m
        sbar = sig * R0^2 / kap;       % sigma_bar = sigma*R0^2/kappa
```

For each of the 625 pairs, convert from log-space back to physical units. $\bar\sigma$ is derived — not searched over.

---

### Step 5: Evaluate $S_\text{model}(q)$ — the inner loops

This is the Pécréaux/Milner-Safran formula:

$$S_\text{model}(q) = \frac{k_BT}{4\kappa} \sum_{\substack{l \geq q \ l+q \text{ even}}}^{l_\text{max}} \frac{n_{lq}}{\lambda_l}$$

with the Milner-Safran eigenvalue:

$$\lambda_l = (l-1)(l+2)\left[l(l+1) + \bar\sigma\right]$$

```matlab
        S_mod = zeros(length(nFit), 1);
        ok    = true;

        for ii = 1:length(nFit)        % loop over q = 6,7,...,20
            q     = nFit(ii);
            s_sum = 0;
            cArr  = legCoeff{q};       % precomputed n_lq for this q

            for l = q:lmax             % sum over 3D modes l >= q
                if mod(l+q,2)~=0, continue; end   % parity rule

                lam = (l-1)*(l+2) * (l*(l+1) + sbar);  % lambda_l

                if lam <= 0            % unphysical: tension destabilises sphere
                    ok = false;
                    break;
                end

                s_sum = s_sum + cArr(l) / lam;   % accumulate n_lq / lambda_l
            end

            if ~ok, break; end

            S_mod(ii) = (kBT/kap) * s_sum / 4;  % prefactor kBT/4kappa
        end

        if ~ok || any(S_mod <= 0), continue; end  % skip unphysical pairs
```

Three levels of loops:

- **`ci`, `cj`** — search over candidate $(\kappa, \sigma)$ pairs
- **`ii`** — evaluate model at each of the 15 fit modes $q$
- **`l`** — accumulate the Legendre sum for one $q$

`ok = false` triggers when $\lambda_l \leq 0$ — physically this means the membrane would be unstable. Those parameter combinations are impossible, skip them.

---

### Step 6: The cost function

$$\text{cost}(\kappa, \sigma) = \sum_{q=6}^{20} \left(\log_{10} S_\text{data}(q) - \log_{10} S_\text{model}(q)\right)^2$$

```matlab
        cost_val = sum((log10(dataFit) - log10(S_mod)).^2);

        if cost_val < best_cost_c
            best_cost_c = cost_val;
            best_lk_c   = lkap_c(ci);
            best_ls_c   = lsig_c(cj);
        end
    end
end

fprintf('Coarse best: kappa=%.1f kBT, sigma=%.1e, cost=%.4f\n', ...
    10^best_lk_c, 10^best_ls_c, best_cost_c);
```

`log10(dataFit) - log10(S_mod)` is the vector of residuals — one per mode. Squaring and summing gives a single number that measures how badly the model fits. The pair with the smallest cost wins.

---

### Step 7: Fine grid — zoom in

The coarse grid found the right basin but with coarse precision (~25% per step). The fine grid searches a ±0.4 log-unit window around the coarse best with 40 steps — precision of ~2% per step.

$$\text{search window: } [p_{1,\text{best}} \pm 0.4] \times [p_{2,\text{best}} \pm 0.4]$$

```matlab
hw     = 0.4;
lkap_f = linspace(best_lk_c - hw, best_lk_c + hw, 40);
lsig_f = linspace(best_ls_c - hw, best_ls_c + hw, 40);
```

The fine grid is **identical in structure** to the coarse grid — same loops, same cost, same model. Only the search range and resolution change. That's why the code looks repetitive — it is, intentionally.

```matlab
% [exact same loop structure as coarse grid]
% ...
kappa     = 10^best_lk_f * kBT;
sigma     = 10^best_ls_f;
sigma_bar = sigma * R0^2 / kappa;

fprintf('kappa     = %.1f kBT\n', kappa/kBT);
fprintf('sigma     = %.2e N/m\n', sigma);
fprintf('sigma_bar = %.4f\n',      sigma_bar);
fprintf('cost      = %.4f\n',      best_cost_f);
```

---

Now add this all to the script and run it. The coarse grid takes ~3 minutes, fine grid ~1 minute. Tell me the numbers and we move to the ACF section.Run it. While the coarse grid runs (~3 min), here's the full picture of what's happening visually:

The cost landscape in log-space looks like a valley — elongated because $\kappa$ and $\sigma$ are partially degenerate (many pairs give similar slopes). The coarse grid finds which part of the valley you're in. The fine grid finds the bottom of that valley precisely.

Expected output:

```
Coarse grid (25x25 = 625 points)... best: kappa=~34 kBT, sigma=~1e-8, cost=~0.05
Fine grid (40x40 = 1600 points)... done.

=== FIT RESULTS ===
kappa     = ~34 kBT
sigma     = ~2e-8 N/m
sigma_bar = ~small
cost      = ~0.004
```

Tell me the numbers and we move to Section 6 — the ACF.


Let's build it piece by piece, same as the fitting section.

---

## The ACF — what it is and why we compute it

The power spectrum told you **how much** each mode fluctuates. The ACF tells you **how long** each mode stays correlated — the memory of the fluctuation.

For mode $q$, the autocorrelation function is:

$$C_q(\tau) = \frac{\langle u_q(t+\tau), u_q(t) \rangle}{\langle u_q^2 \rangle}$$

At $\tau=0$: $C_q(0) = 1$ — perfect correlation with itself. As $\tau$ increases, the membrane forgets its shape and $C_q(\tau) \to 0$.

Milner-Safran predicts this decay is a simple exponential:

$$C_q(\tau) = e^{-\tau/\tau_q}$$

where $\tau_q$ is the relaxation time of mode $q$. Measuring $\tau_q$ gives you $\eta_\text{eff}$.

---

## Step 1: Compute the ACF

```matlab
max_lag = min(max_lag_fr, floor(Nt/3));
lags_s  = (0:max_lag)' / fps;
```

`max_lag` is the maximum lag in frames. We cap it at $N_t/3$ — beyond that, the number of independent pairs drops too low for a reliable estimate. In seconds: `lags_s` goes from 0 to `max_lag/fps`.

```matlab
q_acf = q_acf(q_acf >= 1 & q_acf <= nMax);
n_q   = numel(q_acf);
C_q   = zeros(max_lag+1, n_q);
```

One column of `C_q` per mode — each column is a full ACF curve.

```matlab
for qi = 1:n_q
    c_re = real(U(q_acf(qi)+1, :))';   % cosine amplitude a_q(t), Nt x 1
    c_re = detrend(c_re, 1);            % remove linear trend
    [acf, lags_all] = xcorr(c_re, max_lag, 'normalized');
    C_q(:,qi) = acf(lags_all >= 0);    % keep positive lags only
end
```

**`real(U(q+1,:))`** — takes the cosine component $a_q(t)$ of the complex Fourier coefficient. The sine component $b_q(t)$ would give identical results — both components have the same ACF by symmetry.

**`detrend(c_re, 1)`** — removes a linear trend from the time series. Slow drift in the vesicle position or focus can create an artificial slow component in the ACF. Removing it keeps only the genuine fluctuation dynamics.

**`xcorr(...,'normalized')`** — computes the full two-sided ACF and normalizes so $C_q(0)=1$ exactly. `lags_all >= 0` keeps only positive lags — the ACF is symmetric, the negative side is redundant.

---

## Step 2: Fit the exponential — the OLS trick

Taking the log of $C_q(\tau) = e^{-\tau/\tau_q}$:

$$\log C_q(\tau) = -\frac{\tau}{\tau_q}$$

This is a **straight line through the origin** in the variables $(\tau,, \log C_q)$, with slope $-1/\tau_q$. The OLS solution for a line through the origin with one free parameter is exact — no iteration needed:

$$\tau_q = -\frac{\sum_i t_i^2}{\sum_i t_i \log C_q(t_i)}$$

We only fit where $C_q > 0.2$ — below that the signal is in the noise and $\log C_q$ becomes unreliable.

The **95% CI** comes from propagating the residual variance via the delta method:

$$\text{Var}(\tau_q) = \frac{\sigma^2_\text{res} \cdot \tau_q^4}{\sum_i t_i^2}$$

---

## Step 3: Extract η_eff

Once you have $\tau_q$ for each mode, invert the Milner-Safran formula:

$$\tau_q = \frac{\eta_\text{eff} R_0^3}{\kappa \lambda_q} \cdot \frac{4q^2+6q+3}{q(q+1)}$$

$$\Rightarrow \eta_\text{eff} = \frac{\tau_q \cdot \kappa \cdot \lambda_q}{R_0^3} \cdot \frac{q(q+1)}{4q^2+6q+3}$$

This gives one estimate per mode. Take the median — more robust than the mean to outliers from noisy ACF fits.

Now add it to your script:Copy that block and paste it at the end of your script after the `fprintf('sigma = ...')` line. Here's a summary of the three subsections so you know what each part does before running:

---

**ACF computation** — for each mode in `q_acf`, extracts the time series of the cosine amplitude $a_q(t)$, detrends it, and computes the normalized autocorrelation. Result: `C_q` matrix, one column per mode, rows = lag times.

**Exponential fit** — for each ACF, restricts to the region where $C_q > 0.2$, takes the log to make it linear, and applies the OLS formula to get $\tau_q$ in one step. Also computes the 95% CI. Result: `tau_q` array and `fit_ok` flag.

**η_eff extraction** — for each successfully fitted mode, inverts the Milner-Safran formula using the already-known $\kappa$ and $\sigma_\text{bar}$ to get one η estimate. Takes the median. Result: `eta_eff` scalar.




---

## The two limiting cases

Starting from the full spectrum:

$$\langle|\hat{u}_q|^2\rangle = \frac{k_BT}{4\kappa} \sum_{\substack{l \geq q \ l+q \text{ even}}} \frac{n_{lq}}{(l-1)(l+2)[l(l+1) + \bar\sigma]}$$

The dimensionless tension $\bar\sigma = \sigma R_0^2/\kappa$ controls which term dominates the denominator.

---

## Limit 1: Pure bending ($\bar\sigma \to 0$)

When tension is negligible, $l(l+1) \gg \bar\sigma$ for all modes, so:

$$(l-1)(l+2)[l(l+1) + \bar\sigma] \approx (l-1)(l+2),l(l+1) \approx l^4$$

The spectrum becomes:

$$\langle|\hat{u}_q|^2\rangle \approx \frac{k_BT}{4\kappa} \sum_{l \geq q} \frac{n_{lq}}{l^4}$$

The sum converges fast and the dominant contribution comes from $l \approx q$, giving:

$$\langle|\hat{u}_q|^2\rangle \propto \frac{k_BT}{\kappa, q^4} \quad \text{(in 3D)}$$

But remember you measure the equatorial projection — integrating over $q_y$ costs one power of $q$, giving the slope you actually observe:

$$\langle|\hat{u}_q|^2\rangle \propto q^{-3}$$

**What this means practically:** slope = −3 in log-log. You can fit both $\kappa$ and $\sigma$ independently — $\kappa$ controls the amplitude, $\sigma$ is consistent with zero. Your baseline shows this: slope = −3.1, σ̄ = 27 (small).

---

## Limit 2: High tension ($\bar\sigma \gg l(l+1)$)

When tension dominates, $l(l+1) + \bar\sigma \approx \bar\sigma$ for all modes in your fit range, so:

$$(l-1)(l+2)[l(l+1) + \bar\sigma] \approx \bar\sigma,(l-1)(l+2) \approx \bar\sigma, l^2$$

The spectrum becomes:

$$\langle|\hat{u}_q|^2\rangle \approx \frac{k_BT}{4\kappa,\bar\sigma} \sum_{l \geq q} \frac{n_{lq}}{l^2} \propto \frac{k_BT}{\sigma R_0^2}, \frac{1}{q^2} \quad \text{(in 3D)}$$

After equatorial projection:

$$\langle|\hat{u}_q|^2\rangle \propto q^{-1}$$

**What this means practically:** slope = −1 in log-log. The spectrum is nearly flat. The key consequence: **$\kappa$ disappears from the formula** — it cancels with $\bar\sigma = \sigma R_0^2/\kappa$. Only $\sigma$ is measurable. This is the degeneracy problem you hit in the post-heat segments.

---

## The crossover

The crossover between the two regimes happens at mode $q^*$ where $l(l+1) \approx \bar\sigma$, i.e.:

$$q^* \approx \sqrt{\bar\sigma} = R_0\sqrt{\frac{\sigma}{\kappa}}$$

For your baseline: $\bar\sigma = 27$, so $q^* \approx 5$ — the crossover is below your fit range, which is why you see a clean −3 slope from q=6 upward.

For your post-heat: $\bar\sigma \sim 150$–200, so $q^* \approx 13$ — the crossover sits **inside** your fit range q=6–20. This is why the spectrum has slope ~−2 in that range and neither pure limit applies. The fit can find a (κ, σ) pair that matches the slope, but many pairs give the same slope — the valley in the cost landscape.

---

## Summary table

|Regime|Condition|Slope|What you can measure|
|---|---|---|---|
|Pure bending|$\bar\sigma \ll q^2$|−3|κ and σ independently|
|Crossover|$\bar\sigma \sim q^2$|−2 to −3|Both, but degenerate|
|High tension|$\bar\sigma \gg q^2$|−1|σ only, κ drops out|

This is the cleanest way to explain to your advisor why you report κ only from the baseline and σ from all segments.


## Deriving the crossover explicitly

---

### Starting point

The denominator of each term in the sum is:

$$\lambda_l = (l-1)(l+2)\left[l(l+1) + \bar\sigma\right]$$

The two limiting behaviors come from comparing $l(l+1)$ and $\bar\sigma$ inside the bracket. The crossover is defined as the mode $l^*$ where these two terms are exactly equal:

$$l(l+1) = \bar\sigma$$

This is a quadratic equation in $l^*$.

---

### Solving the quadratic exactly

Write it out:

$$(l^_)^2 + l^_ - \bar\sigma = 0$$

This is a standard quadratic $al^{_2} + bl^_ + c = 0$ with $a=1$, $b=1$, $c=-\bar\sigma$. Applying the quadratic formula:

$$l^* = \frac{-1 \pm \sqrt{1 + 4\bar\sigma}}{2}$$

Take the positive root (since $l^*$ must be positive):

$$\boxed{l^* = \frac{-1 + \sqrt{1 + 4\bar\sigma}}{2}}$$

This is the **exact crossover mode**.

---

### The large $\bar\sigma$ approximation

For $\bar\sigma \gg 1$, expand the square root:

$$\sqrt{1 + 4\bar\sigma} = \sqrt{4\bar\sigma}\sqrt{1 + \frac{1}{4\bar\sigma}} \approx 2\sqrt{\bar\sigma}\left(1 + \frac{1}{8\bar\sigma}\right) = 2\sqrt{\bar\sigma} + \frac{1}{4\sqrt{\bar\sigma}}$$

Substituting:

$$l^* = \frac{-1 + 2\sqrt{\bar\sigma} + \frac{1}{4\sqrt{\bar\sigma}}}{2} = \sqrt{\bar\sigma} - \frac{1}{2} + \frac{1}{8\sqrt{\bar\sigma}}$$

For large $\bar\sigma$ the last two terms are negligible:

$$\boxed{l^* \approx \sqrt{\bar\sigma} = R_0\sqrt{\frac{\sigma}{\kappa}}}$$

---

### What happens at $l = l^*$ explicitly

At exactly $l = l^*$, both terms contribute equally to $\lambda_l$:

$$\lambda_{l^_} = (l^_-1)(l^_+2)\left[l^_(l^_+1) + \bar\sigma\right] = (l^_-1)(l^*+2) \cdot 2\bar\sigma$$

compared to the two limits:

$$\lambda_{l^_}\big|_{\bar\sigma=0} = (l^_-1)(l^_+2)\cdot l^_(l^_+1) = (l^_-1)(l^*+2)\cdot\bar\sigma$$

$$\lambda_{l^_}\big|_{\bar\sigma\to\infty} = (l^_-1)(l^*+2)\cdot\bar\sigma$$

So at the crossover, $\lambda_{l^*}$ is exactly **twice** what either pure limit would give. The denominator is at its most different from both limits — neither approximation is valid here. This is precisely why fitting in the crossover regime gives degenerate results: the spectrum has contributions from both terms in the bracket simultaneously.

---

### The smooth transition — how the slope changes

To see the slope change continuously, look at how $\lambda_l$ scales with $l$ in different regimes:

$$\lambda_l = (l^2+l-2)(l^2+l+\bar\sigma)$$

Let $x = l^2+l$ (which scales as $l^2$ for large $l$). Then:

$$\lambda_l = (x-2)(x+\bar\sigma) \approx x^2 + \bar\sigma x = x\left(x + \bar\sigma\right)$$

The effective power of $l$ in $\lambda_l$ is:

$$\lambda_l \sim \begin{cases} l^4 & l \ll l^* \quad (\text{bending, slope} -3) \ l^2\bar\sigma & l \gg l^* \quad (\text{tension, slope} -1) \end{cases}$$

At intermediate $l \sim l^*$, the effective scaling is:

$$\lambda_l \sim l^2(l^2 + \bar\sigma) \sim l^2 \cdot 2\bar\sigma \sim l^2$$

giving a local slope of $-2$ in the spectrum — which is exactly what your crossover segments show (slope $\approx -2$).

---

### Applying to your experiments

$$l^* = \frac{-1 + \sqrt{1+4\bar\sigma}}{2}$$

|Segment|$\bar\sigma$|$l^*$ exact|$l^* \approx \sqrt{\bar\sigma}$|slope observed|
|---|---|---|---|---|
|Baseline (exp 1)|0.87|$\frac{-1+\sqrt{4.48}}{2} = 0.56$|0.93|−3.11|
|Post-heat 1 (exp 1)|134|$\frac{-1+\sqrt{537}}{2} = 11.1$|11.6|−2.19|
|Post-heat 2 (exp 1)|223|$\frac{-1+\sqrt{893}}{2} = 14.4$|14.9|−2.01|
|Baseline (exp 3)|296|$\frac{-1+\sqrt{1185}}{2} = 16.7$|17.2|−1.87|

The pattern is clear: when $l^_$ is below your fit range (q=6), the entire fit range sees bending and slope ≈ −3. When $l^_$ is inside your fit range, you see crossover and slope between −2 and −1. When $l^*$ is above your fit range, the entire window sees tension and slope ≈ −1.

Your fit range q=6–20 is sensitive to crossover when:

$$6 \lesssim l^* \lesssim 20 \implies 6 \lesssim \sqrt{\bar\sigma} \lesssim 20 \implies 36 \lesssim \bar\sigma \lesssim 400$$

Outside this window you either measure pure bending (σ̄ < 36) or pure tension (σ̄ > 400) — and in the pure tension case κ becomes unmeasurable.


Exp1_DOPC_40x_45fps_1
Thermal_cycles_100_40x_50fps_3
Thermal_lightON_vesicle_exptime01_50fps_40x_1
Thermal_thenLightOn_50fps_40x_11
Vesicle_Light_cycles_40x_50fps_4