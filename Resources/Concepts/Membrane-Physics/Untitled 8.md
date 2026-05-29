# Optothermal Flickering Spectroscopy of DOPC GUVs: Physical Summary for Manuscript Preparation

**Scope.** Standalone physics document collecting all physical arguments behind the optothermal flickering experiment on DOPC giant unilamellar vesicles (GUVs), structured so each block can be lifted into a manuscript. Conventions: $\kappa$ in $k_BT$, $\sigma$ in N/m, $R_0$ in $\mu$m, $T_{\rm exp}$ in ms, $\eta$ in mPa$\cdot$s. Equation citations inline as [Author Year, Eq. (N)]. Observations and inferences are separated explicitly; inferences are flagged ("Based on the trend...", "Inference:"). No number appears without a source or a derivation.

---

## 1. Experimental System

*The system is engineered to deliver a localized, repeatable thermal perturbation to a single GUV while its equatorial contour is tracked at high frame rate, so that the membrane mechanical response can be read out cycle by cycle from the fluctuation spectrum.*

DOPC GUVs are deposited on gold-coated glass passivated with poly(sodium 4-styrenesulfonate) (PSS) and heated optothermally by a blue LED. The gold layer is the optothermal transducer: it absorbs the blue light and converts it to a local temperature rise, so the substrate is functionally required, not incidental. PSS passivation reduces direct adhesion of the bilayer to the gold. The interior is 200 mOsm sucrose, the exterior 200 mOsm glucose; the sugar asymmetry supplies the refractive-index contrast that phase contrast microscopy needs and is nominally iso-osmolar at preparation. Imaging is phase contrast at 40x or 100x at 50 fps, giving an exposure $T_{\rm exp}$ at most $20$ ms (the inverse frame rate is the upper bound; the true shutter time is shorter). Vesicle radii are $R_0 \approx 10$ to $28~\mu$m.

Two consequences for the physics follow directly from this geometry. First, the membrane sits within a fraction of a radius of a solid wall, so substrate hydrodynamic screening and any residual weak adhesion modify both the static spectrum and the mode dynamics relative to a free-floating vesicle. Second, the heat is delivered through the substrate, so the thermal field is asymmetric (hotter near the gold), which is the natural seed for a top-bottom asymmetric area-to-volume response. Both points feed Sections 3, 6, and 10.

---

## 2. Theoretical Framework

*Membrane mechanics are extracted by fitting the camera-corrected, equatorially projected fluctuation spectrum to the Helfrich model in the Milner-Safran modal representation; which parameter is well-determined is set entirely by the reduced tension $\bar\sigma$, equivalently by where the crossover mode index $n^\* = \sqrt{\bar\sigma}$ falls relative to the fitted mode window.*

The membrane free energy is the Helfrich Hamiltonian with zero spontaneous curvature [Helfrich 1973],
$$
\mathcal{H} = \frac{\kappa}{2}\int (2H)^2\, dA \;+\; \sigma \int dA ,
$$
with $H$ the mean curvature, $\kappa$ the bending rigidity and $\sigma$ the membrane tension. Expanding the quasi-spherical shape in spherical harmonics and applying equipartition gives the mode-amplitude spectrum. In the Milner-Safran formulation the per-mode mean-square amplitude is $\langle |u_\ell|^2\rangle \propto k_BT/(\kappa\,\lambda_\ell)$ with the eigenvalue [Milner-Safran 1987]
$$
\lambda_\ell = (\ell-1)(\ell+2)\big[\ell(\ell+1) + \bar\sigma\big], \qquad
\bar\sigma \equiv \frac{\sigma R_0^2}{\kappa}.
$$
The reduced tension $\bar\sigma$ is the single dimensionless group that sets the spectral shape. Pecreaux's projection machinery uses the closely related reduced eigenvalue $\lambda_n = n^2(n+1)^2 - (2-\bar\sigma)\,n(n+1)$ [Pecreaux 2004, Eq. (17)], which agrees with the Milner-Safran form to the constant $-2\bar\sigma$ that is negligible at the high modes that dominate the fit.

