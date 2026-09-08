1. **Configuration and analysis parameters**
2. **Image discovery and frame selection**
3. **Interactive initialization**
4. **Fixed image normalization**
5. **Polar sampling geometry**
6. **Radial-gradient membrane detection**
7. **Subpixel localization + inner/outer edges**
8. **Angular outlier rejection and periodic interpolation**
9. **Center/radius adaptive tracking**
10. **Quality-control metrics and improved diagnostic plots**
11. **Storage and metadata**
12. **Final QC summary and save**
13. **Helper functions**

And I would call the new version something explicit like:

```
ContourDetection_GUV_v1.m
```

rather than another `fixed_final_final`.

---

# Section 1 — Configuration

I would start like this.

```
%% ========================================================================
%  GUV CONTOUR DETECTION — RADIAL GRADIENT METHOD
%  ========================================================================
%
%  Purpose
%  -------
%  Extract the equatorial contour r(theta,t) of a GUV from phase-contrast
%  microscopy images with subpixel radial localization.
%
%  Main steps
%  ----------
%  1. Define an initial vesicle center and radial search annulus.
%  2. Sample the image gradient along radial lines for fixed polar angles.
%  3. Detect candidate membrane edges from positive and negative radial
%     gradient peaks.
%  4. Select the most prominent candidate at each angle.
%  5. Refine the radial position using a local parabolic interpolation.
%  6. Reject isolated angular outliers and interpolate periodic gaps.
%  7. Update the vesicle center and radial search zone frame-by-frame.
%  8. Save contour coordinates and detection-quality metrics.
%
%  The extracted r_midline(theta,t) is subsequently used for:
%     - shape descriptors
%     - projected area/circularity
%     - Fourier fluctuation spectroscopy
%
%  ========================================================================

clearvars;
clc;
close all;

%% 1. USER CONFIGURATION

% ---- Frame range ---------------------------------------------------------
startFrame = 10;
endFrame   = [];       % [] = process until final image

% ---- Polar contour sampling ---------------------------------------------
numAngles = 360;       % angular samples around the vesicle
numRadii  = 500;       % radial interpolation points in search annulus

% ---- Image preprocessing ------------------------------------------------
sigmaSmooth_px = 1.0;
%
% Gaussian smoothing applied before calculating the spatial gradient.
% Keep small for flicker spectroscopy so that high-q fluctuations are not
% unnecessarily attenuated.

% ---- Membrane peak detection --------------------------------------------
minPeakDistance_px = 3.5;

promFactor = 0.18;
promMinAbs = 0.5;
%
% Minimum prominence:
%
%   prominence_threshold =
%       max(promMinAbs, promFactor * local_gradient_range)
%
% This allows the threshold to adapt to contrast variations.

% ---- Inner / outer optical edge estimation ------------------------------
searchBack_px    = 15;
searchForward_px = 15;
thresholdFactor  = 0.5;

% ---- Angular outlier rejection ------------------------------------------
outlierSmoothSpan = 15;
outlierK          = 4;
outlierPadN       = 20;

% ---- Final contour smoothing --------------------------------------------
contourSmoothSpan = 1;
%
% 1 means effectively no additional angular smoothing.
% This is intentional for Fourier fluctuation spectroscopy.

% ---- Adaptive tracking --------------------------------------------------
bufferFactor = 3;
minMargin_px = 4;

% ---- Quality-control plotting -------------------------------------------
plotEveryN = 100;

% ---- Output --------------------------------------------------------------
outputFile = 'contourExtraction_GUV_v1.mat';
```

---

# Why I prefer this

The important difference is that every number now has an identifiable role.

For example:

```
sigmaSmooth_px = 1;
```

is explicitly **image smoothing before edge detection**.

Whereas:

```
contourSmoothSpan = 1;
```

is **angular smoothing after contour extraction**.

Those are physically very different operations, and your old names made them easy to confuse.

Also, all values with physical meaning in pixels explicitly end with:

```
_px
```

That becomes valuable later.

---

# Methods text corresponding to this section

We can already start writing something publication-like:

> **Contour representation and preprocessing.**  
> The equatorial contour of each vesicle was represented in polar coordinates as \(r(\theta,t)\), sampled at \(N_\theta=360\) equally spaced angular positions. Prior to edge localization, each phase-contrast image was lightly Gaussian-filtered with a standard deviation of \(1\) pixel to suppress pixel-scale imaging noise while retaining the spatial fluctuations used for subsequent Fourier analysis. Radial intensity-gradient profiles were evaluated on a dense grid of 500 radial positions within an adaptive annular search region surrounding the membrane.

