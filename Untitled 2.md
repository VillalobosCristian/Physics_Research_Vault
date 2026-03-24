A new collection **"Current Work — Priority Reading"** (30 papers) has been created in your Zotero library. Here is the full structured critical bibliography:

---

## Pécréaux2004
**Full reference:** Pécréaux, Döbereiner, Prost, Joanny, Bassereau. "Refined contour analysis of giant unilamellar vesicles." *Eur. Phys. J. E* 13, 277–290 (2004).

**What it contains:** The canonical method paper for flickering spectroscopy via phase-contrast microscopy. Derives the equatorial-projection power spectrum $\langle |u_q|^2 \rangle$ including the finite camera exposure correction $\chi(\tau_\ell, T_\text{exp})$, and provides the Milner-Safran eigenvalue convention. Reports κ and σ from SOPC GUVs in sucrose/glucose.

**Direct relevance:**
1. *Pipeline — spectral formula:* Eq. (4) is the projection formula your pipeline uses. The 2D equatorial spectrum is $\langle |u_q|^2 \rangle = \frac{k_BT}{2\pi\kappa} \sum_\ell \frac{|\mathcal{Y}_\ell^m(\pi/2)|^2}{\lambda_\ell + \bar{\sigma}}$ where $\lambda_\ell = ((\ell-1)(\ell+2)/2)[\ell(\ell+1) + \bar{\sigma}]$ — verify your Milner-Safran convention sign and factor of 2 against this.
2. *Pipeline — camera correction:* Eq. (6) gives $\chi(\tau_\ell, T_\text{exp}) = \text{sinc}^2(\pi T_\text{exp}/2\tau_\ell)$ [their notation; check whether it enters multiplicatively on the spectrum or additively on the variance] — your "~2% effect at 50 fps" claim should be verified by plugging in $\tau_\ell$ for modes $q = 6$–20.
3. *Question A (κ–σ degeneracy):* Section 4 explicitly discusses how the crossover mode $q^* \sim (\bar{\sigma}/4)^{1/4}$ determines the regime; at high σ all accessible modes are tension-dominated and κ becomes unidentifiable — validates your concern directly.
4. *Question F (statistics):* Reports per-vesicle fits and discusses the spread; no formal population framework.

**Critical caveats:** Uses SOPC, not DOPC; sucrose/glucose but at different concentrations than you may use. The camera correction formula in Eq. (6) is in the time-domain for the ACF — make sure you apply it to the *spectrum*, not to mode amplitudes individually. There is a known normalization ambiguity in the projection sum (equatorial vs. full sphere) that must be checked against your implementation.

**Recommended action:** Verify your Milner-Safran eigenvalue $\lambda_\ell = (\ell-1)(\ell+2)[\ell(\ell+1) + \bar{\sigma}]/2$ vs. Pécréaux's Eq. (3) factor-by-factor, and confirm your camera correction enters as multiplicative suppression of each mode's variance.

---

## Faizi2020
**Full reference:** Faizi, Reeves, Georgiev, Vlahovska, Dimova. "Fluctuation spectroscopy of giant unilamellar vesicles using confocal and phase contrast microscopy." *Soft Matter* 16, 8996 (2020) [+ Supplemental: P7GSHMUP].

**What it contains:** Direct comparison of phase-contrast and confocal flickering spectroscopy on DOPC GUVs, with careful treatment of mode-range selection, fitting protocol, and reported κ = 21 ± 2 k_BT for DOPC in sucrose/glucose at room temperature. The supplemental material (P7GSHMUP) contains all key equations in self-contained form.

**Direct relevance:**
1. *Question D (DOPC benchmark):* Gives $\kappa_\text{DOPC} = 21 \pm 2\ k_BT$ (phase contrast), $20 \pm 2\ k_BT$ (confocal), at 23°C in sucrose/glucose — your primary benchmark.
2. *Pipeline — mode range:* Uses $\ell = 5$–25 (equivalent to $q = 5$–25); your $q = 6$–20 is conservative and appropriate.
3. *Question F (statistics):* Reports N = 10–20 vesicles, mean ± std; provides explicit guidance on rejection criteria (asphericity, drift).
4. *Pipeline — projection formula:* Supplemental Eq. (S1)–(S5) give the cleanest self-contained derivation; use as reference against your code.