Microscopy sees only the contour in the equatorial plane, not the full 3D surface, so the relevant quantity is the projection of the planar Helfrich spectrum onto the equator. Starting from the planar spectrum [Pecreaux 2004, Eq. (10)]
$$
\big\langle |u(q_\perp)|^2\big\rangle = \frac{k_BT}{\sigma q_\perp^2 + \kappa q_\perp^4},
$$
integration over the out-of-equator wavevector $q_y$ yields the equatorial projection actually fitted [Pecreaux 2004, Eq. (11)]
$$
\big\langle |u(q_x, y{=}0)|^2\big\rangle = \frac{k_BT}{2\sigma}\left(\frac{1}{q_x} - \frac{1}{\sqrt{q_x^2 + \sigma/\kappa}}\right).
$$
The two limits of this expression define the regime classification used in the pipeline. For $q_x \gg q^\*$ the bracket reduces to $\sigma/(2\kappa q_x^3)$, so the projected spectrum scales as $q_x^{-3}$ (bending regime); for $q_x \ll q^\*$ it reduces to $1/q_x$, so it scales as $q_x^{-1}$ (tension regime). The empirical slope cuts (bending if log-log slope $< -2.5$, tension if $> -1.5$, crossover between) bracket the ideal exponents $-3$ and $-1$. The crossover separating them is
$$
q^\* = \sqrt{\sigma/\kappa}.
$$

The connection between $q^\*$ and the discrete mode window is the key to parameter reliability. Since $q_n = n/R_0$, the crossover sits at the mode index
$$
n^\* = q^\* R_0 = \sqrt{\sigma R_0^2/\kappa} = \sqrt{\bar\sigma}.
$$
Following Pecreaux, the first five modes are discarded (closed-topology and curvature corrections, plus low-mode noise) and the usable range is roughly $n \in [6,\,30]$ [Pecreaux 2004]. Therefore $\kappa$ is well constrained only when $n^\*$ lies below the fitted window ($n^\* \lesssim 6$, i.e. $\bar\sigma \lesssim 36$) so that every fitted mode is bending-dominated, and $\sigma$ is well constrained only when $n^\*$ lies inside or below the window. This is the rigorous version of the loose statement "$\bar\sigma \ll 1$ versus $\bar\sigma \gg 1$" and it resolves the apparent paradox of vesicles with $\bar\sigma > 1$ that still yield trustworthy $\kappa$ (Section 8).

Finally, the camera correction and the mode dynamics share the same dispersion relation, which is where the effective viscosity enters,
$$
\tau_m(q_\perp)^{-1} = \frac{1}{4\eta_{\rm eff}\,q_\perp}\big(\sigma q_\perp^2 + \kappa q_\perp^4\big),
$$
[Pecreaux 2004, Eq. (18)]. The corrected static spectrum fit [Pecreaux 2004, Eq. (22)] uses $\tau_m$ and therefore couples $(\kappa,\sigma,\eta_{\rm eff})$; this coupling is what makes both the camera correction (Section 9) and any viscosity extraction self-consistent rather than one-shot.

---

## 3. Optothermal Forcing Mechanism

*Heating forces the vesicle because the bilayer area expands roughly an order of magnitude faster than the enclosed water volume, so each heating step generates excess membrane area (lowers the reduced volume); because area equilibrates almost instantly while volume can only change by slow water permeation, the excess area is transiently stored as shape deformation.*

The driving asymmetry is between two thermal expansivities. For DOPC the bilayer area expansivity is $\alpha_A \approx 3.5\times10^{-3}~\mathrm{K^{-1}}$ and the volumetric expansivity of the aqueous interior is that of water, $\alpha_V \approx 2.1\times10^{-4}~\mathrm{K^{-1}}$ (values as specified for this system). At fixed shape a closed surface obeys $A \propto V^{2/3}$, so the rate at which heating produces true excess area, the geometric mismatch between area growth and the area a sphere of the new volume would have, is
$$
\frac{d}{dT}\!\left(\frac{\Delta A}{A}\right)_{\!\rm excess} = \alpha_A - \tfrac{2}{3}\alpha_V \approx 3.5\times10^{-3} - 1.4\times10^{-4} \approx 3.4\times10^{-3}~\mathrm{K^{-1}}.
$$
A heating step of only a few kelvin therefore liberates excess area of order $\Delta A/A \sim 10^{-2}$, which on the scale of membrane mechanics is enormous: it is the same order as the total stored undulation reservoir of a floppy vesicle, so it can drive a quasi-spherical shape deep into the deformed branches of the morphology diagram.

