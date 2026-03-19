Contour Decomposition into Fourier Modes

The vesicle contour is sampled as $r(\phi_j, t)$ in polar coordinates, with $\phi_j = 2\pi j/N_\text{ang}$ and $j = 0, \ldots, N_\text{ang}-1$. The relative radial fluctuation is defined as:

$$u(\phi, t) = \frac{r(\phi, t)}{\bar{R}(t)} - 1, \qquad \bar{R}(t) = \frac{1}{N_\text{ang}}\sum_j r(\phi_j, t)$$

Dividing by $\bar{R}(t)$ removes instantaneous center-of-mass translation; subtracting the mean over all $\phi$ ensures zero mean. The equilibrium radius $R_0 = \langle \bar{R}(t) \rangle_t$ is computed separately.

The discrete Fourier transform of the contour at each frame is:

$$\hat{U}_q(t) = \frac{1}{N_\text{ang}} \sum_{j=0}^{N_\text{ang}-1} u(\phi_j, t), e^{-iq\phi_j}$$
## Helfrich Hamiltonian for a Quasi-Spherical Vesicle

The 3D shape of a vesicle fluctuating around a sphere of radius $R_0$ is expanded in real spherical harmonics:

$$r(\theta,\phi) = R_0 \left[1 + \sum_{l=2}^{\infty}\sum_{m=-l}^{l} u_{lm}, Y_l^m(\theta,\phi)\right]$$

where $u_{lm}$ are dimensionless complex amplitudes (with $u_{l,-m} = (-1)^m u_{lm}^*$ for a real surface). The Helfrich free energy (bending + tension) evaluated to quadratic order in $u_{lm}$ is:

$$\mathcal{H} = \frac{\kappa}{2R_0^2} \sum_{l,m} \lambda_l, |u_{lm}|^2$$

with the eigenvalue:

$$\boxed{\lambda_l = l(l+1)\left[(l-1)(l+2) + \bar{\sigma}\right]}$$

where $\bar{\sigma} = \sigma R_0^2/\kappa$ is the dimensionless (reduced) tension. Equivalently, expanding the product:

$$\lambda_l = l^2(l+1)^2 - (2-\bar{\sigma}),l(l+1)$$
# Projection onto the Equatorial 2D Contour

This comes from the paper [[pécréaux2004_Refined contour analysis of GUVs]], which is the most accepted method for fitting the contour.