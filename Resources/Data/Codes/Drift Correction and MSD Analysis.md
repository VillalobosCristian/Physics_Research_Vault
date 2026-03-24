

 Script to perform drift correction on trajectory data and analyze the mean square displacement (MSD) of tracked particles. The drift correction is based on a velocity correlation method, and the script also computes both individual and ensemble MSD curves.
 
## Overview

The main steps performed by the script are:
1. **Data Loading and Preprocessing:**  
   - Reads trajectory data from a CSV file.
   - Removes non-data rows and converts specific columns to numeric format.
   - Sorts the data by `TRACK_ID` and time (`POSITION_T`).

2. **Trajectory Extraction:**  
   - Separates the data into individual trajectories based on unique `TRACK_ID`s.

3. **Drift Estimation and Correction:**  
   - Estimates drift by computing the average velocity at each time step.
   - Integrates the velocity to obtain drift positions.
   - Corrects individual trajectories by subtracting the estimated drift.

4. **MSD Computation:**  
   - Calculates the mean square displacement (MSD) for each corrected trajectory using the custom function `msd_Gota`.
   - Computes an ensemble MSD by averaging across trajectories.

5. **Visualization:**  
   - Plots raw and drift-corrected trajectories.
   - Visualizes individual MSD curves and the ensemble MSD with a shaded region representing the standard deviation.

## CSV File Format

The script expects a CSV file with the following properties:
- Contains a header row and data rows.
- The first three rows are considered non-data and are removed.
- **Required columns:**
  - `TRACK_ID`
  - `POSITION_X`
  - `POSITION_Y`
  - `POSITION_T`

## Usage

6. **Open MATLAB** and navigate to the repository directory.
7. **Run the script** (e.g., `drift_and_msd_analysis.m`).
8. **Select a CSV file** when prompted via the GUI.
9. The script will generate several figures:
   - Raw trajectories.
   - Drift-corrected trajectories.
   - Individual MSD curves.
   - Ensemble MSD with variability shading.