The timescale separation makes this excess area transient rather than instantly relaxed. Thermal diffusion equilibrates the membrane temperature and hence its area over micron length scales in well under a millisecond, while the enclosed volume can only adjust by water crossing the bilayer, a permeation-limited process orders of magnitude slower. During the interval after a heating step in which area has grown but volume has not yet caught up, the vesicle is over-supplied with area at nearly fixed volume and must absorb it as shape change. Because the heat enters through the substrate, the thermal and hence area field is asymmetric, biasing the response toward an asymmetric (top-bottom) shape rather than a symmetric one. This area-to-volume forcing by temperature is exactly the control variable in the classic shape-transformation experiments [Käs-Sackmann 1991; Döbereiner 1993], and the budding, discocyte-stomatocyte and tether morphologies they catalogued are the menu of shapes available to absorb the liberated area.

---

## 4. Irreversibility Mechanism (Käs-Sackmann)

*A heating-cooling cycle is irreversible because, at the peak of the cycle, the membrane tension reaches the pore-nucleation threshold and a transient pore lets water escape; the volume lost while the pore is open does not return on cooling, so the vesicle re-equilibrates with less slack available to its fluctuating contour and therefore a higher baseline tension. The irreversibility is kinetic and metastable, not thermodynamic.*

The cycle proceeds as follows. Heating liberates excess area faster than the volume can vent (Section 3). With 200 mOsm of osmotic pressure resisting the outward budding that would otherwise shed the area into a daughter bud, the membrane instead invaginates, forming a cup or limiting stomatocyte, the natural area-absorbing morphology when budding is suppressed [Seifert 1997; Miao 1994]. As the area excess accumulates the membrane tension is driven up toward the lysis or pore-nucleation threshold. A transient pore then nucleates and opens; while it is open, water is expelled along the pressure and osmotic gradient, irreversibly reducing the enclosed volume $V$; the pore subsequently reseals. On cooling, the thermally expanded area reversibly contracts back toward its starting value, but the volume does not recover, because the water that left through the pore is gone. The new mechanical equilibrium therefore has less excess area accessible to the analyzed contour than before the cycle, and a vesicle with less accessible slack reads out at a higher tension. Each cycle ratchets the baseline tension upward.

The size of the ratchet step follows from the entropic area-tension relation in its low-tension limit [Evans-Rawicz 1990],
$$
\frac{\Delta A}{A} = \frac{k_BT}{8\pi\kappa}\,\ln\!\frac{\sigma}{\sigma_0},
$$
where $\Delta A/A$ is the fractional change in apparent (projected) area unfolded between the two tension states and the direct-stretching contribution $\sigma/K_A$ is negligible at these tensions. Inverting gives the tension-jump approximation used in the analysis,
$$
\sigma_{\rm PH1} \approx \sigma_0 \exp\!\left(\frac{8\pi\kappa}{k_BT}\,\frac{\Delta A}{A}\right).
$$

That the irreversibility is kinetic rather than thermodynamic is central. The deflated, higher-tension state is metastable: the equilibrium state at a given temperature would be reached if water could re-permeate, and over very long waiting times partial recovery is indeed expected as osmotic re-equilibration slowly restores volume on a timescale $\tau_{\rm perm} \sim 10$ to $100~$s. The "irreversibility" is therefore the statement that the re-equilibration time is long compared with the cycle and the observation window, not that a free-energy barrier permanently locks the state. This distinction is what makes the recovery dissociation of Section 7 interpretable.

One geometric fact removes a possible objection to the invagination step. The bending energy of a complete invagination (a sphere-in-sphere limiting stomatocyte) is $16\pi\kappa$, because each closed-sphere portion contributes the scale-invariant $8\pi\kappa$ of a sphere and there are effectively two of them; this value is independent of how deep the invagination is [Bahrami 2026; the two-sphere result itself is classical, Seifert 1997]. Bending therefore exerts no restoring force against deepening an invagination once it has formed: the energetic cost of going deeper is borne entirely by the volume and tension constraints and by interleaflet (area-difference) coupling, not by curvature elasticity. Invagination to arbitrary depth is thus mechanically cheap, consistent with its role as the dominant area sink.