**Critical caveats:** DOPC in symmetric sucrose/glucose (isosmotic); if you have asymmetric osmotic conditions post-heating, κ and σ will shift. No camera correction for phase contrast — relevant since you're at 50 fps.

**Recommended action:** Use Faizi2020 supplemental equations as the primary reference for your projection formula and take $\kappa = 21 \pm 2\ k_BT$ as baseline DOPC benchmark for your pre-heat segments.

---

## Faizi2024
**Full reference:** Faizi, Granek, Vlahovska. "Curvature fluctuations of fluid vesicles reveal hydrodynamic dissipation within the bilayer." *PNAS* 121, e2402737124 (2024).

**What it contains:** Derives and experimentally validates the ACF relaxation time $\tau_\ell = \eta_\text{eff} R_0^3 / (\kappa \ell^3)$ for the full dissipation spectrum including inter-monolayer friction and bulk viscosity. Provides explicit expressions for $\eta_\text{eff}$ as a function of membrane viscosity $\eta_m$, bulk viscosity $\eta$, and monolayer friction $b$. Reports $\eta_m \approx 10^{-9}$ N·s/m for DOPC.

**Direct relevance:**
1. *Pipeline — ACF fitting and η_eff:* Gives the exact formula $\tau_\ell^{-1} = \kappa\lambda_\ell / \eta_\text{eff} R_0^3$ where $\eta_\text{eff} = \eta_\text{bulk}[1 + \text{Boussinesq corrections}]$; this is the equation your self-consistent iteration should converge to.
2. *Question D (η_eff benchmark):* Reports numerical values for DOPC; provides the expected range for $\eta_\text{eff}$ in water/sucrose.
3. *Pipeline — convergence:* The self-consistent iteration (κ from spectrum → τ_ℓ → η_eff from ACF → camera correction → new κ) is explicitly justified here.
4. *Question A:* Shows that η_eff can be extracted independently from ACF even when the power spectrum is tension-dominated, breaking the κ–σ degeneracy partially.

**Critical caveats:** The derivation assumes a free-standing bilayer with no substrate proximity; your gold substrate may modify the hydrodynamic boundary conditions (see Question E). The inter-monolayer friction contribution is non-negligible for DOPC at timescales accessible at 50 fps — do not assume pure bulk-viscosity limit.

**Recommended action:** Adopt Faizi2024 Eq. (4) for $\tau_\ell$ as the target of your ACF fitting, and include inter-monolayer friction $b$ as a free or literature-constrained parameter.

---

## Döbereiner2003
**Full reference:** Döbereiner, Gompper, Haluska, Kroll, Petrov, Riske. "Advanced Flicker Spectroscopy of Fluid Membranes." *Phys. Rev. Lett.* 91, 048301 (2003).

**What it contains:** Implements full power spectrum analysis including camera integration time correction and fits both κ and σ simultaneously. Reports non-trivial coupling between modes and discusses the breakdown of the independent-mode approximation at large σ. First paper to implement the camera-integration suppression of high-frequency modes in flicker spectroscopy.

**Direct relevance:**
1. *Pipeline — camera correction:* This paper implements the correction your pipeline has "partially" applied — the finite-exposure suppression factor for each mode $q$ is $\langle|u_q|^2\rangle_\text{meas} = \langle|u_q|^2\rangle \cdot f(\omega_q, T_\text{exp})$, where $f$ depends on the relaxation frequency $\omega_q = 1/\tau_q$.
2. *Question A:* Shows explicit examples of how at high σ the spectrum appears mode-independent (flat in reduced units) making κ degenerate — supports fixing κ from baseline.
3. *Pipeline — self-consistent iteration:* Motivates the need for iteration because the camera correction depends on $\tau_q$ which itself depends on κ and η_eff.

**Critical caveats:** Uses DMPC (not DOPC) at temperatures near the transition. The camera correction formula differs slightly in convention from Pécréaux2004 — verify both agree on the sinc² form before using one over the other in your code.

**Recommended action:** Cross-check the camera correction implementation against both Döbereiner2003 and Pécréaux2004 Eq. (6); they should agree; if they differ, Pécréaux is the more cited and better-validated reference.

---

## Pott2002
**Full reference:** Pott, Méléard. "The dynamics of vesicle thermal fluctuations is controlled by intermonolayer friction." *Europhys. Lett.* 59, 87 (2002).

