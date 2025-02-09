---
tags:
  - "#protocol"
  - "#lipids"
  - "#membranes"
  - "#bilayer-properties"
  - "#lipid-calculation"
  - "#stock-solution-preparation"
---
The idea is to revisit the process, to avoid mistakes... 
##  Steps 

- Decide the final volume and **total lipid concentration** 
- Calcule **how many total moles** of lipid that represent 
- **Distribute those moles** among each lipid according to the desired mole percentages (e.g., 99.9% **main lipid**, 0.1% **labeled lipid**).
- **Convert the moles** of each component into  a volume (if a is stock solution in mg/mL or mmol/L). 
- **Combine** the lipids in chloroform.
# Example 

For the protocol of DOPC. 

• **Total final volume:** 500 µL (0.5 mL)

• **Total final lipid concentration:** 4 mM


• **Lipid composition:** 99.9% DOPC (main lipid) and 0.1% DOPE-Rhodamine 
It suppose to be this values (ask to confirm)
• **DOPC stock:** 25 mg/mL in chloroform (MW $\approx 785$ g/mol)

• **DOPE-Rh stock:** 1 mg/mL in chloroform (MW $\approx 1300$ g/mol)

## Calculation

- Decide the final volume and **total lipid concentration** 
**Final volume** ($V$)  = 0.50 mL

**Final concentration** ($C$)  = 4 mM = 4 µmol/mL

## Calculate Total Lipid (in moles)

$n_{\mathrm{totla}} = V \times C = 0.5 \mathrm{mL}\times 4 \mathrm{mol/mL}=2\ \mathrm{mol}\to$ total lipid
## Distribute Moles According to Mole Percent

**Desired mole fraction**:

• $\mathrm{DOPC}$ = 99.9% = 0.999

• $\mathrm{DOPE-Rh}$ = 0.1% = 0.001
  

$$n_{\text{DOPC}}= 0.999 \times 2\,\text{µmol}= 1.998\,\text{µmol}$$
$$n_{\text{DOPE-Rh}}

= 0.001 \times 2\,\text{µmol}

= 0.002\,\text{µmol}.$$
## Formula
**If your stock is in mg/mL**,  need the MW to convert mg ↔ mol, hide that inside a single step.
The **general one-step** formula to get volume (in mL) from a mg/mL stock is:

$$V_i (\text{mL})= n_i (\text{mol})\times \frac{\text{MW} (\text{g/mol})}{\text{Stock conc} (\text{mg/mL})}
\times \frac{1000\,\text{mg}}{1\,\text{g}}.$$
  

$$V_{\text{DOPC}}

= (1.998 \times 10^{-6}\,\text{mol})

\times \frac{785\,\text{g/mol}}{25\,\text{mg/mL}}

\times \frac{1000\,\text{mg}}{1\,\text{g}}.$$
## Extra: Convert Each Lipid’s Moles to Mass (if needed)

  
**A. DOPC**

• Moles: $1.998\,\text{µmol}$

• MW (approx.): 785 g/mol

$$
\text{Mass (DOPC)}

= 1.998 \times 10^{-6}\,\text{mol}

\times 785\,\frac{\text{g}}{\text{mol}}

= 1.57 \times 10^{-3}\,\text{g}

= 1.57\,\text{mg}.
$$
**B. DOPE-Rh**

• Moles:$0.002\,\text{µmol} = 2 \times 10^{-9}\,\text{mol}$

• MW (approx.): 1300 g/mol

$$
\text{Mass (DOPE-Rh)}

= 2\times10^{-9}\,\text{mol}

\times 1300\,\frac{\text{g}}{\text{mol}}

= 2.6\times10^{-6}\,\text{g}

= 2.6\,\text{µg}.$$

## Convert Mass to Volume Based on Stock Concentrations


**A. DOPC Stock (25 mg/mL in chloroform)**
$$V_{\text{DOPC}}

= \frac{1.57\,\text{mg}}{25\,\text{mg/mL}}

= 0.0628\,\text{mL}

= 62.8\,\text{µL}.$$
**B. DOPE-Rh Stock (1 mg/mL in chloroform)**

$$
V_{\text{DOPE-Rh}}

= \frac{2.6\,\text{µg}}{1\,\text{µg/µL}}

= 2.6\,\text{µL}.
$$
  
Pipette 63 µL of the DOPC stock and ~2.6 µL of the DOPE-Rh stock into a single vial.


---

To convert **1 mg/mL** of a compound with **MW** $\approx$ 1300 **g/mol** into **mM** 

1. **Convert the mass in mg to grams** (per mL):

$$1\,\text{mg/mL}

= 0.001\,\text{g/mL}.$$

  

2. **Use the molecular weight** to find the number of moles in that 0.001 g:

  
$$
\text{moles}

= \frac{\text{mass (g)}}{\text{MW (g/mol)}}

= \frac{0.001\,\text{g}}{1300\,\text{g/mol}}

\approx 7.69 \times 10^{-7}\,\text{mol}.
$$
  

1. **Because this is per 1 mL**, the volume is 1 \times 10^{-3}\,\text{L}. So the molar concentration C (in \text{mol/L}) is:

  

$$C

= \frac{7.69 \times 10^{-7}\,\text{mol}}{1 \times 10^{-3}\,\text{L}}

= 7.69 \times 10^{-4}\,\text{mol/L}

= 0.000769\,\text{mol/L}.
$$
  

2. **Convert mol/L (M) to millimolar (mM)**:

  
$$
0.000769\,\text{mol/L}

= 0.769\,\text{mM}

\approx 0.77\,\text{mM}.

  $$

  

Hence, a **1 mg/mL** solution of a lipid with **MW** $\approx 1300$ **g/mol** corresponds to $\approx 0.77$ **mM**.