---

## 5. Two Vesicle Populations

*The dataset contains two mechanically distinct populations, floppy ($\bar\sigma \ll 1$) and pre-tensed ($\bar\sigma \gg 1$), that differ in their initial stored excess area. Both are required: the floppy population both yields reliable $\kappa$ and exhibits the full cycle dynamics, while the pre-tensed population yields reliable $\sigma$ and serves as a near-null mechanical control. The split is natural stochastic variation, not a preparation artifact, and tension state is therefore an output of the analysis, never an a priori label.*

The two populations are summarized below.

| Population  | Date series      | $\sigma_{\rm base}$ (N/m)     | $\bar\sigma$ regime | Cycle response                                  |
|-------------|------------------|-------------------------------|---------------------|-------------------------------------------------|
| Floppy      | 050226, 110326   | $10^{-10}$ to $10^{-8}$        | $\bar\sigma \ll 1$  | Irreversible tension ratcheting, invagination   |
| Pre-tensed  | 270326           | $3\times10^{-6}$ to $9\times10^{-6}$ | $\bar\sigma \gg 1$  | Near-zero response to heating                   |

The physical origin of the split is the excess area each vesicle carries out of preparation. Electroformation and gentle hydration set the reduced volume stochastically, so some vesicles begin with substantial undulation slack (floppy) and others begin taut (pre-tensed). This is variation in a physical state variable, the reduced volume, not a defect introduced by handling, which is why the pre-tensed vesicles must be kept rather than discarded as failures.

The complementarity that makes both populations necessary follows from the forcing mechanism and the reliability hierarchy together. A floppy vesicle has a large stored excess area and a low tension, so heating-liberated area drives a large excursion, the membrane can reach the pore threshold, and the irreversible ratchet operates; simultaneously its small $\bar\sigma$ puts all fitted modes in the bending regime, so it returns trustworthy $\kappa$ (Section 8). A pre-tensed vesicle has almost no slack and a high tension, so the same heating-liberated area is absorbed against an already large tension without crossing the pore threshold and without measurably changing the contour; it is effectively a null experiment that confirms the cycle response is mediated by excess area rather than by temperature per se, and its large $\bar\sigma$ makes $\sigma$ the well-determined parameter. Selecting only floppy vesicles would bias $\sigma$ statistics and remove the internal null control; selecting only pre-tensed vesicles would forfeit both reliable $\kappa$ and the entire dynamical signal. Embracing both, with tension state assigned only after $\sigma_{\rm base}$ is measured, is the scientifically defensible design.

---

## 6. Bending Rigidity Results

*The geometric-mean bending rigidity from bending-dominated baselines is $\kappa \approx 37~k_BT$ with a $68\%$ interval of about $[26,\,54]~k_BT$, roughly $1.7\times$ the Faizi 2020 DOPC benchmark of $22~k_BT$. The elevation is plausibly a sum of material effects from the 200 mOsm buffer and substrate proximity and of two known instrumental biases that have not yet been removed; the split between these is currently unresolved.*

| Source                                  | DOPC $\kappa$ ($k_BT$) | Statistic / conditions                                    |
|-----------------------------------------|------------------------|-----------------------------------------------------------|
| This work (baselines, bending regime)   | $\approx 37$           | Geometric mean; $68\%$ CI $\approx[26,54]$; log-normal [Bivas 2014] |
| Faizi 2020 benchmark                     | $\approx 22$           | Phase contrast / confocal flickering [Faizi 2020]         |
| Ratio                                   | $\approx 1.7$          | This work / benchmark                                     |

The choice of a log-normal description with a geometric mean is deliberate and not cosmetic [Bivas 2014]: $\kappa$ is positive-definite and the measurement combines multiplicative error sources, so pooled estimates are better summarized by a geometric mean and a multiplicative interval than by an arithmetic mean and a symmetric standard deviation, which would be biased high and could even admit unphysical negative tails. The reported interval is the $68\%$ log-normal band, not a Gaussian $\pm 1\sigma$.