**What it contains:** Measures the ACF $C_q(\tau) = \langle u_q(0)u_q(\tau)\rangle / \langle u_q^2 \rangle$ and shows that at long times it is biexponential due to intermonolayer friction, with two timescales $\tau_q^\pm$. The fast timescale scales as $\tau_q^- \propto \eta R_0^3/(\kappa q^3)$ (bulk viscosity dominated) and the slow timescale $\tau_q^+ \propto b R_0^3/(\kappa q^3)$ (friction dominated). Demonstrates for DMPC.

**Direct relevance:**
1. *Pipeline — ACF fitting:* Your single-exponential fit $C_q(\tau) \sim e^{-\tau/\tau_q}$ is a simplification; this paper shows it is biexponential. The fast mode is what your OLS-through-origin at $C_q > 0.2$ likely captures. The slow mode may cause your fitted $\tau_q$ to be systematically too long.
2. *Question D (η_eff):* Provides the physical interpretation of η_eff as an average that mixes the two timescales; the "effective viscosity" you extract is not purely bulk viscosity.
3. *Pipeline — fit window $C_q > 0.2$:* This threshold is likely cutting off the slow (friction-dominated) tail — which is actually desirable if you want to report bulk η_eff alone, but should be stated explicitly.

**Critical caveats:** DMPC, not DOPC; the intermonolayer friction coefficient $b$ for DOPC is unknown from this paper. The biexponential regime is most relevant at low mode numbers ($q < 5$) — your mode range $q = 6$–20 may avoid the worst of this.

**Recommended action:** Report that your ACF fitting yields the fast-timescale η_eff (bulk-viscosity dominated) and note that intermonolayer friction effects are excluded by the $C_q > 0.2$ cutoff — this must be stated in the methods section.

---

## Miao2002
**Full reference:** Miao, Lomholt, Kleis. "Dynamics of shape fluctuations of quasi-spherical vesicles revisited." *Eur. Phys. J. E* 9, 143–160 (2002).

**What it contains:** Rederives the full dynamical theory for quasi-spherical vesicle fluctuations in the grand-canonical ensemble (where $\sigma$ is a Lagrange multiplier, not fixed). Shows that the spectrum $\langle|u_\ell|^2\rangle$ depends critically on whether one uses canonical (fixed area) or grand-canonical (fixed tension) ensemble, and that the two give different results for finite vesicles and at the crossover. Corrects earlier sign/normalization errors.

**Direct relevance:**
1. *Question A (κ–σ degeneracy):* Section 3 gives the analytical crossover mode $q^* \approx (\bar{\sigma}/4)^{1/4}$ and shows that for $q \gg q^*$ the spectrum is $\langle|u_q|^2\rangle \propto 1/\sigma q^2$ (tension-dominated, κ-independent); this is the fundamental reason κ is unresolvable at high tension.
2. *Pipeline — ensemble:* Shows that the Pécréaux/Milner-Safran formula assumes grand-canonical ensemble (σ is a chemical potential of excess area). For heating experiments where excess area changes, this assumption should be re-examined.
3. *Question C (excess area):* Section 4 gives explicit formulas for how excess area $\langle \delta A \rangle$ changes with σ and κ — directly relevant to quantifying excess area change across heating cycles.
4. *Pipeline — eigenvalue convention:* Confirms Milner-Safran $\lambda_\ell = (\ell-1)(\ell+2)[\ell(\ell+1) + \bar{\sigma}]/2$, but note factor of 2 difference from some other conventions — verify your code.

**Critical caveats:** Grand-canonical vs. canonical distinction matters most at the crossover mode $q^*$. If your post-heat vesicles are at high σ, the grand-canonical assumption may break down and the spectrum formula needs correction.

**Recommended action:** Implement the grand-canonical crossover check: compute $q^*$ for each vesicle/segment, and flag segments where $q^* < 6$ (your lowest mode) as tension-dominated and κ-unreliable.

---

## Faucon1989
**Full reference:** Faucon, Mitov, Méléard, Bivas, Bothorel. "Bending elasticity and thermal fluctuations of lipid membranes. Theoretical and experimental requirements." *J. Phys. France* 50, 2389–2414 (1989).

**What it contains:** The original derivation of the Milner-Safran power spectrum for quasispherical vesicles observed by phase-contrast microscopy, in equatorial projection. Establishes the theoretical framework used by virtually all subsequent flickering spectroscopy. Derives the mode-by-mode variance formula and discusses the spherical harmonic decomposition. Reports κ for DMPC and DPPC.

