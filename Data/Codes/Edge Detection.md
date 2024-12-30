# Better Edge Detection GUI (MATLAB)

This note describes an interactive **MATLAB**-based GUI designed to **detect, refine, and visualize edges** in grayscale images. While originally intended for vesicle or cell boundary detection, the approach is general enough for many **bioimaging** or **microscopy** contexts. Below, you’ll find an overview of its functionality, each parameter’s role, and tips on how to tune settings for different types of images.

---

## 1. Overview

The GUI simultaneously displays:
1. **Original Image (top-left)**  
   Shown in grayscale to confirm you’ve loaded the correct file and to appreciate the raw noise levels.
2. **Processed Binary Edges (top-right)**  
   After applying **Gaussian blur**, **edge detection**, and morphological cleanup (opening, closing, hole filling), the resulting binary image is shown here. Boundaries (if chosen) may be overlaid in green for quick inspection.
3. **Overlay Boundaries (bottom)**  
   Shows the original image again, with:
   - **Raw boundaries** (green), if selected.
   - **Sub-pixel interpolation** of the **largest** boundary (in a user-chosen color), so you can see a *smooth, closed loop* representation of the shape.

---

## 2. Primary Parameters & Their Effects

Below is a summary of key parameters in the GUI, how they work, and guidance on typical ranges or recommended usage.

### 2.1 **Edge Detection Method**
- **Sobel**  
  Classic gradient-based operator; good general default, but can be susceptible to noise if the image is very grainy.
- **Canny**  
  Often more robust to noise than Sobel or Prewitt, since it uses a multi-stage approach with non-maximum suppression and hysteresis. Good for faint edges.
- **Prewitt**, **log**, **Roberts**  
  Additional methods that might be more or less sensitive to fine structures. “log” stands for Laplacian of Gaussian, which can catch blob-like edges but sometimes over- or under-detect small features.

**Recommendation**: If your images have **high noise** or **thin, faint edges**, start with **Canny**. If the edges are strong and you want speed or simplicity, **Sobel** is fine.

### 2.2 **Gaussian Sigma** (Blur)
- Typically denoted as “Gauss σ” or “σ” in the code.
- The larger the sigma, the **more** blurring (noise reduction), but also the **more** risk of losing fine edges.
- For a 512 × 512 or 256 × 256 image, a typical range is **1** to **4**. Very high values (like 10+) can smear out the entire object.

**Recommendation**: Start around **σ = 1–2** if your image has moderate noise. If edges vanish, reduce σ; if you see too much noise, increase σ slightly.

### 2.3 **Structuring Element (SE)**
- Used for morphological operations. Common shapes are:
  - **Disk**: Good for roughly circular shapes. The “size” corresponds to the disk radius.
  - **Diamond**: Tends to preserve corners but can shrink certain edges more aggressively.
  - **Rectangle**: Useful if your noise or artifacts are direction-specific.

**Recommendation**: If your object is circular (like GUVs or cells), a small disk or diamond is typical. Size usually 1–3. A bigger SE can remove or unify small features.

### 2.4 **Morphological Operations**  
(checkboxes in the GUI)
- **Open** (imopen): Erodes, then dilates. Removes small bright spots or small edges.
- **Close** (imclose): Dilates, then erodes. Bridges small dark gaps or holes in edges.
- **FillHoles** (imfill): Fills enclosed areas so boundaries become a single loop. Essential if you want a continuous boundary around objects.

**Recommendation**: For vesicle detection, you often want to **Close + FillHoles** to ensure the boundary is one loop. If you have a lot of small bright junk, consider “Open.” 

### 2.5 **Min Object Size (MinObj)**
- The **bwareaopen** parameter that removes objects below a certain pixel area.
- If you see loads of tiny specks, set this to a moderate value (like 20–100). If you might lose small but real structures, reduce it.

**Recommendation**: For well-defined vesicles of radius ~50–100 px, something like minObj=30 or 50 is typical. If you have smaller objects that are real, use a lower threshold (5–10).

### 2.6 **Raw Boundaries** (checkbox)
- If “on,” the raw boundaries from `bwboundaries` are overlaid in **green**. This is helpful to see how well you’re capturing all objects. 
- If the image is busy with multiple objects, you’ll see multiple green loops. This can be cluttered.

