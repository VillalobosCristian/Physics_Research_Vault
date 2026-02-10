The idea here is to write and update the ideas, theory and progress on the experiments using the [[Optothermal platform]] used for colloids. 

## The concept

We want to use the experimental system we used in our work [[villalobos-concha_Optothermal assembly and manipulation of colloids via non-coherent light]], where a temperature gradient is induced by shining blue light  over a metal surface (3nm Cr + 10 nm Au). There we showed that strong convection flows are produced by the thermal gradient, but by closing the diaphragm we could localize the illumination zone and create smaller convection+slip flows to generate 2d colloidal crystal. 

Here, for the GUV the approach is a little bit different, but the same idea, we observed that putting vesicles in this system without closing the diaphragm will induce strong shape changes in DOPC vesicle, and. even phase transition for DPPC vesicle.  We want to study if this fast induced heating create different behavior than slow ramp heating from other systems. 


From [[dimova2020_The giant vesicle book]] vesicle shape changes are usually done by osmotic deflation or temperature changes.
In the case of temperature changes with the assumption that the membrane area is mainly constant.  
A common parameter is the [[reduce volume]] defined by 
$$\nu = \frac{6\sqrt{\pi}V}{A^{3/2}}$$
- $\nu = 1$ means perfect spherical vesicle, maximum volume for a given area.
- $\nu < 1$ means deflated vesicle, it must store the extra area somehow (non-spherical shape, ondulations, etc).


![[montage_5x2.png]]

A typical observation of a DOPC vesicle while heating. Before heating the vesicle is showing thermal fluctuation and has a quasi-spherical shape. When light is turned on, we can see that some small buds are created outward the vesicle and a strong shape change after some time (need to add correct time stamps) an inward bud appear and looks like a inner vesicle inside of a apparent spherical vesicle. Then light is turned off this inner bud/vesicle merge with the membrane and strong shape changes appear , recovering a similar shape to the initial at thermal equilibrium, and the process repeat again when light is turned on.

The fact that the vesicle look spherical can mean:
- Inflation: water comes in (osmotic and temperature effects), the volume $V$ increase at almost constant $A$, almost because, the temperature change create a area increase. This will increase the value of $\nu$. 
- Since the excess of area is stored in thermal fluctuation, when increasing the temperature, the change in volume and area increase the tension too, making the vesicle more spherical. 
To measure experimentally the value of $\nu$  from $2-D$ images we need to assume that the shape of the deformed vesicle has an symmetry axis, the task is to choose the correct symmetry axis and compute $V(t)$ and $A(t)$ from surface revolution. 

### What is happening?

How I look what is happening is: 
- Membrane area respond very fast to temperature change: when $T$ increases, the membrane wants to increase its area by $A(T)\approx A_0(1+\alpha_A\Delta T)$
- Volume responds slowly: The initial water volume also expand almost immediately  $V(T)=V_0(1+\alpha_V\Delta T)+\Delta V_{\mathrm{perm}}(t)$, while if there any permeation it would be in a slower time scale. 

So in this case the reduce volume in time can be written as: 
$$\frac{\nu(t,\Delta T)}{\nu}=\frac{V(t,\Delta T)}{V}\left(\frac{A}{ A(t,\Delta T)}\right)^{3/2}$$
For small changes from the initial values of $A$ and $V$. we can write $V(t,\Delta T)=V(1+\epsilon_V(t))$ and $A(t,\Delta T)=A(1+\epsilon_A)$. Therefore:

$$\frac{\nu(t)}{\nu}=\frac{1+\epsilon_V}{(1+\epsilon_A)^{3/2}}$$
at first order
$$\frac{\nu(t)}{\nu}\approx 1+\epsilon_V-\frac{3}{2}\epsilon_A$$

$$\frac{\Delta \nu(t)}{\nu} \approx \frac{\Delta V(t)}{V} - \frac{3}{2}\frac{\Delta A(t)}{A}$$ At short times, before permation matters, we have
$$\frac{\Delta \nu}{\nu} \approx \alpha_V\Delta T - \frac{3}{2}\alpha_A\Delta T$$
So if $\alpha_A$ dominates, $\nu$ can **drop** immediately after heating even if it later rises as water permeates. 
Then when permeation came in to the game the vesicle will increase the volume and increase tension increasing the value of $\nu$ even surprassing the initial value at thermal equilibrium.

From the images what we can do is to extract the countours in each frame, and determine the symmetry axis using [[principal component analysis]] and do the surface revolution integral. 

So [[principal component analysis|PCA]] finds the direction in the plane along the contour which the contour points have the largest spread (first principal component ) and the perpendicular direction with the smaller spread (second and so on..).



## Steps
First we detect the contour as usual, here is a quasi-spherical vesicle just before turning light on.

