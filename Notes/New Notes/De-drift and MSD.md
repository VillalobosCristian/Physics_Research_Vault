Following https://tinevez.github.io/msdanalyzer/tutorial/MSDTuto_drift.html

And assuming that particles in sample move due thermal motion
 we can write:
$$ \mathbf{v}_i = \mathbf{v}_{\mathrm{drift}}+\mathbf{v}_{\mathrm{Brownian}}$$
 in average without drift  
$$\lim_{t\to\infty}\langle \mathbf{v}\rangle=0$$
means that the equilibrium state is maintained by the friction in the system.

The same over all the particles, and therefore the displacement is given by:

$$\mathbf{r}_{\mathrm{drift}}=\int_{0}^{t} \mathrm{d}t'\  \langle \mathbf{v}_i \rangle$$


## MSD

To compute the MSD usually i use the following implementation:

In discrete sampling,  we have times $t_k = k \,\Delta t$ for $k=0,1,2,\ldots,N-1$.
and $\Delta t$ is the time interval between succesive  measurements, and $N$ the total number of frames. 


The position is recorded as $\mathbf{x}(t_k) = (x_k,\,y_k)$. Then the squared displacement over $m$ time steps is
$$
\bigl[\Delta \mathbf{x}(k,m)\bigr]^{2} \;=\;\bigl[x_{k+m} - x_{k}\bigr]^{2} + \bigl[y_{k+m} - y_{k}\bigr]^{2}$$

where $k+m \leq N-1$. The condition $k+m \leq N-1$ ensures that when you look m steps ahead from position k,  we are not trying to access data beyond the end of the trajectory


The single-trajectory MSD for lag $m$ is typically computed as
$$
\mathrm{MSD}(m\Delta t) \;=\; \frac{1}{N - m} \sum_{k=0}^{N-m-1} \bigl[x_{k+m} - x_{k}\bigr]^{2} + \bigl[y_{k+m} - y_{k}\bigr]^{2}.
$$
The corresponding time lag in seconds is $m \,\Delta t$. 
Where $m$ is is the parameter telling us how many time steps are two position compared.
If one has multiple trajectories, the  sverage} MSD at lag $m\Delta t$ is the mean of each trajectory's MSD at that same lag (assuming **uniform sampling** and **aligned times**
