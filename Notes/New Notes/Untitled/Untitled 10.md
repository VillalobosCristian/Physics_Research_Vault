# Part B-1 (max 10 pages)

> Working title: **CHEM-MEMO: Chemically Driven Membrane Mechanics for Protocell Behaviours**  
> Panel: **P** (Physics) — adjust if needed  
> Fellowship type: **European Postdoctoral Fellowship (12–24 months)** — adjust if GF

## 1. Excellence

### 1.1 Quality and pertinence of the objectives; ambition beyond the state of the art

**Overall objective.** Engineer **temperature- and chemo-responsive protocell platforms** to study how **chemical gradients deform lipid membranes and drive protocell-like interactions**.

**Specific, measurable objectives (O1–O4).**

- **O1 — Build a temperature‑tunable GUV platform** spanning gel–fluid regimes and net charge variants. _KPI:_≥70% unilamellar yield; size distribution 10–30 µm with SD ≤20%; reproducible phase transition mapping.
    
- **O2 — Quantify membrane mechanics under chemical cues** (pH/salt/ligand gradients): bending rigidity (κ), tension (σ~), spontaneous curvature proxies. _KPI:_ ±10% uncertainty in κ via equatorial flicker spectroscopy; validated against tense/folded controls.
    
- **O3 — Demonstrate chemo-driven shape changes & motility of vesicles** in microfluidic gradients. _KPI:_reproducible budding/tubulation thresholds; directed drift ≥0.5 µm/s under defined gradients.
    
- **O4 — Develop predictive models for **chemically driven protocell interactions** (adhesion, fusion, cargo uptake) and validate experimentally. _KPI:_ agreement of model vs. experiment within 15% for onset thresholds; open-source code & datasets.
    

**Ambition & beyond SoA.**

- Integrates **chemical signaling** with **membrane mechanics** in GUVs to reproduce **prebiotic-relevant behaviours** (intake, sorting, shape morphogenesis) with **quantified control by T and gradients**.
    
- Delivers a **robust flickering-spectroscopy pipeline** (acquisition→analysis→validation) and **microfluidic gradient assays**, creating **reproducible benchmarks** usable by the community.
    

### 1.2 Soundness of methodology; interdisciplinarity; gender & diversity; open science

**Concepts & working hypotheses.** Chemical gradients modulate local lipid composition/charge/hydration → shift **effective tension and curvature fields** → drive **shape deformations** and **vesicle–vesicle interactions**.

**Approach overview.**

- **Platform fabrication (WP1):** gentle hydration & PVA-assisted GUVs; defined lipid mixes with tunable T_m and charge; quality control (confocal, phase contrast).
    
- **Mechanical readouts (WP2):** equatorial flickering; contour detection; spherical harmonics spectrum fitting; derive κ and σ~; cross-validate with micropipette/aspiration where feasible.
    
- **Chemo‑gradient assays (WP3):** Y‑junction microfluidics; step & linear gradients in pH/salts/ligands; quantify protrusions, budding, motility; image analysis automations.
    
- **Theory & modeling (WP4):** continuum membrane models with **chemistry‑dependent parameters**; couple to advection–diffusion of solutes; predictions for contact-mediated interactions.
    

**Interdisciplinarity.** Physics (soft matter, nonequilibrium), physical chemistry (lipids/solutes), microfluidics, image analysis/ML, and theoretical modeling.

**Gender & diversity in R&I content.** Ensure datasets disaggregate conditions fairly; mitigate algorithmic bias in automated segmentation (cross‑validation, blinded sets). Include inclusive user documentation for software.

**Open science & RDM.** Preprints; open protocols; GitHub for code (MIT); data under CC‑BY with metadata (FAIR); DMP covers raw/processed movies, segmentation masks, spectra, and microfluidic designs.

### 1.3 Supervision, training, and two‑way knowledge transfer

**Supervisor(s).** [Add names]. Track records in membrane biophysics/soft matter & microfluidics.

**Two‑way transfer.**

- **To fellow:** advanced microfluidics, confocal imaging, biomechanics, lab leadership.
    
- **From fellow:** image analysis (MATLAB/Python), stochastic modeling for active/soft systems, open-source pipelines, prior experience with confined active fluids.
    

**Planned training.** Scientific: vesicle mechanics, microfabrication; Transversal: project management, grant writing, outreach; Short courses/workshops.

**Secondments / non‑academic placement (if any).** [Describe host, timing, added value].

### 1.4 Researcher’s experience, competences, and skills

Briefly evidence: PhD on non‑equilibrium statistical mechanics & active matter (passive tracers in bacterial droplets), stochastic OU frameworks, MATLAB analysis, microscopy; current postdoc bridging physics–chemistry–biology on lipid membranes.

---

## 2. Impact

### 2.1 Career development & employability

**Target profile post‑fellowship:** independent PI at the physics–chemistry–life interface. **Measures:** co‑supervision of students; leadership of open‑source tools; visiting lab exchanges; tailored career development plan; engagement with industry (microfluidics/biotech).

