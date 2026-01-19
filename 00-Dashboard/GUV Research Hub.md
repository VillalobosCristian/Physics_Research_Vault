# 🔬 GUV Research

> A comprehensive map of Giant Unilamellar Vesicle research concepts and literature for writing.

---

## 📐 Theoretical Foundations

### Membrane Elasticity & Helfrich Theory

The foundation of GUV physics rests on the [[Helfrich model]], which describes membrane energy through [[bending rigidity]] (κ) and [[Gaussian curvature modulus]] (κ̄).

**Key Concepts:**
- [[Bending rigidity]] — The primary elastic modulus (~10-20 kBT for lipid membranes)
- [[Spontaneous curvature]] — Intrinsic membrane curvature from lipid asymmetry
- [[Gaussian curvature]] — Topological contribution (Gauss-Bonnet theorem)
- [[Mean curvature]] — Local membrane shape descriptor
- [[Surface tension]] — Membrane tension and area constraint
- [[Helfrich free energy]] — $F = \frac{\kappa}{2}\oint (2H - C_0)^2 dA + \kappa_G \oint K dA + \sigma \oint dA$

**Literature:**
| Paper | Focus |
|-------|-------|
| helfrich1973 | Original elastic theory |
| zhong-can, helfrich1989 | Bending energy variations |
| seifert1997 | Comprehensive review of configurations |
| deserno2015 | Differential geometry approach |
| bernard, wheeler2018 | Rigidity and stability analysis |

---

### Differential Geometry of Membranes

Understanding GUV shapes requires [[differential geometry]] tools.

**Key Concepts:**
- [[Metric tensor]] — Surface parameterization
- [[Christoffel symbols]] — Covariant derivatives on surfaces
- [[Gauss map]] — Normal vector field mapping
- [[Principal curvatures]] — κ₁, κ₂ defining local shape
- [[Gauss-Bonnet theorem]] — Topological invariant

**Literature:**
| Paper | Focus |
|-------|-------|
| deserno_primer | Introductory treatment |
| deserno2015 | Full mathematical framework |
| schamberger2023 | Curvature quantification methods |

---

## 🌊 Thermal Fluctuations & Dynamics

### Fluctuation Spectroscopy

[[Thermal fluctuations]] of GUVs provide a window into membrane mechanics through [[fluctuation spectroscopy]].

**Key Concepts:**
- [[Membrane fluctuation spectrum]] — $\langle |u_q|^2 \rangle = \frac{k_B T}{\kappa q^4 + \sigma q^2}$
- [[Flickering]] — Observable membrane undulations
- [[Fluctuation tension]] — Renormalized tension from fluctuations
- [[Bending rigidity measurement]] — Extracting κ from power spectra
- [[Contour analysis]] — Image processing for fluctuation extraction

**Literature:**
| Paper | Focus |
|-------|-------|
| faucon, mitov1989 | Early theoretical/experimental requirements |
| milner, safran1987 | Dynamical fluctuations theory |
| döbereiner2003 | Advanced flicker spectroscopy |
| pécréaux2004 | Refined contour analysis |
| méléard, pott2011 | Statistical analysis advantages |
| faizi, reeves2020 | Confocal/phase contrast methods |
| bivas2010 | Nearly spherical vesicle analysis |
| genova, vitkova2013 | Shape fluctuation registration |
| monzel, sengupta2016 | Fluctuation measurement review |
| rautu, orsi2017 | Optical projection effects |

### Membrane Dynamics

**Key Concepts:**
- [[Intermonolayer friction]] — Coupling between leaflets
- [[Hydrodynamic dissipation]] — Viscous damping of fluctuations
- [[Membrane viscosity]] — 2D membrane viscosity
- [[Relaxation dynamics]] — Mode-dependent relaxation times

