\documentclass[11pt,a4paper]{article}
\input{preamble.tex}

\fancyhead[L]{\color{intuitionblue}\textsc{GUV membrane mechanics --- canonical derivations}}
\fancyhead[R]{\color{intuitionblue}\thepage}

\title{\color{darknavy}\textbf{Vesicle Membrane Mechanics}\\[0.3em]
\large\color{intuitionblue}Canonical derivations for flickering spectroscopy, viscosity extraction, and optothermal experiments}
\date{}

\begin{document}
\maketitle
\vspace{-1.5em}

\begin{center}
\begin{tcolorbox}[width=0.92\linewidth, colback=intuitionbg, colframe=intuitionblue, arc=3pt]
\small \textbf{What this is.} The derivations every GUV researcher actually uses: Helfrich Hamiltonian from differential geometry to mode-space, the spherical harmonic expansion with the famous $(\ell-1)(\ell+2)$ factor, equipartition giving the static spectrum, P\'ecr\'eaux's equatorial projection, Milner-Safran relaxation dynamics, ACF-based viscosity extraction, the camera integration time correction, the $\kappa$--$\sigma$ degeneracy, substrate corrections, and the area-difference elasticity (ADE) framework. Worked at the level a postdoc actually needs: every contraction shown, every sign-convention choice explained, every approximation justified. \textcolor{freeidxcol}{\textbf{Free indices in blue}}, \textcolor{dumidxcol}{\textbf{dummy in orange}}.
\end{tcolorbox}
\end{center}

\tableofcontents
\newpage

% =====================================================================
\part{The Helfrich Theory}
% =====================================================================

% =====================================================================
\section{Differential geometry of nearly-spherical surfaces}
% =====================================================================

A GUV is, geometrically, a closed 2D surface embedded in 3D. We parametrise it by its radial distance from the origin in spherical coordinates:
\[
r(\theta,\phi,t) = R_0\bigl[1 + u(\theta,\phi,t)\bigr], \qquad |u|\ll 1,
\]
with $R_0$ the equilibrium radius. The function $u$ is the dimensionless shape deviation; $|u|\ll 1$ is the quasi-spherical assumption that underlies everything in this document.

\subsection{Spherical harmonic basis}

Expand $u$ in spherical harmonics:
\[
u(\theta,\phi,t) = \sum_{\ell=0}^\infty\sum_{m=-\ell}^{\ell} u_{\ell m}(t)\,Y_{\ell m}(\theta,\phi).
\]
Three special modes have geometric interpretations:
\begin{itemize}[leftmargin=1.4em,topsep=2pt]
\item $\ell=0$ (monopole): uniform radial scaling — changes the volume. Fixed by volume conservation.
\item $\ell=1$ (dipole): translation of the centre — no shape change. Fixed by choice of origin.
\item $\ell\geq 2$: genuine shape fluctuations. These are what flickering spectroscopy measures.
\end{itemize}

\textbf{Orthonormality:}
\[
\int Y_{\ell m}^* Y_{\ell' m'}\,\sin\theta\,d\theta\,d\phi = \delta_{\ell\ell'}\delta_{m m'}.
\]

\textbf{Laplace-Beltrami eigenvalue:}
\[
\nabla_\Omega^2 Y_{\ell m} = -\ell(\ell+1)\,Y_{\ell m}, \qquad \nabla_\Omega^2 = \frac{1}{\sin\theta}\dd_\theta(\sin\theta\,\dd_\theta) + \frac{1}{\sin^2\theta}\dd_\phi^2.
\]
This eigenvalue $\ell(\ell+1)$ is the source of the $\ell(\ell+1)$ appearing throughout the flickering spectrum.

\subsection{The area element}

For a radial surface $r(\theta,\phi)$, the area element is
\[
dA = r^2\sin\theta\sqrt{1 + \frac{(\dd_\theta r)^2}{r^2} + \frac{(\dd_\phi r)^2}{r^2\sin^2\theta}}\,d\theta\,d\phi.
\]
Substitute $r = R_0(1+u)$ and expand to second order in $u$:
\begin{align*}
r^2 &\approx R_0^2(1 + 2u + u^2),\\
\frac{(\dd_\theta r)^2}{r^2} &\approx (\dd_\theta u)^2,\\
\frac{(\dd_\phi r)^2}{r^2\sin^2\theta} &\approx \frac{(\dd_\phi u)^2}{\sin^2\theta}.
\end{align*}
Using $\sqrt{1+x}\approx 1 + x/2$:
\[
\boxed{\;dA \approx R_0^2\sin\theta\,d\theta\,d\phi\!\left[1 + 2u + u^2 + \half(\nabla_\Omega u)^2\right],\;}
\]
where $(\nabla_\Omega u)^2 = (\dd_\theta u)^2 + (\dd_\phi u)^2/\sin^2\theta$ is the squared surface gradient.

