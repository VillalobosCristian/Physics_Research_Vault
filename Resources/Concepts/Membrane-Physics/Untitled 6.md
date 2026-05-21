# Presentation Working Brief

## Membrane Thermomechanics of DOPC GUVs under Repeated Optothermal Stress

### Cross-disciplinary lab, 25-30 min, mixed audience (chemists, biologists, some physicists)

---

## 0. The arc in one sentence

A membrane heated and cooled does not return to where it started, and the way it appears to recover hides the fact that part of it has changed permanently.

That is the question, the result, and the takeaway. Everything else supports it.

---

## 1. Audience profile and framing principles

The recurring "intro too technical" feedback has one structural cause. Most physics talks open with the method (flickering spectroscopy, Helfrich Hamiltonian) before establishing the question (what happens to a membrane when you heat it repeatedly?). Fix that and the rest of the deck reads cleanly.

### Three framing principles

1. **One question, three results, one mechanism.** Do not list six findings of equal weight. The recovery dissociation is the climax. Tension ratcheting and the two-population structure feed into it. The kappa population summary is supporting evidence, not the headline.
    
2. **Translate every physics quantity once.** Say "bending rigidity, how stiff the membrane is against bending, like paper versus rubber" on slide 2. Then use kappa for the rest of the talk without losing anyone.
    
3. **The balloon analogy is the entire mechanism.** Memorize one version, deliver it on the mechanism slide, never explain it twice.
    

### Audience-specific reframings

|Concept|For chemists|For biologists|
|---|---|---|
|Bending rigidity kappa|Elastic constant of the bilayer, set by acyl chain packing|How resistant the membrane is to curving, like in endocytosis|
|Membrane tension sigma|Lateral pressure on the bilayer, controls pore formation|How taut the membrane is, sets the threshold for budding or fusion|
|Flickering spectroscopy|Thermally driven contour modes, Fourier decomposition gives the elastic constants|The vesicle wiggles, we measure how much, the amount tells us the mechanics|
|Optothermal heating|Blue LED absorbed by gold film, plasmonic conversion to local heat|Targeted local heating like in photothermal cancer therapy|
|Excess area|The difference between the actual surface area and the area of a sphere with the same volume|The membrane has slack that lets it change shape without stretching|

---

## 2. Project state, as of today

### 2.1 Headline findings

1. **DOPC GUVs split into two mechanically distinct populations**, separated by roughly four decades in baseline tension. Floppy (N=8, $\sigma_0 \sim 10^{-10}$ to $10^{-8}$ N/m) invaginates under heating and ratchets tension across cycles. Pre-tensed (N=10, $\sigma_0 \sim 3$ to $9 \times 10^{-6}$ N/m) shows essentially zero response.
    
2. **Roughness recovers, deformability does not.** Within the same vesicle, the fluctuation amplitude relaxes back on a 10 to 80 s timescale ($r = -0.89$ vs $t_{\text{off}}$, N=5), while the circularity dip ratio shows no temporal recovery ($r = -0.15$). This is the central novel finding, the cleanest experimental signature of $\sigma$ and $\Delta a_0$ as independently relaxing degrees of freedom.
    
3. **Mean bending rigidity** $\kappa = 37.4$ kBT (log-normal geometric mean, 68% CI [25.8, 54.2] kBT), elevated about $1.7\times$ above the Faizi 2020 DOPC benchmark of 22 kBT. Attribution: buffer (Bouvrais 2014), substrate proximity, plus two uncorrected systematic biases (optical projection per Rautu and Orsi 2017, camera integration per [Pecreaux 2004, Eq. (6)]).
    

### 2.2 Dataset

22 paired experiments, 4 sessions, all DOPC on gold-coated glass (PSS passivated), 200 mOsm sucrose inside / glucose outside, blue LED optothermal heating, phase contrast at 40x or 100x, 45 or 50 fps.

|Series|N|Protocol|
|---|---|---|
|050226|5|Light-on continuous and cycles|
|110326|5|Light-on, 45 and 50 fps|
|270326|4|Single-cycle thermal pulses|
|160426|8|Two-cycle thermal pulses|

Classification by spectral slope (bending $< -2.5$, tension $> -1.5$, crossover between): 8 bending, 4 crossover, 10 tension.

