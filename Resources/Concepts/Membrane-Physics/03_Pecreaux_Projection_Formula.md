# Pécréaux Equatorial Projection Formula

Tags: #GUV #Pecreaux #projection #Legendre #derivation

---

## The Problem

The microscope images only the equatorial slice at $\theta = \pi/2$. The question is: what is the theoretical variance $\langle|\hat{u}_q|^2\rangle$ of the 2D Fourier modes in terms of the 3D parameters $\kappa$ and $\sigma$?

---

## Step A — Evaluating $Y_l^m$ at the Equator

The complex spherical harmonics (Condon-Shortley convention):

$$Y_l^m(\theta,\phi) = \underbrace{\sqrt{\frac{2l+1}{4\pi}\frac{(l-m)!}{(l+m)!}}}_{\equiv\; N_{lm}}\; P_l^m(\cos\theta)\; e^{im\phi}$$

At $\theta = \pi/2$ (equator, $\cos\theta = 0$):

$$Y_l^m\!\left(\tfrac{\pi}{2},\phi\right) = N_{lm}\cdot P_l^m(0)\cdot e^{im\phi}$$

### A.1 — Parity Selection Rule

From the Rodrigues representation, $P_l^m(x)$ at $x=0$ requires evaluating the $(l+m)$-th derivative of $(x^2-1)^l$ at $x=0$. Expanding $(x^2-1)^l = \sum_k \binom{l}{k} x^{2k}(-1)^{l-k}$, the derivative at zero selects only the term with $2k = l+m$, which is only an integer when $l+m$ is even. Therefore:

$$\boxed{P_l^m(0) = 0 \quad\text{if}\quad l+m \text{ is odd}}$$

This is a mirror symmetry: the equatorial plane $\theta=\pi/2$ is a reflection plane of the sphere. Harmonics with $l+m$ odd are antisymmetric under this reflection and vanish there. The code exploits this with `if mod(l+q,2)~=0, continue; end`, cutting the inner loop work in half exactly.

### A.2 — Closed Form When $l+m$ is Even

Define $a = (l+m)/2$ and $b = (l-m)/2$. Then:

$$\boxed{P_l^m(0) = (-1)^{(l+m)/2}\cdot\frac{(l+m)!}{2^{l}\,\left[\frac{l+m}{2}\right]!\,\left[\frac{l-m}{2}\right]!}}$$

In the code (`Plm_zero`), computed in log-space to avoid overflow for large $l$:

```matlab
a = (l+n)/2;   b = (l-n)/2;
logP = gammaln(2*a+1) - a*log(2) - gammaln(a+1) ...
     - b*log(2)        - gammaln(b+1);
P    = ((-1)^a) * exp(logP);
```

`gammaln(n)` computes $\log\Gamma(n) = \log(n-1)!$ stably for any $n$. The result is safe because the log is $\mathcal{O}(1)$ even for large $l$. Note: since only $[P_l^m(0)]^2$ appears in the formula, the sign is irrelevant.

---

## Step B — Selection Rule from Fourier Orthogonality

The 2D Fourier coefficient of the equatorial profile:

$$\hat{u}_q \equiv \frac{1}{2\pi}\int_0^{2\pi}u\!\left(\tfrac{\pi}{2},\phi\right)\,e^{-iq\phi}\,d\phi$$

Substituting the full 3D expansion and using the orthogonality $\frac{1}{2\pi}\int e^{i(m-q)\phi}d\phi = \delta_{m,q}$, the sum over $m$ collapses to $m=q$ only:

$$\hat{u}_q = \sum_{l\geq q}\; u_{lq}\,N_{lq}\,P_l^q(0)$$

Applying the parity rule:

$$\boxed{\hat{u}_q = \sum_{\substack{l = q \\ l+q\;\text{even}}}^{L} u_{lq}\;\sqrt{\frac{2l+1}{4\pi}\frac{(l-q)!}{(l+q)!}}\;P_l^q(0)}$$

**Key structural consequence:** a single 2D mode $q$ receives contributions from an entire _ladder_ of 3D modes at $m=q$, separated in $l$ by steps of 2. The equatorial observation mixes together modes that are distinct in 3D.

---

## Step C — Computing the Variance

Write $W_{lq} \equiv N_{lq}\,P_l^q(0)$. Then:

$$\langle|\hat{u}_q|^2\rangle = \sum_{l,l'} W_{lq}\,W_{l'q}\,\langle u_{lq}\,u_{l'q}^*\rangle$$

Since the Helfrich Hamiltonian is diagonal in $(l,m)$, different $l$-modes are statistically independent:

$$\langle u_{lq}\,u_{l'q}^*\rangle = \langle|u_{lq}|^2\rangle\,\delta_{l,l'}$$

Substituting equipartition $\langle|u_{lm}|^2\rangle = k_BT/(\kappa\lambda_l)$ (see [[02_Helfrich_Hamiltonian_GUV]]):

$$\boxed{\langle|\hat{u}_q|^2\rangle = \frac{k_BT}{4\pi\kappa}\sum_{\substack{l \geq q \\ l+q\;\text{even}}}^{L}\frac{(2l+1)(l-q)!}{(l+q)!}\;\frac{[P_l^q(0)]^2}{\lambda_l}}$$

This is the **Pécréaux 2004 equatorial projection formula**. The code implements it as:

```matlab
n_lq = (2*l+1)/pi * factorial(l-q)/factorial(l+q)   % absorbs the 1/pi
S(q) = (kBT/kappa) * s_sum / 4                       % the remaining 1/4
```

i.e. the $1/(4\pi)$ prefactor is split as $(1/4) \times (1/\pi)$.

---

## Step D — Convergence of the Sum

Each term decays as $\sim l^{-2q-3}$ for large $l$ (the weight $N_{lq}^2[P_l^q(0)]^2 \sim l^{-2q}$ and $\lambda_l \sim l^4$ in the bending regime). For $q=6$, terms fall off as $l^{-15}$: contributions beyond $l \approx 20$ are negligible. The choice $l_{\max}=200$ in the code is conservative by orders of magnitude.

---

## Physical Content: Spectral Slopes

| Regime | $\lambda_l$ scaling | Spectrum slope |
|---|---|---|
| Bending dominated ($\bar\sigma \ll l^2$) | $\sim l^4$ | $q^{-3}$ |
| Tension dominated ($\bar\sigma \gg l^2$) | $\sim l^2 \bar\sigma$ | $q^{-1}$ |

See [[07_Bending_Tension_Regimes]] for the crossover derivation.

---

## Related Notes

- [[02_Helfrich_Hamiltonian_GUV]]
- [[04_Flickering_Spectrum_Computation]]
- [[07_Bending_Tension_Regimes]]
