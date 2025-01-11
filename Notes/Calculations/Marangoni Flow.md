---
tags:
  - "#physics"
  - "#mathematical-physics"
  - "#interface-physics"
  - "#membrane-biophysics"
  - "#fluid-dynamics"
  - "#surface-tension"
  - "#marangoni-effect"
---
# Revisiting the [[boundary conditions]] at a fluid-fluid interface in the context of a bubble or a droplet

![[New notes/CondicionBordeGota]]

Essentially, at the interface between two fluids, we apply the no-slip condition:

$$
\mathbf{u} = \mathbf{\hat{u}}
$$

The [[kinematic condition]] for the interface tells us that the interface is neither a source nor a sink of mass. This implies that the normal component of the [[velocity]] in both fluids is equal to the [[velocity]] of the interface.

The kinematic relation can be expressed in the form of a relationship between $\mathbf{u}\cdot\mathbf{n}$ and the rate of change of the interface shape.

As defined above, the shape of the interface can be expressed as
$$
F(\mathbf{x},t) = 0
$$
and the normal vector can be defined as:
$$
\mathbf{n} = \pm \frac{\nabla F}{|\nabla F|}
$$

Taking the material derivative, we find:
$$
\frac{\partial F}{\partial t} + \mathbf{u}\cdot\nabla F = 0
$$

$$
\frac{1}{|\nabla F|}\,\frac{\partial F}{\partial t} + \mathbf{u}\cdot\mathbf{n} = 0
$$

For any point on $S$. If the interface is not translating from the origin (i.e., it is stationary in the chosen reference frame), then $F$ is independent of time and
$$
\mathbf{u}\cdot\mathbf{n} = 0
$$
at the interface.

When only one fluid is moving, we have seen that the no-slip condition is sufficient to solve the equations of motion.  
For two fluids, it is not sufficient, and an additional condition is needed. This condition comes from performing a force balance at the interface.

As a general convention, the simplified form of the interface is considered to have negligible thickness, and all forces acting on that interface segment must be identically zero because the volume associated with any arbitrary segment of the interface is zero.

Now let us think about the nature of the forces:

- We have a pressure in the volume and stresses that act on the faces of the interface element, producing a net effect proportional to the area of the surface.
- There is a force associated with [[surface tension]] that acts in the plane of the interface at the edge of the surface element, whose magnitude is given by the specified surface tension.

It was found that surface tension is a measure of the free energy per unit area of the surface.  
An increase in the area of the interface requires an increase in the free energy. This causes the molecules in the vicinity of the interface to experience a net force that tends to push them into the bulk. In order for this macroscopic theory to be satisfied, the existence of surface tension $\gamma$ as a force per unit length is necessary.

### Force Balance

![[New notes/Equilibrio de Fuerzas Gota|500]]

The force balance then yields the following expression:

$$
\iint_A (\mathbf{\hat{T}} - \mathbf{T}) \cdot \mathbf{n}\,dA \;+\; \int_C \gamma\,\mathbf{t}\,dl = 0
$$

