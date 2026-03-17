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