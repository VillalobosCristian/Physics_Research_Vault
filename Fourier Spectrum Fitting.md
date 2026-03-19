Contour Decomposition into Fourier Modes

The vesicle contour is sampled as $r(\phi_j, t)$ in polar coordinates, with $\phi_j = 2\pi j/N_\text{ang}$ and $j = 0, \ldots, N_\text{ang}-1$. The relative radial fluctuation is defined as:

$$u(\phi, t) = \frac{r(\phi, t)}{\bar{R}(t)} - 1, \qquad \bar{R}(t) = \frac{1}{N_\text{ang}}\sum_j r(\phi_j, t)$$

Dividing by $\bar{R}(t)$ removes instantaneous center-of-mass translation; subtracting the mean over all $\phi$ ensures zero mean. The equilibrium radius $R_0 = \langle \bar{R}(t) \rangle_t$ is computed separately.

The discrete Fourier transform of the contour at each frame is:

$$\hat{U}_q(t) = \frac{1}{N_\text{ang}} \sum_{j=0}^{N_\text{ang}-1} u(\phi_j, t), e^{-iq\phi_j}$$
