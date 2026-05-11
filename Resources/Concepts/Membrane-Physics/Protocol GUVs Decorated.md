
**System:** DOPC GUVs + Streptavidin-coated fluorescent microspheres 
**Binding chemistry:** DOPE-Biotin (Avanti 870282) / Streptavidin 
**Objective:** Visualize effect of membrane-bound particles on GUV shape deformation under blue LED optothermal heating.
## Materials

| Item           | Details                                                     |
| -------------- | ----------------------------------------------------------- |
| DOPC           | 25 mg/mL in chloroform                                      |
| DOPE-Biotin    | Avanti 870282, 10 mg/mL (9.68 mM) in chloroform             |
| RhPE           | 10 mg/mL in chloroform                                      |
| Particles      | CFFR002, 0.4 µm Flash Red, streptavidin-coated (Bangs Labs) |
| Sucrose        | 200 mOsm, filtered 0.22 µm                                  |
| Glucose        | 200 mOsm, filtered 0.22 µm                                  |
| Chloroform     | Fresh, pure                                                 |
| Gold substrate | PSS-coated gold-coated glass (3nm Cr+10nm Au)               |

---

## Part 1 -- Particle Washing

Perform on the day of the experiment.

**1.** Allow stock to equilibrate at RT for 15 min in the dark  
**2.** Vortex 20 s, pipette up/down 10x  
**3.** Transfer **10 µL stock** into a clean 1.5 mL Eppendorf. Return stock to fridge

**Wash cycle** -- repeat x3:

1. Add glucose 200 mOsm to **1000 µL total**-
2. Vortex 10 s
3. Centrifuge **14,000 rcf, 10 min**
4. Aspirate supernatant with 200 µL pipette -- leave ~50 µL at bottom
5. Refill with glucose 200 mOsm to 1000 µL, pipette gently 20x

**After 3rd wash:**

- Aspirate leaving ~50 µL
- Add glucose 200 mOsm to **1000 µL** final volume
- Vortex 30 s + pipette 40x vigorously
- Use same day

---

## Part 2 -- Lipid Mixture Preparation

### 2a. Dilute DOPC to 4 mM (460 µL)

$$C_\text{stock} = \frac{25,\text{mg/mL}}{786.1,\text{g/mol}} = 31.8,\text{mM}$$

- **58 µL** DOPC stock (31.8 mM) + **402 µL** chloroform = 460 µL at 4 mM

### 2b. DOPE-Biotin Working Stock 0.968 mM

- **10 µL** DOPE-Biotin stock (9.68 mM) + **90 µL** chloroform = 100 µL at 0.968 mM

### 2c. Lipid mixtures (230 µL per tube)

Add components **in this order**:

|Component|T1 (1 mol% biotin)|T2 (5 mol% biotin)|
|---|---|---|
|Chloroform|198 µL|193 µL|
|DOPC 4 mM|29 µL|29 µL|
|DOPE-Biotin 0.968 mM|1.2 µL|6.3 µL|
|RhPE 10 mg/mL|1.3 µL|1.3 µL|
|**Total**|**~230 µL**|**~230 µL**|

Mix 10x with Hamilton syringe after each addition.

---

## Part 3 -- Spin Coating

Per tube (50 µL per slide, up to 4 slides per tube):

1. Place clean glass slide on spin coater, center over vacuum hole
2. Start spin: **1000 rpm, 120 s**, acceleration/deceleration 2 s
3. Slowly drip **50 µL** lipid mixture onto slide during spinning
4. Transfer coated slide to vacuum desiccator
5. Desiccate **minimum 1 h** (overnight preferred)

---

## Part 4 -- Gentle Hydration

1. Preheat plate to **60°C**, wait 10 min for equilibration
2. Clip spacer onto coated slide, secure with 4 clips (remove metal parts for flat contact)
3. Add **500 µL sucrose 200 mOsm** -- ensure full coverage of slide interior
4. Cover with aluminium foil
5. Incubate **30 min at 60°C**
6. Recover GUV suspension into Eppendorf

---

## Part 5 -- GUV Transfer to Sucrose/Glucose Medium

GUVs are currently in pure sucrose -- must add glucose exterior for sedimentation.

**1.** Take **100 µL** GUV suspension  
**2.** Add to **200 µL glucose 200 mOsm** in new Eppendorf  
**3.** Invert gently 3x  
**4.** Wait **20 min** at RT in the dark -- GUVs sediment (sucrose inside > glucose outside)  
**5.** Aspirate **100 µL from the bottom** slowly -- enriched GUV fraction, reduced lipid debris  
**6.** Transfer to new Eppendorf with **100 µL fresh glucose 200 mOsm**  
**7.** Invert 3x -- ready for particle incubation

---

## Part 6 -- Particle Decoration

1. Vortex washed particles **30 s** + pipette 40x with 200 µL tip
2. Add **10 µL particles** to 200 µL clean GUV suspension
3. Mix by inverting **5x** -- no vortex
4. Incubate **60 min at 37°C**, in the dark, at rest

---

## Part 7 -- Imaging

1. Deposit **50 µL** decorated GUV suspension onto gold substrate
2. Add **50 µL glucose 200 mOsm**
3. Wait **15 min** for sedimentation
4. Observe at **100x**, phase contrast + Flash Red fluorescence channel
5. Perform optothermal heating cycles with blue LED

### Controls

|Control|Preparation|Purpose|
|---|---|---|
|Bare GUV (no particles)|T1/T2 without beads|Baseline shape dynamics|
|Particles only (no GUVs)|Beads in glucose on substrate|Confirm no non-specific gold adhesion|

---

## Key Numbers

|Parameter|Value|
|---|---|
|DOPE-Biotin MW|1033.4 g/mol|
|DOPE-Biotin stock|9.68 mM in chloroform|
|RhPE MW|1301.8 g/mol|
|Particle diameter|400 nm|
|Particle stock|10 mg/mL (1% solids)|
|Working particle concentration|0.001% solids in glucose 200 mOsm|
|Sucrose/glucose osmolarity|200 mOsm each|
|Incubation temperature|37°C, 60 min|

---

## Notes and Troubleshooting

- **No particle attachment:** increase biotin mol% or incubation time; ensure GUV wash step removes free lipid debris competing for streptavidin sites
- **Particle clusters:** re-wash particles; pipette more vigorously before use; use same day after washing
- **Poor GUV formation:** extend desiccation time; check chloroform film uniformity after spin coating
- **Particles visible on gold substrate but not on GUVs:** streptavidin active but biotin inaccessible -- consider switching to DOPE-PEG2000-Biotin (Avanti 880129)
- **Blue LED cross-talk with fluorescence:** Flash Red (ex 660 nm / em 690 nm) is spectrally orthogonal to blue LED (~450 nm) -- no cross-talk