The attribution of the $1.7\times$ elevation is an inference and decomposes into three candidate contributions that the controls of Section 10 are designed to separate.

First, buffer osmolarity. At 200 mOsm the sugar concentration is high enough that sugar adsorption and the depletion of accessible excess area can both stiffen the apparent membrane; elevated osmolarity also suppresses budding and biases the spectrum toward the tension-contaminated regime, which inflates $\kappa$ if not fully accounted for. Based on the trend across the literature, lower-osmolarity preparations report values closer to the benchmark, so part of the elevation is likely buffer-induced.

Second, substrate proximity. The membrane fluctuates within a fraction of $R_0$ of the gold wall, and confinement plus any residual adhesion damp the longest-wavelength modes preferentially; underweighting the low-$q$ amplitudes steepens the apparent bending branch and reads out as a larger $\kappa$. This is specific to the on-substrate geometry and absent for free vesicles, which is why a free-floating comparison is a priority control.

Third, and importantly, uncorrected instrumental bias. Both the camera integration correction and the optical projection correction (Section 9) act in the direction of overestimating $\kappa$ when omitted. Inference: some fraction of the $1.7\times$ is therefore not material at all, and applying both corrections is expected to move the reported $\kappa$ toward, though not necessarily all the way to, the benchmark. The magnitude of the projection contribution is itself contested in the literature (Section 9), so this fraction cannot yet be quantified. Until the corrections are implemented, $37~k_BT$ should be read as an upper estimate carrying an unsubtracted instrumental component, and the material conclusion (a genuine buffer- and substrate-induced stiffening) remains an inference rather than an established result.

---

## 7. Novel Finding: Recovery Dissociation

*The central new result is that two membrane observables relax on mechanistically distinct timescales after heating: fluctuation roughness recovers on a resolvable timescale tied to the time since the LED switched off, whereas large-scale shape deformability does not recover on the observation window. This dissociates the entropic fluctuation channel, governed by the instantaneous tension, from the morphological channel, which carries the irreversible deflation.*

| Observable    | Physical proxy                       | Correlation with $t_{\rm off}$ | Recovers on observation window? |
|---------------|--------------------------------------|--------------------------------|---------------------------------|
| Roughness     | Fluctuation amplitude                | $r = -0.89$                    | Yes (time-resolved)             |
| Deformability | Circularity dip ratio                | $r \approx -0.15$              | No                              |

Roughness is the amplitude of the membrane undulations and is set by the instantaneous tension through the spectrum of Section 2: higher tension suppresses fluctuations, lower tension restores them. After a heating step the tension is elevated and the roughness is suppressed, and as time passes the tension relaxes on the osmotic re-equilibration timescale $\tau_{\rm perm}\sim 10$ to $100~$s and the roughness recovers in step. The strong monotonic correlation with the time since LED-off, $|r| = 0.89$, is the signature of this single-timescale relaxation; the entropic channel re-thermalizes as the membrane slowly re-equilibrates.

Deformability, quantified by the circularity dip ratio, measures the large-scale departure from a circular contour, the macroscopic shape signature of the invagination and overall deflation. Its near-zero correlation with the time since LED-off, $|r| \approx 0.15$, says that the macroscopic shape does not re-round on the observation window. This is exactly the expected behavior of the irreversible component: the volume lost through the transient pore does not return on this timescale, so the vesicle stays morphologically and volumetrically altered even after its undulations have re-thermalized.

Inference: the dissociation localizes the irreversibility. The fluctuation amplitude and the macroscopic shape are not slaved to a single relaxation; rather, the fast-recovering channel (roughness, hence tension) reflects a reversible re-equilibration, while the non-recovering channel (deformability, hence shape and volume) carries the kinetically frozen deflation. Put differently, the membrane can fully restore its thermal undulation spectrum while remaining permanently more deflated, which is direct evidence that the ratchet of Section 4 lives in the area-volume bookkeeping and not in the fluctuation reservoir. This is the cleanest single observation in the dataset and the natural centerpiece of a short manuscript.

---

## 8. Parameter Reliability

