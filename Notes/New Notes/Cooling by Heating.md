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

# ☀️ Clustering inducido por gradiente térmico en recubrimientos de oro

## 🔥 Entalpía en el fluido inducida por iluminación

Cuando una capa delgada de **oro sobre un coverslip** se ilumina (incluso con luz de fluorescencia no láser), **absorbe calor** y genera un **gradiente térmico lateral** $$\nabla_{\parallel} T$$ en la interfase oro–fluido.

### 🔬 Definición de entalpía

$$
H = U + PV
$$

A presión constante:

$$
\Delta H = \int_V \rho c_p \Delta T \, dV
$$

Este incremento de entalpía proviene del calor absorbido en la zona iluminada y se redistribuye al bulk principalmente por conducción.

---

## 🌊 Slip termo-osmótico: mecanismo principal de flujo

La superficie de oro, al calentarse, induce un deslizamiento ("slip") en la capa de solvatación del fluido adyacente:

$$
u_s = -\frac{1}{\eta} \int_0^{\infty} z\, h(z)\, dz \cdot \nabla_{\parallel}T
$$

Donde:

- $$u_s$$: velocidad de slip sobre la pared.  
- $$h(z)$$: exceso de entalpía en la capa de solvatación.  
- $$\eta$$: viscosidad del fluido.

Este flujo paralelo a la superficie genera un bombeo radial hacia la zona caliente.

---

## 🔁 Formación de flujo toroidal

En una celda de $$\sim 100\, \mu \mathrm{m}$$ de espesor:

- El slip en la **pared inferior** (oro) genera un flujo **hacia el centro iluminado**.
- La **pared superior** genera un flujo opuesto (más débil o contrario en dirección).
- Resultado: una **célula toroidal de recirculación** con flujo convergente en el plano y ascendente en el centro.

Este flujo domina sobre convección natural (número de Rayleigh $$\ll 1700$$).

---

## 🔴 Clustering de partículas

### 🌀 ¿Por qué las partículas se agrupan?

1. **Advección radial**: el flujo convergente las lleva hacia el centro.  
2. **Atracción hidrodinámica mutua**.  
3. **Jamming + van der Waals**.

---

## 🚫 ¿Por qué no se escapan hacia arriba?

- **Condiciones de no-deslizamiento**: $$w(z=0) = 0$$.  
- **Termofóresis vertical**: para PS, $$S_T < 0$$.  
- **Presión inducida por lubricación**:

$$
F_z \approx -\frac{3 \pi \eta a^2 u_s}{2 \delta}
$$

---

## 🧪 Comprobaciones experimentales sugeridas

| Ensayo                            | Resultado esperado                         |
|----------------------------------|--------------------------------------------|
| Recubrir el oro con Pluronic     | Se invierte el flujo → partículas se dispersan |
| Disminuir altura a 20 µm         | Flujo toroidal colapsa → clúster desaparece |
| Trazadores fluorescentes + PIV   | Flujo radial intenso en la base, retorno lento arriba |
| Apagar luz brevemente            | Clúster se dispersa en ~1 s                |

---

## 📚 Referencias clave

- Di Leonardo et al., PRL, 2011.  
- Weinert & Braun, J. Appl. Phys., 2008.  
- Bregulla et al., ACS Nano, 2014.  
- Yang & Ripoll, Soft Matter, 2020.

---

**Cristian Villalobos-Conchaa – Obsidian Note – Junio 2025**