**Direct relevance:**
1. *Pipeline — foundational formula:* This is the source paper for the eigenvalue $\lambda_\ell$ and the equipartition theorem applied to vesicle modes. Every formula in your pipeline traces back here.
2. *Question F (statistics):* Discusses single-vesicle analysis and the minimum number of frames needed for reliable $\langle|u_q|^2\rangle$ estimates — important for your 50 fps protocol.
3. *Pipeline — equatorial projection:* Establishes that the equatorial cross-section picks up modes $\ell \geq 2$ with $m = 0$ only (in the frame where $z$-axis = observation axis), which is the convention your pipeline should follow.

**Critical caveats:** Uses old conventions for reduced tension that differ slightly from Pécréaux2004; the reduced tension $\bar{\sigma} = \sigma R_0^2/\kappa$ is used consistently in later work but Faucon sometimes writes it unnormalized. Does not include camera correction (1989 — analog cameras). Not DOPC.

**Recommended action:** Use only for theoretical verification of the mode-variance formula; prefer Pécréaux2004 and Faizi2020 supplemental for the working equations in your pipeline.

---

## Méléard1997
**Full reference:** Méléard, Gerbeaud, Pott, Fernandez-Puente, Bivas, Mitov, Dufourcq, Bothorel. "Bending elasticities of model membranes: influences of temperature and sterol content." *Biophys. J.* 72, 2616–2629 (1997).

**What it contains:** Systematic flickering spectroscopy study of DPPC, DLPC, and mixed membranes with and without cholesterol, in sucrose/glucose buffer. Provides κ as a function of temperature and sterol content. Establishes that κ decreases with temperature (approximately linear) and increases with cholesterol. Uses the Faucon/Milner-Safran framework.

**Direct relevance:**
1. *Question D (DOPC benchmark):* Does not report DOPC directly, but provides the methodological gold standard against which DOPC values should be compared. The sucrose/glucose buffer is directly comparable.
2. *Question D (temperature sensitivity):* Demonstrates $\partial\kappa/\partial T \approx -0.5\ k_BT/°C$ for PC lipids — if your gold substrate heats the GUV by $\Delta T$, this predicts a measurable κ shift independent of tension effects.
3. *Pipeline — frame statistics:* Reports the minimum number of frames (~1000) needed at their fps for reliable mode averages — your 50 fps × analysis window should be checked against this.

**Critical caveats:** Not DOPC; the temperature dependence may differ. The heating is global (temperature-controlled chamber), not local optothermal; your local heating profile near the gold substrate may produce temperature gradients not present here.

**Recommended action:** Use the $\partial\kappa/\partial T$ estimate as a correction factor: if local temperature near the substrate is elevated by $\Delta T$, subtract the expected thermal softening to isolate the tension effect.

---

## Dimova2014
**Full reference:** Dimova. "Recent developments in the field of bending rigidity measurements on membranes." *Adv. Colloid Interface Sci.* 208, 225–234 (2014).

**What it contains:** Comprehensive review of all methods for measuring κ: flickering spectroscopy, tether pulling, micropipette aspiration, electrodeformation. Tabulates κ values for DOPC, DPPC, POPC, and mixtures across many labs and methods. Discusses sources of inter-lab discrepancy (buffer composition, temperature, fitting method, mode range).

**Direct relevance:**
1. *Question D (DOPC benchmark):* Table 1 lists $\kappa_\text{DOPC}$ from multiple studies: range 17–26 $k_BT$ by flickering, ~20 $k_BT$ consensus. Your result should fall in this range for pre-heat segments.
2. *Question D (buffer effects):* Section 4.2 discusses how sucrose/glucose asymmetry affects κ via osmotic effects — directly addresses your concern about buffer asymmetry post-heating.
3. *Question F (statistics):* Section 5 recommends N ≥ 10 vesicles for population reporting, with weighted mean ± SEM preferred over median.
4. *Question E (substrate):* Brief mention that substrate proximity can increase apparent tension — not elaborated, but flags the concern.

**Critical caveats:** Review from 2014; does not include more recent Faizi2020/2024 results. Some tabulated values use different fitting protocols (some include camera correction, some do not) — cross-comparison requires caution.

**Recommended action:** Use Table 1 of Dimova2014 as the primary literature range for DOPC κ, and report whether your pre-heat values are consistent with the 17–26 $k_BT$ range before interpreting heating effects.

