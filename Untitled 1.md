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