That paragraph corresponds directly to the code.

We should avoid putting things like `promFactor=0.18` in the main paper unless necessary. Those belong more naturally in supplementary methods/code availability.

---

# Section 2 — Image discovery and frame validation

I would then clean this part considerably:

```
%% ========================================================================
%  2. IMAGE DISCOVERY AND FRAME RANGE
%  ========================================================================

files = dir('*.tif');

if isempty(files)
    files = dir('*.tiff');
end

if isempty(files)
    files = dir('*.jpg');
end

% Remove macOS hidden/resource files
files = files(~startsWith({files.name}, '._'));

if isempty(files)
    error('No supported image files found in the current directory.');
end

nFiles = numel(files);

% Resolve final frame
if isempty(endFrame)
    endFrame = nFiles;
end

% Validate requested range
validateattributes(startFrame, {'numeric'}, ...
    {'scalar','integer','>=',1,'<=',nFiles});

validateattributes(endFrame, {'numeric'}, ...
    {'scalar','integer','>=',startFrame,'<=',nFiles});

nFrames = endFrame - startFrame + 1;

fprintf('\n============================================================\n');
fprintf(' GUV CONTOUR EXTRACTION\n');
fprintf('============================================================\n');
fprintf('Images found     : %d\n', nFiles);
fprintf('First frame      : %d\n', startFrame);
fprintf('Last frame       : %d\n', endFrame);
fprintf('Frames processed : %d\n', nFrames);
fprintf('Angles/frame     : %d\n', numAngles);
fprintf('============================================================\n\n');
```

One extra thing I eventually want here is **natural filename sorting**, because:

```
frame1.tif
frame2.tif
frame10.tif
```

must not accidentally become

```
frame1
frame10
frame2
```

If your acquisition already produces zero-padded names, e.g.

```
frame000001.tif
```

then we are safe.

We should verify that once rather than silently assuming it.

---

# Section 3 — Interactive initialization

Here I would keep your current manual setup because it has one major advantage:

> the algorithm does not have to solve the difficult problem of identifying which object in the field is the GUV.

You tell it once where the vesicle is, and the algorithm handles the tracking.

I'd rewrite it like this:

```
%% ========================================================================
%  3. INTERACTIVE INITIALIZATION
%  ========================================================================

I0 = imread(files(startFrame).name);

if ndims(I0) == 3
    I0 = rgb2gray(I0);
end

I0 = double(I0);

%% 3.1 Select rectangular region of interest

fig = figure( ...
    'Name','Step 1 — Select vesicle ROI', ...
    'WindowState','maximized', ...
    'Color','w');

imagesc(I0);
colormap gray;
axis image;

title( ...
    sprintf('Frame %d: select a rectangular ROI around the vesicle', ...
    startFrame));

roi = drawrectangle( ...
    'Color',[1 0 0], ...
    'LineWidth',1.5);

wait(roi);

pos = round(roi.Position);

xmin = max(1, pos(1));
ymin = max(1, pos(2));

xmax = min(size(I0,2), xmin + pos(3));
ymax = min(size(I0,1), ymin + pos(4));

close(fig);

Icrop0 = I0(ymin:ymax, xmin:xmax);

[imgHeight,imgWidth] = size(Icrop0);

%% 3.2 Select inner radial search boundary

fig = figure( ...
    'Name','Step 2 — Inner radial boundary', ...
    'WindowState','maximized', ...
    'Color','w');

imagesc(Icrop0);
colormap gray;
axis image;

title({'Draw a circle INSIDE the membrane', ...
       'This defines the initial inner radial search boundary'});

roiInner = drawcircle( ...
    'Color',[0 0.7 0], ...
    'LineWidth',2);

wait(roiInner);

initialCenter = roiInner.Center;
initialInnerRadius = roiInner.Radius;

close(fig);

%% 3.3 Select outer radial search boundary

fig = figure( ...
    'Name','Step 3 — Outer radial boundary', ...
    'WindowState','maximized', ...
    'Color','w');

imagesc(Icrop0);
colormap gray;
axis image;

title({'Draw a circle OUTSIDE the membrane/phase-contrast halo', ...
       'This defines the initial outer radial search boundary'});

hold on;

viscircles( ...
    initialCenter, ...
    initialInnerRadius, ...
    'Color',[0 0.7 0], ...
    'LineWidth',1);

roiOuter = drawcircle( ...
    'Center',initialCenter, ...
    'Color',[0.7 0 0.7], ...
    'LineWidth',2);

wait(roiOuter);

initialOuterRadius = roiOuter.Radius;

close(fig);

%% 3.4 Sanity checks

if initialOuterRadius <= initialInnerRadius
    error('Outer radius must be greater than inner radius.');
end

searchCenter = initialCenter;
innerRadius  = initialInnerRadius;
outerRadius  = initialOuterRadius;

fprintf('Initial tracking geometry\n');
fprintf('  ROI            : x = %d:%d, y = %d:%d\n', ...
    xmin,xmax,ymin,ymax);
fprintf('  Center         : (%.2f, %.2f) px\n', ...
    searchCenter(1),searchCenter(2));
fprintf('  Inner radius   : %.2f px\n',innerRadius);
fprintf('  Outer radius   : %.2f px\n\n',outerRadius);
```

