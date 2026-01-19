---
tags:
  - "#physics"
  - "#membranes"
  - "#interface-physics"
  - "#two-dimensional-surfaces"
  - "#helfrich-model"
  - "#spherical-harmonics"
  - "#membrane-biophysics"
---
The total energy of the system is given by the Helfrich model:
$$E=\frac{\kappa}{2}\int_A \mathrm{d}A\ (c_1+c_2)^2+\sigma A+pV$$
where $\kappa$ is the bending rigidity, $c_1$ and $c_2$ are the local radii curvature, $\sigma$ is the [[Surface tension]], $A$ the total surface area, $p$ is the pressure difference inside the membrane, and $V$ is the interior volume of the vesicle. 


## <font color="#c00000"> Helfrich Energy Functional</font>

The Helfrich energy  for a closed vesicle without [[Spontaneous curvature]] can be written as:

$$E = \frac{\kappa}{2} \int (2H)^2\, dA + \sigma \int dA + \Delta p \int dV,$$

where
   $\kappa$ is the bending rigidity.
   $H=\frac{1}{2}(c_1+c_2)$ is the mean curvature of the membrane surface.
   $\sigma$ is the [[Surface tension]].
   $\Delta p$ is the pressure difference between the inside and outside of the vesicle. 
   $dA$ is the surface element.
   $dV$ is the volume element enclosed by the membrane. 

For a sphere of radius $R_0$, the mean curvature is constant, $H = 1/(2R_0)$, and the equilibrium energy has contributions from bending, tension, and the pressure-volume term. At equilibrium, $R_0$ is determined by balancing these terms under the constraints of fixed total area $A_0=4\pi R_0^2$ and fixed volume $V_0=\frac{4}{3}\pi R_0^3$.

## Volume and Area Constrains

 The fluid inside the membrane is incompressible and the volume is essentially fixed. 
 The area is also approx fixed since the cost of energy to stretch a lipid bilayer is high. 
 Assuming this, we have $\Delta V \approx 0$, and $\Delta A \approx 0$

Consider a coordinate system $(r,\theta,\phi)$ where $\theta$ is the polar angle ($0 \leq \theta \leq \pi$) and $\phi$ is the azimuthal angle ($0 \leq \phi < 2\pi$). For a perfect sphere of radius $R_0$, every point on the surface is given by:

We start from the assumption that a lipid vesicle at equilibrium is a perfect sphere. This is a natural baseline configuration when there are no external perturbations or imbalances. We then consider a small deformation of the vesicle and introduce a dimensionless parameter to measure these deformations.
In spherical coordinates $(\theta,\phi)$, a perfect sphere of radius $R_0$ is described as:

$$R_{\text{sphere}}(\theta,\phi) = R_0.$$
This means that at every point on the surface, regardless of direction, the radial distance from the center is the same.
## Introducing a Small Perturbation

Now, suppose the vesicle is slightly deformed due to various factors (e.g., [[Thermal fluctuations]], chemical gradients, or external fields). The radius in a given direction $(\theta,\phi)$ is no longer $R_0$, but slightly different:
$$R(\theta,\phi) = R_0 + \Delta R(\theta,\phi),$$
where $\Delta R(\theta,\phi)$ represents the small deviation from the original radius. The assumption of a *quasi-spherical* vesicle implies:

$$|\Delta R(\theta,\phi)| \ll R_0.$$
This ensures that the deformation is small and can be treated perturbatively.

To simplify the analysis, we define a dimensionless function $u(\theta,\phi)$ that measures the relative change in radius:
$$u(\theta,\phi) = \frac{\Delta R(\theta,\phi)}{R_0}.$$
This scaling is useful because it introduces a small dimensionless parameter $|u(\theta,\phi)| \ll 1$. With this definition, the perturbed radius becomes:

$$R(\theta,\phi) = R_0[1 + u(\theta,\phi)].$$1. **Linearization**: Because $|u|\ll 1$, we can use linear approximations when expanding geometric and energetic quantities. For example, areas, volumes, and curvature terms can be expanded in series of $u$, retaining only first-order terms for a first approximation.

On a sphere, the natural generalization of Fourier modes (which are used on a line or a circle) are spherical harmonics $Y_{\ell m}(\theta,\phi)$. These functions form an orthonormal and complete basis for expansions of scalar functions defined on the sphere.

Any sufficiently smooth function $f(\theta,\phi)$ can be expanded as:

$$f(\theta,\phi) = \sum_{\ell=0}^{\infty}\sum_{m=-\ell}^{\ell} f_{\ell m} Y_{\ell m}(\theta,\phi).$$


The $Y_{\ell m}$ are defined as:

$$Y_{\ell m}(\theta,\phi) = N_{\ell m} P_{\ell}^{m}(\cos\theta)e^{i m \phi},$$

where $P_{\ell}^{m}$ are the associated Legendre polynomials and $N_{\ell m}$ is a normalization constant such that:
$$
\int_0^{2\pi}\int_0^{\pi} Y_{\ell m}(\theta,\phi) Y_{\ell' m'}^*(\theta,\phi)\sin\theta\,d\theta\,d\phi = \delta_{\ell\ell'} \delta_{mm'}.$$

Spherical harmonics diagonalize angular momentum operators and are eigenfunctions of the spherical Laplacian. This makes them extremely convenient for analyzing curvature-related quantities on the vesicle.


2. **Basis for Spherical Harmonics**: The function $u(\theta,\phi)$ naturally lends itself to expansions in terms of spherical harmonics $Y_{\ell m}(\theta,\phi)$. Since these form a complete orthonormal set on the sphere, any small deformation can be written as:

   $$

   u(\theta,\phi) = \sum_{\ell=0}^{\infty}\sum_{m=-\ell}^{\ell} u_{\ell m} Y_{\ell m}(\theta,\phi).

   $$

3. **Perturbative Energies**: When analyzing the Helfrich energy or related curvature energies, substituting $R(\theta,\phi) = R_0[1 + u(\theta,\phi)]$ makes it straightforward to identify the leading-order contributions of shape fluctuations.


We now expand the perturbation $u(\theta,\phi)$ in terms of spherical harmonics:

$$u(\theta,\phi) = \sum_{\ell=0}^{\infty}\sum_{m=-\ell}^{\ell} u_{\ell m} Y_{\ell m}(\theta,\phi).$$
Thus, the full vesicle radius can be written as:
$$R(\theta,\phi) = R_0 \left[1 + \sum_{\ell=0}^{\infty}\sum_{m=-\ell}^{\ell} u_{\ell m} Y_{\ell m}(\theta,\phi)\right].
$$
Each pair $(\ell,m)$ represents a particular angular mode of deformation. Modes with low $\ell$ correspond to large-scale, low-frequency deformations, while high $\ell$ modes represent more intricate shape fluctuations.