**Literature:**
| Paper | Focus |
|-------|-------|
| pott, méléard2002 | Intermonolayer friction control |
| miao, lomholt2002 | Quasi-spherical dynamics |
| seifert1999 | Hydrodynamic flow formalism |
| faizi2024 | Hydrodynamic dissipation in bilayer |
| lebedev, turitsyn2008 | External flow effects |

---

## 🔬 Bending Rigidity Measurements

### Measurement Techniques

**Key Concepts:**
- [[Flicker spectroscopy]] — Optical fluctuation analysis
- [[Micropipette aspiration]] — Mechanical measurement
- [[Electrodeformation]] — Electric field response
- [[Tether pulling]] — Force-extension measurements

**Literature:**
| Paper | Focus |
|-------|-------|
| dimova2014 | Comprehensive measurement review |
| bouvrais2012 | Bending rigidity methods |
| karal, billah2023 | Recent measurement review |
| gracià2010 | Cholesterol effects on rigidity |
| pinigin2022 | MD simulation approaches |
| drabik2016 | Fluorescence-based spectroscopy |

---

## 🧪 GUV Preparation & Characterization

### Electroformation & Methods

**Key Concepts:**
- [[Electroformation]] — Standard GUV preparation
- [[Gentle hydration]] — Alternative swelling method
- [[Size distribution]] — Polydispersity control
- [[Lipid composition]] — DOPC, DPPC, cholesterol effects

**Literature:**
| Paper | Focus |
|-------|-------|
| morales-penningston2010 | Preparation artifacts |
| boban, mardešić2021 | Electroformation optimization |
| nair, bajaj2023 | Preparation techniques review |
| karal, ahmed2020 | Electrostatic effects on size |
| walde, cosentino2010 | Preparations and applications |

### Reference Books
- [[The Giant Vesicle Book]] — Dimova & Marques (2019) - Comprehensive reference

---

## ⚛️ Particle-Membrane Interactions

### Wrapping & Engulfment

[[Membrane wrapping]] of particles is central to understanding cellular uptake and synthetic cell design.

**Key Concepts:**
- [[Wrapping transition]] — Partial to full engulfment
- [[Wrapping energy]] — Bending vs adhesion competition
- [[Adhesion energy]] — Particle-membrane binding
- [[Endocytosis]] — Biological uptake mechanism
- [[Membrane deformation]] — Shape response to particles

**Literature:**
| Paper | Focus |
|-------|-------|
| deserno, bickel2003 | Spherical colloid wrapping |
| deserno2004 | Elastic deformation on binding |
| lipowsky, döbereiner1998 | Nanoparticle contact |
| mirigian, muthukumar2013 | Wrapping kinetics |
| bahrami, raatz2014 | Nanoparticle wrapping |
| bahrami2024 | Cooperative engulfment |
| fessler, muller2025 | Membrane neck energetics |
| redwan, du2024 | 3D wrapping simulations |
| spanke, style2020 | Floppy vesicle wrapping |

### Particle Assembly on Membranes

**Key Concepts:**
- [[Membrane-mediated interactions]] — Curvature-induced attractions
- [[Capillary forces on membranes]] — Deformation-mediated binding
- [[Particle clustering]] — Assembly on GUV surface

**Literature:**
| Paper | Focus |
|-------|-------|
| wel2016 | Curvature-mediated attractions |
| van der wel2017 | Microparticle assembly pathways |
| ewins, han2022 | Janus particle adhesion |

### Particle Uptake Dynamics

**Literature:**
| Paper | Focus |
|-------|-------|
| ayala2023 | Thermal fluctuations in uptake |
| fessler, sharma2023 | Optical tweezers entry |
| fessler2024 | Autonomous active colloid engulfment |
| sirch2024 | Phase-state dependent uptake |
| marque2024 | Engulfed particle Brownian motion |

---

## 🌡️ Thermal & Active Effects

### Thermophoresis & Optothermal Manipulation

