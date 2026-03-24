---
title: 06_ACF_Viscosity_Extraction
date: '2026-03-24'
status: active
tags:
topic: 
- membrane-physics
project:
---
# ACF, Relaxation Times, and Viscosity Extraction

Tags: #GUV #ACF #viscosity #Milner-Safran #MATLAB

---

## Why Compute the ACF?

The power spectrum gives $\kappa$ and $\sigma$ from **how much** each mode fluctuates. The autocorrelation function gives $\eta_\text{eff}$ from **how fast** modes decorrelate — the memory of the fluctuation.

Each 3D mode $u_{lm}$ satisfies an overdamped Langevin equation:

$$\gamma_l\,\dot{u}_{lm} = -\frac{\kappa\,\lambda_l}{R_0^2}\,u_{lm} + \xi_{lm}(t)$$

This is an Ornstein-Uhlenbeck process, giving exponential decay:

$$C_q(\tau) = \frac{\langle \hat{u}_q(t+\tau)\,\hat{u}_q^*(t)\rangle}{\langle|\hat{u}_q|^2\rangle} = e^{-\tau/\tau_q}$$

The 2D projected ACF is formally a multi-exponential sum, but since $\tau_l \sim l^{-3}$ (bending regime), the slowest mode ($l=q$) dominates at long lags, making the single-exponential approximation valid for $C_q(\tau) > 0.2$.

---

## Computing the ACF in Code

```matlab
for qi = 1:n_q
    c_re = real(U(q_acf(qi)+1, :))';   % cosine amplitude a_q(t)
    c_re = detrend(c_re, 1);            % remove linear drift
    [acf, lags_all] = xcorr(c_re, max_lag, 'normalized');
    C_q(:,qi) = acf(lags_all >= 0);    % keep positive lags only
end
```

**`real(U(q+1,:))`** — the cosine component $a_q(t)$ of the complex Fourier coefficient. The sine component gives identical results by symmetry.

**`detrend(c_re,1)`** — removes a linear trend. Slow drift in vesicle position or focus creates an artificial slow component in the ACF. The $A=1$ assumption in the fit (see below) requires a stationary signal.

**`xcorr(...,'normalized')`** — full two-sided ACF normalized so $C_q(0) = 1$ exactly. Only positive lags are kept (ACF is symmetric).

**Lag limit:** capped at $N_t/3$ — beyond this the number of independent pairs drops too low for reliable estimation.

---

## OLS Fit for $\tau_q$ — No Iteration Needed

Taking the log of $C_q(\tau) = e^{-\tau/\tau_q}$:

$$\log C_q(\tau) = -\frac{\tau}{\tau_q}$$

This is a straight line through the origin. The OLS solution for one parameter is analytic:

$$\boxed{\tau_q = -\frac{\sum_i t_i^2}{\sum_i t_i \log C_q(t_i)}}$$

Only points where $C_q > 0.2$ are used — below this the signal is in the noise and $\log C_q$ becomes unreliable.

```matlab
mask_fit = C_q(:,qi) > 0.2;
t_fit    = lags_s(mask_fit);
y_fit    = log(C_q(mask_fit, qi));
tau_q(qi) = -sum(t_fit.^2) / sum(t_fit .* y_fit);
```

---

## Uncertainty via Delta Method

The residuals are $\varepsilon_i = \log C_q(t_i) + t_i/\tau_q$. Residual variance (1 free parameter):

$$\hat\sigma^2 = \frac{1}{n-1}\sum_i \varepsilon_i^2$$

Propagating $\tau_q = -S_{tt}/S_{ty}$ where $S_{tt} = \sum t_i^2$ and $S_{ty} = \sum t_i \log C_q$:

$$\text{Var}(\tau_q) = \frac{\hat\sigma^2\,\tau_q^4}{\sum_i t_i^2}$$

95% CI: $\tau_q \pm 1.96\sqrt{\text{Var}(\tau_q)}$.

```matlab
res      = y_fit + t_fit / tau_q(qi);
sigma2   = sum(res.^2) / (n - 1);
var_tau  = sigma2 * tau_q(qi)^4 / sum(t_fit.^2);
ci95(qi) = 1.96 * sqrt(var_tau);
```

---

## Milner-Safran Reference Curves

Theoretical predictions for $\tau_q$ from Milner & Safran (1987):

**Bending-dominated** ($\bar\sigma \ll q^2$):

$$\tau_q^\text{bend} \approx \frac{4\eta R_0^3}{\kappa\, q^3}$$

**Tension-dominated** ($\bar\sigma \gg q^2$):

$$\tau_q^\text{tens} \approx \frac{\eta R_0}{\sigma\, q}$$

These are plotted as $q^{-3}$ and $q^{-1}$ power laws using $\eta_\text{water} = 10^{-3}$ Pa·s. Where your measured $\tau_q$ falls between these curves identifies the dominant relaxation mechanism at each mode number.

---

## Extracting $\eta_\text{eff}$

Invert the Milner-Safran formula per mode:

$$\eta_\text{eff} = \frac{\tau_q \cdot \kappa \cdot \lambda_q}{R_0^3} \cdot \frac{q(q+1)}{4q^2+6q+3}$$

One estimate per mode. Take the **median** — more robust than the mean to outliers from noisy ACF fits.

---

## Related Notes

- [[02_Helfrich_Hamiltonian_GUV]]
- [[05_Flickering_Fitting_Procedure]]
- [[07_Bending_Tension_Regimes]]