I actually prefer `drawrectangle` over two `ginput()` clicks.

It's clearer and much harder to make a bad selection accidentally.

---

# Algorithmically, what have we done so far?

At the beginning of the experiment we assume that the GUV can be described around a center

\[ \mathbf c(t) = (x_c(t),y_c(t)). \]

For every direction

\[ \hat{\mathbf e}_r(\theta) = (\cos\theta,\sin\theta), \]

we search along

\[ \mathbf x(r,\theta) = \mathbf c+ r\hat{\mathbf e}_r. \]

The user supplies the initial radial interval

\[ r_{\min}<r<r_{\max}. \]

Everything afterward is automatic.

This is exactly how I would explain the initialization in Methods:

> The vesicle was initialized manually in the first analyzed frame by defining a rectangular region of interest and an annular radial search region enclosing the phase-contrast membrane edge. Subsequent frames were processed automatically using the position and contour obtained from the preceding frame to update the search center and radial interval.

---

# The heart of the Methods will be Section 6

The genuinely interesting algorithmic part is going to be:

\[ \nabla I = (G_x,G_y) \]

followed by the **radial gradient**

\[ \boxed{ G_r(r,\theta) = G_x(r,\theta)\cos\theta + G_y(r,\theta)\sin\theta } \]

and then searching for peaks in both

\[ +G_r \]

and

\[ -G_r. \]

That dual-sign operation is important for phase contrast because it makes the detector robust to local polarity reversals of the membrane/halo profile.

Then we're going to change your current peak selection from “largest peak amplitude among sufficiently prominent peaks” to **actual largest prominence**.

That's one of the two real algorithmic corrections we identified.

---

# Better plotting

I also would redesign the runtime diagnostic completely.

Rather than the current six panels, I want one **publication/debug hybrid QC figure**:

### A — Raw phase-contrast image

- contour;
- center;
- adaptive search annulus.

### B — Local zoom of membrane

Show maybe one selected angular region so we can visually inspect the edge.

### C — \(G_r(\theta,r)\)

Probably the most useful algorithm plot:

\[ \theta \times r \]

with the detected contour superimposed.

### D — \(r(\theta)\)

Show:

- raw detected points;
- rejected points;
- final interpolated contour.

This is much more informative than raw vs “smoothed”.

### E — Detection confidence versus angle

Something like normalized prominence:

\[ P(\theta). \]

Mark fallback detections separately.

### F — Time-dependent QC

Instead of thickness, I would use the panel for:

\[ R(t), \]

and maybe a second axis or markers showing

\[ f_{\rm fallback}(t) \]

or number of rejected angles.

This lets us immediately see whether apparent physical events coincide with detector failure.

For fluctuation spectroscopy, this is far more useful than displaying the optical “membrane thickness”, which is not actually a physical bilayer thickness anyway.

---

## One terminology change I strongly recommend

I would eventually stop calling these:

```
r_inner
r_outer
thickness_total
```

“membrane thickness”.

Phase contrast does **not resolve the 4–5 nm lipid bilayer thickness**.

These are edges of the optical gradient/halo structure.

So if we retain them for QC, I'd call them:

```
r_edge_inner
r_edge_outer
opticalEdgeWidth
```

and explicitly avoid interpreting:

\[ r_{\rm outer}-r_{\rm inner} \]

as membrane thickness.

That matters if this code ever appears in supplementary material.

---

## So yes: let's rewrite it this way

And importantly, I'm **not proposing a fundamentally different detection algorithm**.

We keep the good core:

\[ \boxed{ \text{polar radial sampling} + \text{signed radial gradient} + \text{prominence detection} + \text{subpixel interpolation} + \text{periodic angular QC} + \text{adaptive tracking} } \]

but make it cleaner, auditable, and directly describable in a paper.

The next section I would write is **Section 4–6 together: fixed intensity normalization, polar interpolation, and the actual radial-gradient peak detector**, because that's the scientific core of the algorithm.