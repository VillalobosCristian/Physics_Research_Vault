#

This is a companion to the 46-page prerequisites document you uploaded, not a replacement for it. Its job is narrow: tell you what to read first, what you can skim, and where the document's math is already the math sitting in your own MATLAB pipelines. Section numbers below (§n) refer to the source PDF throughout.

## 1. What you're holding

The document is organized around one repeated idea: active-matter arguments move between four levels — stochastic trajectories, kinetic/probability equations, continuum fields, and measured images/correlations — and most lecture slides are really about translating between two of these. Each numbered section gives a short derivation in the main text, then one or more worked-example boxes where the actual computation happens. The boxes carry almost all the operational content; if you're short on time in any section, read the boxes and treat the surrounding prose as motivation.

Three parts of the document are already built as ongoing references and don't need a separate summary from me: the recognition guide (§18, "what equations on a lecture slide are telling you"), the quick-reference pages (§20), and the glossary (§21.3). Bookmark those three — you'll return to them mid-lecture more than to any derivation.

## 2. Calibrating against your background

Given your PhD work on confined bacterial dynamics and active fluid parameters, several sections are refreshers rather than new material: §3 (index notation), §4 (dimensional analysis, Péclet/Reynolds numbers), §5.1–5.4 (Langevin/Itô/Fokker–Planck), and §9.1–9.2 (linearization and dispersion relations) are all standard stat-mech machinery you already use. Two sections repackage familiar physics in a form worth a second look anyway: §5.6's run-and-tumble telegraph equation is a distinct route to the same effective diffusivity you'd get from an ABP persistence calculation, and §15's distinction between a _stationary_ density and a _detailed-balance_ one (boxed rotational Ornstein–Uhlenbeck example) is a sharper tool than the version of this idea you likely carry around informally.

The genuinely new territory, for someone whose recent work is membrane biophysics rather than dry active matter, is the nematic/topological vocabulary: §2 (Q-tensor formalism, doubled-angle representation), §6 (angular Fourier modes, kinetic moment hierarchy and closures), §7.4–7.5 (the integrability test for when a current is _not_ a gradient flow, tensor functional derivatives), §12 (winding number, defect energetics, pair annihilation), and §13 (memory kernels, delayed feedback, nonreciprocal coupling). None of this overlaps much with flickering spectroscopy, but it is exactly what your active-nematic double-cortex protocol is about to need — see §3.2 below.

## 3. Three bridges to your own experiments

### 3.1 Bridge A — flickering spectroscopy ↔ §8.4–8.5, §15.1

The boxed derivation "Ornstein–Zernike spectrum from a quadratic free energy" (§8.5) is the same three-step argument you already run in `Fitting_Eventd.m`: Parseval's theorem to diagonalize the free energy mode by mode, equipartition at $k_BT/2$ per independent Fourier degree of freedom, then read off the spectrum, $$ S(k) = \frac{k_BT}{a+\kappa k^2}. $$ It isn't literally your fitting formula — your spherical-harmonic Pécréaux/Milner–Safran spectrum replaces the planar $k^2$ with the bending/tension eigenvalue for a quasi-spherical shell — but it's the same derivation skeleton, stripped to its simplest case, which makes it a fast way to re-derive the logic from scratch if you're ever debugging the self-consistent $\kappa$/$\sigma$ iteration.

More useful for your current results is the warning attached to that derivation, repeated in §15.1: a Lorentzian-shaped spectrum does not certify equilibrium, because a stationary density can still carry a nonzero probability current. That's the precise mathematical statement behind the question you're already asking with the elevated-$\kappa$ result (40–44 $k_BT$ against the 22 $k_BT$ DOPC benchmark) and the Karatekin pore-cascade interpretation after optothermal heating cycles — fitting a Lorentzian to a post-heating spectrum doesn't by itself tell you whether the membrane has relaxed to equilibrium or is sitting in an irreversibly-driven steady state. §14.4's point about correlated frames shrinking the effective sample number is also directly relevant to error bars on any single-cycle event-detection statistic.

### 3.2 Bridge B — active-nematic double cortex ↔ §2, §12, §14.2–14.3

This is the section of the document that maps most directly onto a project you haven't built code for yet. §2.3's example of zero polar order coexisting with full nematic order ($S=1$ from two antiparallel populations) is exactly the situation of a cortical filament network with canceling polarities, and it's worth working through by hand once rather than just reading. §14.2 (structure-tensor orientation estimation from image gradients) and §14.3 (discrete defect charge from a lattice loop of director angles) together are close to a ready-made recipe for a defect-detection routine you could build alongside `hybrid_detection_v2.m`. §12.5's symmetry argument — a $+1/2$ defect has a polar axis and can self-propel, a $-1/2$ defect has three-fold symmetry and cannot — is the qualitative prediction your imaging should be able to check once the protocol is running.

### 3.3 Bridge C — swimmer–vesicle interactions ↔ §11

The Stokeslet/stresslet apparatus (§11.3–11.4) gives you the language to classify your _Chlamydomonas_ as a pusher and to predict how its flow field falls off with distance from a nearby vesicle: a force-free swimmer has no monopole term, so its leading far field is the stresslet, decaying as $1/r^2$ rather than the $1/r$ of a Stokeslet — worked out explicitly in the "why a freely swimming organism has no Stokeslet" box. §11.6's discussion of image systems near a no-slip wall is the closest analytical cousin to a swimmer approaching a deformable membrane instead of a rigid boundary; it won't give you a quantitative answer for the vesicle case, but it's the right starting point before reaching for a boundary-integral or immersed-boundary calculation.