### 2.3 Pipeline, fully operational

1. `hybrid_detectionmethod.m`: contour extraction, $r(\theta, t)$, $N_\theta = 256$
2. `Event_detection.m`: segmentation into Baseline / Heating k / Post-heat k by drift, roughness, circularity
3. `Fitting_Eventd.m` and `pecreaux_fit_free.m`: two-stage log-space grid search in $(\kappa, \sigma)$, $q \in [6, 20]$
4. Population figure scripts load directly from `Data_reviewed/`, no intermediate cache

Confirmed bug fixes in working copies: the critical normalization (/4 vs /2 in fine-grid fitting, caused $2\times$ underestimation of kappa); `hc.rad_change` units (pixels not microns, correct source is `segments.R_mean` in $\mu$m).

### 2.4 Theoretical framework

- Helfrich Hamiltonian for bending energy
- Equatorial projection [Pecreaux 2004, Eq. (16)]
- Milner-Safran eigenvalues: $\lambda_l = (l-1)(l+2)[l(l+1) + \bar\sigma]$ with $\bar\sigma = \sigma R_0^2 / \kappa$
- Kas and Sackmann 1991 for bilayer coupling and transient pore formation
- Bahrami 2026: cup bending energy $= 16\pi\kappa$, depth-independent
- Faizi 2020 as DOPC kappa benchmark
- Bivas 2014 for log-normal kappa statistics

### 2.5 Quantitative results

**Bending rigidity (bending-dominated baselines only):**

|Statistic|Value|
|---|---|
|Geometric mean|37.4 kBT|
|68% CI (log-normal)|[25.8, 54.2] kBT|
|Faizi 2020 benchmark|22 kBT|
|Ratio to benchmark|1.7x|

**Cycle mechanics (floppy group):**

- Dip ratio (cycle 2 / cycle 1) = 0.36 (second-cycle deformation 64% weaker than first)
- Mean irreversible radius shrinkage = -1.24 $\mu$m
- Tension jump: $\sigma_{\text{PH1}} \approx \sigma_0 \exp(8\pi\kappa / k_B T \cdot \Delta A / A)$ [Kas 1991]
- Anomaly: 110326_45fps_7 NEG-PEAK2R (Heat 2 roughness below baseline). Cleanest single-experiment validation of irreversible tension buildup.

**Recovery dissociation:**

|Observable|Correlation with $t_{\text{off}}$|
|---|---|
|Delta roughness|$r = -0.89$ (N=5)|
|Circularity dip ratio|$r = -0.15$|

### 2.6 Known systematic biases (uncorrected)

|Source|Magnitude|Direction|
|---|---|---|
|200 mOsm buffer (Bouvrais 2014)|+10 to +30%|Increases apparent kappa|
|Substrate proximity|+10 to +20%|Increases apparent kappa|
|Optical projection (Rautu and Orsi 2017)|+15 to +30%|Increases apparent kappa|
|Camera integration time (Pecreaux 2004)|+5 to +10%|Increases apparent kappa|
|Combined multiplicative bias|$\sim 1.75\times$|Closes most of Faizi gap|

---

## 3. Slide-by-slide brief with speaker notes

12 slides plus 4 to 5 backups. Times sum to ~24 min, leaving 5 min for Q&A.

### Slide 1: Title + hook question (0.5 min)

**Title block:** "Membrane Thermomechanics of DOPC GUVs under Repeated Optothermal Stress" **Subtitle:** "What does a lipid bilayer remember?" **Author block:** standard institutional.

**Visual:** one striking phase-contrast image of a GUV mid-invagination. No text overlay.

**Spoken hook (30 to 45 s):**

> "Every cell in your body experiences temperature changes. Fever, inflammation, photothermal therapy, even just exercise. The cell membrane is where that heat acts first. So we asked a simple question. When a membrane is heated and then cooled, does it return to where it started? Or does it remember? In the next half hour I will show you that the answer depends on the membrane's initial mechanical state, and that one of the two ways a membrane can recover is fundamentally different from the other."

**Why this works:** biologists hear cell, fever, therapy. Chemists hear thermal response, material memory. Nobody hears Helfrich.

---

### Slide 2: What is a membrane and what are kappa and sigma (2 min)