---

## Bouvrais2012
**Full reference:** Bouvrais. "Bending Rigidities of Lipid Bilayers." *Adv. Planar Lipid Bilayers Liposomes* 15, 1–75 (2012).

**What it contains:** Comprehensive chapter covering theory and experimental protocols for flickering spectroscopy, with particular focus on systematic errors: finite-size effects, asphericity corrections, mode coupling, and buffer asymmetry. Reports $\kappa_\text{DOPC} = 22 \pm 3\ k_BT$ specifically in sucrose/glucose, which is the most directly comparable literature value to your system.

**Direct relevance:**
1. *Question D (DOPC benchmark, sucrose/glucose):* Gives $\kappa_\text{DOPC} = 22 \pm 3\ k_BT$ in symmetric sucrose/glucose — your closest reference value.
2. *Question D (buffer effects):* Discusses buffer asymmetry systematically; shows that inner sucrose / outer glucose asymmetry at isosmotic conditions shifts apparent κ by ~5–10% due to a small refractive-index contrast that modifies the optical phase-contrast image of the contour.
3. *Question F (statistics):* Discusses intra-vesicle vs. inter-vesicle variability, recommends reporting both.
4. *Pipeline — mode selection:* Recommends excluding $q < 5$ (coupling to center-of-mass) and $q > 25$ (noise-dominated at typical fps) — consistent with your $q = 6$–20.

**Critical caveats:** Does not include camera correction in detail; chapter format means some derivations are sketched. The value $22 \pm 3\ k_BT$ uses their own fitting pipeline, which may differ from yours in normalization.

**Recommended action:** Treat $\kappa_\text{DOPC} = 22 \pm 3\ k_BT$ (Bouvrais2012) and $\kappa_\text{DOPC} = 21 \pm 2\ k_BT$ (Faizi2020) as your consensus benchmark; flag any pre-heat measurement deviating by >2σ from this range.

---

## Solon2006
**Full reference:** Solon, Pécréaux, Girard, Fauré, Prost, Bassereau. "Negative Tension Induced by Lipid Uptake." *Phys. Rev. Lett.* 97, 098103 (2006).

**What it contains:** Demonstrates that membrane tension can become negative (i.e., the membrane is under compression) when lipids are transferred into the outer leaflet, and that tension can be dynamically modulated by tube pulling. Establishes that σ can be varied over several orders of magnitude in the same vesicle, and that tension recovery after a perturbation is governed by excess area redistribution.