*Trustworthiness of the extracted parameters is governed by where the crossover mode index $n^\* = \sqrt{\bar\sigma}$ falls relative to the fitted mode window $n \in [6,30]$. When $n^\*$ is below the window, $\kappa$ is reliable and $\sigma$ is only a lower bound; when $n^\*$ is inside or above it, $\sigma$ is reliable and $\kappa$ is an extrapolation; when $n^\*$ sits in the window, both are extractable but anti-correlated. Post-heat $\kappa$ is separately untrustworthy because the membrane is tension-contaminated and out of equilibrium.*

| $\bar\sigma$ / crossover            | Fitted-window picture        | $\kappa$                       | $\sigma$                  |
|-------------------------------------|------------------------------|--------------------------------|---------------------------|
| $\bar\sigma \ll 1$ ($n^\* < 6$)     | All modes bending-dominated  | Reliable                       | Lower bound only          |
| $\bar\sigma \gg 1$ ($n^\* > 30$)    | All modes tension-dominated  | Unreliable (extrapolated)      | Reliable                  |
| $\bar\sigma \sim 1$ ($n^\*$ in window) | Crossover inside window   | Extractable, $\chi^2$-correlated | Extractable, $\chi^2$-correlated |

The mechanism is the slope content of the fit. A parameter is only constrained if the fitted modes actually sample the part of the spectrum that depends on it: $\kappa$ controls the $q^{-3}$ bending branch and $\sigma$ controls the $q^{-1}$ tension branch (Section 2). Since $n^\* = \sqrt{\bar\sigma}$ marks the crossover in mode-index units, the comparison is between $n^\*$ and the fitted range, not between $\bar\sigma$ and unity. This refinement matters in practice and resolves the apparent contradiction of vesicles with $\bar\sigma$ modestly above one that nonetheless return reliable $\kappa$: a vesicle with $\bar\sigma = 3.77$ has $n^\* \approx 1.9$, below the first fitted mode, so every fitted mode is bending-dominated and $\kappa$ is well determined despite $\bar\sigma > 1$. A vesicle with $\bar\sigma \approx 25$ has $n^\* \approx 5.0$, sitting right at the edge of the fitted window, which is precisely the borderline case where $\kappa$ becomes unreliable. A strongly pre-tensed vesicle (e.g. $\sigma\sim5\times10^{-6}$ N/m, $R_0\sim15~\mu$m, $\kappa\sim37~k_BT$) has $\bar\sigma$ of order $10^{3}$ to $10^{4}$ and $n^\*$ of order $10^2$, far above the window, so $\sigma$ is well determined and $\kappa$ is pure extrapolation.

The post-heat caveat is independent of the $\bar\sigma$ hierarchy and applies even to vesicles that gave reliable baseline $\kappa$. Immediately after heating the membrane is at an elevated, possibly still-relaxing tension, the spectrum is no longer purely bending, and the assumptions behind a bending-regime $\kappa$ fit are violated. A $\kappa$ extracted from a post-heat segment is therefore tension-contaminated and must not be interpreted as an intrinsic membrane stiffness; at most it is an apparent stiffness of a non-equilibrium state. Intrinsic $\kappa$ should be quoted only from equilibrated, bending-dominated baselines.

---

## 9. Known Systematic Biases

*Two corrections that bias the reported $\kappa$ upward when omitted have not yet been implemented. The camera integration correction is well established and unambiguous in direction; the optical projection correction is significant in some analyses but its magnitude for phase-contrast imaging is disputed in the literature, including by the very benchmark used here.*

The camera integration correction accounts for the finite exposure time $T_{\rm exp}$ acting as a temporal low-pass filter [Pecreaux 2004, Eq. (22)]. A mode with relaxation time $\tau_m(q)$ shorter than $T_{\rm exp}$ is time-averaged within a single frame, so its measured amplitude is reduced relative to its true mean square. For a mode treated as an Ornstein-Uhlenbeck process the attenuation factor is
$$
\frac{\langle |u_q|^2\rangle_{\rm meas}}{\langle |u_q|^2\rangle} = \frac{2\tau_m}{T_{\rm exp}}\left[\,1 - \frac{\tau_m}{T_{\rm exp}}\big(1 - e^{-T_{\rm exp}/\tau_m}\big)\right],
$$
which tends to unity for $T_{\rm exp}\ll\tau_m$ (negligible blur on slow modes) and to $2\tau_m/T_{\rm exp}\to 0$ for $T_{\rm exp}\gg\tau_m$ (strong blur on fast modes). Because the fast modes are the high-$q$ bending-dominated ones, omitting the correction preferentially erases the bending branch, steepens the apparent spectrum, and inflates $\kappa$; tension, set by the slow low-$q$ modes, is comparatively insensitive [Pecreaux 2004]. The correction is not one-shot: $\tau_m$ depends on $(\kappa,\sigma,\eta_{\rm eff})$ through the dispersion relation [Pecreaux 2004, Eq. (18)], so the corrected fit must be iterated to self-consistency. This same iteration is the gate on any reliable $\eta_{\rm eff}$ extraction, since $\eta_{\rm eff}$ only enters through $\tau_m$.

