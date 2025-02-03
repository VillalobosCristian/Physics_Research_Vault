# Vesicle Edge Detection and Tracking Code Documentation

## Overview
This MATLAB code is designed for detecting and tracking lipid vesicles in microscopy image sequences. It features adaptive parameter adjustment to handle varying lighting conditions and includes manual initialization for vesicle size reference.

## Key Features
- Manual vesicle size selection for reference
- Adaptive parameter adjustment for varying light conditions
- Sub-pixel boundary interpolation
- Robust [[Edge Detection]] with multiple attempts
- Real-time visualization of tracking

## Code Structure

### 1. Initialization and Reference Selection
```matlab
% Load image files
files = dir('*.tif');
if isempty(files)
    error('No TIF images found in the current directory.');
end

% Manual vesicle selection
image = files(1).name;
originalImg = imread(image);
roiSmall = drawcircle('Color', 'b', 'FaceAlpha', 0.1);
```
This section allows the user to manually select a vesicle in the first frame, which serves as a reference for size and properties.

### 2. Reference Properties Extraction
The code extracts several properties from the selected vesicle:
- Area (`referenceArea`)
- Intensity (`referenceIntensity`)
- Background intensity (`referenceBg`)
- Edge contrast (`referenceContrast`)
- Edge strength (`initialEdgeStrength`)

These properties are used for adaptive parameter adjustment during tracking.

### 3. Parameters
```matlab
methodStr   = 'Canny';    % Edge detection method
sigmaVal    = 5;          % Gaussian blur sigma
seSize      = 2;          % Structuring element size
minObjVal   = 1000;       % Minimum object size
areaTolerance = 0.3;      % Size deviation tolerance
maxAttempts = 3;          % Maximum adaptation attempts
```

#### Key Parameters Explained
- `methodStr`: [[Edge Detection]] algorithm
  - Options: 'Canny', 'Sobel', 'Prewitt', 'log', 'Roberts'
  - 'Canny' is generally most robust
- `sigmaVal`: Controls smoothing
  - Higher values (5-10) for noisy images
  - Lower values (1-3) for clearer edges
- `areaTolerance`: Allowed size variation
  - 0.3 means ±30% from reference size
  - Increases automatically if needed

### 4. Adaptive Processing Loop
The main processing loop includes several steps for each frame:

1. **Image Normalization**
```matlab
imgNorm = double(originalImg);
imgNorm = (imgNorm - min(imgNorm(:))) / (max(imgNorm(:)) - min(imgNorm(:)));
```
Normalizes intensity to handle lighting variations.

2. **Multiple Detection Attempts**
```matlab
while ~foundVesicle && attempt <= maxAttempts
    % Adjust parameters based on contrast
    if attempt > 1
        currentContrast = mean(imgNorm(circleMask)) - mean(imgNorm(imdilate(circleMask,strel('disk',5)) & ~circleMask));
        contrastRatio = currentContrast / referenceContrast;
        
        if contrastRatio < 0.5
            currentSigma = max(1, currentSigma - 1);
        else
            currentSigma = min(10, currentSigma + 1);
        end
    end
    % ... [Edge detection and validation]
end
```
Makes multiple attempts with adjusted parameters if vesicle isn't found.

### 5. Edge Detection and Morphological Operations
1. Gaussian blur for noise reduction
2. [[Edge Detection]] using specified method
3. Morphological operations:
   - Opening (optional)
   - Closing
   - Hole filling
4. Small object removal

### 6. Vesicle Selection
The code selects the appropriate vesicle based on:
1. Size comparison with reference
2. Area within tolerance
3. Progressive tolerance increase if needed

### 7. Visualization
Three panel display showing:
1. Original image
2. [[Edge Detection]] result
3. Original with overlay of detected boundary

## Usage Tips

### Optimal Parameter Selection
1. **For Clear Images**
   - Lower `sigmaVal` (2-3)
   - Lower `areaTolerance` (0.2-0.3)
   - Fewer `maxAttempts` (2)

2. **For Noisy Images**
   - Higher `sigmaVal` (5-7)
   - Higher `areaTolerance` (0.3-0.4)
   - More `maxAttempts` (3-4)

3. **For Varying Light Conditions**
   - Keep default adaptive settings
   - Increase `maxAttempts` if needed

### Troubleshooting
1. **If vesicle is missed:**
   - Increase `areaTolerance`
   - Decrease `minObjVal`
   - Try different [[Edge Detection]] method

2. **If wrong object is detected:**
   - Decrease `areaTolerance`
   - Increase `minObjVal`
   - Adjust `sigmaVal`

3. **For brightness changes:**
   - Let adaptive system work
   - Increase `maxAttempts` if needed

## Modification Guidelines

### Adding New Features
1. **To add position tracking:**
   ```matlab
   % After boundary detection
   centerX = mean(boundaries{1}(:,2));
   centerY = mean(boundaries{1}(:,1));
   ```

2. **To add area measurements:**
   ```matlab
   % After boundary detection
   vesicleArea = bwarea(BW);
   ```

### Parameter Customization
You can modify the adaptive behavior by adjusting:
1. Contrast ratio thresholds
2. Tolerance increase rate
3. Sigma adjustment steps

## Notes
- The code assumes grayscale or RGB input images
- Processes all .tif files in the directory
- Saves no data by default - add saving if needed
- Uses sub-pixel interpolation for smooth boundaries

## Related Topics
- Image preprocessing techniques
- [[Edge Detection]] algorithms
- Morphological operations
- Object tracking methods

## Future Improvements
1. Add data export functionality
2. Implement trajectory analysis
3. Add GUI for parameter adjustment
4. Include automatic parameter optimization

