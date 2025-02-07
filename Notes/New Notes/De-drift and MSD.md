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
If one has multiple trajectories, the  sverage MSD at lag $m\Delta t$ is the mean of each trajectory's MSD at that same lag (assuming **uniform sampling** and **aligned times**

usually when computing the MSD, for single trajectory we want to ensure statistical significance. 
So i avoid lags longer than thr 10% of the total frames. (im not 100% if this depend on the experiment or not)
## Ensemble

Suppose we have \(M\) distinct trajectories, each with its own time series of positions. We compute the MSD of each trajectory \(i\), denoted as

$$\mathrm{MSD}_i(\tau),$$

up to some maximum lag time $\tau$. Here $\tau$ is discretized in increments of $\Delta t$, typically given by the sampling rate.

The ensemble-averaged MSD at lag $\tau$ is defined as the  mean of the individual MSD values at that same lag:
$$
\mathrm{MSD}_\text{ensemble}(\tau) \;=\; \frac{1}{M} \sum_{i=1}^{M}\, \mathrm{MSD}_i(\tau).
$$
However, each trajectory may be of different length, or might only have valid data up to certain time lags.
In practice, we average only over those trajectories that contribute valid data at a given $\tau$. In other words, if $n_\tau$ is the count of trajectories that have valid data at lag $\tau$, then:
$$\mathrm{MSD}_\text{ensemble}(\tau) \;=\; \frac{1}{n_\tau} \sum_{\substack{i=1 \\ i\text{ has data at }\tau}}^{M}\, \mathrm{MSD}_i(\tau).
$$