The optical projection correction accounts for the microscope integrating fluctuations over a finite focal depth around the equator rather than sampling a single equatorial slice, which contaminates the measured equatorial mode amplitudes [Rautu-Orsi 2017]. Rautu and Orsi argue that neglecting this out-of-plane averaging systematically overestimates $\kappa$ from flickering and that applying their focal-depth-dependent spectrum brings the inferred $\kappa$ down into agreement with X-ray scattering and micropipette values. Two cautions apply before adopting this as a clean upward bias of fixed size. First, the magnitude is contested: Faizi 2020, the benchmark adopted here, reports that phase-contrast results are largely unaffected by out-of-focus projection and disputes the overestimation claimed for phase contrast. Second, because the present work uses phase contrast at 40x and 100x, it sits exactly at the center of this disagreement, so the projection contribution to the $1.7\times$ elevation of Section 6 cannot be assigned a definite value without the dedicated comparison. The honest statement is that the projection correction is a candidate upward bias whose size for this imaging modality is unresolved.

Net effect on the reported numbers. Both corrections, where they apply, move $\kappa$ down; neither has been applied; therefore the current $\kappa \approx 37~k_BT$ is an upper estimate with respect to instrumentation, and $\sigma$ is comparatively robust to both. No correction to $\sigma$ of comparable importance has been identified.

---

## 10. Open Physical Questions and Control Experiments Needed

*The priority experiments separate instrumental from material from substrate contributions to $\kappa$, test the pore-mediated volume-loss mechanism directly, and resolve why the tension ratchet holds between populations but not within them.*

The within-population decorrelation is the sharpest open question and is also a caveat on the ratchet model. The global Pearson correlation between $\Delta A/A$ and $\log_{10}(\sigma_{\rm PH1}/\sigma_0)$ is a Simpson's-paradox artifact: it is large only because it is dominated by the between-population offset between floppy and pre-tensed vesicles, while within each population the correlation is weak, $r \approx -0.14$. Yet the tension-jump relation of Section 4 predicts a deterministic positive correlation within a population. The discrepancy implies that the per-cycle area change is not deterministically tied to the per-cycle tension jump, most plausibly because pore nucleation is a rare stochastic event so that $\Delta A$ varies cycle to cycle independently of the eventual tension. Repeated-cycling statistics on single vesicles would test this directly and is the experiment most likely to either validate or replace the simple exponential ratchet.

The remaining controls and tests, in order of leverage, are as follows.

Implement the camera integration and optical projection corrections and re-fit the baselines. This tests the instrumental fraction of the $\kappa$ elevation: if the corrected geometric mean falls toward $22~k_BT$, the elevation is largely instrumental; if it remains near $37~k_BT$, the material attribution is strengthened. Given the Faizi-Rautu dispute over the projection correction in phase contrast, this should be done with both corrections and with the projection correction toggled.

Free-floating and passivated-substrate arms. Measuring the same DOPC preparation off the substrate, and with stronger passivation, isolates the substrate-proximity contribution to $\kappa$ and to low-mode damping. This is the only way to convert the substrate inference of Section 6 into a measurement.

Low-osmolarity buffer arm. Repeating at reduced sugar osmolarity tests the buffer attribution for $\kappa$ and, independently, whether lowering the budding-suppression pressure changes the invagination pathway and the ratchet, since 200 mOsm is doing double duty as both a stiffening agent and a budding suppressor.