**Title:** "Two numbers describe a lipid membrane"

**Content:**

- Lipid bilayer cartoon, two leaflets, hydrophobic core, fluid at room temperature
- "DOPC is a model lipid, pure, well characterized, fluid at room temperature"
- Two mechanical properties:
    - Bending rigidity $\kappa$, units of energy. How much does it resist bending. (Icon: paper vs rubber sheet.)
    - Membrane tension $\sigma$, units of force per length. How taut is it. (Icon: drum skin.)
- Why these matter: they control shape change, fusion, pore formation. Anything biologically interesting.

**Spoken:**

> "A lipid bilayer is a fluid two-dimensional sheet. From the mechanical point of view two numbers describe it. The first is bending rigidity, written kappa. It tells you how much energy it costs to bend the membrane. The second is membrane tension, written sigma. It tells you how taut the membrane is. These two numbers control essentially every biologically interesting behavior of the membrane, from a cell dividing to a virus entering a cell."

---

### Slide 3: GUVs and the experimental setup (2 min)

**Title:** "Our model system and how we heat it"

**Left half:** phase contrast image of a GUV, 10 to 30 $\mu$m diameter, with the fluctuating contour visible. Caption: "Giant unilamellar vesicle, soap bubble made of lipids, size of a cell."

**Right half:** setup SVG (cross-section).

- Glass substrate, thin gold film, GUV on top
- Sucrose inside (200 mOsm), glucose outside (osmolarity matched)
- Blue LED from below, plasmonic absorption in gold, local heating
- Phase contrast objective from above, 50 fps

**Spoken:**

> "Our model membrane is a giant unilamellar vesicle. A spherical lipid bilayer, micrometer scale, the size of a real cell. We make it on a gold-coated glass slide. When we shine blue light from below, the gold absorbs and heats locally. There is no bulk temperature change in the chamber, and no chemical perturbation. We can switch the LED on and off at will and the membrane sees a heating and cooling cycle. We image with phase contrast at fifty frames per second."

**Note for biologists:** "Local optothermal heating is the same principle behind photothermal cancer therapy."

---

### Slide 4: Contour fluctuations encode the mechanics (2 min)

**Title:** "The vesicle wiggles, and the wiggles tell us kappa and sigma"

**Visual layout:** three small panels.

- Left: contour fluctuation cartoon, with $r(\theta, t)$ labeled
- Middle: power spectrum schematic, log-log, $\langle |\hat{u}_q|^2 \rangle$ vs $q$. Show the $q^{-4}$ (bending) and $q^{-2}$ (tension) asymptotes meeting at $q^* \sim \sqrt{\sigma/\kappa}$
- Right: the formula in one line [Pecreaux 2004, Eq. (16)]

**Spoken:**

> "The membrane is not static. Thermal energy makes it fluctuate. We measure these fluctuations frame by frame, decompose them into Fourier modes, and look at the power spectrum. At short wavelengths the spectrum decays as q to the minus four, that part is set by the bending rigidity. At long wavelengths it decays as q to the minus two, that part is set by the tension. The crossover between these two regimes gives you both numbers at once. This is called flickering spectroscopy. The method dates back to the 1970s but the way we apply it here is recent."

---

### Slide 5: One experiment, end to end (3 min)

**Title:** "What happens during a heating cycle"

This is the most information-dense slide. Take time.

**Layout:** 2x2 panel.

- Top-left: full time trace of one floppy vesicle. Circularity, roughness, mean radius vs time. Shaded bands for Baseline, Heat 1, Post-heat 1, Heat 2, Post-heat 2.
- Top-right: spectra per segment, four curves stacked. Annotate the regime: bending baseline (slope $\sim -3$), heating crossover, post-heat tension-dominated (flat), heat 2.
- Bottom-left: extracted $\sigma$ per segment, bar chart.
- Bottom-right: extracted $\kappa$ per segment, bar chart (only meaningful for bending segments).

**Spoken:**

> "Here is a single floppy vesicle through one of our protocols. The top-left panel is the time trace. The blue band is baseline before any heating. The orange bands are heating, the LED is on. The red bands are post-heat, the LED is back off. You can see the circularity drops during heating, that is the vesicle deforming inward, and the radius decreases after heating, that is the irreversible part."

