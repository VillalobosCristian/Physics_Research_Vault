To-do. 

[  ] Use fluorescent microparticles as temperature probes to map the 2D temperature profile around the laser spot.
[  ] Calibrate temperature response with controlled heating experiments.
 - smaller particles to do PIV experiments?
 - Size particles? 
 - Force balance analysis
 - laser power analysis

# Analysis ideas

- Define the light zone in the first image, then start to doing the number of particles in time and studying the cluster formation. 
- Typical equation for the saturation process (before going 2-D), $N(t) = N_0(1-e^{-t/\tau})$  

## Convection

The Rayleigh number $\mathrm{Ra}$ determines whether buoyancy driven natural convection occurs. 
Is defined as: 
$$Ra = \frac{g\beta\Delta T L^3}{\nu\alpha}$$

Where:

- $g$ = gravitational acceleration 
- $\beta$ = thermal expansion coefficient of the fluid (~$2.1 \times 10^{-4}$ K⁻¹ for water)
- $\Delta T$ = temperature difference across the gap
- $L$ = characteristic length (gap height in this case)
- $\nu$ = kinematic viscosity (~$0.89 \times 10^{-6}$ m²/s for water)
- $\alpha$ = thermal diffusivity (~$1.43 \times 10^{-7}$ m²/s for water)

![[Pasted image 20250617135811.png]]


## Forces on the particle 

The forces acting on the particle are: 

$$\mathbf{F}_{th}+\mathbf{F}_{drag}+\mathbf{F}_{grav}+\mathbf{F}_{lub}+\mathbf{F}_{DLVO}=0$$