![[export_fig_out.png]]
The deformed one, after turning light on
![[export_fig_out 1.png]]
From this contours we can compute the PCA from the contour, for a almost spherical circle we could should expect the usual cartesian basis, since the contour is not 100% symmetric is not the case.
![[Pasted image 20260126095548.png]]
For the deformed one, with no clear symmetry axis we have something like 
![[Pasted image 20260126095757.png]]
From this, we can now compute the reduced volume. To do that we can compute the volume as:

$$V=\pi \int r(z)^2 dz$$
and the area 
$$A=2\pi \int r(z)\sqrt{1+\left(\frac{dr}{dz}\right)^2}dz$$

````[coeff, ~, latent] = pca([x_centered, y_centered]);
principal_component = coeff(:, 1);  % Major axis direction
theta_pca = atan2(principal_component(2), principal_component(1));
````
The major axis is the first principal component, which is the direction of maximum variance, for an ellipse for example is equivalent to the major axis. 

Vesicles at equilibrium are axially symmetric around one axis due to energy minimization, so the key assumption is that vesicle will have rotational symmetry around this axis. 

The problem is that for the instant of heating, invaginations and bud are not axially symmetric making the estimation of the reduced volume inconsistent, nevertheless we can use as another estimator. 
![[Pasted image 20260209133324.png]]

Then we rotate it so the symmetry axis align with the $y$ axis. 
````
x_rot = x_centered * cos(-theta_pca) - y_centered * sin(-theta_pca);
y_rot = x_centered * sin(-theta_pca) + y_centered * cos(-theta_pca); 
````
Then we compute $r(y)$, for each $y$ the radius...
Volume computed using disk method 
````
dy = diff(y_profile);
r_mid = (r_profile(1:end-1) + r_profile(2:end)) / 2;  % Midpoint
volume_um3 = sum(pi * r_mid.^2 .* dy);  % Riemann sum 
````

And surface area 
````
dr = diff(r_profile);
ds = sqrt(dr.^2 + dy.^2);  % Arc length element
r_mid_area = (r_profile(1:end-1) + r_profile(2:end)) / 2;
area_um2 = sum(2 * pi * r_mid_area .* ds);
````

## Shape change analysis

![[Pasted image 20260202092223.png]]
## Detection of heating events

For now, basically is detecting the drift rate, $d\Delta x/dt$, high drift = heating, it can fail if the vesicle is adhered or is moving a little, i also need to combine with shape changes, since when light is turned on the shape change is very fast, it deform, then spherical again and still drift, so the big shape change is only at the beginning. 


## Fourier Analysis 
![[Pasted image 20260209142906.png]]
## Detecting heating events by shape changes 

One observable that can measure is the roughness, which at difference of circularity measure how much the vesicle wiggles around of a mean radius value 

$$\mathrm{Roughness}=\frac{\sigma(r)}{\bar{r}}$$
this tell more about local deformations of the membrane. 

Now for detect the event of heating, we use the first 500 frames to define what is light off(heating off), this is part of the recording protocol, once the vesicle is found the recording start with an unperturbed, no previous heated vesicle that is in thermal equilibrium at T ambient. Usually I'll record 1000 frames of that, then heating for 500-1000 frames. 

Typical roughness at that interval computed using median. and the std, so normally the fluctuation around that value will be given by 3$\sigma$ + median, so that will be the threshold. 

Then a raw detection mask, so basically when the smoothed roughness>rougness_threshold and smooth this vector to avoid flickering and i say that if this smooth threshold at 0.5: if >50% of nearby frames are "true", keep it.
shape_change_raw = roughness_smooth > roughness_threshold;

**What this creates:**
- Boolean array (true/false for each frame)
- `true` = roughness is high (potential shape change)
- `false` = roughness is normal

Frame:          1    2    3    4    5    6    7    8    9   10
Roughness:    0.02 0.02 0.03 0.04 0.05 0.04 0.03 0.02 0.02 0.02
Threshold:    0.029 (constant)
Raw mask:       0    0    1    1    1    1    1    0    0    0
                          ↑ exceeds threshold ↑

Denoise the Mask
```matlab
shape_change_smooth_sig = smoothdata(double(shape_change_raw), 'gaussian', 15) > 0.5;
```
- Raw mask can flicker: true-false-true-false
- Smoothing removes brief spikes (noise)
- Window = 15 frames (about 0.5 seconds)
Threshold at 0.5: if >50% of nearby frames are "true", keep it and we found the boundaries by taking diff between 0 and the denoised mask == 1 means start and -1 means end. 
We filter short events (less than 10 frames).
min_shape_duration = 10;
durations_shape = shape_ends - shape_starts + 1;
mask_valid = durations_shape >= min_shape_duration;
shape_zones = [shape_starts(mask_valid), shape_ends(mask_valid)];

I also filter the min shape gap, how many frames between shape changes to make it only one, let's say 30 frames. Gap < 30 frames (1 second) → same deformation