> "The top-right panel shows the power spectrum for each of those segments. The baseline spectrum has a clean q to the minus three behavior, telling us this vesicle is in the bending-dominated regime. After the first heating, the spectrum changes shape entirely, it becomes much flatter, meaning the tension has risen. After the second heating, the same thing again."

> "The bottom panels are the extracted numbers. Tension jumps by orders of magnitude across each cycle. Bending rigidity is only well-defined in the bending segments and remains roughly constant."

---

### Slide 6: Two populations, same preparation (2 min)

**Title:** "Vesicles from the same batch are not all alike"

**Visual:** $\sigma$ vs $\kappa$ scatter, log scale on $\sigma$. Two clear clusters, color-coded floppy and pre-tensed. Diagonal line at $\bar\sigma = 1$ (the bending-tension crossover). Two flagged outliers labeled.

**Spoken:**

> "When we look at a population of vesicles from the same preparation, the baseline tension splits into two clouds about four orders of magnitude apart. We call them floppy and pre-tensed. Floppy vesicles have plenty of excess area to fluctuate, their spectrum is bending-dominated. Pre-tensed vesicles are already taut, their spectrum is tension-dominated."

> "This is not a preparation artifact. It is the natural stochastic variation in how much excess area gets locked in at electroformation. The two groups behave completely differently under heating, and that difference is the next part of the talk."

**Important:** do not call this a problem with the prep. Frame as feature, not bug.

---

### Slide 7: Tension ratchets across cycles (2 min)

**Title:** "Floppy vesicles ratchet their tension upward; pre-tensed vesicles do not"

**Visual:** two side-by-side $\sigma$ vs cycle plots, both on log scale.

- Left: floppy group. $\sigma$ rises by 2 to 3 orders of magnitude after the first heating. Stays elevated. Subsequent cycles add smaller increments.
- Right: pre-tensed group. $\sigma$ stays essentially flat across cycles.

**Spoken:**

> "When we heat the floppy vesicles, their tension jumps by orders of magnitude in the first cycle, and stays elevated. The second cycle adds a smaller increment. The system is ratcheting in tension, not just oscillating. The pre-tensed vesicles, on the right, do nothing. Their tension is already at the level the floppy ones are heading toward."

> "So the floppy ones are climbing a staircase. The pre-tensed ones are already at the top."

---

### Slide 8: Recovery dissociation (4 min, the climax)

**Title:** "Fluctuation amplitude and shape recover on different timescales"

This is your single most important slide. Give it the most visual space and the most time. Two scatter plots side by side.

**Left panel:** $\Delta$ roughness (post-heat minus baseline) vs $t_{\text{off}}$ (time since LED off). Regression line. Annotation: "r = -0.89, N=5".

**Right panel:** circularity dip ratio (cycle 2 over cycle 1) vs $t_{\text{off}}$. Regression line. Annotation: "r = -0.15".

**Large prominent text near the bottom:**

> "Roughness recovers. Shape does not. They operate on separate timescales."

**Transition from slide 7:**

> "So far you might be saying, fine, heating leaves the membrane tighter, that is what you would expect. The next slide is the part of this work that we did not expect, and it took us months to convince ourselves it was real."

**Spoken (main):**

> "We have two ways of measuring whether a vesicle has recovered after a heating event. The first is roughness, the amplitude of its membrane fluctuations. The second is its shape, specifically how deep it invaginates when you heat it a second time. If the membrane has fully recovered, both should return to baseline."

> "On the left, roughness vs time after heating ended. The correlation is strong and negative, r equals minus point eight nine. The longer the LED has been off, the more the roughness has recovered. That is what you would naively expect of a relaxation process."

> "On the right, the dip ratio. This is how deep the second invagination is compared to the first. If the vesicle had recovered, this ratio should approach one. It does not. It stays around point three six regardless of how long you wait. Correlation with time, r equals minus point one five, statistically indistinguishable from zero."

> "These are the same vesicle, the same cycle, the same microscopy frames. The two observables decouple completely. One recovers, the other does not. They operate on separate timescales."

**Why this is the climax:** it is novel, it is robust (intra-vesicle measurement), and it has biological implications. It also frames the next slide naturally.

---

