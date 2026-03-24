---
title: 04_Flickering_Spectrum_Computation
date: '2026-03-24'
status: active
tags:
topic: 
- membrane-physics
project:
---
# Flickering Spectrum Computation

Tags: #GUV #flickering #MATLAB #FFT #code

---

## Contour to Relative Fluctuation

The vesicle contour is sampled as $r(\phi_j, t)$ in polar coordinates, with $\phi_j = 2\pi j/N_\text{ang}$ and $j = 0, \ldots, N_\text{ang}-1$. The relative radial fluctuation:

$$u(\phi, t) = \frac{r(\phi, t)}{\bar{R}(t)} - 1, \qquad \bar{R}(t) = \frac{1}{N_\text{ang}}\sum_j r(\phi_j, t)$$

Dividing by $\bar{R}(t)$ removes instantaneous center-of-mass translation; subtracting the time-mean over all $\phi$ ensures zero mean per frame (removes the $q=0$ mode).

---

## DFT and the Factor of 2

```matlab
U = fft(uMat, [], 1) / Nang;
```

`fft(...,[],1)` takes the DFT along the angular dimension. Dividing by `Nang` ($= N_\theta$) gives properly normalized coefficients so that Parseval's theorem holds — amplitudes independent of sampling density.

$$\hat{U}_q(t) = \frac{1}{N_\text{ang}} \sum_{j=0}^{N_\text{ang}-1} u(\phi_j, t)\, e^{-iq\phi_j}$$

```matlab
Uq_sq = 2 * abs(U(2:nMax+1, :)).^2;
```

**Why the factor of 2?** Since $u(\phi,t)$ is real, the DFT is Hermitian: $\hat{U}_{-q} = \hat{U}_q^*$, so $|\hat{U}_{-q}|^2 = |\hat{U}_q|^2$. The positive-frequency half returned by `fft` represents both $+q$ and $-q$. Multiplying by 2 accounts for both contributions and gives the correct two-sided power. Forgetting it would halve the spectrum and bias $\kappa$ upward.

`U(2:nMax+1,:)` picks rows $q = 1, 2, \ldots, n_\text{max}$, skipping row 1 which is $q=0$.

---

## Time Average and SEM

```matlab
spectrum = mean(Uq_sq, 2);
sem_spec = std(Uq_sq, 0, 2) / sqrt(Nt);
```

`mean(Uq_sq,2)` averages over the time axis:

$$\langle|\hat{u}_q|^2\rangle = \frac{1}{N_t}\sum_{t=1}^{N_t} 2|\hat{U}_q(t)|^2$$

By ergodicity (valid for equilibrium thermal fluctuations), this time average equals the ensemble average predicted by theory. The SEM shrinks as $1/\sqrt{N_t}$ — longer recordings give tighter error bars.

---

## Precomputing the Legendre Coefficients

The Pécréaux formula (see [[03_Pecreaux_Projection_Formula]]) is:

$$\langle|\hat{u}_q|^2\rangle = \frac{k_BT}{4\kappa} \sum_{\substack{l=q \\ l+q\;\text{even}}}^{l_\text{max}} \underbrace{\frac{2l+1}{\pi}\frac{(l-q)!}{(l+q)!}\left[P_l^q(0)\right]^2}_{\text{coeff}(l,q)} \cdot \frac{1}{\lambda_l}$$

The part $\text{coeff}(l,q)$ depends only on geometry — not on $\kappa$ or $\sigma$. It never changes during the fit. Computed once and stored:

```matlab
legCoeff = cell(nMax, 1);
for n = 1:nMax
    coeffs_l = zeros(lmax, 1);
    for l = n:lmax
        if mod(l+n, 2) ~= 0, continue; end   % parity selection rule

        a = (l+n)/2;   b = (l-n)/2;
        logP = gammaln(2*a+1) - a*log(2) - gammaln(a+1) ...
             - b*log(2)        - gammaln(b+1);
        P    = ((-1)^a) * exp(logP);           % P_l^q(0) in log-space

        logC     = log(2*l+1) - log(pi) + gammaln(l-n+1) - gammaln(l+n+1);
        coeffs_l(l) = exp(logC) * P^2;         % full geometric weight
    end
    legCoeff{n} = coeffs_l;
end
```

**Parity rule:** `mod(l+n,2)~=0` skips terms where $l+q$ is odd — $P_l^q(0) = 0$ there exactly, so no work is wasted.

**Log-space arithmetic:** $(l-q)!/(l+q)!$ and $(l+m)!$ overflow double precision for $l \gtrsim 85$. Working in log-gamma avoids this. `gammaln(n)` computes $\log\Gamma(n) = \log(n-1)!$ for any $n$.

**Payoff:** inside the cost function (called hundreds of times by the optimizer), the inner loop reduces to:

```matlab
s_sum = s_sum + cArr(l) / lam;
```

One division per $(l,q)$ pair. `lam` is the only thing that changes between optimizer calls since it depends on $\sigma$ through $\bar\sigma = \sigma R_0^2/\kappa$.

---

## Convergence

For $q=6$ each term decays as $\sim l^{-15}$; contributions beyond $l \approx 20$ are negligible. $l_{\max} = 200$ is conservative by orders of magnitude.

---

## Related Notes

- [[03_Pecreaux_Projection_Formula]]
- [[05_Flickering_Fitting_Procedure]]
