![[Pasted image 20260505140728.png]]
![[Pasted image 20260505140902.png]]
![[Pasted image 20260505141016.png]]![[Pasted image 20260505141423.png]]
![[Pasted image 20260505142405.png]]
![[Pasted image 20260505142749.png]]
![[Pasted image 20260505143013.png]]
![[Pasted image 20260505143503.png]]
![[Pasted image 20260505144829.png]]
![[Pasted image 20260505145224.png]]



I have full checkcode output from R2024b plus a complete manual read. Let me now compile the full report.   

  ---                                                                                                         

  **Static Analysis & Manual Audit Report**                                                                       

  **MATLAB version note**                                                                                         

  The MCP server is configured for R2025b but only R2024b (/Applications/MATLAB_R2024b.app) is installed.     

  checkcode was run directly via the R2024b CLI.                                                              

  ---                                                                                                         

  **hybrid_dectctionmethod.m**                                                                                    

  **checkcode** **warnings**                                                                                          

  ┌─────────┬───────┬──────────────────────────────────────────────────────────────────────────────────────┐  

  │  Line   │  ID   │                                     Explanation                                      │

  ├─────────┼───────┼──────────────────────────────────────────────────────────────────────────────────────┤  

  │         │       │ candIdx, candScore, candSign are grown by concatenation ([candIdx; idx(l1)]) inside  │  

  │ 203–205 │ AGROW │ the angle loop. They are reset to zeros(0,1) each iteration (L194–196), so growth is │  

  │         │       │  bounded, but MATLAB still warns.                                                    │  

  ├─────────┼───────┼──────────────────────────────────────────────────────────────────────────────────────┤  

  │ 214–216 │ AGROW │ Same for the -Gr candidate list.                                                     │  

  ├─────────┼───────┼──────────────────────────────────────────────────────────────────────────────────────┤  

  │ 399     │ CAXIS │ caxis([...]) is deprecated since R2022a. Direct replacement: clim([...]).            │

  └─────────┴───────┴──────────────────────────────────────────────────────────────────────────────────────┘  

  **Manual findings**                                                                                             

  4. **No hardcoded absolute paths** — all file I/O uses dir('*.tif') and a relative save(...). Safe across       

  machines.

  5. **Output filename mismatch (critical — see Event_detection §8 below)** — saves                               

  contourExtraction_hybrid_fixed2.mat (line 435). The 2 suffix causes the downstream script to always error.  

  6. **Toolbox dependency, no guard** — findpeaks needs Signal Processing Toolbox; drawcircle, imgaussfilt,

  imgradientxy, imadjust need Image Processing Toolbox. No license/exist check.                               

  ---                                                                                                         

  **Event_detection.m**

  

  **checkcode** **warnings**

  

  ┌─────────┬─────────┬───────────────────────────────────────────────────────────────────────────────────┐   

  │  Line   │   ID    │                                    Explanation                                    │

  ├─────────┼─────────┼───────────────────────────────────────────────────────────────────────────────────┤   

  │ 170,    │ SAGROW  │ segments(end+1) grows a struct array inside loops. Preallocate with a known max   │

  │ 179     │         │ size.                                                                             │

  ├─────────┼─────────┼───────────────────────────────────────────────────────────────────────────────────┤   

  │ 229 ×2  │ NANMEAN │ nanmean(roughness_smooth(post)) — deprecated. Replace with mean(..., 'omitnan').  │

  ├─────────┼─────────┼───────────────────────────────────────────────────────────────────────────────────┤   

  │ 230 ×2  │ NANMEAN │ Same for circularity_smooth.                                                      │

  ├─────────┼─────────┼───────────────────────────────────────────────────────────────────────────────────┤   

  │ 231 ×2  │ NANMEAN │ Same for radius_smooth.                                                           │

  ├─────────┼─────────┼───────────────────────────────────────────────────────────────────────────────────┤   

  │ 282     │ SAGROW  │ baselines(end+1) = bk grows struct array inside loop.                             │

  ├─────────┼─────────┼───────────────────────────────────────────────────────────────────────────────────┤   

  │ 282     │ MSNU    │ The %#ok<AGROW> suppression comment is stale — the warning is now SAGROW (script  │

  │         │         │ context), so the comment suppresses nothing.                                      │   

  ├─────────┼─────────┼───────────────────────────────────────────────────────────────────────────────────┤

  │ 408,    │         │ qleg is captured from quickPlot(...) but the corresponding qleg(ax, ...) call is  │   

  │ 431,    │ ASGLU   │ commented out in all three blocks, so the value is never used. Replace the 4th    │   

  │ 518     │         │ output with ~.                                                                    │

  ├─────────┼─────────┼───────────────────────────────────────────────────────────────────────────────────┤   

  │ 481     │ CAXIS   │ caxis(ax, [...]) deprecated; use clim(ax, [...]). Note that the very next figure  │

  │         │         │ block (L491) already correctly uses clim, making this inconsistent.               │   

  └─────────┴─────────┴───────────────────────────────────────────────────────────────────────────────────┘

  **Manual findings**                                                                                             

  7. **Hardcoded external-drive path (line 11)**                                                                  

  reviewedDir = '/Volumes/SSD samsung/Vesicles2026/Data_reviewed';

  7. This is a macOS mount point for a specific USB/SSD drive. Will fail (mkdir error or silent               

  save-to-wrong-place) on any machine without that exact volume mounted.                                      

  8. **Critical filename mismatch with upstream script (lines 4 & 15)**                                           

    - hybrid_dectctionmethod.m L435 saves: **contourExtraction_hybrid_fixed2.mat**                                

    - Event_detection.m L4 checks for: **contourExtraction_hybrid_fixed.mat** (no 2)                              

    - L15 loads the same wrong name.                                                                          

  The L4–6 safety guard will **always** throw the error message unless the .mat file is renamed manually between  

  runs. The pipeline is currently broken at this seam.                                                        

  9. **Copy-paste bug in** **circ_excursion** **(lines 114–115)**

  rough_excursion(k) = max(roughness_smooth(idx))       - roughness_smooth(zones_drift(k,1));  % correct      

  circ_excursion(k)  = roughness_smooth(zones_drift(k,1)) - min(circularity_smooth(idx));      % BUG          

  10. The first term of circ_excursion should be circularity_smooth(zones_drift(k,1)), not                     

  roughness_smooth(...). As written, circ_excursion is mixing the two signals, making the event-filter        

  criterion on L120 produce wrong results.

  11. **transient_skip** **redefined (line 157)** — already set to 50 at L127, then silently reassigned to 50 again at

   L157 inside %% 6. SEGMENT DEFINITIONS. Not a bug, but confusing.                                           

  12. **Hardcoded calibration constant (line 288)**

  pixels_per_micron = 11.5;                                                                                   

  13. Not a path issue, but silently produces wrong physical units on any other microscope/camera combination.

   Should come from metadata or a config variable.                                                            

  14. **Stale layout size (line 390)** — tiledlayout(fig1, 5, 1) allocates 5 rows, but two subplot blocks are     

  commented out, so only 3 tiles are filled. The saved figure has two empty tile slots and wasted whitespace. 

  15. **Potential crash when no segments qualify (lines 498–508)** — fourier_segs(1).spectrum at L503 is evaluated

   unconditionally (outside the for k = 1:n_fs loop). If n_fs == 0 (no segment passed the spectral-analysis   

  filter), MATLAB throws an out-of-bounds index error.

  16. **Helper functions not on path** — quickPlot and savefigures_new are in Plots/ subdirectory. Neither script 

  calls addpath. The scripts rely on the user having Plots/ in their saved MATLAB path; this is invisible to  

  anyone who clones the repo fresh.

  ---             

  **Fitting_Eventd.m**

  

  **checkcode** **warnings**

  

  ┌──────┬───────┬─────────────────────────────────────────────────────────────────────────────────────────┐

  │ Line │  ID   │                                       Explanation                                       │

  ├──────┼───────┼─────────────────────────────────────────────────────────────────────────────────────────┤

  │ 437  │ AGROW │ kap_str = [kap_str ' *'] grows a string inside a loop. Use a logical flag and format in │

  │      │       │  one sprintf call instead.                                                              │

  └──────┴───────┴─────────────────────────────────────────────────────────────────────────────────────────┘  

  **Manual findings**                                                                                             

  17. **Hardcoded** **external-drive** **path** **(line 38)**

  reviewedDir = '/Volumes/SSD samsung/Vesicles2026/Data_reviewed';

  18. Same /Volumes/SSD samsung/... path as in Event_detection.m. Same failure mode.

  19. **Redundant computation (lines 219 & 222)** — sigma_bar and sbar_fit are computed with the identical         

  expression (sigma_fit * R0_m^2 / kappa_fit) two lines apart into two different variables. Not a bug, but the

   duplicate is confusing.                                                                                    

  20. **Commented-out factor-of-4 vs factor-of-2 (lines 165, 234, 303)** — the Pécréaux spectral weight has / 4    

  commented out in favour of / 2 in every occurrence. The prefactor affects the absolute scale of κ. This     

  change should be documented (a comment explaining which ensemble convention is used).

  21. **ternary** **is a local function** — defined at L448. Works correctly; no issue.                                

  22. **Chain dependency** — loads analysisWorkspace.mat (L46). Event_detection.m saves exactly that name (L566).  

  Names match; no mismatch here (unlike the hybrid→event link).                                               

  23. **Helper functions not on path** — same quickPlot / savefigures_new concern as above.                        

  ---             

  **Priority summary**                                                                                            

  ┌─────┬───────────────────────┬─────────────┬───────────────────────────────────────────────────────────┐ 

  │  #  │         File          │  Severity   │                           Issue                           │ 

  ├─────┼───────────────────────┼─────────────┼───────────────────────────────────────────────────────────┤ 

  │ 1   │ hybrid → Event        │ **Critical**    │ Filename _fixed2 vs _fixed — pipeline is broken           │ 

  ├─────┼───────────────────────┼─────────────┼───────────────────────────────────────────────────────────┤ 

  │ 2   │ Event_detection       │ **Bug**         │ circ_excursion uses roughness_smooth instead of           │   

  │     │                       │             │ circularity_smooth (L115)                                 │   

  ├─────┼───────────────────────┼─────────────┼───────────────────────────────────────────────────────────┤   

  │ 3   │ Event_detection,      │ **Portability** │ Hardcoded /Volumes/SSD samsung/... path (L11, L38)        │   

  │     │ Fitting               │             │                                                           │   

  ├─────┼───────────────────────┼─────────────┼───────────────────────────────────────────────────────────┤

  │ 4   │ Event_detection       │ **Crash risk**  │ fourier_segs(1) accessed without guard when n_fs == 0     │   

  │     │                       │             │ (L503)                                                    │   

  ├─────┼───────────────────────┼─────────────┼───────────────────────────────────────────────────────────┤

  │ 5   │ Both                  │ **Portability** │ quickPlot/savefigures_new not on path, no addpath call    │   

  ├─────┼───────────────────────┼─────────────┼───────────────────────────────────────────────────────────┤   

  │ 6   │ Event_detection       │ **Warning**     │ 6× deprecated nanmean                                     │

  ├─────┼───────────────────────┼─────────────┼───────────────────────────────────────────────────────────┤   

  │ 7   │ hybrid, Event         │ **Warning**     │ caxis deprecated (L399, L481)                             │

  ├─────┼───────────────────────┼─────────────┼───────────────────────────────────────────────────────────┤   

  │ 8   │ Event_detection       │ **Warning**     │ 3× qleg assigned but never used (L408, L431, L518)        │

  ├─────┼───────────────────────┼─────────────┼───────────────────────────────────────────────────────────┤   

  │ 9   │ hybrid, Event,        │ **Minor**       │ AGROW/SAGROW array-growth warnings                        │

  │     │ Fitting               │             │                                                           │   

  └─────┴───────────────────────┴─────────────┴───────────────────────────────────────────────────────────┘

✻ Baked for 3m 40s                    

※ **recap:** _Audited three GUV membrane analysis scripts for errors. The most important fix is renaming the saved_ 

  _file in hybrid_dectctionmethod.m from contourExtraction_hybrid_fixed2.mat to_                                

  _contourExtraction_hybrid_fixed.mat so Event_detection.m can load it. (disable recaps in /config)_