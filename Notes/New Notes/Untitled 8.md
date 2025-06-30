
## Thermal Convection Forces

1. **Stokes' Drag Force** on spherical particles: $$F_{\text{drag}} = 6\pi\eta r v$$ where η is the dynamic viscosity (temperature-dependent), r is particle radius, and v is fluid velocity.
    
2. **Temperature-dependent viscosity** of water: $$\eta(T) = \eta_0 \exp\left(\frac{E_a}{k_B}\left(\frac{1}{T} - \frac{1}{T_0}\right)\right)$$ where η₀ is reference viscosity, E_a is activation energy, k_B is Boltzmann constant.
    
3. **Convective flow velocity** in microscale Rayleigh-Bénard convection: $$v \propto \frac{\beta g \Delta T h^2}{\nu}$$ where β is thermal expansion coefficient, g is gravitational acceleration, ΔT is temperature difference, h is characteristic length, and ν is kinematic viscosity.
    

## Thermophoresis

4. **Thermophoretic velocity**: $$v_{\text{th}} = -D_T \nabla T$$ where D_T is thermophoretic mobility coefficient.
    
5. **Thermophoretic force**: $$F_{\text{th}} = -6\pi\eta r S_T k_B T \nabla T$$ where S_T is the Soret coefficient and ∇T is temperature gradient.
    
6. **Soret coefficient** (empirical dependence on salt concentration): $$S_T(c) = S_T^{\infty} - \frac{S_T^{\infty} - S_T^0}{1 + (c/c_0)^p}$$ where c is salt concentration and c₀ is characteristic concentration where [[Thermophoresis]] effect is halved.
    

## Heat Generation and Distribution

7. **Optical absorption** in gold film: $$A = 1 - e^{-4\pi\kappa d/\lambda}$$ where κ is extinction coefficient, d is film thickness, and λ is wavelength.
    
8. **Heat generation rate**: $$Q = I_0 A$$ where I₀ is incident power density.
    
9. **Temperature increase** at the center of a Gaussian beam spot: $$\Delta T = \frac{P A}{4\pi\kappa_{\text{th}}d}$$ where P is laser power, κ_th is thermal conductivity, and d is beam diameter.
    

## Particle Dynamics and Trapping

10. **Force balance** for stable trapping: $$F_{\text{th}} + F_{\text{optical}} > F_{\text{drag}}$$ where F_optical is the optical gradient force (minimal in this system).
    
11. **Particle distribution** in the trap (Boltzmann statistics): $$n(r) = n_0 \exp\left(-\frac{U(r)}{k_B T}\right)$$ where U(r) is the effective potential energy.
    
12. **Trapping potential** from [[Thermophoresis]]: $$U(r) \approx -k_B T S_T \Delta T \exp\left(-\frac{r^2}{2\sigma^2}\right)$$ where σ is related to the laser spot size.
    
13. **Time-dependent particle accumulation**: $$N(t) = N_{\text{max}}(1 - e^{-t/\tau})$$ where τ is characteristic trapping time, matching the exponential growth observed in the experiments.
    
14. **Critical salt concentration** for trap quenching: $$c_{\text{crit}} \approx 10^{-4} \text{ mol}$$ when |F_th| ≈ F_drag, at which point the trap becomes unstable.
    

These equations collectively describe the physics of how plasmonic heating creates temperature gradients that drive both [[Thermophoresis]] and convection, leading to stable trapping when thermophoretic forces exceed convective drag forces.