### Slide 9: Physical interpretation, the Kas-Sackmann mechanism (3 min)

**Title:** "Two recovery channels, two timescales"

**Visual:** three-panel mechanism cartoon.

- Panel A, baseline: spherical GUV, low tension, smooth contour. Labeled "kappa, sigma zero, excess area in reservoir."
- Panel B, heating: gold heats, area expands faster than volume can osmotically equilibrate, vesicle invaginates. Labeled "Delta A / A > (2/3) Delta V / V."
- Panel C, cooling: transient nanopore opens during recontraction, internal solution leaks, vesicle has lost volume. Labeled "Same area, reduced volume, sigma elevated, irreversible."

**Spoken (the balloon analogy, deliver this verbatim or close to it):**

> "Think of a balloon. You squeeze it. The air inside pushes outward but cannot escape, so the rubber stretches. You release. The rubber relaxes back. If you do this enough times nothing has changed."

> "Now imagine that during each squeeze, an invisible valve opens for a fraction of a second and a small amount of air leaks out. After every release, the balloon is slightly tighter than before. Same rubber, less air, more tension. That valve in our system is a transient nanopore that opens during the cooling phase. The air leaking out is internal sucrose solution."

> "This explains both observations. The fluctuation amplitude recovers because tension partially relaxes through osmotic re-equilibration on a ten to hundred second timescale. The shape does not recover because the lost volume is, on the timescale of our experiment, permanent. Two channels, two timescales."

**For biologists, add:** "In a real cell, the same decoupling would mean that a membrane can look recovered, normal fluctuations, while still being mechanically compromised, elevated tension, persistent shape change. Any biophysical assay that relies only on fluctuation amplitude would miss this."

---

### Slide 10: Bending rigidity population (2 min)

**Title:** "Bending rigidity of DOPC, our distribution"

**Visual:** sorted bar chart of kappa values, with a horizontal line at 22 kBT labeled "Faizi 2020 (DOPC, low osmolarity)" and a band showing the geometric mean and 68% CI of our population.

**Spoken:**

> "On the way out, one supporting result. Our distribution of bending rigidities across all bending-dominated baselines has a geometric mean of thirty seven kBT, log-normal as Bivas and coworkers showed it should be. The Faizi 2020 reference for DOPC in dilute buffer is twenty two kBT. We are sitting about a factor of one point seven high."

> "Two systematic effects we have not yet corrected for, optical projection and camera integration time, push our number downward when applied. Two physical effects, the high sucrose buffer concentration and the proximity to the gold substrate, are known to stiffen the apparent bending rigidity. The combination explains the gap. We report this as the current upper bound, with the corrections to come."

**Important:** do not get pulled into a long discussion of why kappa is high. One sentence, move on. If asked in Q&A, then go deep.

---

### Slide 11: Outlook (2 min)

**Title:** "What comes next"

Three bullets, one image each.

1. **Control experiments.** Passivated substrate (remove gold) and low-osmolarity (50 mOsm) arms, to isolate the two contributions to elevated kappa.
    
2. **Mechanism validation.** FRAP with fluorescent tracer to directly test the transient pore hypothesis. Osmotic-step recovery to measure permeability change after heating.
    
3. **Particle decoration.** Streptavidin-coated microspheres attached via biotin-DOPE to the membrane. Does attaching particles change the tension-ratcheting dynamics? Does it pin the invagination?
    

**Closing spoken:**

> "What we are learning is that membrane recovery is not a single process. Different mechanical observables relax on different timescales. A vesicle can look recovered while remaining mechanically compromised. We think that matters for any biophysical assay that relies on fluctuation amplitude alone. Thank you."

---

### Slide 12: Acknowledgements and Q&A

Lab, funding sources, BIO2.0 team, collaborators if any. Then Q&A.

---

## 4. Transitions, the connective tissue

The talk should feel like one continuous argument, not twelve disconnected slides. The transitions matter.