\subsection{The mean curvature}

For our parametrisation, the mean curvature $H$ to second order in $u$ is
\[
2H \approx \frac{2}{R_0}\!\left[1 - u - \half\nabla_\Omega^2 u + \mathcal{O}(u^2)\right].
\]
The reference value $2H_0 = 2/R_0$ for a sphere of radius $R_0$. The deviation from this baseline:
\[
\delta(2H) = -\frac{1}{R_0}(2u + \nabla_\Omega^2 u).
\]
This is the key combination that appears in the bending energy.

\begin{intuition}[Why the combination $2u + \nabla_\Omega^2 u$?]
The mean curvature contains two competing pieces:
\begin{itemize}[leftmargin=1.4em,topsep=2pt]
\item Radial dilation by factor $1+u$ \emph{reduces} the curvature (a bigger sphere is less curved): contributes $-u/R_0$ to $H$.
\item Tangential deformation $\nabla_\Omega u$ \emph{adds} angular curvature: contributes $-\half\nabla_\Omega^2 u/R_0$ to $H$.
\end{itemize}
The combination $2u + \nabla_\Omega^2 u$ is the total curvature deviation. Using $\nabla_\Omega^2 Y_{\ell m} = -\ell(\ell+1)Y_{\ell m}$, this becomes $[2 - \ell(\ell+1)]u_{\ell m}$ in mode space, which equals $-[\ell(\ell+1)-2]u_{\ell m} = -(\ell-1)(\ell+2)u_{\ell m}$.

\textbf{This is where the famous $(\ell-1)(\ell+2)$ factor comes from.}
\end{intuition}

\subsection{The factor $(\ell-1)(\ell+2)$ explicitly}