Direct test of pore-mediated volume loss. Encapsulating a fluorescent volume marker and monitoring leakage during the heating peak, with FRAP or single-vesicle volume tracking, would confirm that water is actually lost through transient pores and would quantify the per-cycle $\Delta V$. This is the load-bearing assumption of the entire irreversibility account and is currently inferred rather than observed.

Osmotic-step experiments. Setting the excess area directly by osmotic deflation, with no thermal cycling, should reproduce the floppy and pre-tensed states and their distinct fluctuation behavior. Success would confirm that the populations and the response are excess-area-mediated rather than thermally specific.

High-NA or confocal imaging of the invagination. Resolving the cup or stomatocyte morphology during the cycle would confirm the invagination pathway and provide a test of the depth-independence of the cup bending energy [Bahrami 2026].

Independent mechanical cross-check. Micropipette aspiration or tether pulling on the same preparation would calibrate $\kappa$ and $\sigma$ against a non-flickering method and place the benchmark comparison of Section 6 on a same-sample footing rather than a cross-study one.

---

## References

1. W. Helfrich, "Elastic properties of lipid bilayers: theory and possible experiments," Z. Naturforsch. C 28, 693-703 (1973).
2. S. T. Milner and S. A. Safran, "Dynamical fluctuations of droplet microemulsions and vesicles," Phys. Rev. A 36, 4371-4379 (1987).
3. J. Käs and E. Sackmann, "Shape transitions and shape stability of giant phospholipid vesicles in pure water induced by area-to-volume changes," Biophys. J. 60, 825-844 (1991).
4. H.-G. Döbereiner, J. Käs, D. Noppl, I. Sprenger, and E. Sackmann, "Budding and fission of vesicles," Biophys. J. 65, 1396-1403 (1993).
5. E. Evans and W. Rawicz, "Entropy-driven tension and bending elasticity in condensed-fluid membranes," Phys. Rev. Lett. 64, 2094-2097 (1990).
6. L. Miao, U. Seifert, M. Wortis, and H.-G. Döbereiner, "Budding transitions of fluid-bilayer vesicles: the effect of area-difference elasticity," Phys. Rev. E 49, 5389-5407 (1994).
7. U. Seifert, "Configurations of fluid membranes and vesicles," Adv. Phys. 46, 13-137 (1997). Companion reference present in the project: U. Seifert and R. Lipowsky, "Morphology of vesicles," in Handbook of Biological Physics, Vol. 1, eds. R. Lipowsky and E. Sackmann (Elsevier, 1995), p. 403.
8. J. Pécréaux, H.-G. Döbereiner, J. Prost, J.-F. Joanny, and P. Bassereau, "Refined contour analysis of giant unilamellar vesicles," Eur. Phys. J. E 13, 277-290 (2004).
9. I. Bivas and N. S. Tonchev, "On the statistical mechanics of shape fluctuations of nearly spherical lipid vesicles," J. Phys.: Conf. Ser. 558, 012020 (2014).
10. S. A. Rautu, D. Orsi, L. Di Michele, G. Rowlands, P. Cicuta, and M. S. Turner, "The role of optical projection in the analysis of membrane fluctuations," Soft Matter 13, 3480-3483 (2017).
11. H. A. Faizi, C. J. Reeves, V. N. Georgiev, P. M. Vlahovska, and R. Dimova, "Fluctuation spectroscopy of giant unilamellar vesicles using confocal and phase contrast microscopy," Soft Matter 16, 8996-9001 (2020).
12. A. H. Bahrami (2026), cup/invagination bending energy equal to $16\pi\kappa$ and shape-morphology classification. Note: the full bibliographic record for this 2026 reference was not independently verified; cite as provided. The underlying two-sphere bending result ($8\pi\kappa$ per closed sphere, scale-invariant) is classical and is also covered by ref. 7.

Secondary benchmark (not in the original list, directly relevant to Section 6): W. Rawicz, K. C. Olbrich, T. McIntosh, D. Needham, and E. Evans, "Effect of chain length and unsaturation on elasticity of lipid bilayers," Biophys. J. 79, 328-339 (2000), reports DOPC $\kappa$ near the Faizi benchmark by micropipette aspiration.