|Between|Transition line|
|---|---|
|1 -> 2|"Before I can show you what we found, I need to tell you what we measure."|
|2 -> 3|"Now: how do we get at those two numbers experimentally?"|
|3 -> 4|"We do not need to do anything mechanical to the membrane to measure its mechanics. The membrane does the work for us."|
|4 -> 5|"That gives us a knob for every segment of an experiment. So let me show you what an experiment looks like."|
|5 -> 6|"That was one vesicle. When we look at the full population, we see something we did not initially expect."|
|6 -> 7|"The two populations diverge dramatically when you start heating them."|
|7 -> 8|"So tension ratchets. That much you might predict. The next slide is the part of this work that we did not predict, and it took us months to convince ourselves it was real."|
|8 -> 9|"Two observables, same vesicle, different recovery. That demands a mechanism."|
|9 -> 10|"Let me close the loop with one supporting result on the population of vesicles we surveyed."|
|10 -> 11|"Where this goes from here."|

---

## 5. Q&A preparation

Predicted questions, with prepared answers.

**Q1. Why is your kappa so high compared to literature?**

> "Four contributions, each modest, multiplying together. The buffer at 200 mOsm stiffens by about 10 to 30 percent. Substrate proximity another 10 to 20. Two optical corrections we have not yet applied, projection and camera integration, push the value down by another 15 to 30 percent each when included. The combined expected bias is about 1.75. We see 1.7. So the gap is explained by known effects, not by anomalous DOPC physics."

**Q2. How do you know the recovery dissociation is not just measuring two different vesicles?**

> "Both observables are extracted from the same vesicle, same cycle, same microscopy frame. The dissociation is intra-vesicle, not inter-vesicle. That is the strongest part of the result."

**Q3. What sets which vesicle ends up floppy versus pre-tensed?**

> "Stochastic excess area at electroformation. We embrace both populations rather than selecting against one. The two-population structure is a feature of the system, not an artifact."

**Q4. What about cycle three, four, five? Does the ratchet saturate?**

> "We have up to two-cycle data in the current dataset. Saturation is expected and predicted by the model, since once you have used up the excess area reservoir, further heating cannot invaginate. Quantifying saturation directly is in the next round of experiments."

**Q5. What is the next experiment?**

> "FRAP with a fluorescent tracer would directly test the pore hypothesis. Osmotic-step recovery tests the permeability change. Both go after the proposed mechanism head-on."

**Q6. Is this relevant to actual cells?**

> "DOPC is a model lipid. Real cells have proteins, cholesterol, and an active cytoskeleton. We are establishing the bare-bilayer thermomechanical baseline. The dissociation we see should be there in any system that has both osmotic and area-coupling channels, which is essentially any closed membrane. The particle decoration arm is the next step toward composite, decorated membranes that are closer to biological reality."

**Q7. Could the irreversibility just be photodamage?**

> "We checked. The blue LED is at intensity well below the lipid peroxidation threshold for DOPC, and we see the same effect at multiple intensities and exposure times that are inconsistent with a chemical degradation timescale. The behavior also depends on the initial tension state of the vesicle, which photodamage would not explain."

**Q8. (Hostile) Your statistics are weak, N is small.**

> "Correct, that is a current limitation. Five vesicles for the recovery analysis. The within-vesicle correlations are strong, but expanding the dataset is in the immediate plan. We are aiming for 15 to 20 well-characterized vesicles before submission."

---

## 6. Three-day execution plan

### Day 1, today: figures and structure

1. From the `Data_reviewed/` pipeline, export the following figures at 300 dpi, all in the Okabe-Ito palette:
    - Time trace with segments for one floppy vesicle (e.g., 050226_thenLightOn_11 or 160426 dataset)
    - Time trace with segments for one pre-tensed vesicle (270326 series)
    - Spectra per segment, four curves, for the floppy example
    - $\sigma$ vs $\kappa$ population scatter
    - $\sigma$ staircase for floppy group across cycles
    - $\sigma$ flat for pre-tensed group across cycles
    - Recovery panel: $\Delta$ roughness vs $t_{\text{off}}$
    - Recovery panel: circularity dip ratio vs $t_{\text{off}}$
    - Sorted kappa bar with Faizi 2020 reference
2. Draft slides 1 to 4 (intro and bridge) on paper or whiteboard. Do not open Beamer yet. The intro is what gets corrected most by the audience, so design it analog first.

### Day 2: Beamer build