### 2.2 Dissemination, exploitation & communication (DEC)

- **Dissemination:** 2–3 open‑access papers; preprints; protocols.io; conference talks; thematic workshop on “Chemically Driven Protocells”.
    
- **Exploitation:** reusable **analysis pipeline** (pip install), microfluidic designs (CAD); potential IP around gradient‑responsive vesicle carriers (with TTO guidance).
    
- **Communication:** public demos of “living soap bubbles”; schools & science festivals; bilingual materials (EN/ES); social media visuals; trackable KPIs.
    

### 2.3 Magnitude & importance of impacts (quantified where meaningful)

- **Scientific:** standardized **flicker‑spectra** datasets (>10 conditions); reference κ, σ~ vs. temperature/chemistry curves; expected reuse by ≥10 labs within 2 years.
    
- **Technological:** plug‑and‑play microfluidic gradient chip; >500 downloads; integration in 2 partner labs.
    
- **Societal:** improved understanding of **prebiotic pathways** (education/outreach); training of early‑career researchers (≥2).
    

---

## 3. Implementation

### 3.1 Work plan, risks, and effort

**WP overview**

- **WP1 (M1–M6):** GUVs platform — deliver D1.1 protocols; D1.2 QC dataset.
    
- **WP2 (M3–M12):** Flicker pipeline — D2.1 code+docs; D2.2 benchmark κ, σ~.
    
- **WP3 (M6–M20):** Chemo‑gradient assays — D3.1 microfluidic chip; D3.2 morphodynamics dataset.
    
- **WP4 (M9–M22):** Modeling & integration — D4.1 model repo; D4.2 validation report.
    
- **WP5 (M1–M24):** Management & DEC — D5.1 DMP; D5.2 DEC plan; D5.3 workshop.
    

**Milestones**

- **MS1 (M3):** ≥60% unilamellar yield; stable phase mapping.
    
- **MS2 (M9):** κ reproducibility within ±10% on standards.
    
- **MS3 (M14):** First chemo‑driven shape transitions reproduced.
    
- **MS4 (M20):** Validated model predictions vs. experiments.
    

**Risks & mitigations**

- Low GUV yield → switch to electroformation; tweak lipid hydration/sugars.
    
- Unstable gradients → use flow‑stabilized chips; fluorescent solute calibration.
    
- Weak shape response → increase charge asymmetry; use curvature‑inducing lipids/proteins.
    
- Analysis robustness → augment training sets; manual QC subset; cross‑lab validation.
    

**Indicative Gantt (months)**

|WP|1–3|4–6|7–9|10–12|13–15|16–18|19–21|22–24|
|---|---|---|---|---|---|---|---|---|
|WP1|███|██|||||||
|WP2||███|███|██|||||
|WP3|||██|███|███|██|||
|WP4||||██|███|███|██||
|WP5|█|█|█|█|█|█|█|█|

**Secondments/placement (if applicable)**

- [Insert] e.g., 2–3 months to a theory group for model coupling; or 4–6 months non‑academic placement post‑fellowship in microfluidics startup.
    

### 3.2 Host capacity & arrangements

**Hosting.** CRPP (or equivalent) provides confocal/microfluidics facilities, cleanroom access, and data infrastructure. Integration: weekly group meetings; shared lab space; access to workshops & tech platforms.

**Support services.** Grant office, IP/TTO, HPC cluster, training catalogue.

---

### Page budget (aim for ≤10 pages)

- 1.1: 2.5 pages · 1.2: 3.0 pages · 1.3: 1.25 pages · 1.4: 0.75 pages · 2.1: 0.75 pages · 2.2: 0.75 pages · 2.3: 0.75 pages · 3.1: 1.0 page · 3.2: 0.5 pages
    

---

# Part B-2 (no page limit)

## 4. CV of the researcher (≤5 pages suggested)

- Reverse‑chronological positions (dd/mm/yyyy). Brief achievements per role.
    
- Publications (OA or repository), software, datasets; invited talks; awards; supervision.
    
- Funding obtained; outreach.
    

## 5. Capacity of Participating Organisations

- Table 5.1 overview; Table 5.2 one per org (beneficiary ≤1 page; each associated partner ≤½ page).
    
- Facilities: confocal, microfluidics, image analysis, HPC; training & support.
    

## 6. Ethics & security (if needed)

- Human/animal/dual use: N/A (expected). Data: anonymised/no personal data.
    

## 7. Environmental considerations (MSCA Green Charter)

- Lab waste minimisation; energy‑aware imaging; reusable microfluidics where possible; travel plan with remote options.
    

---

## Draft text placeholders to fill next

- Supervisor bio(s) and training calendar
    
- Concrete secondment/placement host(s)
    
- DEC messages & target audiences
    
- Quantified impact ranges (citations/downloads/reuse) and traceable KPIs
    
- Timeline fine‑tuning to match EF duration (12–24 months) or GF (24–36 months with return phase)