## 4. Reading path before the school

1. **§2 and §12, in full.** This is the toolkit least like anything already in your pipeline, and it's the one your own experiment will need soonest.
2. **§14.2–14.3.** Read immediately after §12 — these are the "how do I actually measure this" companion to the defect formalism, and the most portable into MATLAB.
3. **§11, in full.** Swimmer multipole language; useful both for your own analysis and for following any lecture on swimmer hydrodynamics.
4. **§8.4–8.5 and §15**, as a fast reference pass rather than first-read. You know the physics; the value here is re-deriving it in this notation so you can map it onto your own formalism quickly during discussion sessions.
5. **§3, §4, §5.1–5.4, §9** — skim only, confirm notation matches what you already use, move on.
6. **§6, §7, §9.3–9.4, §13** — read in full only ahead of a lecture that specifically uses them (kinetic theory, field theory, pattern formation, or intelligent/delayed active systems, respectively); otherwise treat as reference material to consult when a slide references them.

## 5. Formula sheet — the equations worth having cold

|Concept|Expression|
|---|---|
|2D nematic tensor|$Q = \dfrac{S}{2}\begin{pmatrix}\cos2\theta & \sin2\theta\ \sin2\theta & -\cos2\theta\end{pmatrix}$|
|Defect winding number|$s = \dfrac{1}{2\pi}\oint \nabla\theta\cdot d\boldsymbol\ell \in \tfrac12\mathbb{Z}$ (nematic)|
|Defect elastic energy|$F_s = \pi K s^2 \ln(R/a)$|
|Pair annihilation law|$R(t)\propto (t_a-t)^{1/2}$|
|Stokeslet|$G_{ij}(r) = \dfrac{1}{8\pi\eta r}!\left(\delta_{ij}+\dfrac{r_ir_j}{r^2}\right)$, decays as $1/r$|
|Stresslet (force-free swimmer)|$S_{ij} = \sigma_0!\left(p_ip_j - \delta_{ij}/3\right)$, decays as $1/r^2$|
|Structure factor, quadratic free energy|$S(k) = \dfrac{k_BT}{a+\kappa k^2}$, $\xi = \sqrt{\kappa/a}$|
|Kernel-density estimation error|bias $\sim h^2$, relative noise $\sim (\rho h^d)^{-1/2}$|
|Orientation from image structure tensor|$\theta = \tfrac12,\mathrm{atan2}(2J_{xy},,J_{xx}-J_{yy}) + \pi/2$|
|Effective independent samples|$N_{\rm eff} \simeq T/(2\tau_{\rm int})$|
|Active stress|$\sigma^a_{ij} = -\zeta Q_{ij}$, $;f_i^a = -\zeta,\partial_jQ_{ij}$ (vanishes for uniform $Q$)|
|Jeffery rotation|$\dot{\mathbf p} = \boldsymbol\Omega\cdot\mathbf p + \lambda\left(\mathbf E\cdot\mathbf p - (\mathbf p\cdot\mathbf E\cdot\mathbf p),\mathbf p\right)$|

## 6. Problem-set triage (§19, 10 problems)

Worth doing by hand: **1** (orientation tensor from tracked rods — 15 minutes, literally the double-cortex computation), **3**(moment closure for $Q_{ij}$ — connects kinetic theory to the continuum equations you'll see on slides), **6** (Stokes projector, Fourier-space flow — warms up the swimmer-hydrodynamics machinery), **7** (defect energy of one $+1$ versus two $+1/2$ defects — the reasoning behind defect unbinding in your cortex system), and **9** (coarse-graining scale) — do this last one with your own numbers (your cortex density, expected defect spacing) rather than the generic ones, and you'll have a first-pass coarse-graining scale ready before you've taken a single image.

Fast pass, mainly to catch notation rather than concept: **2, 5, 8, 10** (Fokker–Planck current, two-field stability, delay Hopf threshold, explicit-Euler stability) — you can likely do these quickly from existing fluency.

Optional: **4** (active spinodal / motility-induced phase separation) — a clean 20-minute exercise, but not obviously connected to your current experiments unless you're specifically attending a lecture on MIPS.

## 7. Notation and convention traps flagged in the text

Activity and stresslet sign conventions vary by author — pin down the sign used in each lecture before comparing it to your own analysis. Péclet number definitions are not unique either; reconstruct the definition from units rather than assuming a quoted $\mathrm{Pe}$ means what you expect. For nematics, the angle must always be doubled before averaging — feeding $\theta$ instead of $2\theta$ into an averaging routine silently destroys the signal from a mixed-polarity configuration, which is a real risk if you adapt existing polar-order code (built around $\langle e^{i\theta}\rangle$) for the double-cortex nematic analysis rather than writing the $\langle e^{i2\theta}\rangle$ version from scratch. And, as noted in Bridge A: stationary is not equilibrium — check for a nonzero probability current before leaning on equipartition-based extraction under active or optothermal driving.

## 8. Folding this into your existing workflow

The section numbers here track the summer school's Module 0–5 structure (§22 of the source lists the mapping explicitly), so this guide slots naturally as a parent note above both the PDF and your own Module 1–3 LaTeX notes. A low-effort way to use it: create three short Obsidian notes — one per bridge above — each linking to the relevant source sections, to this guide, and to your existing flickering-spectroscopy and active-matter vault notes. That gives you a single jumping-off point the next time you need the connection between, say, the OZ spectrum derivation and your own $\kappa$/$\sigma$ extraction, without re-deriving the link from memory each time.