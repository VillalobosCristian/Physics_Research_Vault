
Since i change the way to store data from simple .mat variables to structures all the data from the edge detection code is store in `allContours` 
`allContours(iFrame)` has fields:

- `.x_midline`, `.y_midline` — contour points (pixel coordinates)
- `.r_midline_smooth`, `.r_inner_smooth`, `.r_outer_smooth` — radial profiles (already smoothed, presumably from a polar decomposition in the extraction step)

`angles` — the angular sampling used during contour extraction (not actually used in this script beyond being loaded).

## Basic metric 

Circularity: The ratio $C= 4\pi A/P^2$, is $1$ for a perfect circle.  And is computed by closing the contour polygon and using polyarea+perimeter sum. 

Center of mass drift: $\Delta (t)=\sqrt{(x-x_0)^2+(y-y_0)}^2$ with $y=y_{CM}$. cumulative displacement from the first frame. Since CM is computed as the mean of contour points (not area-weighted), this is an approximation, but good enough for qusi spherical vesicles.

**Radii:** Mean of the smoothed inner/mid/outer radial profiles per frame. **Roughness** is the coefficient of variation of the midline radius: $\sigma_r / \langle r \rangle$ — a shape-agnostic measure of contour irregularity.

All time series are Gaussian-smoothed. The drift rate $\dot{\Delta}$ is estimated via `gradient`  on the pre-smoothed drift, then re-smoothed  a double smoothing that trades temporal resolution for noise suppression. Window `sw=50` frames at 50 fps = 1 s.

## Event Detection — Drift Only

Heating events are identified purely from **drift rate** exceeding a threshold:

$$\text{thr} = \max!\left(\tilde{\dot\Delta} + 3,\sigma_{\dot\Delta}^{(0)}, ; 0.03 \text{ px/fr}\right)$$

where $\tilde{\cdot}$ is the median and $\sigma^{(0)}$ is estimated from the first 100 frames (assumed quiet). The `0.03` floor prevents false positives when baseline noise is very low.

Binary mask → Gaussian-blurred → thresholded at 0.5 → rising/falling edges give `heat_starts/ends`. Short events ($<100$ fr) and low-drift events ($<10$ px total) are rejected. Adjacent events separated by $<300$ fr are merged.

**Key design choice:** detection uses _drift rate_ (sensitivity to motion onset) rather than drift magnitude or roughness. This means it's detecting _translation_ events, not necessarily membrane fluctuation events — a distinction that matters for interpretation.