Here, $\mathbf{T}$ is the total stress in the flow on a surface element $A$, evaluated in the limit as we approach the interface.  
A generalization of the [[Stokes' Theorem]] can be used to show that:
$$
\int_C \gamma\,\mathbf{t}\,dl
= \iint_A (\nabla\gamma)\,dA - \iint_A \gamma\,\mathbf{n}(\nabla\cdot\mathbf{n})\,dA
$$

Combining, we get the differential stress balance:
$$
(\mathbf{T} - \mathbf{\hat{T}})\cdot\mathbf{n} + \nabla\gamma - \gamma\,\mathbf{n}(\nabla\cdot\mathbf{n}) = 0
$$

It is more useful to see this by components. Taking the inner product of this equation with $\mathbf{n}$, and recalling that for a [[Newtonian fluid]] $\mathbf{T} = -p\,\mathbf{I} + \mathbf{\tau}$, we arrive at the following expression for the normal component:
$$
\hat{p}_{\text{total}} - p_{\text{total}}
+ \bigl[\bigl((\tau - \hat{\tau})\cdot\mathbf{n}\bigr)\cdot\mathbf{n}\bigr]
- \gamma\,(\nabla\cdot\mathbf{n}) = 0
$$

We can see that the normal component has a discontinuity $\gamma(\nabla\cdot\mathbf{n})$. Therefore, if there is no fluid motion:
$$
\hat{p}_{\text{total}} - p_{\text{total}} = \gamma\,(\nabla\cdot\mathbf{n})
$$

This means that for a curved surface, the pressure on the outside is greater than the pressure on the inside by a factor of $\gamma\,(\nabla\cdot\mathbf{n})$.

Once we have this, let us consider the case of a bubble. For a bubble or a droplet, we have:
$$
\nabla\cdot\mathbf{n} = \frac{1}{R_1} + \frac{1}{R_2} = \frac{2\gamma}{R}
$$

These flows are generally known as capillary flows.

The tangential component will have two parts, obtained by taking the inner product with tangent vectors $\mathbf{t}_{1,2}$ that are orthogonal to $\mathbf{n}$. Defining these vectors as $\mathbf{t}_{1,2}$ (for shear stress), we obtain:
$$
0 = \bigl((\tau - \hat{\tau})\cdot\mathbf{n}\bigr)\cdot\mathbf{t}_i \;+\; (\nabla\gamma)\cdot\mathbf{t}_i
$$

where now the shear stress is discontinuous at the interface, proportional to $\nabla\gamma$. This is important because in systems where $\nabla\gamma \neq 0$, there **must** be motion.

## Example

For two fluids with equal densities, $\gamma \neq 0$, and which do not mix, there is a state of equilibrium for which the interface has constant curvature. The simplest surface in this case is a sphere. The spherical interface is also stable; if a droplet is deformed into an ellipse due to a perturbation, it will quickly want to return to its spherical shape. For this reason, many times surface tension is interpreted as an energy optimization process in these cases.

Thus, for example, an infinite cylindrical thread tends to break up into many droplets. The source of the instability can be seen by imagining small undulations that deviate from the cylinder of constant radius. Depending on the wavelength relative to the cylinder's radius, there will be a growth mechanism for these undulations. As time passes, they become unstable.

If the total curvature of the surface is such that points of minimal radius produce a local maximum in $\nabla\cdot\mathbf{n}$, then there will be a local maximum in internal pressure at that same point, which pushes the fluid away from the region of minimal radius toward where the radius grows. This motion further reduces the radius and increases the undulations, which then grow even more over time until the thread radius becomes zero, forming a droplet.

---

# Marangoni Effect

Surface tension depends on the thermodynamic state; that is, it depends on pressure and temperature. In this problem, we want to solve the motion of a droplet due to a gradient in its surface tension, but first let us solve the case of a droplet moving in a fluid due to buoyancy.

We will solve this problem in the limit of [[low Reynolds number flow]].

Let us define characteristic scales $l_c = a$ as the (undeformed) droplet radius and $u_c = U$ as the droplet's [[velocity]] of translation. The resulting equations are:

$$
\nabla^2\mathbf{u} - \nabla p = 0
$$

$$
\nabla\cdot\mathbf{u} = 0
$$

and for the other fluid:

$$
\nabla^2\mathbf{\hat{u}} - \nabla\hat{p} = 0
$$

$$
\nabla\cdot\mathbf{\hat{u}} = 0
$$

The far-field boundary condition is the usual one:
$$
\mathbf{u}\;\to\;\mathbf{I}\cdot\hat{z}
\quad\text{as}\quad|\mathbf{x}|\to\infty
$$

![[New notes/Gotita moviendose en fluido quieto|500]]

To solve this, we can use what we learned for the flow around a solid sphere in a fluid with a certain [[velocity]]. We can also solve it using an expansion in terms of the [[Stokelet]] and the [[Oseen tensor]].

We will use the [[Streamfunction]] $\psi$ and $\hat{\psi}$. Since the flow is axisymmetric, we can use an expansion in terms of the operator $D^4$. Then:
$$
D^2D^2\psi = D^4\psi = 0
$$

$$
\hat{D}^4\hat{\psi} = 0
$$

where
$$
D^2 = \frac{\partial}{\partial r^2} + \frac{\sin\theta}{r^2}\,\frac{\partial}{\partial\theta}\!\biggl(\frac{1}{\sin\theta}\,\frac{\partial}{\partial\theta}\biggr)
$$

Both fluids will be described by the solution in spherical coordinates. We saw in some auxiliary materials that, applying the operator $D^2$ twice, we arrive at an expression of the form:
$$
f(r) = A\,r^4 + B\,r^2 + C\,r + \frac{D}{r}
$$

Thus, the general solution will be:
$$
\psi
= \sum_{n=1}^{\infty}\Bigl[A_n\,r^{n+3} + B_n\,r^{n+1} + C_n\,r^{2-n} + D_n\,r^{-n}\Bigr]\,Q_n(\cos\theta)
$$

$$
\hat{\psi}
= \sum_{n=1}^{\infty}\Bigl[\hat{A}_n\,r^{n+3} + \hat{B}_n\,r^{n+1} + \hat{C}_n\,r^{2-n} + \hat{D}_n\,r^{-n}\Bigr]\,Q_n(\cos\theta)
$$

We must then determine 8 constants using the boundary conditions. As in the solid-sphere case, the far-field must behave like $r^2 Q_1$, because we have:
$$
u_r = \frac{1}{r^2\sin\theta}\,\frac{\partial\psi}{\partial\theta},\quad
u_\theta = -\frac{1}{r\sin\theta}\,\frac{\partial\psi}{\partial r}
$$

Hence $A_n=0$ and $B_n=0$ for all $n$, except $B_1=-1$. So $\psi$ becomes
$$
\psi
= -r^2 Q_1 + \sum_{n=1}^{\infty}\bigl[C_n\,r^{2-n} + D_n\,r^{-n}\bigr]\,Q_n(\eta)
$$

where $\eta=\cos\theta$.

Inside the droplet, the velocity components must be continuous at the origin, so $\hat{D}_n=0$ and $\hat{C}_n=0$. The velocity components are then:
$$
u_r = -\frac{1}{r^2}\,\frac{\partial\psi}{\partial\eta},\quad
u_\theta = -\frac{1}{r\,\sqrt{1-\eta^2}}\,\frac{\partial\psi}{\partial r}
$$

and the streamfunction $\hat{\psi}$ is:
$$
\hat{\psi}
= \sum_{n=1}^\infty\bigl[\hat{A}_n\,r^{n+3} + \hat{B}_n\,r^{n+1}\bigr]\,Q_n(\eta)
$$

We still have to determine the constants $C_n$, $D_n$, $\hat{A}_n$, and $\hat{B}_n$. To do so, we use the previously defined boundary conditions and the kinematic condition. First, let us define the capillary number, which is a dimensionless group measuring the relative magnitude of viscous forces to surface tension:
$$
C_a = \frac{\mu\,U_\infty}{\gamma}
$$

We will use $\mu\,U_\infty / a$ to normalize the pressure. Thus:
$$
\begin{align}
u_\theta &= \hat{u}_\theta \quad\text{when}\quad r = 1,\\
u_r &= \hat{u}_r = 0 \quad\text{when}\quad r = 1,\\
e_{r\theta} &= \lambda\,\hat{e}_{r\theta}\quad\text{when}\quad r = 1,\\
\hat{p} - p + \bigl(e_{rr} - \lambda\,\hat{e}_{rr}\bigr) &= \frac{2}{C_a}\quad\text{when}\quad r = 1
\end{align}
$$

where $e_{ij}$ is the strain rate and $\lambda=\hat{\mu}/\mu$. We recognize that the first two come from the continuity of the [[velocity]]; the last two are the normal and tangential stress components—actually a combination of those conditions. The last one assumes that the droplet shape is known; we might not use this condition in general because we do not usually know the shape of the droplet. Even so, we have four boundary conditions since the second equation really represents two conditions.

Let us find the constants:

- $r=1$
  $$
  u_r = \hat{u}_r = 0
  $$

  $$
  \frac{1}{r^2}\,\frac{\partial\psi}{\partial\eta}
  =
  \frac{1}{r^2}\,\frac{\partial\hat{\psi}}{\partial\eta}
  $$

  $$
  -r^2 Q_1
  + \sum_{n=1}^{\infty}\bigl[c_n(1)^{2-n} + D_n(1)^{-n}\bigr]\,Q_n(\eta)
  =
  \sum_{n=1}^\infty\bigl[\hat{A}_n(1)^{n+3} + \hat{B}_n(1)^{n+1}\bigr]\,Q_n(\eta)
  $$

  This is satisfied for $n=1$, and for $n>2$ the constants become zero. Repeating for the other boundary conditions, and recalling that
  $$
  e_{r\theta}
  =
  \biggl(
    \frac{1}{r}\,\partial_\theta v_r
    + \partial_r v_\theta
    + \frac{v_\theta}{r}
  \biggr)
  $$

  we find:
  $$
  C_1 = \frac{3\lambda + 2}{2\lambda + 2},\quad
  D_1 = \frac{-\lambda}{2(\lambda + 1)},\quad
  \hat{A}_1 = -\hat{B}_1 = \frac{1}{2\lambda + 1}
  $$

Hence the streamfunction becomes:
$$
\psi
=
-Q_1\biggl[
  r^2
  - \frac{3\lambda + 2}{2\lambda + 2}\,r
  + \frac{\lambda}{2\lambda + 2}\,\frac{1}{r}
\biggr]
$$

$$
\hat{\psi}
=
\frac{Q_1}{2}
\biggl[
  \frac{r^2 - r^4}{\lambda + 1}
\biggr]
$$

Then the drag in the $z$-direction is the integral of the stress tensor in the normal direction:
$$
F_z
=
4\pi\,\mu\,C_1\,U
=
4\pi\,\mu\,U\,\frac{3\lambda + 2}{2\lambda + 2}
$$

In the limit $\lambda \to \infty$, we recover the known value for a solid sphere
$$
F = 6\pi\,\mu\,a\,U
$$
Then, using the velocity fields from the streamfunction, when $\lambda \to 0$,
$$
F = 4\pi\,\mu\,a\,U
$$
which is the drag on a bubble.

---

Now let us consider the case when there is a gradient of surface tension. This is known as the [[Marangoni Effect]], and in this particular scenario it produces self-propulsion of the droplet.

We impose a temperature gradient acting on the droplet, with temperature decaying as $T(z)=T_{\infty}(0)-\alpha\,z$, where $T(0)$ is a reference value at $z=0$.  
We will **not** solve the [[Laplace equation]] for temperature on the droplet surface; instead, we will simplify the problem using the tools described above.

The boundary conditions change from the previous problem regarding the stresses. Therefore we have:
$$
\tau_{r\theta}
+ \frac{1}{\mu\,U}\,\frac{\partial\gamma}{\partial\theta}
= 0
\quad\text{when }r=1
$$

This is the tangential stress balance in dimensionless form. To calculate the derivative of surface tension with respect to the angle, we use the expression for temperature in spherical coordinates and the fact that surface tension decreases as temperature increases:
$$
\frac{\partial\gamma}{\partial T} = -\beta < 0
$$

$$
\frac{\partial\gamma}{\partial\theta}
= \frac{\partial\gamma}{\partial T}\,\frac{\partial T}{\partial\theta}
= \beta\,\alpha\,\sin\theta
= \alpha\,\beta\,\sqrt{1-\eta^2}
$$

recalling that $\eta=\cos\theta$.

Thus:
$$
\tau_{r\theta}
= \frac{\alpha\,\beta\,\sqrt{1-\eta^2}}{\mu\,U}
\quad\text{at }r=1
$$

We know that the streamfunction takes the form:
$$
\psi
= \sum_{n=1}^{\infty}\bigl[
  A_n\,r^{n+3}
  + B_n\,r^{n+1}
  + C_n\,r^{2-n}
  + D_n\,r^{-n}
\bigr]\,Q_n(\cos\theta)
$$

When $r\to\infty$:
$$
\psi
= -r^2\,Q_1 + \sum_{n=1}^{\infty}\bigl[
  C_n\,r^{2-n}
  + D_n\,r^{-n}
\bigr]\,Q_n(\eta)
$$

Applying the remaining boundary condition $u_r=0$ on the surface:
$$
0
= -Q_1(\eta)
+ \sum_{n=1}(C_n + D_n)\,Q_n(\eta)
$$

The second condition,
$$
\tau_{r\theta}
= \frac{\alpha\,\beta\,\sqrt{1-\eta^2}}{\mu\,U}
\quad\text{at }r=1
$$

$$
r\,\frac{\partial}{\partial r}\!\biggl(\frac{u_\theta}{r}\biggr)
= -\frac{\alpha\,\beta}{\mu\,U}\,\sqrt{1-\eta^2}
$$

where
$$
u_\theta
= -\frac{1}{\sqrt{1-\eta^2}}\,\frac{1}{r}\,\frac{\partial\psi}{\partial r}
$$

Thus:
$$
-2\,Q_1
+ 2\,C_1\,Q_1
- 4\,D_1\,Q_1
+ \sum\bigl[(2-n)(n+1)\,C_n - n(n+3)\,D_n\bigr]\,Q_n
= \frac{2\,\alpha\,\beta}{\mu\,U}\,Q_1
$$

Solving, we find $C_n=D_n=0$ for $n\ge2$:
$$
C_1
= 1 + \frac{\alpha\,\beta}{3\,\mu\,U},
\quad
D_1
= \frac{\alpha\,\beta}{3\,\mu\,U}
$$

Therefore, the drag in this case is:
$$
F
= 4\pi\,\mu\,a\,U
\Bigl[
  1 + \tfrac{1}{3}\,\frac{\alpha\,\beta}{\mu\,U}
\Bigr]
$$

This is greater than when there is no temperature gradient, due to the contribution of the surface stress on the droplet. Consequently, the droplet will move more slowly when, for example, it is sedimenting.

The terminal [[velocity]] can be found by force balance:
$$
\frac{4}{3}\,\pi\,a^3\,\rho\,g
= 4\pi\,\mu\,a\,U
\Bigl[
  1 + \tfrac{1}{3}\,\frac{\alpha\,\beta}{\mu\,U}
\Bigr]
$$

$$
U
= \frac{1}{3}\,\frac{a^2\,\rho\,g}{\mu}
\Bigl(
  \frac{a^2\,\rho\,g - \alpha\,\beta}{a^2\,\rho\,g}
\Bigr)
$$

Thus, there is a critical value of $\alpha$ for which the droplet will not sediment due to this temperature gradient :o.