\begin{prfbox}[Why $\ell=0,1$ modes don't bend]
The combination $\ell(\ell+1)-2$ vanishes for $\ell=1$ ($1\cdot 2 - 2 = 0$) and equals $-2$ for $\ell=0$ (giving $-2u$, which integrates to zero by volume constraint). Factoring:
\[
\ell(\ell+1)-2 = (\ell-1)(\ell+2).
\]
For $\ell\geq 2$, this factor is non-zero, and the mode genuinely contributes to bending energy. The translation mode ($\ell=1$) is in the kernel of the curvature operator — translating the vesicle doesn't change its curvature, so it costs zero bending energy. The breathing mode ($\ell=0$) costs zero \emph{bending} energy but is constrained by volume conservation.
\end{prfbox}

\newpage
% =====================================================================
\section{The Helfrich Hamiltonian in mode space
% =====================================================================
}

The Helfrich energy of a closed quasi-spherical vesicle is:
\[
\mathcal{H} = \frac{\kappa}{2}\oint(2H - C_0)^2\,dA + \sigma\oint dA + \Delta p\,V.
\]
For a symmetric bilayer $C_0 = 0$. We compute each term in the spherical harmonic basis.

\subsection{The bending term}

Substitute $2H = 2/R_0 + \delta(2H)$ into the bending integral. The constant $2/R_0$ piece gives the bending energy of a perfect sphere of radius $R_0$ (a reference offset; ignore it). The quadratic deviation:
\[
\mathcal{H}_{\rm bend}^{(2)} = \frac{\kappa}{2}\oint\bigl[\delta(2H)\bigr]^2\,dA \approx \frac{\kappa}{2R_0^2}\oint(2u + \nabla_\Omega^2 u)^2\,R_0^2\,d\Omega,
\]
using $dA \approx R_0^2\sin\theta\,d\theta\,d\phi$ to leading order. Insert $u = \sum u_{\ell m}Y_{\ell m}$, use orthonormality and $\nabla_\Omega^2 Y_{\ell m} = -\ell(\ell+1)Y_{\ell m}$:
\[
\boxed{\;\mathcal{H}_{\rm bend}^{(2)} = \frac{\kappa}{2}\sum_{\ell\geq 2}\sum_m\bigl[\ell(\ell+1) - 2\bigr]^2 |u_{\ell m}|^2 = \frac{\kappa}{2}\sum_{\ell,m}\bigl[(\ell-1)(\ell+2)\bigr]^2 |u_{\ell m}|^2.\;}
\]
Note $|u_{\ell m}|^2$ accounts for both real and imaginary parts; alternatively $|u_{\ell m}|^2 = u_{\ell m}u_{\ell -m}(-1)^m$ when using complex $Y_{\ell m}$.

\subsection{The tension term}

From the area expansion, the deviation from the reference sphere area is
\[
\Delta A = \oint(dA - R_0^2 d\Omega) \approx R_0^2\oint\!\left[2u + u^2 + \half(\nabla_\Omega u)^2\right]d\Omega.
\]
The linear $2u$ piece is fixed by volume conservation (see below). The quadratic pieces give:
\[
\Delta A^{(2)} = R_0^2\sum_{\ell, m}|u_{\ell m}|^2\!\left[1 + \half\,\ell(\ell+1)\right] = R_0^2\sum_{\ell,m}\half[\ell(\ell+1)+2]\,|u_{\ell m}|^2.
\]
(Using $\oint(\nabla_\Omega u)^2 d\Omega = \sum\ell(\ell+1)|u_{\ell m}|^2$ via integration by parts and the eigenvalue equation.)

So the tension contribution is:
\[
\mathcal{H}_\sigma^{(2)} = \sigma\Delta A^{(2)} = \frac{\sigma R_0^2}{2}\sum_{\ell,m}\bigl[\ell(\ell+1)+2\bigr]\,|u_{\ell m}|^2.
\]

Wait — this doesn't yet account for volume conservation. Let me do that carefully.

\subsection{Volume conservation and the $\ell=0$ constraint}

The vesicle volume is
\[
V = \frac{1}{3}\oint r^3\sin\theta\,d\theta\,d\phi \approx \frac{R_0^3}{3}\oint(1+u)^3\,d\Omega = \frac{R_0^3}{3}\oint\!\left[1 + 3u + 3u^2 + \mathcal{O}(u^3)\right]d\Omega.
\]
Setting $V = V_0 = (4\pi/3)R_0^3$ (the reference sphere volume) requires:
\[
\oint(3u + 3u^2)\,d\Omega = 0 \quad\Rightarrow\quad u_{00}\sqrt{4\pi} + \sum_{\ell\geq 1,m}|u_{\ell m}|^2 = 0.
\]
Solving for $u_{00}$ (the breathing mode) in terms of the other modes:
\[
u_{00} = -\frac{1}{\sqrt{4\pi}}\sum_{\ell\geq 1,m}|u_{\ell m}|^2.
\]
This is a \emph{second-order} relation: the breathing mode is non-zero at quadratic order in the other modes. The breathing mode gets ``eaten'' by volume conservation.

\subsection{Substituting back into the area}

The crucial step: the linear-in-$u$ piece of $\Delta A$ involves only $u_{00}$:
\[
\oint 2u\,d\Omega = 2\sqrt{4\pi}\,u_{00}.
\]
Substituting the volume constraint:
\[
2\sqrt{4\pi}\,u_{00} = -2\sum_{\ell\geq 1,m}|u_{\ell m}|^2.
\]
This subtracts a term $-2\sigma R_0^2\sum|u_{\ell m}|^2$ from the tension contribution. Combining with the quadratic piece $\sigma R_0^2 \sum\!\half[\ell(\ell+1)+2]|u_{\ell m}|^2$:
\[
\mathcal{H}_\sigma^{\rm total} = \sigma R_0^2\sum_{\ell\geq 2,m}\!\left[\half(\ell(\ell+1)+2) - 1\right]|u_{\ell m}|^2 = \frac{\sigma R_0^2}{2}\sum_{\ell\geq 2,m}\ell(\ell+1)|u_{\ell m}|^2.
\]

\subsection{The total Hamiltonian}

Combining bending and tension contributions for $\ell\geq 2$:
\[
\mathcal{H}^{(2)} = \frac{1}{2}\sum_{\ell\geq 2,m}\!\left[\kappa[(\ell-1)(\ell+2)]^2 + \sigma R_0^2\,\ell(\ell+1)\right]|u_{\ell m}|^2.
\]
Factor out $\kappa$ and define the dimensionless tension $\bar\sigma \equiv \sigma R_0^2/\kappa$:
\[
\boxed{\;\mathcal{H}^{(2)} = \frac{\kappa}{2}\sum_{\ell\geq 2,m} \lambda_\ell\,|u_{\ell m}|^2,\quad \lambda_\ell = (\ell-1)(\ell+2)\bigl[\ell(\ell+1) + \bar\sigma\bigr].\;}
\]

\begin{key}[Milner-Safran spectrum]
The quadratic Helfrich Hamiltonian, after volume conservation, is diagonal in spherical harmonic modes. The mode stiffness is
\[
\lambda_\ell = (\ell-1)(\ell+2)\bigl[\ell(\ell+1) + \bar\sigma\bigr].
\]
This is the Milner-Safran 1987 form. The $(\ell-1)(\ell+2)$ factor reflects volume conservation; the $\bar\sigma$ term is the dimensionless tension.
\end{key}

\subsection{The P\'ecr\'eaux variant}

In P\'ecr\'eaux 2004 the spectrum is presented in a slightly different form, with mode stiffness
\[
\lambda_\ell^{\rm Pec} = \ell^2(\ell+1)^2 - (2-\bar\sigma)\ell(\ell+1) = L^2 - (2-\bar\sigma)L, \quad L\equiv\ell(\ell+1).
\]
Compare to Milner-Safran (expanded):
\[
\lambda_\ell^{\rm MS} = (L-2)(L+\bar\sigma) = L^2 + \bar\sigma L - 2L - 2\bar\sigma.
\]
Difference: $\lambda^{\rm Pec} - \lambda^{\rm MS} = 2\bar\sigma$, \emph{independent of $\ell$}.

\begin{confusion}[The $2\bar\sigma$ difference and why it matters]
At $\ell=1$ (rigid-body translation), $\lambda^{\rm Pec} = 2\bar\sigma$ (non-zero except at zero tension) while $\lambda^{\rm MS} = 0$ identically. The Milner-Safran form \emph{explicitly} removes the translation mode by construction; the P\'ecr\'eaux form handles it implicitly via the lower cutoff $q\geq q_{\min}$ in the fit (typically $q_{\min} = 6$), so the $\ell=1$ mode never enters anyway.

\textbf{Physical origin:} Milner-Safran works in the \textbf{constant-volume ensemble} where $u_{00}$ is eliminated exactly. P\'ecr\'eaux works in a \textbf{constant-pressure ensemble} where $\delta(\Delta p) = 0$ and the Laplace condition $\Delta p_0 = 2\sigma/R$ is substituted. The two ensembles differ by a $-2\bar\sigma$ subtraction in $\lambda$.

\textbf{Practical impact:} At low tension ($\bar\sigma\sim 1$), the two forms give essentially identical fits. At high tension ($\bar\sigma \sim 150$, e.g. post-heating in your data), the difference is $\sim 300$ on a baseline of $\sim 600$-$900$ for $\ell=2$, a $\sim 30\%$ effect. \emph{Use one form consistently and cite accordingly.}
\end{confusion}

\subsection{Equipartition gives the static spectrum}

The Hamiltonian is quadratic, modes decouple, so equipartition assigns $k_BT/2$ to each independent quadratic degree of freedom:
\[
\half\,\kappa\,\lambda_\ell\,\langle|u_{\ell m}|^2\rangle = \half\,k_B T \quad\Rightarrow\quad \boxed{\;\langle|u_{\ell m}|^2\rangle = \frac{k_BT}{\kappa\,\lambda_\ell}.\;}
\]

The 3D mode spectrum: a single number per $(\ell,m)$ pair, independent of $m$ by isotropy, with the rapidly-decaying scaling
\[
\langle|u_{\ell m}|^2\rangle \;\sim\; \frac{k_BT}{\kappa\,\ell^4} \quad\text{(bending-dominated, } \bar\sigma\ll \ell^2\text{)},
\]
\[
\langle|u_{\ell m}|^2\rangle \;\sim\; \frac{k_BT}{\sigma R_0^2\,\ell^2} \quad\text{(tension-dominated, } \bar\sigma\gg \ell^2\text{)}.
\]

\begin{intuition}[The crossover mode]
The crossover between bending-dominated and tension-dominated regimes happens at $\bar\sigma\sim \ell(\ell+1)$, i.e.
\[
\ell_c \approx \sqrt{\bar\sigma}\sim R_0\sqrt{\sigma/\kappa}.
\]
For DOPC at $\kappa = 20 k_BT$, $\sigma = 10^{-7}$ N/m, $R_0 = 10\,\mu$m: $\bar\sigma\sim 50$, so $\ell_c\sim 7$. The first 6 modes are bending-dominated; modes $\ell\sim 10$ and higher are tension-dominated. Modes near $\ell_c$ carry mixed information --- this is where the $\kappa$-$\sigma$ joint fit gets its leverage.
\end{intuition}

BIGEOF
echo "Part I (Helfrich theory) written"