**Direct relevance:**
1. *Question B (tension buildup and recovery):* Shows that tension change ΔΣ is related to excess area change $\Delta\alpha$ by $\Delta\Sigma = \kappa(\Delta\alpha) \cdot \partial^2 F/\partial\alpha^2$ — the tension response is a second derivative of the free energy with respect to excess area. This is the framework for interpreting your irreversible tension buildup across heating cycles.
2. *Question C (excess area):* Provides direct measurement protocol for tracking excess area change by monitoring mode amplitudes (each mode's amplitude decreases as σ increases, all contributing to the total excess area).
3. *Question B (recovery time):* Shows tension recovery after perturbation is slow (minutes) when it involves lipid exchange, fast (<1 s) when it involves mode redistribution — relevant for your partial recovery observation.

**Critical caveats:** The mechanism here is lipid transfer from external vesicles, not thermal perturbation. The timescales and magnitudes may differ for your optothermal experiments. The negative-tension regime may not be relevant post-heating.

**Recommended action:** Adopt the Solon2006 excess-area formalism $\alpha = \sum_\ell \frac{(2\ell+1)}{4\pi} \langle|u_\ell|^2\rangle \cdot \ell(\ell+1)/2$ to quantify excess area change across heating cycles (Question C), and compare pre/post-heat values directly.

---

## Wennerström2022
**Full reference:** Wennerström, Sparr, Stenhammar. "Thermal fluctuations and osmotic stability of lipid vesicles." *Phys. Rev. E* 106, 064401 (2022).

**What it contains:** Derives the equilibrium osmotic pressure of a fluctuating vesicle, showing that the effective osmotic pressure and the mechanical tension are coupled through the thermal fluctuations. Demonstrates that upon osmotic stress changes (e.g., heating-induced concentration changes via water evaporation or thermal expansion), the membrane tension adjusts to maintain mechanical equilibrium, providing a quantitative framework.

**Direct relevance:**
1. *Question B (osmotic contributions to tension recovery):* This is the key paper for Question B. Provides the explicit relationship between osmotic imbalance $\Delta\Pi$ and membrane tension $\sigma$: $\sigma \approx \sigma_0 + \kappa \cdot \delta n / (2R_0)$ where $\delta n$ is the osmolyte imbalance — verify the exact expression.
2. *Question C (excess area under osmotic stress):* Shows that osmotic deflation reduces vesicle volume and increases excess area, which then redistributes into thermal fluctuations — the reverse of what heating does.
3. *Question B (partial recovery):* Irreversible tension component after heating could originate from irreversible osmolyte concentration changes (e.g., local sucrose concentration gradient in the heated zone near the gold substrate).

**Critical caveats:** Theory assumes spherically symmetric osmotic conditions; your gold substrate creates an asymmetric local heating and osmotic environment. The gold substrate is a heat source that locally increases temperature and could create local osmolyte gradients that are not captured by this bulk osmotic theory.

**Recommended action:** Use Wennerström2022 to estimate the expected tension change from a given osmolyte concentration change; if your measured ΔΣ is larger than this estimate, the excess must come from thermal area expansion or photooxidation.

---

## Wennerström2024
**Full reference:** Wennerström, Sparr, Stenhammar. "On the coupling between membrane bending and stretching in lipid vesicles." *arXiv* (2024).

**What it contains:** Shows that the commonly used decoupled approximation (separate bending modulus κ and stretching modulus $K_A$) is inconsistent for finite vesicles under tension, and derives a coupled formula that modifies the effective κ measured by flickering spectroscopy when $\sigma$ is large. The correction is $\kappa_\text{eff} = \kappa / (1 + \kappa K_A / \sigma R_0^2)$ — at large σ, apparent κ decreases.

**Direct relevance:**
1. *Question A (κ–σ degeneracy):* This is a new source of apparent κ–σ coupling: at high σ, the measured $\langle|u_\ell|^2\rangle$ yields an effectively reduced κ, making κ and σ even more degenerate than in the pure bending model.
2. *Question B (tension buildup effect on κ):* If heating increases σ, the apparent κ from flickering will decrease even if the actual κ is unchanged — this paper gives the quantitative correction.
3. *Pipeline — interpretation:* If you fix κ from baseline and fit σ only post-heat, you may be systematically underestimating σ because you're ignoring the stretching correction to the mode spectrum.

**Critical caveats:** Preprint; not yet peer-reviewed. The coupling correction is largest when $\sigma R_0^2 \sim \kappa^2/K_A$; for DOPC ($K_A \approx 240$ mN/m, $\kappa \approx 20\ k_BT$, $R_0 = 15\ \mu$m), the crossover tension is $\sigma^* \approx \kappa K_A / R_0^2 \approx 0.01$ mN/m — small but accessible if your post-heat tensions are in the μN/m–mN/m range.

**Recommended action:** Compute the bending-stretching coupling correction for your highest post-heat σ values; if the correction exceeds 5%, include it in the fitting model or report it as a systematic uncertainty.

---

## Gueguen2017
**Full reference:** Gueguen, Destainville, Manghi. "Fluctuation tension and shape transition of vesicles: renormalisation calculations and Monte Carlo simulations." *Soft Matter* 13, 6100 (2017).

**What it contains:** Distinguishes between the "bare" tension σ (Lagrange multiplier, thermodynamic tension) and the "fluctuation tension" $\sigma_\text{fl}$ (what flickering spectroscopy measures), which differ by a renormalization correction. Shows that in the tension-dominated regime ($\sigma R_0^2/\kappa \gg 1$), $\sigma_\text{fl} \approx \sigma$ but in the fluctuation-dominated regime they can differ significantly.

**Direct relevance:**
1. *Question A (κ–σ degeneracy):* Provides the quantitative condition for degeneracy: when $\bar\sigma = \sigma R_0^2/\kappa > (\ell_\text{max}/2)^2 \approx 25$ (for $\ell_\text{max} = 20$), the spectrum is entirely tension-dominated and κ is unresolvable. Check whether your post-heat segments exceed this threshold.
2. *Question A (fix κ from baseline):* Validates the strategy of fixing κ from baseline (pre-heat) segments where $\bar\sigma$ is small, then fitting σ only in tension-dominated post-heat segments — this is the correct approach.
3. *Pipeline — convention:* Uses grand-canonical ensemble throughout; confirms that Pécréaux/Milner-Safran formula is grand-canonical (σ is a Lagrange multiplier, not fixed).

**Critical caveats:** Renormalization corrections are most important for large vesicles ($R_0 > 20\ \mu$m) and low tension; for your R₀ ~ 10–20 µm and moderate tension, the correction is small (<5%) but should be verified.

**Recommended action:** For each vesicle segment, compute $\bar\sigma = \sigma R_0^2/\kappa$ using the fitted values, flag segments with $\bar\sigma > 25$ as "tension-dominated, κ unreliable," and report κ from baseline-only segments.

---

## Rautu2017
**Full reference:** Rautu, Orlandini, Goldstein. "The role of optical projection in the analysis of membrane fluctuations." *Phys. Rev. Lett.* 118, 108102 (2017).

**What it contains:** Shows that the measured contour in phase-contrast microscopy is not the true equatorial cross-section but an optical projection that depends on the depth of focus and the vesicle's out-of-plane fluctuations. Derives a correction to the apparent mode amplitudes that becomes significant for large amplitude fluctuations (low-tension, large vesicles). Demonstrates that uncorrected spectra can yield κ values 10–20% too low.

**Direct relevance:**
1. *Question A (κ–σ degeneracy and systematic errors):* Projection artifacts are an additional source of κ–σ confusion: the apparent σ from a projected contour is higher than the true σ, potentially masking true low-tension behavior.
2. *Pipeline — contour extraction:* Your sub-pixel contour extraction at $N_\theta = 256$ may be subject to this projection effect, especially for your largest GUVs ($R_0 \sim 20\ \mu$m) which have larger out-of-plane excursions.
3. *Pipeline — systematic bias:* The correction is ~10–20% for low-tension, high-κ membranes — comparable to your statistical error bars. This systematic bias must either be corrected or acknowledged.

**Critical caveats:** The correction magnitude depends on the depth of focus of your microscope objective, which is not specified in your pipeline description. For high-NA objectives with shallow depth of focus, the correction is smaller.

**Recommended action:** Estimate your objective's depth of focus and apply the Rautu2017 correction factor to your low-tension (pre-heat) κ values; if correction >5%, implement it in the pipeline.

---

## Bivas2010 & Bivas2014
**Full references:**
- Bivas. "Shape fluctuations of nearly spherical lipid vesicles and emulsion droplets." *Phys. Rev. E* 81, 061911 (2010).
- Bivas, Tonchev. "On the statistical mechanics of shape fluctuations of nearly spherical lipid vesicle." *J. Phys.: Conf. Ser.* 558, 012020 (2014).

**What they contain:** Bivas2010 provides a careful treatment of the canonical vs. grand-canonical ensemble for finite vesicles, showing that the two ensembles give the same spectrum in the thermodynamic limit but differ for small vesicles or near the fluctuation-dominated/tension-dominated crossover. Bivas2014 extends this to population statistics.

**Direct relevance:**
1. *Question F (statistics):* Bivas2014 explicitly addresses the distribution of fitted κ across a population of vesicles and shows that the distribution is approximately log-normal, so the geometric mean (or mean of log κ) is the appropriate population estimator — not the arithmetic mean.
2. *Question A (ensemble):* Bivas2010 shows that for R₀ ~ 10–20 µm (your range), canonical and grand-canonical spectra are indistinguishable for $q > 5$ — confirms the Milner-Safran grand-canonical formula is safe to use.
3. *Question F (error propagation):* Bivas2014 provides explicit formulas for the uncertainty in fitted κ as a function of number of frames, number of modes, and SNR.

**Recommended action:** For population reporting (Objective 3), use log-normal statistics as recommended by Bivas2014: report geometric mean and geometric standard deviation, alongside the standard error on the mean.

---

## Pott2002 (already covered above as Pott2002)

---

## Drabik2016
**Full reference:** Drabik, Przybyło, Chodaczek, Iglič, Langner. "The modified fluorescence based vesicle fluctuation spectroscopy technique for determination of lipid bilayer bending properties." *BBA Biomembranes* 1858, 244–252 (2016).

**What it contains:** Compares fluorescence-based flickering with phase-contrast flickering, and demonstrates that both give consistent κ for DOPC when the fitting protocol is matched. Provides a self-contained description of the power spectrum fitting including the mode-range selection and the treatment of outlier vesicles.

**Direct relevance:**
1. *Question F (statistics):* Recommends excluding vesicles with $\langle u_q^2 \rangle$ variance > 2σ from the population mean before computing averages — a robust outlier criterion for your population dataset.
2. *Question D (DOPC):* Reports $\kappa_\text{DOPC} = 19 \pm 2\ k_BT$ (HEPES buffer, not sucrose/glucose) — shows buffer sensitivity; sucrose/glucose buffer tends to give ~2 $k_BT$ higher values.

**Critical caveats:** Fluorescence-based method has different systematic errors (photobleaching, fluorophore insertion stiffening); use only their statistical framework, not their absolute κ values, for direct comparison.

**Recommended action:** Adopt the Drabik2016 outlier rejection criterion (vesicles with mode variance >2σ from population) for your population-level analysis.

---

## Bouvrais2014
**Full reference:** Bouvrais, Pott, Bagatolli, Ipsen, Méléard. "Impact of Membrane-Anchored Fluorescent Probes on the Mechanical Properties of Lipid Bilayers." *Biochim. Biophys. Acta* 1798, 1427–1433 (2010); and Bouvrais et al. "Buffers Affect the Bending Rigidity of Model Lipid Membranes." *Biophys. J.* 105 (2014).

**What it contains:** Shows that buffer composition — specifically the presence of PBS, HEPES, sucrose, glucose — systematically affects the measured κ of DOPC GUVs. Reports that sucrose/glucose buffer gives $\kappa_\text{DOPC} \approx 22\ k_BT$ while HEPES buffer gives $\approx 18\ k_BT$, a ~20% difference from the same lipid.

**Direct relevance:**
1. *Question D (buffer sensitivity):* Quantifies the buffer effect on κ directly. If your buffer composition changes post-heating (e.g., due to water evaporation or osmolyte redistribution), this could shift κ by up to 20% independent of any membrane physical changes — a major systematic.
2. *Question B (post-heat tension):* Buffer asymmetry between inner and outer leaflet created by differential heating near the gold substrate could change the apparent κ — this paper quantifies that effect.

**Recommended action:** Characterize your exact buffer composition (sucrose concentration inner/outer, glucose concentration) and compare to Bouvrais2014 conditions; report the expected systematic shift in κ.

---

## Aoki2015
**Full reference:** Aoki, Schroder, Constantino, Marques. "Bioadhesive giant vesicles for monitoring hydroperoxidation in lipid membranes." *Soft Matter* 11, 5995 (2015).

**What it contains:** Studies DOPC GUVs in the presence of reactive oxygen species (ROS) and demonstrates that lipid peroxidation measurably softens the membrane (κ decreases by 20–40%) and increases σ. The effect is detectable after minutes of exposure to H₂O₂ or UV light.

**Direct relevance:**
1. *Question G (Trolox/antioxidants):* This is the primary justification for using Trolox in your experiment. Without antioxidant protection, blue LED illumination can generate ROS (via flavin contamination or direct photoexcitation of unsaturated lipids), causing κ to decrease and σ to increase — mimicking a "heating effect" but actually being photooxidation artifact.
2. *Question B (irreversible tension buildup):* The irreversible component of your tension buildup across heating cycles could be partially from cumulative photooxidation rather than purely thermal effects — Trolox suppresses this.
3. *Question G (Trolox effect on κ):* The paper does not specifically test Trolox; known from other literature that Trolox at 1–2 mM does not measurably change κ for DOPC, but this should be verified.

**Critical caveats:** Uses H₂O₂ as the oxidant, which is more aggressive than the ROS generated by LED illumination; the timescale of your experiments (seconds per heating segment) may produce negligible oxidation. Nevertheless, accumulation across many cycles is plausible.

**Recommended action:** Run a control experiment: N heating cycles without Trolox vs. with 1 mM Trolox. If irreversible tension buildup is suppressed by Trolox, photooxidation is implicated; if not, the effect is purely thermal/osmotic.

---

## Dimova2020 (Giant Vesicle Book)
**Full reference:** Dimova, Marques (eds.). *The Giant Vesicle Book*. CRC Press (2019/2020).

**What it contains:** Comprehensive reference covering all aspects of GUV science including Chapter 6 (flickering spectroscopy protocol), Chapter 3 (GUV