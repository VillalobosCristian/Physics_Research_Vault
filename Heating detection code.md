
Since i change the way to store data from simple .mat variables to structures all the data from the edge detection code is store in `allContours` 
`allContours(iFrame)` has fields:

- `.x_midline`, `.y_midline` — contour points (pixel coordinates)
- `.r_midline_smooth`, `.r_inner_smooth`, `.r_outer_smooth` — radial profiles (already smoothed, presumably from a polar decomposition in the extraction step)

`angles` — the angular sampling used during contour extraction (not actually used in this script beyond being loaded).

## Basic metric 

Circularity: The ratio $C= 4\pi A/P^2$, is $1$ for a perfect circle.  And is c