1. Start from the existing `flickering_full.tex` (33 slides from April) and prune to 12 slides per this brief. Aggressive pruning, not soft editing.
2. Replace `\figbox` placeholders with day 1 figures.
3. Slides 8 and 9 last and most carefully. They are the climax. Multiple iterations.
4. Compile and verify: title page (no overlap), setup schematic, footer, ACF slide subtitle (lingering hyperref underline from April, see notes below).
5. Build 4 to 5 backup slides (section 7).

### Day 3: rehearsal and trim

1. Time each slide on a first run-through. Cut anything that puts you over 25 min.
2. Replace any equation or jargon a chemist or biologist would stop on.
3. Second rehearsal, full pace, time the climax slide (8) carefully. It should be the longest single slide.
4. Final compile, export PDF, copy to the presentation machine. Bring two USB sticks.

---

## 7. Backup slides to prepare (4 to 5)

1. **Full Pecreaux spectrum fit details:** the two-stage log-space grid search, the cost function, fit range and bounds. For physicist questions.
2. **Pipeline overview:** the four-stage chain, hybrid_detectionmethod -> Event_detection -> Fitting_Eventd -> population figures. For methods questions.
3. **Full systematic bias table:** the four contributions, their estimated magnitudes, references, and how they combine multiplicatively. For the kappa-is-high question if it goes deep.
4. **Simpson's paradox note:** the global $r = -0.55$ between $\Delta A / A$ and $\log_{10}(\sigma_{\text{PH1}} / \sigma_0)$ is a between-group artifact; within-group $r \approx -0.14$. For statistically sophisticated questioners.
5. **Particle decoration cartoon and protocol summary:** 0.4 $\mu$m streptavidin Flash Red beads, 1 mol% and 5 mol% DOPE-Biotin, 100x phase contrast plus far-red fluorescence channel. For questions about what is next.

---

## 8. Beamer notes from the existing deck

The existing `flickering_full.tex` (33 slides) is the starting point. From the previous session, known issues:

1. **Title page overlap:** previously fixed (author no longer overlaps subtitle).
2. **ACF slide subtitle hyperref underline:** unresolved as of last build. Robust fix is to wrap the subtitle access in the frametitle template with `\NoHyper ... \endNoHyper`, or to use `hidelinks` only within the frametitle. Specifically:

```latex
\ifx\insertframesubtitle\@empty\else\\[2pt]%
  {\color{textGray}\usebeamerfont{framesubtitle}%
   \begingroup\hypersetup{hidelinks}\insertframesubtitle\endgroup}%
\fi
```

3. **Compile command on Mac:** `pdflatex talk && pdflatex talk` (two passes for cross-references).
4. **Theme:** custom minimal, Okabe-Ito palette, accent-rule frame titles, three-zone fixed-width footer. Keep it.
5. **Pgfplots reference spectrum:** $q^{-4}$ to $q^{-2}$ crossover with three sigma regimes overlaid. Keep this for slide 4.
6. **Setup schematic:** the rebuilt one with Au film shading, plasmonic hotspots, heat plume, tracked contour dots, scale bar. Keep this for slide 3.

---

## 9. What to deliberately leave out

Tempting but cuts that hurt the narrative.

1. Pipeline implementation details (hybrid detection method, two-stage grid search). Put one slide in backup if asked.
2. Simpson's paradox aside on the global r in the phase trajectory. Save for Q&A or backup.
3. Camera and optical projection derivation. One sentence as caveat on the kappa slide. Backup if pressed.
4. Particle decoration protocol detail. One outlook bullet, no numbers.
5. Spin coater gentle hydration. Not relevant to the story being told.
6. The original $/4$ vs $/2$ normalization bug history. This is internal lab knowledge; do not air dirty laundry in a talk.

---

## 10. Final notes on delivery

1. Practice the hook out loud. The first 45 seconds are 90 percent of what people remember.
2. On slide 8, slow down. Pause after "they operate on separate timescales." Let it land.
3. On the balloon analogy, do not rush. Two beats between sentences. Hand gestures help.
4. Read the room on slide 10. If kappa-is-high questions are already coming up nonverbally, expand. If not, keep it tight.
5. Q&A: have your prepared answers ready, but if the first question stumps you, "that is a good question, let me think for a second" is always better than improvising poorly.
6. End the talk on time. A talk that runs 28 minutes is forgivable. One that runs 35 is not.