**Recommendation**: If you only care about the main object, you might turn this off once you’re satisfied with the largest boundary overlay.

### 2.7 **Sub-pixel** Interpolation (checkbox)
- When active, the code identifies the **largest** boundary by area, forces it to be a closed loop (last point = first point), and performs a spline interpolation with a specified number of points (e.g., 1000).
- Overlaid in a user-chosen color (like **red** or **blue**) to see a smooth contour.

**Recommendation**: Always beneficial if you want a **clean** loop. The #points (e.g. 1000) can be adjusted based on how fine you want the interpolation.

### 2.8 **Chosen Color** & # Points
- You can pick the color (red, green, blue, etc.) for the sub-pixel boundary.
- #Points sets how many interpolated samples are used around the boundary loop. A higher number yields smoother lines but might be slower for extremely large images.

**Recommendation**: 500–1500 points usually suffice for a neat curve on typical 256–512 px images.

---

## 3. Which Parameters Are Most Critical?

1. **Gaussian Blur (σ)**  
   This often is the biggest factor in preserving vs. losing edges. Too big a sigma can smudge out edges; too small can leave noise unhandled.

2. **Edge Method**  
   If your edges are faint, try **Canny**. If edges are strong and you want speed, **Sobel** might suffice.

3. **Morphological Cleanup**  
   Opening or closing can drastically change the final boundaries. *Close + fill holes* is common for getting a single continuous loop on something roughly circular like a vesicle.

4. **Min Object Size**  
   If you see a ton of extra loops, increasing this filter helps. But if your real object is smaller than the threshold, it’ll be removed, so pick carefully.

---

## 4. Common Image Types & Example Settings

### 4.1 Fluorescent Microscope Images (Cells, Vesicles)
- Usually quite noisy in the background.  
  - **Gaussian sigma** around **1–3**.  
  - **Edge method** often **Canny** for faint boundaries.  
  - **Close + fill** to unify boundaries.  
  - **MinObj** 30–100 if your main cell area is in the hundreds+ of pixels.

### 4.2 Phase-Contrast or Brightfield
- Edges can be strong or variable in intensity.  
  - **Gaussian sigma** ~1–2 if mild noise.  
  - **Sobel** or **Prewitt** can work if edges are quite crisp.  
  - Possibly still use **Close** if you have patchy edges.  

### 4.3 Synthetic or Simulated Data
- If the boundary is already crisp, you can skip large morphological steps or use a smaller sigma (like ~0.5).

---

## 5. Tuning Strategy

1. **Start** with moderate values: e.g. **sigma=2**, **method=Canny**, **Close + Fill** on, **MinObj=30**.  
2. Toggle the checkboxes to see if you need “Open.”  
3. Increase or decrease **MinObj** if you’re seeing extra small loops or losing a real small region.  
4. If edges vanish entirely or appear too thick, adjust **sigma** up/down or pick a different edge method.  
5. Once you see green boundaries in the top-right axis that look correct, check the bottom overlay.  
   - The **largest** boundary in sub-pixel interpolation (red, for instance) should appear as a **closed** loop around your object.

---

## 6. Potential Pitfalls

- **Over-blurring** with large sigma.  
  You might end up with a very faint or nonexistent edge.  
- **Not filling holes** if you want a continuous loop.  
  For some images, leaving holes unfilled is desired, but often for single-objects you want one closed boundary.  
- **Small structuring element** not bridging small gaps.  
  Might see discontinuities in the boundary.  
- **Large structuring element** removing your object entirely.  
  If your object is smaller than the morphological footprint, it might vanish.

---

## Conclusion

This GUI approach lets you:
1. Load your image.  
2. Interactively adjust **Gaussian blur** and **edge detection** settings.  
3. Apply morphological operations with tuneable shape/size.  
4. Optionally fill holes and remove small objects.  
5. View boundaries in real-time (raw vs. sub-pixel).  

As you iterate, you’ll refine a pipeline that best suits your typical images (faint edges vs. strong edges, high noise vs. low noise, etc.). Once satisfied, you can record the final chosen parameters for your downstream analysis or batch processes.

If you have *very large* images or *hundreds of frames*, you might eventually want a **non-GUI** batch script with fixed best parameters. But for discovering the sweet spot, a GUI is invaluable.