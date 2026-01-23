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
Then when permation came in to the game