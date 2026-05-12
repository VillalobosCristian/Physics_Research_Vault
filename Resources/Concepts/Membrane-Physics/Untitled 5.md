# Einstein Index Notation and Tensor Contractions
## A Pedagogical Tutorial for Soft Matter Physics and Hydrodynamics

---

> **Audience.** This tutorial is written for graduate students entering theoretical or experimental soft matter, hydrodynamics, active matter, or membrane biophysics. We assume strong undergraduate physics, comfort with vectors and matrices, and basic continuum mechanics. We assume *no* prior fluency with tensors, indices, or contractions. By the end of this tutorial, you should be able to read papers in soft matter and hydrodynamics fluently and perform routine derivations with confidence.

> **Convention.** Unless stated otherwise, we work in $\mathbb{R}^3$ with Cartesian coordinates. Latin indices $i, j, k, \ldots$ run over $1, 2, 3$. Greek indices $\alpha, \beta, \mu, \nu, \ldots$ are reserved for $d$-dimensional or relativistic contexts when needed. The Einstein summation convention is always in force: any index appearing exactly twice in a single term is implicitly summed.

---

## Table of Contents

1. [Why Index Notation Exists](#1-why-index-notation-exists)
2. [Free vs. Dummy Indices](#2-free-vs-dummy-indices)
3. [Geometric and Linear-Algebra Interpretation](#3-geometric-and-linear-algebra-interpretation)
4. [Differential Operators in Index Notation](#4-differential-operators-in-index-notation)
5. [The Kronecker Delta and the Levi-Civita Symbol](#5-the-kronecker-delta-and-the-levi-civita-symbol)
6. [Symmetric and Antisymmetric Tensors](#6-symmetric-and-antisymmetric-tensors)
7. [Isotropic Tensors and the Trace/Deviatoric Decomposition](#7-isotropic-tensors-and-the-tracedeviatoric-decomposition)
8. [Continuum Mechanics Identities](#8-continuum-mechanics-identities)
9. [Fourier-Space Index Notation](#9-fourier-space-index-notation)
10. [Applications in Soft Matter and Membrane Physics](#10-applications-in-soft-matter-and-membrane-physics)
11. [How to Derive Safely: An Expert Workflow](#11-how-to-derive-safely-an-expert-workflow)
12. [Common Mistakes and How to Avoid Them](#12-common-mistakes-and-how-to-avoid-them)
13. [Covariant vs. Contravariant: A Light Touch](#13-covariant-vs-contravariant-a-light-touch)
14. [Exercises with Worked Solutions](#14-exercises-with-worked-solutions)

---

## 1. Why Index Notation Exists

### 1.1 The Limits of Vector Notation

Vector notation — boldface symbols $\mathbf{v}$, dots $\mathbf{a}\cdot\mathbf{b}$, crosses $\mathbf{a}\times\mathbf{b}$, the nabla $\nabla$ — is wonderfully compact for first-year electromagnetism. It survives intact through Gauss, Stokes, and the simplest forms of the Navier–Stokes equation. But once you open a soft-matter or hydrodynamics paper, vector notation cracks under three pressures:

1. **Tensors of rank $\geq 2$ have no clean vector symbol.** The stress tensor $\boldsymbol{\sigma}$ is a $3\times 3$ array of components. So is the strain-rate tensor, the velocity gradient $\nabla\mathbf{v}$, the mobility tensor, the Oseen tensor, the nematic order parameter $\mathbf{Q}$. Writing $\nabla\mathbf{v}$ tells you nothing about whether you mean $\partial_i v_j$ or $\partial_j v_i$ — these are *different* tensors (they are transposes of each other).

2. **Contractions are ambiguous.** What is $\nabla\cdot(\nabla\mathbf{v})$? Is it $\partial_j \partial_j v_i$ (a vector Laplacian), or $\partial_j \partial_i v_j$ (which by incompressibility vanishes)? Vector notation cannot tell you. Indices can.

3. **Coordinate-free identities become opaque.** Try to prove $\nabla\times(\nabla\times\mathbf{v}) = \nabla(\nabla\cdot\mathbf{v}) - \nabla^2\mathbf{v}$ from the vector-notation definitions alone. Then try with $\varepsilon_{ijk}\partial_j(\varepsilon_{klm}\partial_l v_m)$ and the $\varepsilon$–$\delta$ identity. The second is a three-line calculation; the first is an act of faith.

Index notation solves all three problems. It is the *natural* language of continuum mechanics, and you must become fluent in it.

### 1.2 Tensors as Linear Maps

Forget for a moment the notion of a tensor as "a thing with indices." A tensor is fundamentally a **multilinear map**.

- A **vector** $\mathbf{v}$ is a rank-1 object: it points in a direction.
- A **rank-2 tensor** $\mathbf{T}$ is a machine that eats a direction $\mathbf{n}$ and spits out a vector: $\mathbf{T}\mathbf{n}$. Equivalently, it eats two directions and produces a number: $\mathbf{m}\cdot\mathbf{T}\mathbf{n}$.
- A **rank-$n$ tensor** eats $n$ direction-vectors and returns a number.

The stress tensor $\sigma_{ij}$ is the canonical example: feed it a unit normal $n_j$ to a surface, and it returns the traction vector $t_i = \sigma_{ij} n_j$ — the force per unit area transmitted across that surface. The index $j$ "eats" the normal direction; the index $i$ "labels" the returned force. That's what tensor indices mean physically: **each index is a slot waiting for a direction-vector**.

> **Intuition box — what is an index?**
> An index $i$ is a *slot* in a multilinear machine. Lower-rank objects fill those slots. When you contract two indices (sum them), you are *gluing two slots together*: one slot feeds into another, eliminating both. That is why contraction reduces rank by 2.

### 1.3 Why Repeated-Index Summation Makes Sense

The Einstein convention says: an index that appears *exactly twice* in a single term is summed from 1 to 3. Why? Because that's the only operation that produces a coordinate-independent (rotationally invariant) object from two tensors. The dot product
$$
\mathbf{a}\cdot\mathbf{b} = \sum_{i=1}^{3} a_i b_i \equiv a_i b_i
$$
is rotation-invariant. The "sum" of components $a_i + b_i$ for a specific $i$ is *not* — it depends on your axes. So summation over repeated indices is not a typographical convenience; it is the geometric operation that produces scalars (and lower-rank tensors) from higher-rank ones.

### 1.4 A Tour of Tensors You Will Meet

To set the stage, here are the rank-2 tensors that will populate this tutorial and your research career:

| Tensor | Symbol | Physical meaning |
|---|---|---|
| Stress | $\sigma_{ij}$ | Force per area on a surface with normal $j$ in direction $i$ |
| Strain rate | $D_{ij} = \tfrac{1}{2}(\partial_i v_j + \partial_j v_i)$ | Local rate of deformation |
| Vorticity | $\Omega_{ij} = \tfrac{1}{2}(\partial_i v_j - \partial_j v_i)$ | Local rate of rotation |
| Velocity gradient | $L_{ij} = \partial_j v_i$ | Full gradient of velocity |
| Mobility | $\mu_{ij}$ | Velocity response to force: $v_i = \mu_{ij} F_j$ |
| Oseen tensor | $G_{ij}(\mathbf{r}) = \tfrac{1}{8\pi\eta r}(\delta_{ij} + \hat r_i \hat r_j)$ | Stokeslet propagator |
| Diffusion | $D_{ij}$ | Anisotropic Brownian motion |
| Nematic order | $Q_{ij}$ | Headless orientational order |
| Polarization gradient | $\partial_i P_j$ | Splay/bend/twist in nematics |
| Curvature | $C_{ij}$ | Membrane shape (second fundamental form) |

Every one of these requires index notation to manipulate cleanly. By section 10 you will derive identities involving them effortlessly.

---

## 2. Free vs. Dummy Indices

This is the *single most important distinction* in index notation. Master it now and ninety percent of your future confusion evaporates.

### 2.1 Definitions

In any expression involving indices:

- A **free index** appears *exactly once* in every term. It represents an "unspecified component" — when you set it to $1, 2,$ or $3$, you get one specific equation. Free indices determine the **rank of the expression**.
- A **dummy index** appears *exactly twice* in a single term. It is summed over and **does not appear in the final result**. You can rename it freely.

> **Golden rule.** An index appearing **three or more times** in a single term is *forbidden* (in Cartesian index notation). It is meaningless. If you see this in your own work, you have made an error.

### 2.2 Worked Examples

Consider the expression
$$
T_i = A_{ij} b_j.
$$

- The index $j$ appears twice on the right-hand side. It is a **dummy index** and is summed: $A_{ij}b_j = \sum_{j=1}^{3} A_{ij}b_j = A_{i1}b_1 + A_{i2}b_2 + A_{i3}b_3$.
- The index $i$ appears once on each side. It is a **free index**. Setting $i=1$ gives $T_1 = A_{11}b_1 + A_{12}b_2 + A_{13}b_3$; setting $i=2$ gives another equation; setting $i=3$ a third. The single expression $T_i = A_{ij}b_j$ stands for *three* scalar equations.
- The rank of both sides is 1 (one free index on each side). The expression represents the vector $\mathbf{T} = \mathbf{A}\mathbf{b}$.

Now look at:
$$
S = A_{ii}.
$$

- The index $i$ appears twice — it is a **dummy index**. Sum: $A_{ii} = A_{11} + A_{22} + A_{33}$.
- There are *no* free indices, so the expression is a scalar (rank 0). This is the **trace**: $S = \operatorname{tr}\mathbf{A}$.

Compare:
$$
C_{ik} = A_{ij}B_{jk}.
$$

- The index $j$ appears twice on the right: dummy, summed.
- The indices $i$ and $k$ each appear once on each side: free.
- Two free indices means rank 2: $\mathbf{C} = \mathbf{A}\mathbf{B}$ (matrix multiplication).

And:
$$
s = A_{ij}B_{ij}.
$$

- Both $i$ and $j$ appear twice on the right: both are dummy indices, summed.
- No free indices: scalar. Component-by-component:
$$
s = \sum_{i=1}^{3}\sum_{j=1}^{3} A_{ij}B_{ij} = A_{11}B_{11} + A_{12}B_{12} + \cdots + A_{33}B_{33}.
$$
This is the **Frobenius inner product**, often written $\mathbf{A}:\mathbf{B}$ in continuum mechanics.

Finally:
$$
M_{ij} = a_i b_j.
$$

- $i$ and $j$ each appear once on each side: both free.
- No dummy indices. No summation. Rank 2. This is the **outer product** $\mathbf{a}\otimes\mathbf{b}$.

### 2.3 Legal and Illegal Expressions

Stare at these until you can immediately classify them.

**Legal:**

- $a_i b_i$ &nbsp;&nbsp; (scalar, dummy $i$)
- $A_{ij} b_j$ &nbsp;&nbsp; (vector, free $i$, dummy $j$)
- $A_{ij} B_{jk}$ &nbsp;&nbsp; (rank-2, free $i$ and $k$, dummy $j$)
- $A_{ij} B_{ji}$ &nbsp;&nbsp; (scalar, dummy $i$ and $j$; this is $\operatorname{tr}(\mathbf{A}\mathbf{B})$)
- $\partial_i \partial_i \phi$ &nbsp;&nbsp; (scalar, the Laplacian $\nabla^2 \phi$)
- $\varepsilon_{ijk} a_j b_k$ &nbsp;&nbsp; (vector, free $i$; this is $(\mathbf{a}\times\mathbf{b})_i$)

**Illegal:**

- $A_{ii} b_i$ &nbsp;&nbsp; **(three $i$'s in one term — meaningless)**
- $A_{ij} b_i c_j d_i$ &nbsp;&nbsp; **(three $i$'s)**
- $A_{ij} = B_{ik}$ &nbsp;&nbsp; **(free indices don't match: LHS has $i,j$; RHS has $i,k$)**
- $C_i = A_{ij}$ &nbsp;&nbsp; **(LHS rank 1, RHS rank 2 — mismatched ranks)**
- $A_{ij} + b_i$ &nbsp;&nbsp; **(adding tensors of different rank)**

> **Debugging tip.** Before manipulating any expression, *count the indices*. Every term must have:
> 1. The *same set of free indices*.
> 2. Each free index appearing exactly once per term.
> 3. Each dummy index appearing exactly twice per term.
>
> If any of these fail, the expression is wrong. Period.

### 2.4 Renaming Dummy Indices

Dummy indices are invisible after summation: they're just summation variables. Therefore you may rename them at will, as long as you don't collide with a free index or another dummy in the same term.

For example,
$$
A_{ij} B_{jk} = A_{im} B_{mk} = A_{i\ell} B_{\ell k},
$$
all identical. But
$$
A_{ij} B_{jk} \neq A_{ik} B_{kk}, \qquad \text{(illegal: three $k$'s)}
$$
because we collided the dummy $j$ with the free $k$.

This trick is *enormously* useful for combining expressions. If you have
$$
v_i = A_{ij} u_j \quad \text{and} \quad u_j = B_{jk} w_k,
$$
you cannot directly substitute the second into the first without renaming: the $j$ in the second equation is bound (dummy with $B$); the $j$ in the first is free (it's a slot). After substitution:
$$
v_i = A_{ij}(B_{jk} w_k) = A_{ij} B_{jk} w_k.
$$
Here $j$ is now a dummy in the combined expression — it appears twice on the right and not at all on the left. The free indices $i$ (LHS) and $k$ (RHS dummy with $w$) — wait, let's recount: $i$ once on LHS, once on RHS (in $A_{ij}$); $j$ twice on RHS (dummy); $k$ twice on RHS (dummy, in $B_{jk}$ and $w_k$). Free index: $i$. The expression has rank 1. Correct.

### 2.5 Rank Counting

The rank of an expression equals the number of free indices.

- $a_i b_i$ → 0 free → rank 0 → scalar.
- $A_{ij}b_j$ → 1 free ($i$) → rank 1 → vector.
- $A_{ij}B_{kl}$ → 4 free → rank 4 → a 4-tensor (think elastic stiffness $C_{ijkl}$).
- $a_i b_j$ → 2 free → rank 2.

Every contraction (summation over a repeated index) **reduces rank by 2**: it eliminates two slots. This is the geometric content of contraction.

---

## 3. Geometric and Linear-Algebra Interpretation

### 3.1 The Translation Table

For 3D Cartesian tensors of rank $\leq 2$:

| Vector / matrix notation | Index notation | Comment |
|---|---|---|
| $\mathbf{a}\cdot\mathbf{b}$ | $a_i b_i$ | inner product |
| $\mathbf{a}\otimes\mathbf{b}$ or $\mathbf{a}\mathbf{b}^\top$ | $a_i b_j$ | outer product |
| $\mathbf{A}\mathbf{b}$ | $A_{ij}b_j$ | matrix–vector |
| $\mathbf{b}^\top \mathbf{A}$ | $b_i A_{ij}$ | row–matrix (free index $j$) |
| $\mathbf{A}\mathbf{B}$ | $A_{ij}B_{jk}$ | matrix–matrix |
| $\mathbf{A}^\top$ | $A_{ji}$ | transpose: swap indices |
| $\operatorname{tr}\mathbf{A}$ | $A_{ii}$ | trace |
| $\mathbf{A}:\mathbf{B}$ | $A_{ij}B_{ij}$ | Frobenius inner product |
| $\operatorname{tr}(\mathbf{A}\mathbf{B})$ | $A_{ij}B_{ji}$ | note the swapped indices |
| $\mathbf{I}$ (identity) | $\delta_{ij}$ | Kronecker delta |
| $\mathbf{a}\times\mathbf{b}$ | $\varepsilon_{ijk}a_j b_k$ | cross product (free $i$) |
| $\nabla\phi$ | $\partial_i \phi$ | gradient of scalar |
| $\nabla\cdot\mathbf{v}$ | $\partial_i v_i$ | divergence |
| $\nabla\times\mathbf{v}$ | $\varepsilon_{ijk}\partial_j v_k$ | curl |
| $\nabla^2 \phi$ | $\partial_i\partial_i\phi$ | Laplacian |

> **Crucial warning.** $\mathbf{A}:\mathbf{B}$ and $\operatorname{tr}(\mathbf{A}\mathbf{B})$ are **not** the same in general. They agree when $\mathbf{A}$ or $\mathbf{B}$ is symmetric, but otherwise differ. Specifically,
> $$
> \mathbf{A}:\mathbf{B} = A_{ij}B_{ij}, \qquad \operatorname{tr}(\mathbf{A}\mathbf{B}) = A_{ij}B_{ji}.
> $$
> The second is $\mathbf{A}:\mathbf{B}^\top$. Confusing these is one of the most common errors in continuum mechanics derivations.

### 3.2 Tensors as Slot Machines

The clearest geometric picture: a rank-$n$ tensor $T_{i_1 i_2 \cdots i_n}$ is a machine with $n$ slots. Each slot accepts a vector. When all slots are filled with vectors $\mathbf{a}^{(1)}, \ldots, \mathbf{a}^{(n)}$, the machine produces a scalar:
$$
T_{i_1\cdots i_n} a^{(1)}_{i_1} \cdots a^{(n)}_{i_n} = \text{(a number)}.
$$

Contracting two indices of $T$ together — say $T_{iijk}$ — means *internally connecting* two slots: you're feeding the basis vectors $\mathbf{e}_1, \mathbf{e}_2, \mathbf{e}_3$ into both slots simultaneously and summing. The result is a rank-$(n-2)$ tensor.

Outer products glue tensors together without contracting: $A_{ij}B_{kl}$ is a rank-4 tensor with no shared slots. Inner products combine *and* contract: $A_{ij}B_{ij}$ glues all four slots into two contracted pairs, leaving rank 0.

### 3.3 Matrix Multiplication is a Contraction

Re-examine $C_{ik} = A_{ij} B_{jk}$. The "$j$" is a contraction: the second slot of $\mathbf{A}$ (which accepts column vectors) is connected to the first slot of $\mathbf{B}$ (which receives row vectors). The leftover slots are the row of $\mathbf{A}$ ($i$) and the column of $\mathbf{B}$ ($k$). This is exactly the matrix multiplication rule from linear algebra — but now the *geometric content* is visible: matrix multiplication chains two linear maps together by feeding the output of one into the input slot of the next.

> **Mental picture.** Index notation lets you see matrix multiplication as plumbing. The dummy index is the "pipe" joining two slots; the free indices are the open ends.

### 3.4 Tensor Products and Higher Rank

The outer product $a_i b_j = M_{ij}$ builds a rank-2 tensor from two rank-1 tensors. Iterating, $a_i b_j c_k = T_{ijk}$ is rank 3. In soft matter, the simplest rank-3 tensor you encounter is the gradient of a rank-2 tensor: $\partial_k \sigma_{ij}$, which appears in momentum balance derivations.

The most important rank-4 tensor in soft matter is the **elastic stiffness** $C_{ijkl}$, relating stress and strain in linear elasticity:
$$
\sigma_{ij} = C_{ijkl}\, \epsilon_{kl}.
$$
Here $k$ and $l$ are dummies; $i$ and $j$ are free. For an isotropic material, $C_{ijkl}$ has only two independent components (Lamé coefficients) — see section 7.

---

## 4. Differential Operators in Index Notation

This section is the longest because it is where most students lose their footing. The payoff is enormous: once you internalize $\partial_i$, all of fluid mechanics opens up.

### 4.1 The Gradient $\partial_i \phi$

For a scalar field $\phi(\mathbf{r})$, the symbol $\partial_i$ means "differentiate with respect to the $i$th Cartesian coordinate":
$$
\partial_i \phi \equiv \frac{\partial \phi}{\partial x_i}.
$$
- $i$ is a **free index** (it appears once); the result is a vector — the gradient $\nabla\phi$.
- Component-by-component: $\partial_1 \phi = \partial\phi/\partial x$, $\partial_2 \phi = \partial\phi/\partial y$, $\partial_3 \phi = \partial\phi/\partial z$.

**Physical meaning.** The gradient points in the direction of steepest increase of $\phi$, and its magnitude equals the rate of increase. The chain rule then gives the change in $\phi$ for an infinitesimal displacement $d\mathbf{r}$ as
$$
d\phi = (\partial_i \phi)\, dx_i,
$$
where $i$ is dummy. This is the index-notation form of the directional derivative.

### 4.2 The Velocity Gradient Tensor $L_{ij} = \partial_j v_i$

Here is where confusion explodes, so we go slowly. For a velocity field $v_i(\mathbf{r})$, the expression
$$
L_{ij} = \partial_j v_i = \frac{\partial v_i}{\partial x_j}
$$
defines a rank-2 tensor with **two free indices**. In matrix form:
$$
\mathbf{L} = \begin{pmatrix}
\partial_1 v_1 & \partial_2 v_1 & \partial_3 v_1 \\
\partial_1 v_2 & \partial_2 v_2 & \partial_3 v_2 \\
\partial_1 v_3 & \partial_2 v_3 & \partial_3 v_3
\end{pmatrix}.
$$
Row $i$ contains derivatives of the $i$th velocity component; column $j$ contains derivatives with respect to $x_j$.

> **Convention warning.** Different books and papers disagree on whether the velocity gradient is $\partial_j v_i$ or $\partial_i v_j$ (its transpose). Both choices give the same physics — the strain-rate and vorticity tensors come out the same after symmetrization/antisymmetrization. But you *must* always check the convention when reading a paper. Index notation makes this transparent; vector notation hides it.

**Physical meaning.** $L_{ij}$ tells you how the velocity component $v_i$ changes as you move in direction $j$. It encodes *all* local kinematics of the flow:
- how fluid elements stretch (diagonal entries on the symmetric part),
- how they shear (off-diagonal symmetric part),
- how they rotate (antisymmetric part).

### 4.3 Symmetric and Antisymmetric Decomposition

Any rank-2 tensor $L_{ij}$ can be split into a symmetric part and an antisymmetric part:
$$
L_{ij} = \underbrace{\tfrac{1}{2}(L_{ij} + L_{ji})}_{\text{symmetric}} + \underbrace{\tfrac{1}{2}(L_{ij} - L_{ji})}_{\text{antisymmetric}}.
$$
For the velocity gradient:
$$
\boxed{D_{ij} = \tfrac{1}{2}(\partial_j v_i + \partial_i v_j), \qquad \Omega_{ij} = \tfrac{1}{2}(\partial_j v_i - \partial_i v_j).}
$$
- $D_{ij}$ is the **strain-rate tensor** (also called the symmetric velocity gradient or rate-of-deformation tensor).
- $\Omega_{ij}$ is the **vorticity tensor** (antisymmetric).

**Physical meaning of $D_{ij}$.** It captures *deformation*. Consider a small fluid blob at a point. The trace $D_{ii} = \partial_i v_i$ is the local rate of volume expansion (positive = expanding, zero = incompressible). The diagonal entries (with the trace subtracted) describe extension/compression along each axis. The off-diagonals describe shear: how perpendicular fluid lines tilt toward each other.

**Physical meaning of $\Omega_{ij}$.** It captures *rigid-body rotation* of the blob. An antisymmetric $3\times 3$ tensor has only three independent components, which can be packaged into a vector — the **vorticity vector**:
$$
\omega_k = \varepsilon_{kij}\, \partial_i v_j, \qquad \Omega_{ij} = -\tfrac{1}{2}\varepsilon_{ijk}\,\omega_k.
$$
(We'll prove the second relation in section 5.) The vorticity vector $\boldsymbol{\omega} = \nabla\times\mathbf{v}$ is twice the angular velocity of an infinitesimal fluid element about its own center.

### 4.4 The Divergence $\partial_i v_i$

The contraction of the velocity gradient on its two indices,
$$
\partial_i v_i = \nabla\cdot\mathbf{v},
$$
is the **divergence**. It's a scalar (no free indices). Physically, it is the rate at which volume is created or destroyed per unit volume — the local expansion rate. For an incompressible fluid,
$$
\boxed{\partial_i v_i = 0.}
$$
This single equation is one of the workhorses of fluid dynamics; you will write it ten thousand times.

### 4.5 The Curl $\varepsilon_{ijk}\partial_j v_k$

The curl is the only rank-1 combination involving a single $\partial$ and a single $v$ that survives if both are vectors. In index notation:
$$
(\nabla\times\mathbf{v})_i = \varepsilon_{ijk}\partial_j v_k.
$$
- $i$ is the free index.
- $j$ and $k$ are dummies, each appearing twice.

The Levi-Civita symbol enforces antisymmetry: only the antisymmetric part of $\partial_j v_k$ contributes (more on this in section 5), and this is exactly the vorticity.

### 4.6 The Laplacian $\partial_i \partial_i \phi$

The Laplacian is the divergence of the gradient:
$$
\nabla^2 \phi = \partial_i(\partial_i \phi) = \partial_i\partial_i \phi.
$$
Both indices are dummy; the result is a scalar (if $\phi$ is scalar) or a vector (component-wise, if applied to $v_i$: $\partial_j\partial_j v_i$).

### 4.7 Second Derivatives

The Hessian of a scalar is $\partial_i\partial_j\phi$ — rank 2, symmetric (mixed partials commute). The combination $\partial_i\partial_j$ acting on a vector field gives $\partial_i\partial_j v_k$ — rank 3.

A subtle but vital identity:
$$
\partial_i \partial_j v_k = \partial_j \partial_i v_k
$$
for smooth fields. **Partial derivatives commute.** This will save your life in section 8.

### 4.8 Incompressibility, Shear, and Rotation: Visual Intuition

Take a 2D flow and consider three canonical velocity gradients:

**Pure expansion:** $v_i = \alpha x_i$.  
Then $L_{ij} = \alpha\delta_{ij}$. Symmetric, diagonal, trace $= 2\alpha$ (in 2D) or $3\alpha$ (in 3D). Vorticity zero. A circle stays a circle, just bigger.

**Pure shear:** $v_1 = \gamma x_2$, $v_2 = 0$.  
Then $L_{12} = \gamma$, all others zero. Splitting: $D_{12} = D_{21} = \gamma/2$, $\Omega_{12} = -\Omega_{21} = \gamma/2$. The flow has *both* deformation and rotation. A circle becomes an ellipse and simultaneously rotates.

**Pure rotation:** $v_1 = -\omega x_2$, $v_2 = \omega x_1$.  
Then $L_{12} = -\omega$, $L_{21} = \omega$. Strain rate zero; vorticity tensor nonzero. A circle stays a circle but rotates.

The decomposition $L = D + \Omega$ literally separates these effects.

> **Mental picture for $\partial_j v_i$.** Imagine standing at a point and looking at the fluid right next to you. $L_{ij}$ tells you that if you move slightly in direction $j$ ($\delta x_j$), the $i$th velocity component changes by $L_{ij}\,\delta x_j$. So $L$ is the *Jacobian* of the velocity field: it linearizes the flow at a point.

---

## 5. The Kronecker Delta and the Levi-Civita Symbol

These two objects are the algebraic glue of index notation. Master their identities and you can do almost any contraction.

### 5.1 The Kronecker Delta $\delta_{ij}$

Defined by
$$
\delta_{ij} = \begin{cases} 1 & i = j, \\ 0 & i \neq j. \end{cases}
$$
It is the components of the identity tensor: $\mathbf{I}_{ij} = \delta_{ij}$.

**Key properties:**

1. **Symmetric:** $\delta_{ij} = \delta_{ji}$.
2. **Trace:** $\delta_{ii} = 3$ in 3D (in general, $\delta_{ii} = d$ in $d$ dimensions). Always check the dimension!
3. **Substitution property:** $\delta_{ij}a_j = a_i$, $\delta_{ij}A_{jk} = A_{ik}$, etc. The delta "replaces" the contracted index. This is the most useful identity in all of index notation.
4. $\delta_{ij}\delta_{jk} = \delta_{ik}$ (chain of substitutions).
5. $\delta_{ij}\delta_{ij} = \delta_{ii} = 3$.

**Worked example.** Compute $\delta_{ij}A_{ij}$:
$$
\delta_{ij}A_{ij} = A_{ii} = \operatorname{tr}\mathbf{A}.
$$
The delta forces $i = j$ and we are left with the trace.

### 5.2 The Levi-Civita Symbol $\varepsilon_{ijk}$

Defined as the totally antisymmetric symbol with $\varepsilon_{123} = +1$:
$$
\varepsilon_{ijk} = \begin{cases}
+1 & (ijk) \text{ is an even permutation of } (123), \\
-1 & (ijk) \text{ is an odd permutation}, \\
0 & \text{any two indices equal}.
\end{cases}
$$
So $\varepsilon_{123} = \varepsilon_{231} = \varepsilon_{312} = +1$, $\varepsilon_{213} = \varepsilon_{132} = \varepsilon_{321} = -1$, and all others zero.

**Key properties:**

1. **Totally antisymmetric:** swapping any two indices flips the sign. $\varepsilon_{ijk} = -\varepsilon_{jik} = -\varepsilon_{ikj}$, etc.
2. **Cyclic invariance:** $\varepsilon_{ijk} = \varepsilon_{jki} = \varepsilon_{kij}$ (these are cyclic permutations, all even).
3. Any contraction of $\varepsilon$ with a symmetric tensor vanishes: $\varepsilon_{ijk}S_{jk} = 0$ if $S_{jk} = S_{kj}$.

**Proof of property 3.** Write
$$
\varepsilon_{ijk}S_{jk} = \tfrac{1}{2}\bigl(\varepsilon_{ijk}S_{jk} + \varepsilon_{ijk}S_{jk}\bigr).
$$
In the second term, rename dummies $j \leftrightarrow k$:
$$
\varepsilon_{ijk}S_{jk} = \tfrac{1}{2}\bigl(\varepsilon_{ijk}S_{jk} + \varepsilon_{ikj}S_{kj}\bigr).
$$
Use $\varepsilon_{ikj} = -\varepsilon_{ijk}$ and $S_{kj} = S_{jk}$ (symmetry of $S$):
$$
\varepsilon_{ijk}S_{jk} = \tfrac{1}{2}\bigl(\varepsilon_{ijk}S_{jk} - \varepsilon_{ijk}S_{jk}\bigr) = 0. \qquad\blacksquare
$$
This is a calculation pattern you will use constantly: rename dummies, exploit symmetry/antisymmetry, force terms to cancel.

### 5.3 The $\varepsilon$–$\delta$ Identity

The most useful identity in all of vector calculus:
$$
\boxed{\varepsilon_{ijk}\varepsilon_{ilm} = \delta_{jl}\delta_{km} - \delta_{jm}\delta_{kl}.}
$$
Note that the $i$ is contracted on both $\varepsilon$'s. The free indices are $j, k$ (from the first $\varepsilon$) and $l, m$ (from the second). The right-hand side has a "natural" pairing ($j$ with $l$, $k$ with $m$) minus a "crossed" pairing ($j$ with $m$, $k$ with $l$).

A useful mnemonic: it's like a $2\times 2$ determinant of deltas.

**Corollaries:**

- Contracting two indices: $\varepsilon_{ijk}\varepsilon_{ijm} = \delta_{jj}\delta_{km} - \delta_{jm}\delta_{kj} = 3\delta_{km} - \delta_{km} = 2\delta_{km}$.
- All three contracted: $\varepsilon_{ijk}\varepsilon_{ijk} = 2\delta_{kk} = 6$.

### 5.4 Worked Example: Cross Product Identities

**Goal.** Prove the BAC–CAB rule: $\mathbf{a}\times(\mathbf{b}\times\mathbf{c}) = \mathbf{b}(\mathbf{a}\cdot\mathbf{c}) - \mathbf{c}(\mathbf{a}\cdot\mathbf{b})$.

**Setup.** Write the LHS in index notation:
$$
[\mathbf{a}\times(\mathbf{b}\times\mathbf{c})]_i = \varepsilon_{ijk}\,a_j\,(\mathbf{b}\times\mathbf{c})_k = \varepsilon_{ijk}\,a_j\,\varepsilon_{klm}b_l c_m.
$$

**Step 1.** Combine the two epsilons. Note $\varepsilon_{ijk} = \varepsilon_{kij}$ (cyclic), so:
$$
\varepsilon_{ijk}\varepsilon_{klm} = \varepsilon_{kij}\varepsilon_{klm}.
$$
Apply the $\varepsilon$–$\delta$ identity with $k$ as the contracted index:
$$
\varepsilon_{kij}\varepsilon_{klm} = \delta_{il}\delta_{jm} - \delta_{im}\delta_{jl}.
$$

**Step 2.** Substitute back:
$$
[\mathbf{a}\times(\mathbf{b}\times\mathbf{c})]_i = (\delta_{il}\delta_{jm} - \delta_{im}\delta_{jl})\,a_j b_l c_m.
$$

**Step 3.** Use the substitution property of the deltas:
$$
\delta_{il}\delta_{jm}a_j b_l c_m = a_m b_i c_m = b_i (a_m c_m) = b_i(\mathbf{a}\cdot\mathbf{c}).
$$
Wait — let me redo this carefully. $\delta_{il}b_l = b_i$ and $\delta_{jm}a_j c_m = a_m c_m$, so the first term is $b_i(a_m c_m)$. Good.

Similarly, $\delta_{im}c_m = c_i$ and $\delta_{jl}a_j b_l = a_l b_l$, so the second term is $c_i(a_l b_l)$.

**Step 4.** Assemble:
$$
[\mathbf{a}\times(\mathbf{b}\times\mathbf{c})]_i = b_i(\mathbf{a}\cdot\mathbf{c}) - c_i(\mathbf{a}\cdot\mathbf{b}).
$$
In vector form: $\mathbf{a}\times(\mathbf{b}\times\mathbf{c}) = \mathbf{b}(\mathbf{a}\cdot\mathbf{c}) - \mathbf{c}(\mathbf{a}\cdot\mathbf{b})$. $\blacksquare$

This computation took ten lines. Try it without index notation. It will take pages.

### 5.5 The Cross Product

By definition,
$$
(\mathbf{a}\times\mathbf{b})_i = \varepsilon_{ijk}a_j b_k.
$$
**Why is this antisymmetric in $\mathbf{a}, \mathbf{b}$?** Swap them: $\varepsilon_{ijk}b_j a_k = \varepsilon_{ikj}b_k a_j$ (rename $j\leftrightarrow k$) $= -\varepsilon_{ijk}a_j b_k$. So $\mathbf{b}\times\mathbf{a} = -\mathbf{a}\times\mathbf{b}$, as required.

**Why does $\mathbf{a}\times\mathbf{a} = 0$?** $\varepsilon_{ijk}a_j a_k$: the tensor $a_j a_k$ is symmetric in $jk$, contracted with antisymmetric $\varepsilon$, so it vanishes (section 5.2, property 3).

### 5.6 The Vorticity Vector

Define the vorticity vector $\omega_i = (\nabla\times\mathbf{v})_i = \varepsilon_{ijk}\partial_j v_k$. We claimed in section 4 that $\Omega_{ij} = -\tfrac{1}{2}\varepsilon_{ijk}\omega_k$. Let's verify:
$$
-\tfrac{1}{2}\varepsilon_{ijk}\omega_k = -\tfrac{1}{2}\varepsilon_{ijk}\varepsilon_{klm}\partial_l v_m.
$$
Use $\varepsilon_{ijk}\varepsilon_{klm} = \varepsilon_{kij}\varepsilon_{klm} = \delta_{il}\delta_{jm} - \delta_{im}\delta_{jl}$:
$$
-\tfrac{1}{2}(\delta_{il}\delta_{jm} - \delta_{im}\delta_{jl})\partial_l v_m = -\tfrac{1}{2}(\partial_i v_j - \partial_j v_i) = \tfrac{1}{2}(\partial_j v_i - \partial_i v_j) = \Omega_{ij}. \;\;\blacksquare
$$

### 5.7 Summary Table

| Identity | Statement |
|---|---|
| Substitution | $\delta_{ij}a_j = a_i$ |
| Trace of delta | $\delta_{ii} = d$ |
| Antisymmetry of $\varepsilon$ | $\varepsilon_{ijk} = -\varepsilon_{jik}$ |
| Symmetric × antisymmetric | $\varepsilon_{ijk}S_{jk} = 0$ if $S$ symmetric |
| $\varepsilon$–$\delta$ | $\varepsilon_{ijk}\varepsilon_{ilm} = \delta_{jl}\delta_{km} - \delta_{jm}\delta_{kl}$ |
| Cross product | $(\mathbf{a}\times\mathbf{b})_i = \varepsilon_{ijk}a_j b_k$ |
| Curl | $(\nabla\times\mathbf{v})_i = \varepsilon_{ijk}\partial_j v_k$ |

---

## 6. Symmetric and Antisymmetric Tensors

### 6.1 The Decomposition

Any rank-2 tensor $T_{ij}$ admits a unique decomposition into symmetric and antisymmetric parts:
$$
T_{ij} = S_{ij} + A_{ij}, \qquad S_{ij} = \tfrac{1}{2}(T_{ij} + T_{ji}), \quad A_{ij} = \tfrac{1}{2}(T_{ij} - T_{ji}).
$$
$S$ is symmetric ($S_{ij} = S_{ji}$, 6 independent components in 3D), $A$ is antisymmetric ($A_{ij} = -A_{ji}$, 3 independent components in 3D).

This decomposition is universal in continuum mechanics. We saw it for the velocity gradient ($L = D + \Omega$). Every flow, every deformation, every linear response splits into "shape change" (symmetric) and "rotation" (antisymmetric).

### 6.2 The Orthogonality Theorem

> **Theorem.** The full contraction of a symmetric tensor with an antisymmetric tensor vanishes:
> $$
> S_{ij} A_{ij} = 0 \quad \text{whenever } S_{ij}=S_{ji} \text{ and } A_{ij}=-A_{ji}.
> $$

**Proof.** Rename dummies in $S_{ij}A_{ij}$ by swapping $i \leftrightarrow j$:
$$
S_{ij}A_{ij} = S_{ji}A_{ji}.
$$
Apply symmetry of $S$ and antisymmetry of $A$:
$$
S_{ji}A_{ji} = S_{ij}(-A_{ij}) = -S_{ij}A_{ij}.
$$
So $S_{ij}A_{ij} = -S_{ij}A_{ij}$, forcing $S_{ij}A_{ij} = 0$. $\blacksquare$

### 6.3 Physical Consequence: Stress and Vorticity Don't Mix

In a Newtonian fluid, the deviatoric stress is $\sigma'_{ij} = 2\eta D_{ij}$, symmetric. The viscous dissipation rate per unit volume is
$$
\Phi = \sigma'_{ij} L_{ij} = \sigma'_{ij}(D_{ij} + \Omega_{ij}) = \sigma'_{ij}D_{ij},
$$
because $\sigma'_{ij}\Omega_{ij} = 0$ by the theorem above. **Rigid-body rotation dissipates no energy.** This is intuitive: spinning a glass of water rigidly is reversible. Only deformation costs energy. The math enforces this automatically.

> **Mental picture.** Symmetric and antisymmetric tensors live in orthogonal subspaces of the space of rank-2 tensors (dimension 9 = 6 + 3 in 3D). Their inner product is zero — like two perpendicular vectors.

### 6.4 The Newtonian Constitutive Law

For an incompressible Newtonian fluid:
$$
\sigma_{ij} = -p\,\delta_{ij} + 2\eta\,D_{ij}, \qquad D_{ij} = \tfrac{1}{2}(\partial_i v_j + \partial_j v_i).
$$
The pressure $p$ is the isotropic part; $2\eta D_{ij}$ is the deviatoric viscous part. For a compressible fluid you add a $\zeta(\partial_k v_k)\delta_{ij}$ bulk-viscosity term.

### 6.5 The Antisymmetric–Vector Duality (3D Only)

In three dimensions, any antisymmetric rank-2 tensor $A_{ij}$ has 3 independent components and so encodes the same information as a vector. The map is
$$
A_{ij} \leftrightarrow \omega_k = -\tfrac{1}{2}\varepsilon_{kij}A_{ij}, \qquad A_{ij} = -\varepsilon_{ijk}\omega_k.
$$
We've already seen this for vorticity. Be aware that this trick works *only in 3D* — there is no Levi-Civita duality of this form in 2D or 4D.

### 6.6 Counting Independent Components

For a rank-2 tensor in $d$ dimensions:
- Symmetric: $\tfrac{1}{2}d(d+1)$ independent components. In 3D: 6.
- Antisymmetric: $\tfrac{1}{2}d(d-1)$. In 3D: 3.
- Total: $d^2$. Check: $6 + 3 = 9$. ✓

This is your sanity check whenever you write down a constitutive law.

---

## 7. Isotropic Tensors and the Trace/Deviatoric Decomposition

### 7.1 What is an Isotropic Tensor?

A tensor is **isotropic** if its components are unchanged by rotations. In 3D Cartesian:

- The only rank-0 isotropic tensor: any scalar.
- The only rank-1 isotropic tensor: zero. (A vector picks out a direction; rotations change it.)
- The only rank-2 isotropic tensor (up to scalar multiple): $\delta_{ij}$.
- The only rank-3 isotropic tensor: $\varepsilon_{ijk}$ (up to sign; a "pseudo-tensor" under parity).
- Rank-4 isotropic tensors form a 3-dimensional space, spanned by $\delta_{ij}\delta_{kl}$, $\delta_{ik}\delta_{jl}$, $\delta_{il}\delta_{jk}$.

These facts constrain constitutive laws enormously.

### 7.2 The Most Important Application: Isotropic Elasticity

For a linear isotropic elastic solid, the stiffness tensor $C_{ijkl}$ must be rank-4 isotropic:
$$
C_{ijkl} = \lambda\,\delta_{ij}\delta_{kl} + \mu\,(\delta_{ik}\delta_{jl} + \delta_{il}\delta_{jk}) + \nu\,(\delta_{ik}\delta_{jl} - \delta_{il}\delta_{jk}).
$$
The symmetry $C_{ijkl} = C_{jikl}$ (from $\sigma_{ij} = \sigma_{ji}$) plus $C_{ijkl} = C_{ijlk}$ (from $\epsilon_{kl}$ symmetric) kills the third combination ($\nu = 0$). What remains is the Hooke's law with two Lamé constants:
$$
\sigma_{ij} = \lambda\,\epsilon_{kk}\,\delta_{ij} + 2\mu\,\epsilon_{ij}.
$$
**This is why isotropic solids have exactly two elastic moduli.** Index notation makes the counting transparent.

### 7.3 The Trace/Deviatoric Decomposition

Any rank-2 tensor $T_{ij}$ splits as
$$
T_{ij} = \underbrace{\tfrac{1}{d}T_{kk}\,\delta_{ij}}_{\text{isotropic part}} + \underbrace{\bigl(T_{ij} - \tfrac{1}{d}T_{kk}\,\delta_{ij}\bigr)}_{\text{deviatoric (traceless)}}.
$$
The deviatoric part is traceless: contracting the indices gives $T_{ii} - \tfrac{d}{d}T_{kk} = 0$.

In fluid mechanics, the stress decomposes as
$$
\sigma_{ij} = -p\,\delta_{ij} + \tau_{ij}, \qquad p = -\tfrac{1}{3}\sigma_{kk}, \quad \tau_{ii} = 0.
$$
The pressure is the (negative) isotropic part; the deviatoric stress $\tau_{ij}$ encodes shear.

### 7.4 The Symmetric–Traceless Decomposition of $\partial_j v_i$

Combining sections 6 and 7, the velocity gradient splits *three* ways:
$$
\partial_j v_i = \underbrace{\tfrac{1}{3}(\partial_k v_k)\,\delta_{ij}}_{\text{isotropic}} + \underbrace{\bigl(D_{ij} - \tfrac{1}{3}D_{kk}\,\delta_{ij}\bigr)}_{\text{traceless symmetric}} + \underbrace{\Omega_{ij}}_{\text{antisymmetric}}.
$$
- Isotropic: pure expansion/compression (3 → 1 dof).
- Traceless symmetric: pure shear (6 − 1 = 5 dof).
- Antisymmetric: pure rotation (3 dof).
- Total: $1 + 5 + 3 = 9$. ✓ (Same as $d^2 = 9$.)

This is the kinematic Helmholtz decomposition for flows. In a Newtonian *compressible* fluid, each piece couples to a different stress component (bulk viscosity $\zeta$ for the isotropic part, shear viscosity $\eta$ for the deviatoric, nothing for the rotation).

### 7.5 Nematic Order Parameter

In nematic liquid crystals, the order parameter is a symmetric traceless rank-2 tensor:
$$
Q_{ij} = S\bigl(n_i n_j - \tfrac{1}{3}\delta_{ij}\bigr),
$$
where $\mathbf{n}$ is the director and $S$ the scalar order parameter. The "$-\tfrac{1}{3}\delta_{ij}$" guarantees $Q_{ii} = 0$: this is the symmetric–traceless deviatoric form, dictated by the head–tail symmetry of nematics. The $n_in_j$ form (rather than $n_i$) is *exactly* the construction needed to forget the sign of $\mathbf{n}$, since $(-\mathbf{n})_i(-\mathbf{n})_j = n_i n_j$.

---

## 8. Continuum Mechanics Identities

We now derive the identities you'll use every day.

### 8.1 Divergence of the Stress: $\partial_j \sigma_{ij}$

This appears on the right-hand side of the Cauchy momentum equation. It is a vector ($i$ free; $j$ dummy). For the Newtonian stress with constant density:
$$
\partial_j \sigma_{ij} = \partial_j(-p\,\delta_{ij}) + \partial_j(2\eta D_{ij}).
$$

**First term:** $\partial_j(-p\,\delta_{ij}) = -\delta_{ij}\partial_j p = -\partial_i p$. The delta substitutes.

**Second term:** $2\eta\partial_j D_{ij} = \eta\partial_j(\partial_i v_j + \partial_j v_i) = \eta(\partial_j\partial_i v_j + \partial_j\partial_j v_i)$.
Commute partials in the first piece: $\partial_j\partial_i v_j = \partial_i(\partial_j v_j) = \partial_i(\nabla\cdot\mathbf{v})$. For an incompressible fluid this vanishes. The second piece is $\eta\nabla^2 v_i$.

Result:
$$
\boxed{\partial_j\sigma_{ij} = -\partial_i p + \eta\,\partial_j\partial_j v_i \qquad \text{(incompressible Newtonian)}.}
$$
This is the Navier–Stokes viscous + pressure RHS. In vector notation: $-\nabla p + \eta\nabla^2\mathbf{v}$.

### 8.2 Curl of a Gradient is Zero

$$
[\nabla\times(\nabla\phi)]_i = \varepsilon_{ijk}\partial_j\partial_k\phi.
$$
$\partial_j\partial_k\phi$ is symmetric in $jk$ (mixed partials commute). $\varepsilon_{ijk}$ is antisymmetric in $jk$. Symmetric × antisymmetric = 0. So $\nabla\times\nabla\phi = 0$. $\blacksquare$

### 8.3 Divergence of a Curl is Zero

$$
\nabla\cdot(\nabla\times\mathbf{v}) = \partial_i\varepsilon_{ijk}\partial_j v_k = \varepsilon_{ijk}\partial_i\partial_j v_k.
$$
$\partial_i\partial_j$ symmetric in $ij$; $\varepsilon_{ijk}$ antisymmetric in $ij$. Product zero. $\blacksquare$

### 8.4 The Vector Laplacian Identity

$$
\nabla\times(\nabla\times\mathbf{v}) = \nabla(\nabla\cdot\mathbf{v}) - \nabla^2\mathbf{v}.
$$

**Proof.** In index notation:
$$
[\nabla\times(\nabla\times\mathbf{v})]_i = \varepsilon_{ijk}\partial_j(\nabla\times\mathbf{v})_k = \varepsilon_{ijk}\partial_j(\varepsilon_{klm}\partial_l v_m).
$$
Combine the epsilons:
$$
\varepsilon_{ijk}\varepsilon_{klm} = \varepsilon_{kij}\varepsilon_{klm} = \delta_{il}\delta_{jm} - \delta_{im}\delta_{jl}.
$$
Substitute:
$$
[\nabla\times(\nabla\times\mathbf{v})]_i = (\delta_{il}\delta_{jm} - \delta_{im}\delta_{jl})\partial_j\partial_l v_m = \partial_j\partial_i v_j - \partial_j\partial_j v_i = \partial_i(\partial_j v_j) - \partial_j\partial_j v_i.
$$
This is $\nabla(\nabla\cdot\mathbf{v}) - \nabla^2\mathbf{v}$ in components. $\blacksquare$

### 8.5 The Convective Term $v_j\partial_j v_i$

The bedrock nonlinearity of Navier–Stokes:
$$
(\mathbf{v}\cdot\nabla)\mathbf{v}\,\bigr|_i = v_j\,\partial_j v_i.
$$
- $i$ is free (rank 1).
- $j$ is dummy.

**Physical meaning.** The acceleration of a fluid parcel comes in two pieces (material derivative):
$$
\frac{D v_i}{Dt} = \partial_t v_i + v_j\partial_j v_i.
$$
The first piece, $\partial_t v_i$, is the change at a fixed point. The second, $v_j\partial_j v_i$, is the change *because the parcel moves into regions with different velocity*. If you stand still and watch a fluid blob fly past, the blob accelerates because the fluid downstream of it has a different velocity — captured by the velocity gradient $\partial_j v_i$ contracted with the parcel's own velocity $v_j$.

> **Mental picture for $v_j\partial_j v_i$.** Imagine a fluid parcel at position $\mathbf{r}$ with velocity $\mathbf{v}(\mathbf{r})$. In time $dt$ it moves to $\mathbf{r} + \mathbf{v}\,dt$. The velocity at the new location is, to first order, $\mathbf{v}(\mathbf{r}) + (\mathbf{v}\cdot\nabla)\mathbf{v}\,dt$. The "extra" piece $(\mathbf{v}\cdot\nabla)\mathbf{v}$ is the parcel's acceleration purely due to spatial inhomogeneity of the flow — independent of any time dependence.

**Why is this term nonlinear?** Both factors involve $\mathbf{v}$, so the term is quadratic in the velocity. This single nonlinearity is responsible for turbulence, vortex stretching, and most of the open problems in fluid dynamics.

### 8.6 A Useful Reformulation of the Convective Term

Using the identity $v_j\partial_j v_i = \partial_j(v_j v_i) - v_i\partial_j v_j$, for incompressible flow $\partial_j v_j = 0$, so
$$
v_j\partial_j v_i = \partial_j(v_i v_j).
$$
The convective term is the divergence of the **momentum-flux tensor** $\rho v_i v_j$. This is the *conservative form* of the Navier–Stokes nonlinearity, important for numerical schemes and for deriving energy balances.

Another rearrangement uses $\varepsilon$–$\delta$:
$$
v_j\partial_j v_i = \partial_i(\tfrac{1}{2}v_j v_j) - \varepsilon_{ijk}v_j\omega_k.
$$
The first piece is the gradient of the kinetic-energy density per unit mass; the second is the "Lamb vector" $\boldsymbol{\omega}\times\mathbf{v}$. (Derive this in exercise 14.4.)

### 8.7 The Cauchy Momentum Equation

Putting it all together, the incompressible Navier–Stokes equation in index notation is
$$
\boxed{\rho\bigl(\partial_t v_i + v_j\partial_j v_i\bigr) = -\partial_i p + \eta\,\partial_j\partial_j v_i + f_i, \qquad \partial_i v_i = 0.}
$$
Every term has $i$ as its single free index. Every other index is a dummy. Check: this is one vector equation, i.e., three scalar equations, plus one constraint. ✓

---

## 9. Fourier-Space Index Notation

Fourier analysis is *the* tool for linear soft matter problems: membrane fluctuations, Stokes flow, linear-response correlation functions, scattering. The index notation translates beautifully.

### 9.1 The Basic Rule

Take a field $f(\mathbf{r})$ with Fourier transform $\tilde f(\mathbf{q}) = \int d^3r\, e^{-i\mathbf{q}\cdot\mathbf{r}} f(\mathbf{r})$. Then
$$
\partial_i f(\mathbf{r}) \quad\longleftrightarrow\quad i\,q_i\,\tilde f(\mathbf{q}).
$$
Each partial derivative becomes a factor of $i q_i$ in Fourier space. Higher derivatives:
$$
\partial_i\partial_j f \longleftrightarrow -q_i q_j \tilde f, \qquad \nabla^2 f = \partial_i\partial_i f \longleftrightarrow -q^2 \tilde f, \quad q^2 \equiv q_i q_i.
$$

### 9.2 Incompressibility in Fourier Space

$\partial_i v_i = 0$ becomes
$$
q_i \tilde v_i(\mathbf{q}) = 0.
$$
The velocity field in $\mathbf{q}$-space is **transverse**: orthogonal to $\mathbf{q}$. This is the spectral statement of incompressibility, and it underlies the whole structure of Stokes flow in Fourier space.

### 9.3 Transverse Projector

The transverse projector,
$$
\boxed{P^T_{ij}(\mathbf{q}) = \delta_{ij} - \frac{q_i q_j}{q^2},}
$$
is the most important rank-2 tensor in spectral hydrodynamics. Key properties:

1. **Idempotent:** $P^T_{ij}P^T_{jk} = P^T_{ik}$.
2. **Symmetric:** $P^T_{ij} = P^T_{ji}$.
3. **Annihilates the longitudinal mode:** $P^T_{ij} q_j = 0$.
4. **Trace:** $P^T_{ii} = \delta_{ii} - q_iq_i/q^2 = 3 - 1 = 2$ in 3D (the rank of the transverse subspace).

**Proof of idempotence:**
$$
P^T_{ij}P^T_{jk} = (\delta_{ij} - q_iq_j/q^2)(\delta_{jk} - q_jq_k/q^2) = \delta_{ik} - q_iq_k/q^2 - q_iq_k/q^2 + q_i q_k q_jq_j/q^4.
$$
Now $q_jq_j = q^2$, so the last term becomes $q_iq_k q^2/q^4 = q_iq_k/q^2$. Sum:
$$
\delta_{ik} - q_iq_k/q^2 - q_iq_k/q^2 + q_iq_k/q^2 = \delta_{ik} - q_iq_k/q^2 = P^T_{ik}. \;\blacksquare
$$

### 9.4 The Oseen Tensor

The Oseen tensor (Stokeslet) is the Green's function of the steady Stokes equation with incompressibility:
$$
G_{ij}(\mathbf{r}) = \frac{1}{8\pi\eta r}\bigl(\delta_{ij} + \hat r_i \hat r_j\bigr), \qquad \hat r_i = r_i/r.
$$
It tells you that a point force $\mathbf{F}$ at the origin produces a velocity field
$$
v_i(\mathbf{r}) = G_{ij}(\mathbf{r})\,F_j
$$
at distance $\mathbf{r}$. The factor $1/r$ is the long-range, slow-decay of Stokes flow that makes hydrodynamic interactions crucial in colloidal suspensions, microswimmers, and active matter.

**In Fourier space**, the Oseen tensor has a remarkably clean form:
$$
\tilde G_{ij}(\mathbf{q}) = \frac{1}{\eta q^2} P^T_{ij}(\mathbf{q}) = \frac{1}{\eta q^2}\bigl(\delta_{ij} - q_iq_j/q^2\bigr).
$$
Two factors of $1/q$ from the Laplacian, projected onto the transverse subspace by incompressibility.

**Sketch of derivation.** Take Stokes equations in Fourier space:
$$
-i q_i \tilde p + (-\eta q^2)\tilde v_i + \tilde F_i = 0, \qquad q_i \tilde v_i = 0.
$$
Solve for $\tilde p$ by dotting the first equation with $q_i$ and using incompressibility:
$$
-i q^2\tilde p + 0 + q_i \tilde F_i = 0 \quad\Rightarrow\quad \tilde p = \frac{q_i \tilde F_i}{iq^2}.
$$
Substitute back:
$$
\eta q^2 \tilde v_i = \tilde F_i - i q_i\tilde p = \tilde F_i - \frac{q_i q_j \tilde F_j}{q^2} = P^T_{ij}\tilde F_j.
$$
Thus $\tilde v_i = (1/\eta q^2)P^T_{ij}\tilde F_j$. The Oseen tensor is $\tilde G_{ij} = P^T_{ij}/(\eta q^2)$. $\blacksquare$

> **Why this matters in soft matter.** Every membrane fluctuation, every microswimmer flow field, every colloidal hydrodynamic interaction has the Oseen tensor (or its modifications near walls) at its core. You will see $P^T_{ij}/(\eta q^2)$ in essentially every paper on membrane dynamics.

### 9.5 Why Index Notation is Unavoidable in $\mathbf{q}$-Space

Fourier-space expressions are inherently *tensor-valued in $\mathbf{q}$* even when their real-space counterparts look scalar. The kernel $P^T_{ij}/(\eta q^2)$ is rank-2, and you cannot manipulate it without indices. Coordinate-free notation collapses here.

---

## 10. Applications in Soft Matter and Membrane Physics

We now deploy everything in concrete, modern soft-matter calculations.

### 10.1 The Helfrich Hamiltonian and Membrane Fluctuations

For a nearly flat fluid membrane parameterized by its height $h(x,y)$ above a reference plane, the Helfrich bending energy is, to quadratic order,
$$
H = \int d^2r\, \Bigl[\tfrac{\kappa}{2}(\nabla^2 h)^2 + \tfrac{\sigma}{2}(\partial_i h)(\partial_i h)\Bigr],
$$
with $\kappa$ the bending rigidity and $\sigma$ the surface tension. Indices $i, j$ here run over $1, 2$ (the membrane plane).

**Fourier-space form.** Substituting $h(\mathbf{r}) = \int (d^2q/(2\pi)^2) e^{i\mathbf{q}\cdot\mathbf{r}} \tilde h(\mathbf{q})$:
$$
\nabla^2 h \to -q^2 \tilde h, \qquad \partial_i h \to iq_i\tilde h.
$$
So
$$
H = \tfrac{1}{2}\int \frac{d^2q}{(2\pi)^2}\,\bigl[\kappa q^4 + \sigma q^2\bigr]\,|\tilde h(\mathbf{q})|^2.
$$
**Equipartition** gives the fluctuation spectrum:
$$
\boxed{\langle |\tilde h(\mathbf{q})|^2 \rangle = \frac{k_B T}{\kappa q^4 + \sigma q^2}.}
$$
This is the master formula for analyzing flicker spectroscopy data on GUVs: a fit to $1/(\kappa q^4 + \sigma q^2)$ in the appropriate planar projection extracts $\kappa$ and $\sigma$ simultaneously.

For a GUV, the analog on a sphere uses spherical harmonics rather than $\mathbf{q}$, but the structure is identical: a $q^4$ bending mode dominates at high wavenumber, a $q^2$ tension mode at low wavenumber, with a crossover at $q_c = \sqrt{\sigma/\kappa}$.

### 10.2 Membrane Hydrodynamics and Saffman–Delbrück

A protein diffusing in a lipid membrane couples to the *2D* membrane viscosity $\eta_m$ and the *3D* surrounding fluid viscosity $\eta$. The relevant projector is again $P^T_{ij}$, but in 2D. The Saffman–Delbrück mobility for an inclusion of radius $a$ is
$$
\mu \sim \frac{1}{4\pi\eta_m}\bigl[\ln(\eta_m/\eta a) - \gamma\bigr].
$$
The crossover length $\ell_{SD} = \eta_m/\eta$ separates the 2D-dominated regime from the 3D-bulk-dominated regime. Deriving this rigorously is an index-notation calculation in Fourier space using the membrane Oseen tensor (essentially a 2D version of section 9.4 with the bulk fluid coupling added).

### 10.3 Mobility Tensors for Colloids

For two spheres of radius $a$ at positions $\mathbf{r}_1, \mathbf{r}_2$ separated by $\mathbf{r} = \mathbf{r}_2 - \mathbf{r}_1$, the leading hydrodynamic-interaction mobility tensor is the Oseen tensor evaluated at $\mathbf{r}$ (the Rotne–Prager–Yamakawa correction adds short-distance regularization). The translation-translation mobility between particles $\alpha, \beta$ is
$$
\mu^{\alpha\beta}_{ij} = \frac{1}{6\pi\eta a}\delta_{\alpha\beta}\delta_{ij} + G_{ij}(\mathbf{r}_{\alpha\beta})(1-\delta_{\alpha\beta}) + O(a^2/r^2).
$$
Free indices: $i, j$ (Cartesian) and $\alpha, \beta$ (particle labels). Brownian dynamics simulations of colloidal suspensions are built around contracting forces with this tensor at every timestep.

### 10.4 Fluctuation–Dissipation

The fluctuation-dissipation theorem in tensor form:
$$
\langle v_i(\mathbf{r}, t) v_j(\mathbf{r}', 0)\rangle = 2 k_B T \,G_{ij}(\mathbf{r} - \mathbf{r}')\,\delta(t) + \ldots
$$
(within linear response and the appropriate approximations). The off-diagonal Cartesian correlations are dictated by the Oseen-tensor structure of the dissipative kernel. You cannot write this without indices.

### 10.5 Active Stresses

An active suspension of swimmers or motors generates a stress
$$
\sigma^{\text{act}}_{ij}(\mathbf{r}) = \sigma_0\,\bigl(n_i n_j - \tfrac{1}{3}\delta_{ij}\bigr) c(\mathbf{r}),
$$
with $\mathbf{n}$ the local director (rod orientation), $c$ the concentration, and $\sigma_0$ a coefficient (positive for "extensile" swimmers like *E. coli*, negative for "contractile" like myosin–actin). Crucially, this is rank-2, symmetric, and traceless — built from the nematic structure of section 7.5. The momentum balance $\partial_j\sigma^{\text{act}}_{ij}$ then drives spontaneous flows in active gels — the central object of active matter theory.

### 10.6 The Diffusion Tensor

For a rigid body in a viscous fluid (e.g., a microtubule, a rod-shaped bacterium), Brownian motion is anisotropic:
$$
\langle \Delta r_i \Delta r_j\rangle = 2 D_{ij}\,t.
$$
For a rod with diffusion coefficients $D_\parallel$ along its axis and $D_\perp$ perpendicular,
$$
D_{ij} = D_\parallel\,\hat n_i \hat n_j + D_\perp\,(\delta_{ij} - \hat n_i \hat n_j).
$$
The structure is again $(\hat n_i \hat n_j)$-based projector plus its complement — the parallel and perpendicular projectors. Note $D_\parallel + 2D_\perp = D_{ii} = \operatorname{tr}\mathbf{D}$.

### 10.7 Curvature Tensor for Membranes

For a parameterized surface $\mathbf{R}(u^1, u^2)$, the second fundamental form (curvature tensor) is
$$
b_{\alpha\beta} = \mathbf{n}\cdot\partial_\alpha\partial_\beta\mathbf{R},
$$
with $\mathbf{n}$ the unit normal. The mean curvature is $H = \tfrac{1}{2}g^{\alpha\beta}b_{\alpha\beta}$ (trace with the inverse metric); the Gaussian curvature is $K = \det(b)/\det(g)$. The Helfrich Hamiltonian in its full geometric form,
$$
H = \int dA\,\bigl[\tfrac{\kappa}{2}(2H - C_0)^2 + \bar\kappa K\bigr],
$$
requires index notation on a curved surface — this is where the metric $g_{\alpha\beta}$ enters and covariant/contravariant distinctions (section 13) start to matter.

---

## 11. How to Derive Safely: An Expert Workflow

After enough practice, manipulating indices becomes automatic. To accelerate that, here is the explicit workflow experts run in their heads (often without being aware of it).

### 11.1 The Three-Step Index Hygiene Check

Before writing the next line of any derivation, run through three checks on the line you just wrote:

1. **Rank check.** Count free indices on each side. They must match.
2. **Symmetry check.** If a term is a contraction between a symmetric and antisymmetric tensor, it vanishes — simplify immediately.
3. **Dummy check.** Each dummy index appears exactly twice in its term. No index appears three or more times.

### 11.2 Renaming Strategy

When combining or substituting, rename dummies *before* substitution to avoid collisions. A useful habit: pick a "scratch pool" of letters ($m, n, p, q, r, s$) for dummies that appear during intermediate manipulations; reserve $i, j, k, l$ for "primary" indices that survive to the final answer.

### 11.3 Symbol Hygiene

- Always use upright Greek for components of physical fields ($\sigma_{ij}, \epsilon_{ij}, \omega_i$, …) to distinguish from constants.
- Don't reuse the same letter for an Einstein-summed dummy and a free index in the same expression.
- If a Cartesian–nematic computation mixes Cartesian and spherical/curvilinear, use *different alphabets* (Latin for Cartesian, Greek for surface coordinates).

### 11.4 Sanity Checks

Run these whenever a result feels suspicious:

- **Dimensional analysis.** All terms in a sum must have the same physical dimensions.
- **Reduction to a known limit.** Set the antisymmetric part to zero, or set $\mathbf{n} = \mathbf{e}_3$, or take an isotropic limit. The result should reduce to something you recognize.
- **Special-case index values.** Set $i = 1$, see if the resulting equation is correct.
- **Sign check.** Antisymmetric tensors flip sign on swapping indices; gradients of even powers are odd. Verify.

### 11.5 A Worked Workflow Example

**Problem.** Simplify $\varepsilon_{ijk}\partial_i\partial_j v_k$.

- **Rank check.** Free indices on the LHS? $i$ appears in $\varepsilon$ and $\partial$ (twice — dummy), $j$ similarly (dummy), $k$ in $\varepsilon$ and $v$ (dummy). Wait — but $\partial_i\partial_j$ has $i$ and $j$ as separate indices, each appearing once in the differential operators. Let me recount: $\varepsilon_{ijk}$ has $i, j, k$. $\partial_i\partial_j v_k$ has $i, j, k$. So $i$ appears twice (in $\varepsilon$ and $\partial$), $j$ appears twice (in $\varepsilon$ and $\partial$), $k$ appears twice (in $\varepsilon$ and $v$). All dummies. Rank 0 scalar. ✓
- **Symmetry check.** $\partial_i\partial_j v_k$ is symmetric in $i, j$ (partials commute), antisymmetric none. $\varepsilon_{ijk}$ is antisymmetric in $i, j$. Contraction of symmetric and antisymmetric in $i, j$: **zero**.

Done. The expression vanishes identically: this is the divergence-free property of the curl, $\nabla\cdot(\nabla\times\mathbf{v}) = 0$, recovered by inspection.

### 11.6 Symbolic-Computation Backup

Several tools (Mathematica's `Tensor` package, Python's SymPy with `tensor` modules, Cadabra) can perform index manipulations automatically. They are *no substitute* for fluency, because in research you constantly read expressions you must understand at a glance — but they're useful for verifying long derivations.

For MATLAB users in particular: there is no built-in symbolic index manipulator that handles Einstein summation natively as elegantly as Cadabra. For routine numerical tensor contractions, however, MATLAB's `tensorprod`, `pagemtimes`, and the explicit summation patterns
```matlab
% Compute C_ik = A_ij B_jk
C = A * B;          % built-in matrix product

% Compute s = A_ij B_ij (Frobenius)
s = sum(A(:) .* B(:));

% Compute T_ij = a_i b_j (outer product)
T = a(:) * b(:).';
```
are clean and fast.

---

## 12. Common Mistakes and How to Avoid Them

A catalog of errors that will trip you, with diagnostics.

### 12.1 The Triple-Index Crime

**Wrong:** $A_{ij}B_{ij}C_{ij}$.

Here $i$ appears three times, $j$ appears three times. This is meaningless in Einstein notation.

**Why it happens:** you wanted "sum over $i, j$" of a product of three rank-2 tensors and forgot you need *separate* dummy pairs for each contraction. Likely you meant
$$
A_{ij}B_{jk}C_{ki} = \operatorname{tr}(\mathbf{A}\mathbf{B}\mathbf{C}),
$$
or some other unambiguous contraction. Re-derive what you wanted.

### 12.2 Mismatched Free Indices

**Wrong:** $A_{ij} = B_{ik}C_{kj} + D_{i}E_{j}F_{k}$.

The first two terms on the RHS have free indices $i, j$; the third has $i, j, k$ free. Adding objects of different rank is illegal. Likely you forgot to contract $F_k$ with something.

### 12.3 $\mathbf{A}:\mathbf{B}$ vs. $\operatorname{tr}(\mathbf{A}\mathbf{B})$

Recall:
$$
\mathbf{A}:\mathbf{B} = A_{ij}B_{ij}, \qquad \operatorname{tr}(\mathbf{A}\mathbf{B}) = A_{ij}B_{ji}.
$$
These differ by a transpose. They agree only when at least one of $\mathbf{A}, \mathbf{B}$ is symmetric. In the viscous dissipation $2\eta D_{ij}D_{ij}$, the symmetry of $\mathbf{D}$ saves you. In general formulations, distinguish them carefully.

### 12.4 Wrong Position of $\partial$

**Wrong:** writing $\partial_j v_i$ when you mean $\partial_i v_j$ (or vice versa). This is the transpose of the velocity gradient — a different tensor. The symmetric and antisymmetric parts are the same, but the unsymmetrized tensor appears in many places (e.g., the convective term, $v_j\partial_j v_i$, where the order is fixed by physics).

**Defense:** always remember the convention you're using and write it explicitly at the start of any calculation.

### 12.5 Forgetting that Indices on $\partial$ Count

**Wrong:** writing $\partial v_i / \partial j$ instead of $\partial v_i / \partial x_j = \partial_j v_i$. The shorthand $\partial_j$ has $j$ as a *real* index — it participates in contractions.

### 12.6 Premature Setting of Indices

**Wrong:** writing out specific values like "$A_{12}b_2$" early in a derivation. This collapses your equations to one scalar component and obscures the structure. Keep indices symbolic until the very end.

### 12.7 Confusing Pseudovectors and Vectors

$\varepsilon_{ijk}$ is a *pseudotensor*: under a parity transformation it picks up an extra minus sign. So $\boldsymbol{\omega} = \nabla\times\mathbf{v}$ is a pseudovector. In most soft matter you don't care, but in chiral systems (helical filaments, cholesterics), this distinction matters.

### 12.8 Sign Errors from Antisymmetry

**Common:** writing $\Omega_{ij} = (\partial_i v_j - \partial_j v_i)/2$ vs. the convention with the opposite sign. Either is acceptable; just pick one and *stick to it* throughout a paper.

### 12.9 Misapplied $\varepsilon$–$\delta$ Identity

The identity is $\varepsilon_{ijk}\varepsilon_{ilm} = \delta_{jl}\delta_{km} - \delta_{jm}\delta_{kl}$, with $i$ contracted *as the first index* on both. If your $\varepsilon$'s share a different index, *cyclically permute* to put it in the first slot before applying the identity.

### 12.10 Forgetting Dimension-Dependent Identities

$\delta_{ii} = 3$ in 3D. $\delta_{ii} = 2$ in 2D. $P^T_{ii} = d - 1$ in $d$ dimensions. The trace-of-projector or trace-of-delta is **not** universal. When working on membrane problems (2D), double-check.

---

## 13. Covariant vs. Contravariant: A Light Touch

Soft-matter papers in Cartesian frames almost always use lowercase indices in any position — there is no distinction between "upper" and "lower" indices, because in Cartesian (Euclidean) coordinates, the metric is $\delta_{ij}$ and raising or lowering an index does nothing.

This breaks down on **curved surfaces** (membranes parameterized by $u^\alpha$ with metric $g_{\alpha\beta}$) and in **general relativity** (not relevant here). When you see a membrane paper write
$$
\partial_\alpha h\,\partial^\alpha h = g^{\alpha\beta}\partial_\alpha h\,\partial_\beta h,
$$
the upper-$\alpha$ index is shorthand for "raised by the metric." Specifically:
- $v^\alpha = g^{\alpha\beta}v_\beta$ (raise).
- $v_\alpha = g_{\alpha\beta}v^\beta$ (lower).
- Summation only happens between one upper and one lower index in the strict convention.

For a *flat 2D membrane* in Monge gauge $h(x, y)$ in the small-gradient limit, the metric is $g_{\alpha\beta} = \delta_{\alpha\beta} + \partial_\alpha h\,\partial_\beta h \approx \delta_{\alpha\beta}$, and we recover Cartesian rules.

For *strongly curved* membranes (a full nonlinear Helfrich treatment, or treating budding/fission), the distinction becomes essential. The covariant Laplace–Beltrami operator $\Delta_g = (1/\sqrt{g})\partial_\alpha(\sqrt{g}\,g^{\alpha\beta}\partial_\beta)$ replaces the flat Laplacian. The relevant geometry textbooks for soft matter are Kamien's *Geometry of Soft Materials* and David's *Statistical Mechanics of Membranes and Surfaces*.

> **Pragmatic rule.** If you are working in 3D Cartesian and the problem is translation-invariant, ignore the upper/lower distinction. If you are computing on a curved surface (sphere, GUV, manifold), use proper covariant notation.

---

## 14. Exercises with Worked Solutions

We close with a curated exercise set spanning beginner to research-level. Try each before reading the solution.

---

### 14.1 (Beginner) Identify free and dummy indices

For each expression, state the free indices, the dummy indices, the rank, and whether the expression is legal.

(a) $A_{ij}b_j$ &nbsp;&nbsp; (b) $A_{ii}B_{jj}$ &nbsp;&nbsp; (c) $A_{ij}B_{jk}C_{ki}$ &nbsp;&nbsp; (d) $A_{ij}B_{ij}C_{ij}$ &nbsp;&nbsp; (e) $\varepsilon_{ijk}a_i b_j c_k$

**Solution.**

(a) Free: $i$. Dummy: $j$. Rank 1. Legal.

(b) Free: none. Dummy: $i, j$ (each twice). Rank 0. Legal. This is $(\operatorname{tr}\mathbf{A})(\operatorname{tr}\mathbf{B})$.

(c) Free: none. Dummies: $i, j, k$. Rank 0. Legal. This is $\operatorname{tr}(\mathbf{A}\mathbf{B}\mathbf{C})$.

(d) **Illegal.** Each of $i$ and $j$ appears three times.

(e) Free: none. Dummies: $i, j, k$. Rank 0. Legal. This is the triple product $\mathbf{a}\cdot(\mathbf{b}\times\mathbf{c}) = \det[\mathbf{a}, \mathbf{b}, \mathbf{c}]$.

---

### 14.2 (Beginner) Compute the trace

Compute $\delta_{ij}\delta_{ji}$ in 3D and in $d$ dimensions.

**Solution.** $\delta_{ij}\delta_{ji} = \delta_{ii} = d$. In 3D, this is 3.

---

### 14.3 (Beginner) Symmetric–antisymmetric orthogonality

Let $S_{ij}$ be symmetric and $A_{ij}$ antisymmetric. Show that $S_{ij}A_{ij} = 0$ by writing out all nine terms explicitly in 3D and pairing them.

**Solution.** Diagonal: $S_{11}A_{11}, S_{22}A_{22}, S_{33}A_{33}$. But antisymmetry forces $A_{ii} = -A_{ii} \Rightarrow A_{ii} = 0$ (no sum). So all three diagonal terms vanish individually.

Off-diagonal: pair $(1,2)$ with $(2,1)$. We have $S_{12}A_{12} + S_{21}A_{21} = S_{12}A_{12} + S_{12}(-A_{12}) = 0$. Similarly $(1,3)$ with $(3,1)$ and $(2,3)$ with $(3,2)$. All vanish. Total: 0. ✓

---

### 14.4 (Intermediate) The convective term identity

Show
$$
v_j\partial_j v_i = \partial_i\bigl(\tfrac{1}{2}v_k v_k\bigr) - \varepsilon_{ijk}v_j\omega_k,
$$
where $\omega_k = \varepsilon_{klm}\partial_l v_m$.

**Solution.** Start from the RHS:
$$
\partial_i(\tfrac{1}{2}v_k v_k) = v_k\partial_i v_k.
$$
For the second piece:
$$
\varepsilon_{ijk}v_j\omega_k = \varepsilon_{ijk}v_j\varepsilon_{klm}\partial_l v_m.
$$
Use $\varepsilon_{ijk}\varepsilon_{klm} = \varepsilon_{kij}\varepsilon_{klm} = \delta_{il}\delta_{jm} - \delta_{im}\delta_{jl}$:
$$
\varepsilon_{ijk}v_j\omega_k = (\delta_{il}\delta_{jm} - \delta_{im}\delta_{jl})v_j\partial_l v_m = v_j\partial_i v_j - v_j\partial_j v_i.
$$
Rename $j \to k$ in the first piece: $v_j\partial_i v_j = v_k\partial_i v_k$. So
$$
\varepsilon_{ijk}v_j\omega_k = v_k\partial_i v_k - v_j\partial_j v_i.
$$
The RHS is then
$$
v_k\partial_i v_k - (v_k\partial_i v_k - v_j\partial_j v_i) = v_j\partial_j v_i. \;\;\blacksquare
$$

---

### 14.5 (Intermediate) Vector triple product variant

Prove $(\mathbf{a}\times\mathbf{b})\cdot(\mathbf{c}\times\mathbf{d}) = (\mathbf{a}\cdot\mathbf{c})(\mathbf{b}\cdot\mathbf{d}) - (\mathbf{a}\cdot\mathbf{d})(\mathbf{b}\cdot\mathbf{c})$.

**Solution.**
$$
(\mathbf{a}\times\mathbf{b})\cdot(\mathbf{c}\times\mathbf{d}) = \varepsilon_{ijk}a_j b_k\,\varepsilon_{ilm}c_l d_m = (\delta_{jl}\delta_{km} - \delta_{jm}\delta_{kl})a_j b_k c_l d_m
$$
$$
= a_j b_k c_j d_k - a_j b_k c_k d_j = (\mathbf{a}\cdot\mathbf{c})(\mathbf{b}\cdot\mathbf{d}) - (\mathbf{a}\cdot\mathbf{d})(\mathbf{b}\cdot\mathbf{c}). \;\;\blacksquare
$$

---

### 14.6 (Intermediate) Decompose a velocity gradient

Given the 3D flow $v_1 = 3x_1 + x_2$, $v_2 = -x_1 + 2x_2$, $v_3 = x_3$, compute $L_{ij}$, $D_{ij}$, $\Omega_{ij}$, and the vorticity vector $\boldsymbol{\omega}$. Verify $\partial_i v_i = $ trace of $L$ = trace of $D$.

**Solution.** Compute partial derivatives:
$$
L_{ij} = \partial_j v_i = \begin{pmatrix} 3 & 1 & 0 \\ -1 & 2 & 0 \\ 0 & 0 & 1 \end{pmatrix}.
$$
Symmetric part:
$$
D_{ij} = \tfrac{1}{2}(L + L^\top) = \begin{pmatrix} 3 & 0 & 0 \\ 0 & 2 & 0 \\ 0 & 0 & 1 \end{pmatrix}.
$$
Antisymmetric part:
$$
\Omega_{ij} = \tfrac{1}{2}(L - L^\top) = \begin{pmatrix} 0 & 1 & 0 \\ -1 & 0 & 0 \\ 0 & 0 & 0 \end{pmatrix}.
$$
Vorticity: $\omega_k = \varepsilon_{klm}\partial_l v_m$. Compute $\omega_3 = \varepsilon_{312}\partial_1 v_2 + \varepsilon_{321}\partial_2 v_1 = (1)(-1) + (-1)(1) = -2$. Other components: $\omega_1 = \partial_2 v_3 - \partial_3 v_2 = 0$; $\omega_2 = \partial_3 v_1 - \partial_1 v_3 = 0$. So $\boldsymbol{\omega} = (0, 0, -2)$.

Check: $\partial_i v_i = 3 + 2 + 1 = 6$. $\operatorname{tr}\mathbf{L} = 3 + 2 + 1 = 6$. $\operatorname{tr}\mathbf{D} = 3 + 2 + 1 = 6$. ✓

---

### 14.7 (Intermediate) Hessian and Laplacian relations

Show that for any smooth scalar field $\phi$:

(a) $\partial_i\partial_j\phi$ is symmetric in $i, j$.
(b) $\partial_i\partial_j\phi\,\delta_{ij} = \nabla^2\phi$.
(c) $\varepsilon_{ijk}\partial_i\partial_j\phi = 0$.

**Solution.**

(a) Mixed partials commute: $\partial_i\partial_j\phi = \partial_j\partial_i\phi$.

(b) $\delta_{ij}\partial_i\partial_j\phi = \partial_i\partial_i\phi = \nabla^2\phi$ (substitution).

(c) Symmetric in $ij$ contracted with antisymmetric $\varepsilon_{ijk}$: zero.

---

### 14.8 (Advanced) Verify the Oseen tensor solves Stokes equations

Verify that, with $G_{ij}(\mathbf{r}) = \tfrac{1}{8\pi\eta r}(\delta_{ij} + \hat r_i \hat r_j)$ and an associated pressure $p(\mathbf{r}) = (F_j r_j)/(4\pi r^3)$, the velocity field $v_i = G_{ij}F_j$ satisfies $-\partial_i p + \eta\partial_k\partial_k v_i = -F_i\delta^{(3)}(\mathbf{r})$ and $\partial_i v_i = 0$.

**Solution sketch.** The calculation is long but routine. Define $r = |\mathbf{r}|$, $\hat r_i = r_i/r$. Use:
- $\partial_i r = \hat r_i$.
- $\partial_i \hat r_j = (\delta_{ij} - \hat r_i \hat r_j)/r$.
- $\partial_i(1/r) = -\hat r_i/r^2$.
- $\nabla^2(1/r) = -4\pi\delta^{(3)}(\mathbf{r})$.
- $\nabla^2(\hat r_i \hat r_j/r) = 2\delta_{ij}/r^3 - 6\hat r_i\hat r_j/r^3 - \tfrac{4\pi}{3}\delta_{ij}\delta^{(3)}(\mathbf{r})$. (Distributional sources at origin require care; see Jackson §1.7 or Kim–Karrila §2.)

Once you compute $\eta\nabla^2 G_{ij} - \partial_i\partial_j(r/8\pi)$ (the pressure piece corresponds to $-\partial_i p$ where $p = F_j\partial_j(1/4\pi r)$), the leading delta-function piece gives $-F_i\delta^{(3)}(\mathbf{r})$ as required. The divergence $\partial_i v_i = F_j \partial_i G_{ij}$ vanishes away from the origin by direct calculation (try it).

This exercise is genuinely tedious; doing it once is a rite of passage in soft matter. After that, one cites it and moves on.

---

### 14.9 (Advanced) Symmetry decomposition of $\partial_i\partial_j v_k$

Show that the rank-3 tensor $T_{ijk} = \partial_i\partial_j v_k$ decomposes as
$$
T_{ijk} = T^{(s)}_{ijk} + T^{(a)}_{ijk},
$$
where $T^{(s)}_{ijk}$ is symmetric in $ij$ and $T^{(a)}_{ijk} = 0$ (because $\partial_i\partial_j$ commutes). So $T$ is fully symmetric in $ij$. Use this to show $\nabla\cdot(\nabla\times\mathbf{v}) = 0$.

**Solution.** $T_{ijk} - T_{jik} = (\partial_i\partial_j - \partial_j\partial_i)v_k = 0$. So $T_{ijk} = T_{jik}$ — symmetric in $ij$. Then $\nabla\cdot(\nabla\times\mathbf{v}) = \varepsilon_{ijk}\partial_i\partial_j v_k = \varepsilon_{ijk}T_{kij}$ (rename) — but cyclic permutation gives $\varepsilon_{ijk}T_{kij}=\varepsilon_{kij}T_{kij}$, contraction of antisymmetric $\varepsilon_{kij}$ (in $ij$) with symmetric (in $ij$) $T$ vanishes.

---

### 14.10 (Advanced) Compute the Frobenius norm of the strain rate

Express $D_{ij}D_{ij}$ in terms of $\partial_i v_j$.

**Solution.**
$$
D_{ij} = \tfrac{1}{2}(\partial_i v_j + \partial_j v_i).
$$
$$
D_{ij}D_{ij} = \tfrac{1}{4}(\partial_i v_j + \partial_j v_i)(\partial_i v_j + \partial_j v_i).
$$
Expanding:
$$
= \tfrac{1}{4}\bigl[(\partial_i v_j)(\partial_i v_j) + 2(\partial_i v_j)(\partial_j v_i) + (\partial_j v_i)(\partial_j v_i)\bigr].
$$
The first and third terms are equal (rename dummies in the third: $i\leftrightarrow j$ gives $(\partial_i v_j)(\partial_i v_j)$). So
$$
D_{ij}D_{ij} = \tfrac{1}{2}(\partial_i v_j)(\partial_i v_j) + \tfrac{1}{2}(\partial_i v_j)(\partial_j v_i).
$$
This is the form that appears in the viscous-dissipation rate $\Phi = 2\eta D_{ij}D_{ij}$.

---

### 14.11 (Research-style) Membrane fluctuation amplitude

For a tense incompressible membrane (Helfrich Hamiltonian with $\kappa$ and $\sigma$), compute the mean-square real-space height fluctuation
$$
\langle h^2(\mathbf{r}) \rangle = \int \frac{d^2q}{(2\pi)^2}\langle |\tilde h(\mathbf{q})|^2\rangle.
$$
Express the answer in closed form for an annular wavenumber range $q_{\min} < q < q_{\max}$, with $q_c = \sqrt{\sigma/\kappa}$ the crossover wavenumber.

**Solution.** Using $\langle |\tilde h(\mathbf{q})|^2\rangle = k_BT/(\kappa q^4 + \sigma q^2) = k_BT/[\sigma q^2(1 + q^2/q_c^2)]$:
$$
\langle h^2\rangle = \int_{q_{\min}}^{q_{\max}}\frac{q\,dq}{2\pi}\,\frac{k_BT}{\sigma q^2(1 + q^2/q_c^2)} = \frac{k_BT}{2\pi\sigma}\int_{q_{\min}}^{q_{\max}}\frac{dq}{q(1 + q^2/q_c^2)}.
$$
Substituting $u = q^2/q_c^2$:
$$
= \frac{k_BT}{4\pi\sigma}\int_{u_{\min}}^{u_{\max}}\frac{du}{u(1+u)} = \frac{k_BT}{4\pi\sigma}\ln\Bigl(\frac{u/(1+u)}{u_0/(1+u_0)}\Bigr)\bigg|^{u_{\max}}_{u_{\min}}.
$$
Limits: at high $q$, the integrand goes like $1/q^3$ — convergent. At low $q$, like $1/q$ — divergent unless $q_{\min}$ cut off by frame/vesicle radius. Setting $u_{\min} \ll 1 \ll u_{\max}$:
$$
\langle h^2\rangle \approx \frac{k_BT}{4\pi\sigma}\ln\Bigl(\frac{q_{\max}^2/q_c^2}{q_{\min}^2/q_c^2}\Bigr)\cdot\frac{1}{\text{(complicated)}} \to \frac{k_BT}{2\pi\sigma}\ln(q_c/q_{\min})\;\text{at low $q$, tension-dominated},
$$
and at very high $q$ a $1/(\kappa q_{\max}^2)$-type small contribution. The precise expression with finite limits:
$$
\langle h^2\rangle = \frac{k_BT}{4\pi\sigma}\ln\Bigl(\frac{q_{\max}^2(q_c^2 + q_{\min}^2)}{q_{\min}^2(q_c^2 + q_{\max}^2)}\Bigr).
$$
This is the form you fit when doing flickering spectroscopy: $q_{\max}$ is set by the optical resolution, $q_{\min}$ by the vesicle size $\sim 1/R$.

---

### 14.12 (Research-style) Transverse projector identity

Show that for any vector field $\mathbf{u}(\mathbf{q})$ in Fourier space, $P^T_{ij}\tilde u_j$ is the *incompressible projection* of $\tilde{\mathbf{u}}$, i.e., the unique vector field obtained by subtracting the longitudinal (compressible) part.

**Solution.** Decompose any vector into longitudinal and transverse parts: $\tilde u_i = \tilde u^\parallel_i + \tilde u^\perp_i$ with $\tilde u^\parallel_i = \hat q_i (\hat q_j \tilde u_j)$, where $\hat q_i = q_i/q$. Then
$$
P^T_{ij}\tilde u_j = (\delta_{ij} - \hat q_i\hat q_j)\tilde u_j = \tilde u_i - \hat q_i(\hat q_j\tilde u_j) = \tilde u_i - \tilde u^\parallel_i = \tilde u^\perp_i.
$$
The transverse part automatically satisfies $q_i \tilde u^\perp_i = 0$ (incompressibility).

This is the spectral content of the Helmholtz decomposition: $\mathbf{u} = \nabla\phi + \nabla\times\boldsymbol{\psi}$ in real space corresponds to $\tilde{\mathbf{u}} = \tilde{\mathbf{u}}^\parallel + \tilde{\mathbf{u}}^\perp$ in $\mathbf{q}$-space, with the projector $P^T$ extracting the rotational (transverse) part.

---

### 14.13 (Research-style) Force–velocity coupling of two colloids

Two identical spheres of radius $a$ are separated by $\mathbf{r}$, with $r \gg a$. Force $F_j$ is applied to sphere 1; sphere 2 is force-free and far enough that we treat the flow at its position as the unperturbed background. Use the Oseen tensor to compute the velocity of sphere 2 (Faxén's law to lowest order says $V^{(2)}_i = G_{ij}(\mathbf{r})F_j$). Decompose this into components parallel and perpendicular to $\hat r$ and compare magnitudes.

**Solution.** $G_{ij}(\mathbf{r}) = (1/8\pi\eta r)(\delta_{ij} + \hat r_i \hat r_j)$.

Parallel: $G_{\parallel} = \hat r_i G_{ij}\hat r_j = (1/8\pi\eta r)(\hat r_i\hat r_i + \hat r_i\hat r_i\hat r_j\hat r_j) = (1/8\pi\eta r)(1+1) = 1/(4\pi\eta r)$.

Perpendicular: pick any unit vector $\hat e\perp\hat r$. $G_\perp = \hat e_i G_{ij}\hat e_j = (1/8\pi\eta r)(\hat e_i\hat e_i + 0) = 1/(8\pi\eta r)$.

**Result:** $G_\parallel = 2G_\perp$. **Parallel motion is twice as easy as perpendicular** at long range — a fundamental fact of low-Reynolds hydrodynamics that drives, e.g., the orientation-dependent drag on rod-like swimmers.

---

### 14.14 (Research-style) Nematic-stress divergence

Compute $\partial_j Q_{ij}$ where $Q_{ij} = S(n_i n_j - \tfrac{1}{3}\delta_{ij})$, for spatially varying $S(\mathbf{r})$ and $\mathbf{n}(\mathbf{r})$ with $n_i n_i = 1$ everywhere.

**Solution.**
$$
\partial_j Q_{ij} = \partial_j[S(n_i n_j - \tfrac{1}{3}\delta_{ij})] = (\partial_j S)(n_i n_j - \tfrac{1}{3}\delta_{ij}) + S\,\partial_j(n_i n_j) - \tfrac{1}{3}\delta_{ij}\partial_j S.
$$
First piece: $(\partial_j S)n_i n_j - \tfrac{1}{3}\partial_i S$.

Second piece: $S\,(n_j\partial_j n_i + n_i\partial_j n_j)$.

Third piece: $-\tfrac{1}{3}\partial_i S$.

Combine the first and third: $(\partial_j S)n_i n_j - \tfrac{2}{3}\partial_i S$.

Use the unit-vector constraint to simplify $n_j\partial_j n_i$: differentiate $n_i n_i = 1$ to get $n_i \partial_j n_i = 0$, so $\partial_j n_i \perp \mathbf{n}$. The term $n_j\partial_j n_i$ is the parallel-gradient of the director — related to the **bend** mode in Frank elasticity. The term $n_i\partial_j n_j$ — *splay* — has $n_i$ factored, so it points along $\mathbf{n}$.

Final:
$$
\partial_j Q_{ij} = (\partial_j S)n_i n_j - \tfrac{2}{3}\partial_i S + S(n_j\partial_j n_i + n_i\partial_j n_j).
$$
This is the active-stress divergence (up to the coupling constant $\sigma_0$) that drives flows in extensile and contractile active gels — every term has a physical name (splay-driven flow, bend-driven flow, concentration-gradient flow).

---

### 14.15 (Research-style) Verifying the trace and traceless decomposition of strain rate

Write $D_{ij} = D^{(s)}_{ij} + \tfrac{1}{d}D_{kk}\delta_{ij}$, where $D^{(s)}_{ij}$ is traceless. Show that $D_{ij}D_{ij} = D^{(s)}_{ij}D^{(s)}_{ij} + \tfrac{1}{d}(D_{kk})^2$.

**Solution.**
$$
D_{ij}D_{ij} = (D^{(s)}_{ij} + \tfrac{1}{d}D_{kk}\delta_{ij})(D^{(s)}_{ij} + \tfrac{1}{d}D_{ll}\delta_{ij}).
$$
Expand four terms:
1. $D^{(s)}_{ij}D^{(s)}_{ij}$.
2. $D^{(s)}_{ij}\cdot\tfrac{1}{d}D_{ll}\delta_{ij} = \tfrac{1}{d}D_{ll}D^{(s)}_{ii} = 0$ (traceless).
3. Same as 2: zero.
4. $\tfrac{1}{d^2}D_{kk}D_{ll}\delta_{ij}\delta_{ij} = \tfrac{1}{d^2}D_{kk}D_{ll}\cdot d = \tfrac{1}{d}D_{kk}D_{ll}$. But $k$ and $l$ are independent dummies, so $D_{kk}D_{ll} = (D_{kk})^2$.

Total: $D^{(s)}_{ij}D^{(s)}_{ij} + \tfrac{1}{d}(D_{kk})^2$. ✓

For incompressible flow, $D_{kk} = 0$ and the second piece vanishes — viscous dissipation is purely from traceless shear, as expected.

---

## Closing Remarks

You have now seen, in roughly a hundred densely written pages, the major patterns of index notation as deployed in soft matter physics and hydrodynamics. The mastery you need is not memorization of identities but *fluency in the patterns*: free vs. dummy, rank counting, symmetric–antisymmetric orthogonality, the $\varepsilon$–$\delta$ identity, projector structures in Fourier space.

Three habits will accelerate your fluency:

1. **Re-derive identities yourself.** Don't ever copy a Levi-Civita identity from a table — derive it again. After ten derivations, you will know them in your bones.

2. **Read papers with a pen.** When you see an equation in *Phys. Rev. Lett.* or *Soft Matter*, count free indices on each side. Identify the dummies. Mentally substitute the deltas. Within months, this becomes invisible — you read the equation as a sentence.

3. **Write your own derivations in full.** Skip no algebraic step until you can skip steps and *recover them on demand* if challenged. Premature compression breeds errors; eventual compression is the mark of mastery.

Index notation is not a notational quirk of physics papers — it is the language in which the geometry of continuum mechanics is most clearly expressed. Inhabit it long enough and it becomes invisible; what remains is the physics itself.

---

## Appendix A: Quick-Reference Cheat Sheet

| Object | Index form | Vector form |
|---|---|---|
| Vector | $a_i$ | $\mathbf{a}$ |
| Inner product | $a_i b_i$ | $\mathbf{a}\cdot\mathbf{b}$ |
| Outer product | $a_i b_j$ | $\mathbf{a}\otimes\mathbf{b}$ |
| Matrix product | $A_{ij}B_{jk}$ | $\mathbf{A}\mathbf{B}$ |
| Trace | $A_{ii}$ | $\operatorname{tr}\mathbf{A}$ |
| Transpose | $A_{ji}$ | $\mathbf{A}^\top$ |
| Frobenius | $A_{ij}B_{ij}$ | $\mathbf{A}:\mathbf{B}$ |
| Cross product | $\varepsilon_{ijk}a_j b_k$ | $\mathbf{a}\times\mathbf{b}$ |
| Gradient | $\partial_i\phi$ | $\nabla\phi$ |
| Divergence | $\partial_i v_i$ | $\nabla\cdot\mathbf{v}$ |
| Curl | $\varepsilon_{ijk}\partial_j v_k$ | $\nabla\times\mathbf{v}$ |
| Laplacian | $\partial_i\partial_i\phi$ | $\nabla^2\phi$ |
| Velocity gradient | $\partial_j v_i$ | $\nabla\mathbf{v}$ |
| Strain rate | $\tfrac{1}{2}(\partial_i v_j+\partial_j v_i)$ | $\mathbf{D}$ |
| Vorticity tensor | $\tfrac{1}{2}(\partial_i v_j-\partial_j v_i)$ | $\boldsymbol{\Omega}$ |
| Vorticity vector | $\varepsilon_{ijk}\partial_j v_k$ | $\boldsymbol{\omega}=\nabla\times\mathbf{v}$ |
| Transverse projector | $\delta_{ij}-q_iq_j/q^2$ | $\mathbf{P}^T(\mathbf{q})$ |
| Oseen | $\frac{1}{\eta q^2}P^T_{ij}$ (Fourier) | $\mathbf{G}(\mathbf{q})$ |

## Appendix B: The Three Identities You Must Memorize

$$
\boxed{\delta_{ij}\,a_j = a_i, \qquad \varepsilon_{ijk}\varepsilon_{ilm} = \delta_{jl}\delta_{km} - \delta_{jm}\delta_{kl}, \qquad S_{ij}A_{ij} = 0\;\;(S\text{ sym},\, A\text{ antisym}).}
$$

Everything else is derivable from these.