**Key Concepts:**
- [[Thermophoresis]] — Particle motion in temperature gradients
- [[Soret coefficient]] — Thermophoretic mobility
- [[Thermo-osmosis]] — Fluid flow from thermal gradients
- [[Optothermal trapping]] — Laser-induced thermal manipulation
- [[Marangoni flow]] — Surface tension gradient flow

**Literature:**
| Paper | Focus |
|-------|-------|
| würger2010 | Thermal transport review |
| piazza, parola2008 | Thermophoresis in colloids |
| duhr, braun2006 | Why molecules move in gradients |
| hill, li2018 | Opto-thermophoretic GUV manipulation |
| talbot2019 | Thermal gradient tubule growth |
| rørvig-lund2015 | Gold nanoparticle vesicle fusion |
| kyrsting2011 | Heat profiling with GUVs |

### Active Matter in/on Vesicles

**Key Concepts:**
- [[Active fluctuations]] — Non-equilibrium membrane motion
- [[Active matter]] — Self-propelled particles
- [[Bacterial baths]] — Microswimmer suspensions

**Literature:**
| Paper | Focus |
|-------|-------|
| takatori, sahu2020 | Active contact forces on membranes |
| turlier, betz2019 | Living membrane fluctuations |
| sharma, azar2021 | Active colloids orbiting GUVs |
| vincent2024 | Confined bacteria dynamics |
| willems, baron2025 | Run-and-tumble GUV dynamics |
| park, lee2022 | Dense inner active matter |
| sciortino, faizi2025 | Active synthetic cell deformations |

---

## 🔄 Shape Transformations

### Vesicle Morphology

**Key Concepts:**
- [[Vesicle shapes]] — Sphere, prolate, oblate, stomatocyte
- [[Shape phase diagram]] — Reduced volume vs area difference
- [[Budding]] — Membrane bud formation
- [[Tubulation]] — Membrane tube pulling
- [[Fission]] — Vesicle division

**Literature:**
| Paper | Focus |
|-------|-------|
| seifert, lipowsky1995 | Morphology classification |
| seifert1997 | Configuration review |
| kraus, seifert1995 | Gravity-induced shapes |
| gueguen, destainville2017 | Shape transitions |
| leirer2009_fission | Phase transition fission |
| leirer2009_expulsion | Thermodynamic expulsion |
| muñoz-basagoiti2025_tutorial | Simulation of shapes |

---

## 🧬 Towards Synthetic Cells

### Protocells & Minimal Cells

**Key Concepts:**
- [[Protocells]] — Minimal life-like systems
- [[Synthetic cells]] — Engineered cellular mimics
- [[Encapsulation]] — Cargo loading in GUVs
- [[Membrane proteins]] — Reconstitution in GUVs

**Literature:**
| Paper | Focus |
|-------|-------|
| imai, sakuma2022 | Vesicles to protocells |
| agudo-canalejo2025 | Synthetic cell shapes |
| litschel, ramm2018 | Beating vesicles |
| gallen2023 | Fluctuation-induced formation |

---

## 📊 Quick Reference: Key Parameters

| Parameter | Symbol | Typical Value | Notes |
|-----------|--------|---------------|-------|
| Bending rigidity | κ | 10-25 kBT | Depends on lipid composition |
| Gaussian modulus | κ̄ | -κ to 0 | Usually negative |
| Membrane thickness | h | ~5 nm | Bilayer thickness |
| Surface tension | σ | 10⁻⁶-10⁻³ N/m | Depends on area reservoir |
| Persistence length | ξp | ~1 μm | κ/kBT dependent |

---

## 🔗 Related Notes

- [[00-Dashboard/Concepts MOC|Concepts Map]]
- [[00-Dashboard/Papers MOC|Papers Map]]
- [[03-Concepts/Membrane-Physics/Giant Unilamellar Vesicles (GUVs)|GUVs Overview]]
- [[03-Concepts/Membrane-Physics/Bending elasticity|Bending Elasticity]]
