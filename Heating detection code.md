
Since i change the way to store data from simple .mat variables to structures all the data from the edge detection code is store in `allContours` 
`allContours(iFrame)` has fields:

- `.x_midline`, `.y_midline` — contour points (pixel coordinates)
- `.r_midline_smooth`, `.r_inner_smooth`, `.r_outer_smooth` — radial profiles (already smoothed, presumably from a polar decomposition in the extraction step)

`angles` — the angular sampling used during contour extraction (not actually used in this script beyond being loaded).

## Basic metric 

Circularity: The ratio $C= 4\pi A/P^2$, is $1$ for a perfect circle.  And is computed by closing the contour polygon and using polyarea+perimeter sum. 

Center of mass drift: $\Delta (t)=\sqrt{(x-x_0)^2+(y-y_0)}^2$ with $y=y_{CM}$. cumulative displacement from the first frame. Since CM is computed as the mean of contour points (not area-weighted), this is an approximation, but good enough for qusi spherical vesicles.

