clearvars; clc; close all;
%% ═══════════════════════════════════════════════════════════════
%% VESICLE SHAPE ANALYSIS PIPELINE v2
%% ═══════════════════════════════════════════════════════════════
% Complete analysis of GUV shape dynamics under optothermal heating.
%
% Corrections applied (from literature review):
%   1. Area centroid instead of geometric mean (Pecreaux 2004)
%   2. Fourier mode indexing: physical modes n=2..N (n=0 volume, n=1 translation)
%   3. Integration time correction for camera exposure (Pecreaux 2004)
%   4. Optical projection correction factor (Rautu 2017)
%   5. White noise floor estimation and subtraction (Genova 2013)
%   6. Bending rigidity + tension fitting from Helfrich spectrum (Faizi 2020)
%   7. Reduced volume with asymmetry flagging for non-axisymmetric frames
%   8. Unified smoothing timescale based on physical reasoning
%   9. Adaptive heating detection via Gaussian mixture model
%  10. Proper time axis in seconds throughout
%
% References:
%   Pecreaux et al., Eur Phys J E (2004) — contour analysis
%   Faizi et al., Soft Matter (2020)      — DOPC kappa benchmark
%   Rautu et al., Soft Matter (2017)      — optical projection
%   Genova et al., Phys Rev E (2013)      — white noise subtraction
%   Meleard et al., Eur Phys J E (2011)   — statistical methods
%   Wennerstrom et al., Phys Rev E (2022) — osmotic timescales

%% ═══════════════════════════════════════════════════════════════
%% PARAMETERS (all tunables collected here)
%% ═══════════════════════════════════════════════════════════════

% --- Experimental parameters ---
fps                 = 30;             % Acquisition frame rate [Hz]
exposure_time_ms    = 33;             % Camera exposure time [ms]
pixels_per_micron   = 11.5;           % Calibration [px/um]
T_kelvin            = 298;            % Room temperature [K]
kB                  = 1.381e-23;      % Boltzmann constant [J/K]
kBT                 = kB * T_kelvin;  % Thermal energy [J]
eta_water           = 1e-3;           % Water viscosity [Pa.s]

% --- Derived ---
pixel_size_um       = 1 / pixels_per_micron;
tau_exposure        = exposure_time_ms * 1e-3;  % Exposure time [s]
dt                  = 1 / fps;                  % Frame interval [s]

% --- Smoothing (physically motivated) ---
% Use ~1 s window: shorter than the 2.7 s permeability spike
smooth_window_frames = round(1.0 * fps);  % 1 second = 30 frames at 30 fps
% For drift magnitude: use slightly longer to capture linear trends
drift_smooth_frames  = round(1.5 * fps);  % 1.5 seconds

% --- Heating detection ---
heating_min_duration_s   = 3.0;       % Minimum heating event [s]
heating_min_drift_px     = 10;        % Minimum total drift [px]
heating_merge_gap_s      = 10.0;      % Merge events closer than this [s]
heating_baseline_frames  = 100;       % Frames for baseline estimation

% --- Shape change detection ---
roughness_sigma_threshold = 3.0;      % n-sigma above baseline (3σ avoids false positives)
roughness_baseline_frames = 200;      % Frames for baseline estimation
shape_min_duration_s      = 3.0;      % Minimum event duration [s]
shape_merge_gap_s         = 1.0;      % Merge gap [s]
shape_require_heating     = true;     % Only flag events near/after heating onset

% --- Fourier analysis ---
nFourierModes       = 30;             % Max Fourier mode
fit_mode_min        = 4;              % Lowest mode for kappa fitting
fit_mode_max        = 20;             % Highest mode for kappa fitting
optical_projection_factor = 1.4;      % Rautu 2017 correction

% --- Reduced volume ---
asymmetry_warning_threshold = 0.05;   % Flag frames with asymmetry > 5%

%% ═══════════════════════════════════════════════════════════════
%% LOAD DATA
%% ═══════════════════════════════════════════════════════════════

fprintf('=== Loading Data ===\n');
S = load('contourExtraction_hybrid_fixed.mat', 'allContours', 'angles');
allContours = S.allContours;
angles      = S.angles;
numFrames   = length(allContours);
nAngles     = length(angles);

% Time vector
time_s = (0:numFrames-1)' * dt;

fprintf('Loaded %d frames (%.1f s at %d fps)\n', numFrames, time_s(end), fps);
fprintf('Angular resolution: %d points (%.1f deg)\n', nAngles, 360/nAngles);

%% ═══════════════════════════════════════════════════════════════
%% 1. BASIC METRICS — CIRCULARITY
%% ═══════════════════════════════════════════════════════════════

fprintf('\n=== Computing Basic Metrics ===\n');

circularity = zeros(numFrames, 1);
proj_area   = zeros(numFrames, 1);
perimeter   = zeros(numFrames, 1);

for iFrame = 1:numFrames
    x = [allContours(iFrame).x_midline; allContours(iFrame).x_midline(1)];
    y = [allContours(iFrame).y_midline; allContours(iFrame).y_midline(1)];
    proj_area(iFrame) = polyarea(x, y);
    dx = diff(x);
    dy = diff(y);
    perimeter(iFrame) = sum(sqrt(dx.^2 + dy.^2));
    % Circularity: C = 4*pi*A / P^2  (=1 for perfect circle)
    circularity(iFrame) = 4 * pi * proj_area(iFrame) / (perimeter(iFrame)^2);
end

%% ═══════════════════════════════════════════════════════════════
%% 2. BASIC METRICS — DRIFT (proper area centroid)
%% ═══════════════════════════════════════════════════════════════

xCM = zeros(numFrames, 1);
yCM = zeros(numFrames, 1);

for iFrame = 1:numFrames
    x = allContours(iFrame).x_midline;
    y = allContours(iFrame).y_midline;
    n_pts = length(x);

    % Close the polygon
    x_closed = [x; x(1)];
    y_closed = [y; y(1)];

    % Signed area (shoelace formula)
    cross_terms = x_closed(1:n_pts) .* y_closed(2:n_pts+1) ...
                - x_closed(2:n_pts+1) .* y_closed(1:n_pts);
    A_signed = 0.5 * sum(cross_terms);

    % Area centroid (not geometric mean of vertices)
    % Reference: any computational geometry text; avoids bias from
    % non-uniform point density in hybrid radial search
    xCM(iFrame) = sum((x_closed(1:n_pts) + x_closed(2:n_pts+1)) .* cross_terms) / (6 * A_signed);
    yCM(iFrame) = sum((y_closed(1:n_pts) + y_closed(2:n_pts+1)) .* cross_terms) / (6 * A_signed);
end

% Drift from first frame
drift_x         = xCM - xCM(1);
drift_y         = yCM - yCM(1);
drift_magnitude = sqrt(drift_x.^2 + drift_y.^2);

%% ═══════════════════════════════════════════════════════════════
%% 3. BASIC METRICS — RADIUS
%% ═══════════════════════════════════════════════════════════════

radius_inner_mean   = zeros(numFrames, 1);
radius_midline_mean = zeros(numFrames, 1);
radius_outer_mean   = zeros(numFrames, 1);

for iFrame = 1:numFrames
    radius_inner_mean(iFrame)   = mean(allContours(iFrame).r_inner_smooth);
    radius_midline_mean(iFrame) = mean(allContours(iFrame).r_midline_smooth);
    radius_outer_mean(iFrame)   = mean(allContours(iFrame).r_outer_smooth);
end

delta_radius_inner   = radius_inner_mean   - radius_inner_mean(1);
delta_radius_midline = radius_midline_mean - radius_midline_mean(1);
delta_radius_outer   = radius_outer_mean   - radius_outer_mean(1);

% Mean radius in microns (for Helfrich fitting)
R_mean_um = mean(radius_midline_mean) * pixel_size_um;
fprintf('Mean vesicle radius: %.2f um (%.1f px)\n', R_mean_um, mean(radius_midline_mean));

%% ═══════════════════════════════════════════════════════════════
%% 4. BASIC METRICS VISUALIZATION
%% ═══════════════════════════════════════════════════════════════

hFig = figure('Name', 'Shape Metrics Time Series', ...
    'Units', 'normalized', 'Position', [0.1 0.05 0.8 0.9], 'Color', 'white');

subplot(2, 3, 1);
plot(time_s, circularity, 'b-', 'LineWidth', 1.5); hold on;
yline(mean(circularity), 'r--', 'LineWidth', 1.5);
xlabel('Time (s)', 'Interpreter', 'latex', 'FontSize', 20);
ylabel('Circularity', 'Interpreter', 'latex', 'FontSize', 20);
grid on;
set(gca, 'FontSize', 20, 'TickLabelInterpreter', 'latex');
ylim([min(circularity)*0.995, max(circularity)*1.005]);
legend({'Circularity', sprintf('Mean = %.4f', mean(circularity))}, ...
    'Location', 'best', 'Interpreter', 'latex', 'FontSize', 16);

subplot(2, 3, 2);
plot(time_s, drift_magnitude, 'k-', 'LineWidth', 1.5);
xlabel('Time (s)', 'Interpreter', 'latex', 'FontSize', 20);
ylabel('Drift Magnitude (px)', 'Interpreter', 'latex', 'FontSize', 20);
grid on;
set(gca, 'FontSize', 20, 'TickLabelInterpreter', 'latex');
legend({sprintf('Drift (total = %.2f px)', drift_magnitude(end))}, ...
    'Location', 'best', 'Interpreter', 'latex', 'FontSize', 16);

subplot(2, 3, 3);
plot(time_s, drift_x, 'r-', 'LineWidth', 1.5, 'DisplayName', '$\Delta x$'); hold on;
plot(time_s, drift_y, 'b-', 'LineWidth', 1.5, 'DisplayName', '$\Delta y$');
xlabel('Time (s)', 'Interpreter', 'latex', 'FontSize', 20);
ylabel('Drift (px)', 'Interpreter', 'latex', 'FontSize', 20);
grid on;
set(gca, 'FontSize', 20, 'TickLabelInterpreter', 'latex');
legend('Interpreter', 'latex', 'Location', 'best', 'FontSize', 16);
yline(0, 'k--', 'LineWidth', 0.5);

subplot(2, 3, 4);
plot(time_s, radius_inner_mean, 'g-', 'LineWidth', 1.5, 'DisplayName', 'Inner'); hold on;
plot(time_s, radius_midline_mean, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Midline');
plot(time_s, radius_outer_mean, 'm-', 'LineWidth', 1.5, 'DisplayName', 'Outer');
xlabel('Time (s)', 'Interpreter', 'latex', 'FontSize', 20);
ylabel('Mean Radius (px)', 'Interpreter', 'latex', 'FontSize', 20);
grid on;
set(gca, 'FontSize', 20, 'TickLabelInterpreter', 'latex');
legend('Interpreter', 'latex', 'Location', 'best', 'FontSize', 16);

subplot(2, 3, 5);
plot(time_s, delta_radius_inner, 'g-', 'LineWidth', 1.5, ...
    'DisplayName', '$\Delta R_{\mathrm{inner}}$'); hold on;
plot(time_s, delta_radius_midline, 'r-', 'LineWidth', 1.5, ...
    'DisplayName', '$\Delta R_{\mathrm{midline}}$');
plot(time_s, delta_radius_outer, 'm-', 'LineWidth', 1.5, ...
    'DisplayName', '$\Delta R_{\mathrm{outer}}$');
xlabel('Time (s)', 'Interpreter', 'latex', 'FontSize', 20);
ylabel('$\Delta R$ from initial (px)', 'Interpreter', 'latex', 'FontSize', 20);
grid on;
set(gca, 'FontSize', 20, 'TickLabelInterpreter', 'latex');
legend('Interpreter', 'latex', 'Location', 'best', 'FontSize', 16);
yline(0, 'k--', 'LineWidth', 0.5);

subplot(2, 3, 6);
yyaxis left
plot(time_s, circularity, 'b-', 'LineWidth', 1);
ylabel('Circularity', 'Color', 'b', 'Interpreter', 'latex', 'FontSize', 20);
yyaxis right
plot(time_s, radius_midline_mean, 'r-', 'LineWidth', 1);
ylabel('Radius (px)', 'Color', 'r', 'Interpreter', 'latex', 'FontSize', 20);
xlabel('Time (s)', 'Interpreter', 'latex', 'FontSize', 20);
set(gca, 'FontSize', 20, 'TickLabelInterpreter', 'latex');
grid on;

%% ═══════════════════════════════════════════════════════════════
%% 5. SMOOTHING (unified timescale)
%% ═══════════════════════════════════════════════════════════════

circularity_smooth = smoothdata(circularity, 'gaussian', smooth_window_frames);
radius_smooth      = smoothdata(radius_midline_mean, 'gaussian', smooth_window_frames);
drift_smooth       = smoothdata(drift_magnitude, 'gaussian', drift_smooth_frames);

% Drift rate: gradient in px/s (not px/frame)
drift_rate    = gradient(drift_smooth, dt);
drift_rate_sm = smoothdata(drift_rate, 'gaussian', smooth_window_frames);

dCirc_dt = gradient(circularity_smooth, dt);
dRad_dt  = gradient(radius_smooth, dt);

%% Smoothed Signals Visualization
figure('Name', 'Smoothed Signals and Drift Rate', ...
    'Position', [100 100 1800 900], 'Color', 'white');

subplot(3,2,1);
plot(time_s, circularity, 'Color', [0.7 0.7 0.7], 'LineWidth', 0.5); hold on;
plot(time_s, circularity_smooth, 'b-', 'LineWidth', 2.5);
xlabel('Time (s)', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('Circularity', 'Interpreter', 'latex', 'FontSize', 16);
legend({'Raw', 'Smoothed'}, 'Interpreter', 'latex', 'FontSize', 14);
grid on; set(gca, 'FontSize', 14, 'TickLabelInterpreter', 'latex');

subplot(3,2,2);
plot(time_s, radius_midline_mean, 'Color', [0.7 0.7 0.7], 'LineWidth', 0.5); hold on;
plot(time_s, radius_smooth, 'r-', 'LineWidth', 2.5);
xlabel('Time (s)', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('Radius (px)', 'Interpreter', 'latex', 'FontSize', 16);
legend({'Raw', 'Smoothed'}, 'Interpreter', 'latex', 'FontSize', 14);
grid on; set(gca, 'FontSize', 14, 'TickLabelInterpreter', 'latex');

subplot(3,2,3);
plot(time_s, drift_magnitude, 'k-', 'LineWidth', 1); hold on;
plot(time_s, drift_smooth, 'Color', [0.8 0.2 0.2], 'LineWidth', 3);
xlabel('Time (s)', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('Drift (px)', 'Interpreter', 'latex', 'FontSize', 16);
legend({'Raw', 'Smoothed'}, 'Interpreter', 'latex', 'FontSize', 14, 'Location', 'northwest');
grid on; set(gca, 'FontSize', 14, 'TickLabelInterpreter', 'latex');

subplot(3,2,4);
plot(time_s, drift_rate_sm, 'k-', 'LineWidth', 2); hold on;
yline(0, 'r--', 'LineWidth', 1.5);
xlabel('Time (s)', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('Drift Rate (px/s)', 'Interpreter', 'latex', 'FontSize', 16);
grid on; set(gca, 'FontSize', 14, 'TickLabelInterpreter', 'latex');
[drift_peaks, drift_peak_locs] = findpeaks(drift_rate_sm, ...
    'MinPeakHeight', 0.1*fps, 'MinPeakDistance', round(5*fps));
plot(time_s(drift_peak_locs), drift_peaks, 'r^', 'MarkerSize', 12, ...
    'LineWidth', 2, 'MarkerFaceColor', 'r');
if ~isempty(drift_peak_locs)
    legend({'Drift rate', 'Zero', sprintf('%d peaks found', length(drift_peak_locs))}, ...
        'Interpreter', 'latex', 'FontSize', 14);
    fprintf('Found %d major drift rate peaks\n', length(drift_peak_locs));
    for i = 1:length(drift_peak_locs)
        fprintf('  Peak %d: t = %.1f s, rate = %.2f px/s\n', ...
            i, time_s(drift_peak_locs(i)), drift_peaks(i));
    end
end

subplot(3,2,5);
plot(time_s, dCirc_dt, 'b-', 'LineWidth', 1.5);
yline(0, 'k--', 'LineWidth', 1);
xlabel('Time (s)', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('$\mathrm{d}C/\mathrm{d}t$ (s$^{-1}$)', 'Interpreter', 'latex', 'FontSize', 16);
grid on; set(gca, 'FontSize', 14, 'TickLabelInterpreter', 'latex');

subplot(3,2,6);
plot(time_s, dRad_dt, 'r-', 'LineWidth', 1.5);
yline(0, 'k--', 'LineWidth', 1);
xlabel('Time (s)', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('$\mathrm{d}R/\mathrm{d}t$ (px/s)', 'Interpreter', 'latex', 'FontSize', 16);
grid on; set(gca, 'FontSize', 14, 'TickLabelInterpreter', 'latex');

%% ═══════════════════════════════════════════════════════════════
%% 6. HEATING DETECTION (adaptive threshold via GMM or fallback)
%% ═══════════════════════════════════════════════════════════════

fprintf('\n=== Heating Detection ===\n');

% Convert duration/gap parameters to frames
heating_min_duration = round(heating_min_duration_s * fps);
heating_merge_gap    = round(heating_merge_gap_s * fps);

% Drift rate for detection (in px/s)
dr_detect = drift_rate_sm;

% --- Adaptive threshold via Gaussian Mixture Model ---
% The drift rate distribution is bimodal: low (no heating) and high (heating)
try
    gmm = fitgmdist(dr_detect(:), 2, 'RegularizationValue', 0.01, ...
        'Options', statset('MaxIter', 500));
    [mu_sorted, sort_idx] = sort(gmm.mu);
    % Threshold at midpoint between the two Gaussian means
    threshold_heating = mean(mu_sorted);
    % Ensure threshold is positive and sensible
    if threshold_heating <= 0
        error('GMM threshold non-positive, falling back');
    end
    fprintf('GMM detection: mu1 = %.3f, mu2 = %.3f px/s\n', mu_sorted(1), mu_sorted(2));
    fprintf('GMM threshold: %.3f px/s\n', threshold_heating);
    detection_method = 'GMM';
catch
    % Fallback: sigma-based threshold from baseline
    baseline_dr   = dr_detect(1:min(heating_baseline_frames, numFrames));
    mu_baseline   = median(baseline_dr);
    std_baseline  = std(baseline_dr);
    threshold_heating = max(mu_baseline + 3 * std_baseline, 0.5);
    fprintf('Fallback detection: baseline = %.3f +/- %.3f px/s\n', mu_baseline, std_baseline);
    fprintf('Threshold: %.3f px/s (3-sigma)\n', threshold_heating);
    detection_method = 'sigma';
end

% Apply threshold
active_heating = dr_detect > threshold_heating;
active_heating_smooth = smoothdata(double(active_heating), 'gaussian', ...
    round(0.5 * fps)) > 0.5;

% Extract events
heat_starts = find(diff([0; active_heating_smooth]) == 1);
heat_ends   = find(diff([active_heating_smooth; 0]) == -1);

% Filter by duration and drift magnitude
if ~isempty(heat_starts) && ~isempty(heat_ends)
    durations = heat_ends - heat_starts + 1;
    total_drift_per_event = abs(drift_magnitude(heat_ends) - drift_magnitude(heat_starts));
    mask_valid = (durations >= heating_min_duration) & ...
                 (total_drift_per_event >= heating_min_drift_px);
    valid_zones = [heat_starts(mask_valid), heat_ends(mask_valid)];
else
    valid_zones = zeros(0, 2);
end

% Merge nearby events
if size(valid_zones, 1) > 1
    merged = valid_zones(1, :);
    for k = 2:size(valid_zones, 1)
        gap = valid_zones(k, 1) - merged(end, 2);
        if gap < heating_merge_gap
            merged(end, 2) = valid_zones(k, 2);
        else
            merged = [merged; valid_zones(k, :)]; %#ok<AGROW>
        end
    end
    valid_zones = merged;
end

num_cycles = size(valid_zones, 1);
fprintf('Heating cycles detected: %d (method: %s)\n', num_cycles, detection_method);

% Build heatingCycles struct
heatingCycles = struct('id',{},'onset',{},'offset',{},'duration_frames',{}, ...
    'duration_s',{},'drift_start',{},'drift_end',{},'drift_total',{}, ...
    'drift_rate_mean',{},'drift_rate_max',{}, ...
    'circ_pre',{},'circ_post',{},'circ_change',{}, ...
    'rad_pre',{},'rad_post',{},'rad_change',{});

pre_post_window = round(1.5 * fps);  % 1.5 s pre/post window

for i = 1:num_cycles
    onset  = valid_zones(i, 1);
    offset = valid_zones(i, 2);

    dr_seg = dr_detect(onset:offset);

    pre_idx  = max(1, onset - pre_post_window) : onset - 1;
    post_idx = offset + 1 : min(numFrames, offset + pre_post_window);

    heatingCycles(i).id              = i;
    heatingCycles(i).onset           = onset;
    heatingCycles(i).offset          = offset;
    heatingCycles(i).duration_frames = offset - onset + 1;
    heatingCycles(i).duration_s      = (offset - onset + 1) * dt;
    heatingCycles(i).drift_start     = drift_magnitude(onset);
    heatingCycles(i).drift_end       = drift_magnitude(offset);
    heatingCycles(i).drift_total     = drift_magnitude(offset) - drift_magnitude(onset);
    heatingCycles(i).drift_rate_mean = mean(dr_seg);
    heatingCycles(i).drift_rate_max  = max(dr_seg);

    if ~isempty(pre_idx)
        heatingCycles(i).circ_pre = mean(circularity_smooth(pre_idx));
        heatingCycles(i).rad_pre  = mean(radius_smooth(pre_idx));
    else
        heatingCycles(i).circ_pre = NaN;
        heatingCycles(i).rad_pre  = NaN;
    end
    if ~isempty(post_idx)
        heatingCycles(i).circ_post = mean(circularity_smooth(post_idx));
        heatingCycles(i).rad_post  = mean(radius_smooth(post_idx));
    else
        heatingCycles(i).circ_post = NaN;
        heatingCycles(i).rad_post  = NaN;
    end
    heatingCycles(i).circ_change = heatingCycles(i).circ_post - heatingCycles(i).circ_pre;
    heatingCycles(i).rad_change  = heatingCycles(i).rad_post  - heatingCycles(i).rad_pre;

    fprintf('  Cycle %d: t = %.1f–%.1f s (%.1f s, drift: %.1f px)\n', ...
        i, time_s(onset), time_s(offset), ...
        heatingCycles(i).duration_s, heatingCycles(i).drift_total);
end

% Build heating mask
heating_mask = false(numFrames, 1);
for i = 1:num_cycles
    heating_mask(heatingCycles(i).onset:heatingCycles(i).offset) = true;
end

%% Heating Cycles Visualization
col_heating = [1 0.6 0.2];
colors_cycle = [0.9 0.3 0.3; 0.3 0.3 0.9; 0.3 0.8 0.3; 0.8 0.3 0.8];

fig1 = figure('Name', 'Heating Cycle Analysis', ...
    'Position', [50 50 1900 1100], 'Color', 'white');

ax1 = subplot(5,1,1);
plot(time_s, circularity, 'Color', [0.75 0.75 0.75], 'LineWidth', 0.5); hold on;
plot(time_s, circularity_smooth, 'Color', [0.5 0.5 0.5], 'LineWidth', 2.5);
for i = 1:num_cycles
    col = colors_cycle(mod(i-1,4)+1, :);
    idx = heatingCycles(i).onset:heatingCycles(i).offset;
    plot(time_s(idx), circularity_smooth(idx), 'Color', col, 'LineWidth', 3.5);
end
ylabel('Circularity', 'Interpreter', 'latex', 'FontSize', 20);
grid on; set(gca, 'FontSize', 16, 'TickLabelInterpreter', 'latex');

ax2 = subplot(5,1,2);
plot(time_s, radius_inner_mean, 'Color', [0.7 0.7 0.7], 'LineWidth', 1.5); hold on;
plot(time_s, radius_midline_mean, 'Color', [0.5 0.5 0.5], 'LineWidth', 2);
plot(time_s, radius_outer_mean, 'Color', [0.7 0.7 0.7], 'LineWidth', 1.5);
for i = 1:num_cycles
    col = colors_cycle(mod(i-1,4)+1, :);
    idx = heatingCycles(i).onset:heatingCycles(i).offset;
    plot(time_s(idx), radius_midline_mean(idx), 'Color', col, 'LineWidth', 3.5);
end
ylabel('Radius (px)', 'Interpreter', 'latex', 'FontSize', 20);
legend({'Inner', 'Midline', 'Outer'}, ...
    'Interpreter', 'latex', 'FontSize', 14, 'Location', 'northeast');
grid on; set(gca, 'FontSize', 16, 'TickLabelInterpreter', 'latex');

ax3 = subplot(5,1,3);
plot(time_s, drift_magnitude, 'Color', [0.7 0.7 0.7], 'LineWidth', 1); hold on;
plot(time_s, drift_smooth, 'Color', [0.5 0.5 0.5], 'LineWidth', 2.5);
for i = 1:num_cycles
    col = colors_cycle(mod(i-1,4)+1, :);
    idx = heatingCycles(i).onset:heatingCycles(i).offset;
    plot(time_s(idx), drift_smooth(idx), 'Color', col, 'LineWidth', 4);
    plot(time_s(heatingCycles(i).onset), drift_magnitude(heatingCycles(i).onset), ...
        'go', 'MarkerSize', 16, 'LineWidth', 3, 'MarkerFaceColor', 'g');
    plot(time_s(heatingCycles(i).offset), drift_magnitude(heatingCycles(i).offset), ...
        'bs', 'MarkerSize', 16, 'LineWidth', 3, 'MarkerFaceColor', 'b');
end
ylabel('Drift (px)', 'Interpreter', 'latex', 'FontSize', 20);
grid on; set(gca, 'FontSize', 16, 'TickLabelInterpreter', 'latex');

ax4 = subplot(5,1,4);
plot(time_s, dr_detect, 'Color', [0.5 0.5 0.5], 'LineWidth', 2); hold on;
for i = 1:num_cycles
    col = colors_cycle(mod(i-1,4)+1, :);
    idx = heatingCycles(i).onset:heatingCycles(i).offset;
    plot(time_s(idx), dr_detect(idx), 'Color', col, 'LineWidth', 3.5);
end
yline(threshold_heating, 'r--', 'LineWidth', 2.5);
yline(0, 'k:', 'LineWidth', 1);
ylabel('Drift Rate (px/s)', 'Interpreter', 'latex', 'FontSize', 20);
grid on; set(gca, 'FontSize', 16, 'TickLabelInterpreter', 'latex');

ax5 = subplot(5,1,5);
plot(time_s, drift_magnitude, 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5); hold on;
for i = 1:num_cycles
    col = colors_cycle(mod(i-1,4)+1, :);
    idx = heatingCycles(i).onset:heatingCycles(i).offset;
    plot(time_s(idx), drift_magnitude(idx), 'Color', col, 'LineWidth', 4);
end
ylabel('Drift (px)', 'Interpreter', 'latex', 'FontSize', 20);
xlabel('Time (s)', 'Interpreter', 'latex', 'FontSize', 20);
grid on; set(gca, 'FontSize', 16, 'TickLabelInterpreter', 'latex');
ylim([0 max(drift_magnitude)*1.1]);

linkaxes([ax1, ax2, ax3, ax4, ax5], 'x');

%% ═══════════════════════════════════════════════════════════════
%% 7. SHAPE-CHANGE DETECTION (roughness-based)
%% ═══════════════════════════════════════════════════════════════

fprintf('\n=== Shape-Change Detection ===\n');

roughness = zeros(numFrames, 1);
for iFrame = 1:numFrames
    r = allContours(iFrame).r_midline_smooth;
    roughness(iFrame) = std(r) / mean(r);
end

roughness_smooth = smoothdata(roughness, 'gaussian', smooth_window_frames);

% Baseline from early frames
bw = min(roughness_baseline_frames, numFrames);
roughness_baseline = median(roughness_smooth(1:bw));
roughness_noise    = std(roughness_smooth(1:bw));
roughness_threshold = roughness_baseline + roughness_sigma_threshold * roughness_noise;

fprintf('Roughness baseline: %.5f\n', roughness_baseline);
fprintf('Roughness noise: %.5f\n', roughness_noise);
fprintf('Roughness threshold: %.5f (%.1f-sigma)\n', roughness_threshold, roughness_sigma_threshold);

% Detect high roughness events
shape_change_raw = roughness_smooth > roughness_threshold;
shape_change_smooth_sig = smoothdata(double(shape_change_raw), 'gaussian', ...
    round(0.5 * fps)) > 0.5;

shape_starts = find(diff([0; shape_change_smooth_sig]) == 1);
shape_ends   = find(diff([shape_change_smooth_sig; 0]) == -1);

% Filter by minimum duration
shape_min_frames = round(shape_min_duration_s * fps);
shape_merge_gap  = round(shape_merge_gap_s * fps);

if ~isempty(shape_starts) && ~isempty(shape_ends)
    dur_shape  = shape_ends - shape_starts + 1;
    mask_valid = dur_shape >= shape_min_frames;
    shape_zones = [shape_starts(mask_valid), shape_ends(mask_valid)];
else
    shape_zones = zeros(0, 2);
end

% Merge nearby events
if size(shape_zones, 1) > 1
    merged_shape = shape_zones(1, :);
    for k = 2:size(shape_zones, 1)
        gap = shape_zones(k, 1) - merged_shape(end, 2);
        if gap < shape_merge_gap
            merged_shape(end, 2) = shape_zones(k, 2);
        else
            merged_shape = [merged_shape; shape_zones(k, :)]; %#ok<AGROW>
        end
    end
    shape_zones = merged_shape;
end

% --- Filter: only keep events near or after heating onset ---
% Spurious roughness spikes before any heating are likely noise/drift
if shape_require_heating && num_cycles > 0 && size(shape_zones, 1) > 0
    first_heating_frame = heatingCycles(1).onset;
    % Allow events that start within 2 s BEFORE heating (thermal lag)
    margin_frames = round(2.0 * fps);
    earliest_valid = max(1, first_heating_frame - margin_frames);

    keep = false(size(shape_zones, 1), 1);
    for k = 1:size(shape_zones, 1)
        % Keep event if it overlaps with the valid window
        if shape_zones(k, 2) >= earliest_valid
            keep(k) = true;
        end
    end

    n_removed = sum(~keep);
    if n_removed > 0
        fprintf('Filtered %d pre-heating roughness events (before t=%.1f s)\n', ...
            n_removed, time_s(earliest_valid));
    end
    shape_zones = shape_zones(keep, :);
end

shape_change_mask = false(numFrames, 1);
for i = 1:size(shape_zones, 1)
    shape_change_mask(shape_zones(i, 1):shape_zones(i, 2)) = true;
end

num_shape_events = size(shape_zones, 1);
fprintf('Shape-change events detected: %d\n', num_shape_events);
for i = 1:num_shape_events
    fprintf('  Event %d: t = %.1f–%.1f s (%.1f s)\n', ...
        i, time_s(shape_zones(i,1)), time_s(shape_zones(i,2)), ...
        (shape_zones(i,2)-shape_zones(i,1)+1)*dt);
end

%% Roughness Visualization
figure('Name', 'Shape-Change Detection (Roughness)', ...
    'Position', [100 100 1400 600], 'Color', 'white');

subplot(2, 1, 1);
plot(time_s, roughness, 'Color', [0.7 0.7 0.7], 'LineWidth', 0.5); hold on;
plot(time_s, roughness_smooth, 'b-', 'LineWidth', 2.5);
yline(roughness_threshold, 'r--', 'LineWidth', 2);
yline(roughness_baseline, 'b:', 'LineWidth', 1.5);
xlabel('Time (s)', 'Interpreter', 'latex', 'FontSize', 14);
ylabel('Roughness $\sigma_r / \langle r \rangle$', 'Interpreter', 'latex', 'FontSize', 14);
legend({'Raw', 'Smoothed', ...
    sprintf('Threshold (%.4f)', roughness_threshold), ...
    sprintf('Baseline (%.4f)', roughness_baseline)}, ...
    'Interpreter', 'latex', 'FontSize', 12);
grid on; set(gca, 'FontSize', 12, 'TickLabelInterpreter', 'latex');

subplot(2, 1, 2);
plot(time_s, roughness_smooth, 'Color', [0.7 0.7 0.7], 'LineWidth', 1.5); hold on;
yline(roughness_threshold, 'r--', 'LineWidth', 1);
for i = 1:num_shape_events
    idx = shape_zones(i, 1):shape_zones(i, 2);
    plot(time_s(idx), roughness_smooth(idx), 'r-', 'LineWidth', 3);
end
xlabel('Time (s)', 'Interpreter', 'latex', 'FontSize', 14);
ylabel('Roughness', 'Interpreter', 'latex', 'FontSize', 14);
grid on; set(gca, 'FontSize', 12, 'TickLabelInterpreter', 'latex');

%% ═══════════════════════════════════════════════════════════════
%% 8. REGIME CLASSIFICATION
%% ═══════════════════════════════════════════════════════════════

fprintf('\n=== Regime Classification ===\n');

regime = ones(numFrames, 1);       % Default: regime 1 (no heating)
regime(heating_mask) = 3;           % Regime 3: heating steady
regime(shape_change_mask) = 2;      % Regime 2: shape change (overrides 3)

mask_no_heating    = (regime == 1);
mask_shape_change  = (regime == 2);
mask_heating_steady = (regime == 3);

fprintf('Regime 1 (No heating):     %d frames (%.1f%%, %.1f s)\n', ...
    sum(mask_no_heating), 100*sum(mask_no_heating)/numFrames, sum(mask_no_heating)*dt);
fprintf('Regime 2 (Shape change):   %d frames (%.1f%%, %.1f s)\n', ...
    sum(mask_shape_change), 100*sum(mask_shape_change)/numFrames, sum(mask_shape_change)*dt);
fprintf('Regime 3 (Heating steady): %d frames (%.1f%%, %.1f s)\n', ...
    sum(mask_heating_steady), 100*sum(mask_heating_steady)/numFrames, sum(mask_heating_steady)*dt);

%% ═══════════════════════════════════════════════════════════════
%% 9. REDUCED VOLUME ANALYSIS (with asymmetry flagging)
%% ═══════════════════════════════════════════════════════════════

fprintf('\n=== Reduced Volume Analysis ===\n');

reduced_volume  = zeros(numFrames, 1);
R0_values       = zeros(numFrames, 1);
volume_um3      = zeros(numFrames, 1);
area_um2        = zeros(numFrames, 1);
eccentricity    = zeros(numFrames, 1);
asymmetry       = zeros(numFrames, 1);
v_is_reliable   = true(numFrames, 1);  % Flag for axisymmetry reliability

for iFrame = 1:numFrames
    x_px = allContours(iFrame).x_midline;
    y_px = allContours(iFrame).y_midline;

    x_um = x_px * pixel_size_um;
    y_um = y_px * pixel_size_um;

    x_center = mean(x_um);
    y_center = mean(y_um);
    x_centered = x_um - x_center;
    y_centered = y_um - y_center;

    % PCA alignment
    X = [x_centered(:), y_centered(:)];
    [coeff, ~, latent] = pca(X);
    theta_pca = atan2(coeff(2,1), coeff(1,1));
    eccentricity(iFrame) = 1 - sqrt(latent(2)/latent(1));

    x_rot = x_centered * cos(-theta_pca) - y_centered * sin(-theta_pca);
    y_rot = x_centered * sin(-theta_pca) + y_centered * cos(-theta_pca);

    % --- Right half (positive x) ---
    idx_right = x_rot >= 0;
    x_right = x_rot(idx_right);
    y_right = y_rot(idx_right);
    [y_right_sorted, si] = sort(y_right);
    r_right_sorted = x_right(si);
    [y_r_uniq, ~, ic_r] = uniquetol(y_right_sorted, 1e-6);
    r_r_uniq = zeros(size(y_r_uniq));
    for i = 1:length(y_r_uniq)
        r_r_uniq(i) = max(r_right_sorted(ic_r == i));
    end

    % --- Left half (negative x, reflected) ---
    idx_left = x_rot <= 0;
    x_left = abs(x_rot(idx_left));
    y_left = y_rot(idx_left);
    [y_left_sorted, si_l] = sort(y_left);
    r_left_sorted = x_left(si_l);
    [y_l_uniq, ~, ic_l] = uniquetol(y_left_sorted, 1e-6);
    r_l_uniq = zeros(size(y_l_uniq));
    for i = 1:length(y_l_uniq)
        r_l_uniq(i) = max(r_left_sorted(ic_l == i));
    end

    % --- Asymmetry check (compare left and right profiles) ---
    y_min_common = max(min(y_r_uniq), min(y_l_uniq));
    y_max_common = min(max(y_r_uniq), max(y_l_uniq));
    y_check = linspace(y_min_common, y_max_common, 100);
    r_right_interp = interp1(y_r_uniq, r_r_uniq, y_check, 'pchip');
    r_left_interp  = interp1(y_l_uniq, r_l_uniq, y_check, 'pchip');
    asymmetry(iFrame) = std(r_right_interp - r_left_interp) / mean(r_right_interp);

    if asymmetry(iFrame) > asymmetry_warning_threshold
        v_is_reliable(iFrame) = false;
    end

    % --- Average left and right for more robust axisymmetric estimate ---
    r_avg_interp = 0.5 * (r_right_interp + r_left_interp);
    dy_check = diff(y_check(:));
    r_mid_v  = 0.5 * (r_avg_interp(1:end-1)' + r_avg_interp(2:end)');
    dr_check = diff(r_avg_interp(:));
    ds_check = sqrt(dr_check.^2 + dy_check.^2);

    volume_um3(iFrame) = sum(pi * r_mid_v.^2 .* dy_check);
    area_um2(iFrame)   = sum(2 * pi * r_mid_v .* ds_check);

    R0_values(iFrame) = sqrt(area_um2(iFrame) / (4 * pi));
    V_sphere = (4/3) * pi * R0_values(iFrame)^3;
    reduced_volume(iFrame) = volume_um3(iFrame) / V_sphere;
end

% Also compute simple spherical proxy: V_eff = (4/3)*pi*R_eff^3
R_eff_um    = sqrt(proj_area * pixel_size_um^2 / pi);
V_eff_um3   = (4/3) * pi .* R_eff_um.^3;
v_spherical = V_eff_um3 ./ ((4/3) * pi .* R0_values.^3);

reduced_volume_smooth = smoothdata(reduced_volume, 'gaussian', smooth_window_frames);
delta_v = reduced_volume - reduced_volume(1);

n_unreliable = sum(~v_is_reliable);
fprintf('Reduced volume: v_0 = %.4f (first frame)\n', reduced_volume(1));
fprintf('Reduced volume range: [%.4f, %.4f]\n', min(reduced_volume), max(reduced_volume));
fprintf('Asymmetry-flagged frames: %d (%.1f%%)\n', n_unreliable, 100*n_unreliable/numFrames);

% Update heating cycles with reduced volume
for i = 1:num_cycles
    onset  = heatingCycles(i).onset;
    offset = heatingCycles(i).offset;
    pre_idx  = max(1, onset - pre_post_window) : onset - 1;
    post_idx = offset + 1 : min(numFrames, offset + pre_post_window);

    if ~isempty(pre_idx)
        heatingCycles(i).v_pre = mean(reduced_volume_smooth(pre_idx));
    else
        heatingCycles(i).v_pre = NaN;
    end
    if ~isempty(post_idx)
        heatingCycles(i).v_post = mean(reduced_volume_smooth(post_idx));
    else
        heatingCycles(i).v_post = NaN;
    end
    heatingCycles(i).v_change = heatingCycles(i).v_post - heatingCycles(i).v_pre;

    % Min reduced volume during cycle
    cycle_idx = onset:offset;
    heatingCycles(i).v_min = min(reduced_volume_smooth(cycle_idx));
    heatingCycles(i).v_max_loss = heatingCycles(i).v_pre - heatingCycles(i).v_min;

    fprintf('  Cycle %d: v_pre=%.3f, v_min=%.3f, v_post=%.3f (loss=%.1f%%)\n', ...
        i, heatingCycles(i).v_pre, heatingCycles(i).v_min, ...
        heatingCycles(i).v_post, 100*heatingCycles(i).v_max_loss);
end

%% Reduced Volume Visualization
figure('Name', 'Reduced Volume Analysis', ...
    'Position', [100 100 1600 800], 'Color', 'white');

subplot(2,2,1);
plot(time_s, reduced_volume, 'Color', [0.7 0.7 0.7], 'LineWidth', 0.5); hold on;
plot(time_s, reduced_volume_smooth, 'b-', 'LineWidth', 2.5);
% Mark unreliable frames
if any(~v_is_reliable)
    plot(time_s(~v_is_reliable), reduced_volume(~v_is_reliable), ...
        'rx', 'MarkerSize', 3, 'LineWidth', 0.5);
end
for i = 1:num_cycles
    col = colors_cycle(mod(i-1,4)+1, :);
    idx = heatingCycles(i).onset:heatingCycles(i).offset;
    plot(time_s(idx), reduced_volume_smooth(idx), 'Color', col, 'LineWidth', 3);
end
xlabel('Time (s)', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('Reduced volume $v$', 'Interpreter', 'latex', 'FontSize', 16);
yline(1, 'k:', 'LineWidth', 1);
grid on; set(gca, 'FontSize', 14, 'TickLabelInterpreter', 'latex');
legend({'Raw', 'Smoothed', 'Unreliable (asymmetric)'}, ...
    'Interpreter', 'latex', 'FontSize', 12, 'Location', 'southwest');

subplot(2,2,2);
plot(time_s, asymmetry, 'k-', 'LineWidth', 1); hold on;
yline(asymmetry_warning_threshold, 'r--', 'LineWidth', 2);
xlabel('Time (s)', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('Asymmetry $\sigma_{L-R} / \langle r \rangle$', 'Interpreter', 'latex', 'FontSize', 16);
legend({'Asymmetry', sprintf('Threshold (%.2f)', asymmetry_warning_threshold)}, ...
    'Interpreter', 'latex', 'FontSize', 12);
grid on; set(gca, 'FontSize', 14, 'TickLabelInterpreter', 'latex');

subplot(2,2,3);
plot(time_s, eccentricity, 'Color', [0.4 0.6 0.8], 'LineWidth', 1.5);
xlabel('Time (s)', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('Eccentricity', 'Interpreter', 'latex', 'FontSize', 16);
grid on; set(gca, 'FontSize', 14, 'TickLabelInterpreter', 'latex');

subplot(2,2,4);
plot(time_s, reduced_volume_smooth, 'b-', 'LineWidth', 2); hold on;
plot(time_s, v_spherical, 'r--', 'LineWidth', 1.5);
xlabel('Time (s)', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('Reduced volume', 'Interpreter', 'latex', 'FontSize', 16);
legend({'Axisymmetric $v$', 'Spherical proxy $v_{\mathrm{sph}}$'}, ...
    'Interpreter', 'latex', 'FontSize', 12);
grid on; set(gca, 'FontSize', 14, 'TickLabelInterpreter', 'latex');

%% ═══════════════════════════════════════════════════════════════
%% 10. FOURIER SPECTRA BY REGIME (corrected)
%% ═══════════════════════════════════════════════════════════════

fprintf('\n=== Fourier Spectra Analysis (Corrected) ===\n');

% Physical mode numbers: n = 2, 3, ..., nFourierModes+1
% FFT index k maps to physical mode n = k
% u_n(k=1) = DC, u_n(k=2) = n=1 (translation), u_n(k=3) = n=2, ...
% So physical mode n corresponds to FFT index k = n+1

physical_modes = (2 : nFourierModes+1)';  % n = 2 to nFourierModes+1
nPhysModes     = length(physical_modes);

% Allocate: raw Fourier amplitudes per frame
amp_sq_raw = zeros(numFrames, nPhysModes);

for iF = 1:numFrames
    r = allContours(iF).r_midline_smooth(:);
    r_mean  = mean(r);
    u_fluct = (r - r_mean) / r_mean;  % Dimensionless fluctuation u = (r-R)/R

    % FFT
    U_n = fft(u_fluct) / length(u_fluct);

    % Physical modes n=2..nFourierModes+1 → FFT indices 3..nFourierModes+2
    amp_sq_raw(iF, :) = abs(U_n(3 : nFourierModes+2)).^2;
end

% --- Integration time correction (Pecreaux 2004) ---
% Relaxation time for mode n on a vesicle of radius R:
%   tau_n = (4*eta*R^3) / (kappa * (n-1)*(n+2) * [n*(n+1) + sigma_bar])
% Approximate with sigma_bar ~ 0 for initial estimate:
%   tau_n ~ (4*eta*R^3) / (kappa * (n-1)*(n+2) * n*(n+1))
%
% Correction factor (Pecreaux 2004, Eq. 11):
%   C_n = (tau_m/tau_n) / [1 - (tau_n/tau_m)*(1 - exp(-tau_m/tau_n))]
% where tau_m = exposure time.
%
% IMPORTANT: When tau_n << tau_m (high modes), the correction diverges.
% These modes are irrecoverably averaged — we cap the correction and
% restrict kappa fitting to modes where the correction is moderate.

R_m   = R_mean_um * 1e-6;  % Radius in meters
kappa_est = 20 * kBT;      % Initial estimate for DOPC

tau_n_est = zeros(nPhysModes, 1);
integration_correction = ones(nPhysModes, 1);

max_correction_factor = 10;  % Cap: modes needing >10x are unreliable

for i = 1:nPhysModes
    n = physical_modes(i);
    tau_n_est(i) = (4 * eta_water * R_m^3) / ...
        (kappa_est * (n-1)*(n+2) * n*(n+1));

    ratio = tau_exposure / tau_n_est(i);  % tau_m / tau_n
    if ratio < 0.01
        % Exposure much shorter than relaxation: no correction needed
        integration_correction(i) = 1.0;
    elseif ratio > 50
        % Mode is hopelessly averaged — cap at max
        integration_correction(i) = max_correction_factor;
    else
        % Full correction
        C = ratio / (1 - (1/ratio) * (1 - exp(-ratio)));
        integration_correction(i) = min(C, max_correction_factor);
    end
end

% Determine the highest reliable mode (where correction < max_correction)
reliable_mode_mask = integration_correction < max_correction_factor;
if any(reliable_mode_mask)
    max_reliable_mode = max(physical_modes(reliable_mode_mask));
else
    max_reliable_mode = physical_modes(end);
end

fprintf('Integration time corrections:\n');
fprintf('  Mode n=2:  tau_n = %.1f ms, correction = %.3f\n', ...
    tau_n_est(1)*1e3, integration_correction(1));
idx_n10 = find(physical_modes == 10, 1);
if ~isempty(idx_n10)
    fprintf('  Mode n=10: tau_n = %.1f ms, correction = %.3f\n', ...
        tau_n_est(idx_n10)*1e3, integration_correction(idx_n10));
end
idx_n20 = find(physical_modes == 20, 1);
if ~isempty(idx_n20)
    fprintf('  Mode n=20: tau_n = %.2f ms, correction = %.1f (CAPPED)\n', ...
        tau_n_est(idx_n20)*1e3, integration_correction(idx_n20));
end
fprintf('  Highest reliable mode: n = %d (correction < %dx)\n', ...
    max_reliable_mode, max_correction_factor);

% Apply integration time correction (per mode, broadcast across frames)
amp_sq_corrected = amp_sq_raw .* integration_correction';

% --- White noise floor estimation (Genova 2013) ---
% Estimate from RAW (uncorrected) high modes, not corrected ones
% (corrected high modes have inflated noise from the large correction factor)
high_mode_idx = physical_modes > 20;
if sum(high_mode_idx) >= 3
    noise_floor = median(mean(amp_sq_raw(:, high_mode_idx), 1));
    fprintf('White noise floor: %.2e (from raw modes n > 20)\n', noise_floor);
else
    noise_floor = 0;
    fprintf('Not enough high modes to estimate noise floor\n');
end

% Subtract noise floor from RAW, then apply correction to the denoised signal
amp_sq_denoised_raw = amp_sq_raw - noise_floor;
amp_sq_denoised_raw(amp_sq_denoised_raw < 0) = 0;
amp_sq_denoised = amp_sq_denoised_raw .* integration_correction';

% --- Average spectra per regime ---
spectrum_regime1 = mean(amp_sq_denoised(mask_no_heating, :), 1)';
spectrum_regime2 = mean(amp_sq_denoised(mask_shape_change, :), 1)';
spectrum_regime3 = mean(amp_sq_denoised(mask_heating_steady, :), 1)';

% Also compute raw (uncorrected) for comparison
spectrum_raw_regime1 = mean(amp_sq_raw(mask_no_heating, :), 1)';

fprintf('Regime spectra computed (corrected for integration time + noise)\n');

%% ═══════════════════════════════════════════════════════════════
%% 11. BENDING RIGIDITY FITTING (Helfrich spectrum)
%% ═══════════════════════════════════════════════════════════════

fprintf('\n=== Bending Rigidity Fitting ===\n');

% Helfrich fluctuation spectrum for quasi-spherical vesicle (Faizi 2020):
%   <|u_n|^2> = kBT / [ kappa * (n-1)*(n+2) * ((n-1)*(n+2) + sigma_bar) ]
%
% where sigma_bar = sigma * R^2 / kappa is the dimensionless tension.
%
% REPARAMETERIZATION for numerical stability:
%   Let kappa_hat = kappa / kBT  (dimensionless, ~20 for DOPC)
%   Then: <|u_n|^2> = 1 / [ kappa_hat * (n-1)*(n+2) * ((n-1)*(n+2) + sigma_bar) ]
%
% Fit parameters: kappa_hat [dimensionless], sigma_bar [dimensionless]
% Both are O(1)-O(100), so the optimizer works well.

% --- Fitting function (dimensionless kappa_hat) ---
helfrich_spectrum_hat = @(params, n) 1 ./ ...
    (params(1) .* (n-1).*(n+2) .* ((n-1).*(n+2) + params(2)));
% params(1) = kappa_hat = kappa/kBT, params(2) = sigma_bar

% Also define the physical version for plotting:
helfrich_spectrum = @(kappa_kBT, sigma_bar, n) 1 ./ ...
    (kappa_kBT .* (n-1).*(n+2) .* ((n-1).*(n+2) + sigma_bar));

% --- Restrict fitting range to reliable modes ---
% Upper limit: min of user setting and highest reliable mode from
% integration time analysis
fit_mode_max_actual = min(fit_mode_max, max_reliable_mode);
fprintf('Fitting mode range: n = %d to %d (max reliable: %d)\n', ...
    fit_mode_min, fit_mode_max_actual, max_reliable_mode);

fit_idx = (physical_modes >= fit_mode_min) & (physical_modes <= fit_mode_max_actual);

% --- Helper function to fit one regime ---
fit_helfrich = @(spectrum_data) fit_helfrich_regime(spectrum_data, ...
    fit_idx, physical_modes, helfrich_spectrum_hat, ...
    R_m, kBT, optical_projection_factor);

% --- Fit regime 1 (no heating baseline) ---
[fit_result_1, fit_success_1] = fit_helfrich(spectrum_regime1);

if fit_success_1
    kappa_kBT_1           = fit_result_1.kappa_kBT;
    kappa_corrected_kBT_1 = fit_result_1.kappa_corrected_kBT;
    sigma_bar_1           = fit_result_1.sigma_bar;
    sigma_Nm_1            = fit_result_1.sigma_Nm;
    p_fit1                = [fit_result_1.kappa_kBT, fit_result_1.sigma_bar];

    fprintf('--- Regime 1 (No Heating) ---\n');
    fprintf('  kappa (raw)       = %.1f kBT  (%.2e J)\n', ...
        kappa_kBT_1, kappa_kBT_1 * kBT);
    fprintf('  kappa (corrected) = %.1f kBT  [x%.1f projection, Rautu 2017]\n', ...
        kappa_corrected_kBT_1, optical_projection_factor);
    fprintf('  sigma_bar         = %.1f\n', sigma_bar_1);
    fprintf('  sigma             = %.2e N/m\n', sigma_Nm_1);
    fprintf('  Literature DOPC:    20-27 kBT (Faizi 2020, Rautu 2017)\n');
else
    kappa_kBT_1 = NaN; kappa_corrected_kBT_1 = NaN;
    sigma_bar_1 = NaN; sigma_Nm_1 = NaN;
    fprintf('Regime 1 fit FAILED\n');
end

% --- Fit regime 3 (heating steady state) ---
if sum(mask_heating_steady) > 50
    [fit_result_3, fit_success_3] = fit_helfrich(spectrum_regime3);
else
    fit_success_3 = false;
    fprintf('Not enough regime 3 frames for fitting\n');
end

if fit_success_3
    kappa_kBT_3           = fit_result_3.kappa_kBT;
    kappa_corrected_kBT_3 = fit_result_3.kappa_corrected_kBT;
    sigma_bar_3           = fit_result_3.sigma_bar;
    sigma_Nm_3            = fit_result_3.sigma_Nm;
    p_fit3                = [fit_result_3.kappa_kBT, fit_result_3.sigma_bar];

    fprintf('\n--- Regime 3 (Heating Steady) ---\n');
    fprintf('  kappa (raw)       = %.1f kBT\n', kappa_kBT_3);
    fprintf('  kappa (corrected) = %.1f kBT\n', kappa_corrected_kBT_3);
    fprintf('  sigma_bar         = %.1f\n', sigma_bar_3);
    fprintf('  sigma             = %.2e N/m\n', sigma_Nm_3);

    if fit_success_1
        delta_kappa = kappa_corrected_kBT_3 - kappa_corrected_kBT_1;
        fprintf('  Delta kappa (heated - baseline) = %.1f kBT\n', delta_kappa);
        if delta_kappa < 0
            fprintf('  -> Membrane SOFTENS during heating (Wennerstrom 2025)\n');
        end
    end
else
    kappa_kBT_3 = NaN; kappa_corrected_kBT_3 = NaN;
    sigma_bar_3 = NaN; sigma_Nm_3 = NaN;
    if sum(mask_heating_steady) > 50
        fprintf('Regime 3 fit FAILED\n');
    end
end

%% Fourier Spectra Visualization (corrected)
col_no_heating    = [0.5 0.5 0.5];
col_shape_change  = [0.9 0.3 0.3];
col_heating_steady = [1 0.6 0.2];

figure('Name', 'Fourier Spectra by Regime (Corrected)', ...
    'Position', [100 100 1200 800], 'Color', 'white');

% --- Left panel: spectra + fits ---
subplot(1,2,1);
h1 = loglog(physical_modes, spectrum_regime1, 'o-', 'Color', col_no_heating, ...
    'MarkerSize', 8, 'MarkerFaceColor', col_no_heating, 'LineWidth', 2); hold on;
h2 = loglog(physical_modes, spectrum_regime2, 's-', 'Color', col_shape_change, ...
    'MarkerSize', 8, 'MarkerFaceColor', col_shape_change, 'LineWidth', 2);
h3 = loglog(physical_modes, spectrum_regime3, 'd-', 'Color', col_heating_steady, ...
    'MarkerSize', 8, 'MarkerFaceColor', col_heating_steady, 'LineWidth', 2);

% Helfrich fit overlay (n_plot defined outside conditionals to avoid scope issues)
n_plot = linspace(2, nFourierModes+1, 200)';
h_fit1 = gobjects(0); h_fit3 = gobjects(0);  % Initialize as empty graphics

if fit_success_1
    s_fit_plot = helfrich_spectrum(p_fit1(1), p_fit1(2), n_plot);
    h_fit1 = loglog(n_plot, s_fit_plot, '-', 'Color', [0.3 0.3 0.3], 'LineWidth', 2.5);
end
if fit_success_3
    s_fit3_plot = helfrich_spectrum(p_fit3(1), p_fit3(2), n_plot);
    h_fit3 = loglog(n_plot, s_fit3_plot, '-', 'Color', [0.9 0.5 0.1], 'LineWidth', 2.5);
end

% Mark fit range
xline(fit_mode_min, 'k:', 'LineWidth', 0.8, 'Alpha', 0.5);
xline(fit_mode_max_actual, 'k:', 'LineWidth', 0.8, 'Alpha', 0.5);

% Reference power laws
n_ref = [2, nFourierModes+1]';
n0_ref = 10;
S0_ref = spectrum_regime1(n0_ref - 1);  % Index offset since physical_modes starts at 2
ref_n2 = S0_ref * (n_ref/n0_ref).^(-2);
ref_n3 = S0_ref * (n_ref/n0_ref).^(-3);
ref_n4 = S0_ref * (n_ref/n0_ref).^(-4);

h_r2 = loglog(n_ref, ref_n2, 'k--',  'LineWidth', 1.5);
h_r3 = loglog(n_ref, ref_n3, 'k:',   'LineWidth', 1.5);
h_r4 = loglog(n_ref, ref_n4, 'k-.',  'LineWidth', 1.5);

xlabel('Mode $n$', 'Interpreter', 'latex', 'FontSize', 20);
ylabel('$\langle |u_n|^2 \rangle$', 'Interpreter', 'latex', 'FontSize', 20);
grid on; set(gca, 'FontSize', 18, 'TickLabelInterpreter', 'latex');
xlim([2 nFourierModes+1]);

% Build legend dynamically
leg_entries = {h1, h2, h3};
leg_labels  = {'No heating', 'Shape change', 'Heating steady'};
if fit_success_1 && ~isempty(h_fit1)
    leg_entries{end+1} = h_fit1;
    leg_labels{end+1}  = sprintf('Fit R1: $\\kappa=%.1f\\,k_BT$', kappa_kBT_1);
end
if fit_success_3 && ~isempty(h_fit3)
    leg_entries{end+1} = h_fit3;
    leg_labels{end+1}  = sprintf('Fit R3: $\\kappa=%.1f\\,k_BT$', kappa_kBT_3);
end
leg_entries = [leg_entries, {h_r2, h_r3, h_r4}];
leg_labels  = [leg_labels, {'$n^{-2}$ (tension)', '$n^{-3}$ (mixed)', '$n^{-4}$ (bending)'}];
legend([leg_entries{:}], leg_labels, 'Interpreter', 'latex', 'FontSize', 12, 'Location', 'southwest');

title('Corrected Spectra', 'Interpreter', 'latex', 'FontSize', 18);

% --- Right panel: raw vs corrected comparison ---
subplot(1,2,2);
loglog(physical_modes, spectrum_raw_regime1, 'o--', 'Color', [0.7 0.7 0.9], ...
    'MarkerSize', 6, 'LineWidth', 1.5, 'DisplayName', 'Raw'); hold on;
loglog(physical_modes, spectrum_regime1, 'o-', 'Color', col_no_heating, ...
    'MarkerSize', 8, 'MarkerFaceColor', col_no_heating, 'LineWidth', 2, ...
    'DisplayName', 'Corrected');
if noise_floor > 0
    yline(noise_floor, 'm:', 'LineWidth', 1.5, 'DisplayName', 'Noise floor');
end
% Show max reliable mode
xline(max_reliable_mode, 'r--', 'LineWidth', 1.5, 'DisplayName', ...
    sprintf('Max reliable (n=%d)', max_reliable_mode));
xlabel('Mode $n$', 'Interpreter', 'latex', 'FontSize', 20);
ylabel('$\langle |u_n|^2 \rangle$', 'Interpreter', 'latex', 'FontSize', 20);
legend('Interpreter', 'latex', 'FontSize', 14, 'Location', 'southwest');
grid on; set(gca, 'FontSize', 18, 'TickLabelInterpreter', 'latex');
xlim([2 nFourierModes+1]);
title('Integration Time + Noise Correction', 'Interpreter', 'latex', 'FontSize', 18);

%% ═══════════════════════════════════════════════════════════════
%% 12. NON-GAUSSIAN STATISTICS CHECK (Sciortino 2025)
%% ═══════════════════════════════════════════════════════════════

fprintf('\n=== Non-Gaussian Statistics Check ===\n');

% For each regime, check if fluctuation amplitudes follow Gaussian statistics
% Excess kurtosis: 0 for Gaussian, positive for heavy tails (active signature)

modes_to_check = [3, 5, 10, 15];  % Physical mode numbers
kurtosis_table = zeros(length(modes_to_check), 3);  % [regime1, regime2, regime3]

for im = 1:length(modes_to_check)
    n_check = modes_to_check(im);
    idx_mode = find(physical_modes == n_check, 1);

    if ~isempty(idx_mode)
        % Regime 1
        data1 = amp_sq_denoised(mask_no_heating, idx_mode);
        kurtosis_table(im, 1) = kurtosis(data1) - 3;  % Excess kurtosis

        % Regime 2
        if sum(mask_shape_change) > 10
            data2 = amp_sq_denoised(mask_shape_change, idx_mode);
            kurtosis_table(im, 2) = kurtosis(data2) - 3;
        else
            kurtosis_table(im, 2) = NaN;
        end

        % Regime 3
        if sum(mask_heating_steady) > 10
            data3 = amp_sq_denoised(mask_heating_steady, idx_mode);
            kurtosis_table(im, 3) = kurtosis(data3) - 3;
        else
            kurtosis_table(im, 3) = NaN;
        end
    end
end

fprintf('Excess kurtosis (0 = Gaussian, >0 = heavy tails):\n');
fprintf('  Mode n | No Heat  | Shape Ch | Heat Steady\n');
fprintf('  -------|----------|----------|------------\n');
for im = 1:length(modes_to_check)
    fprintf('  n = %2d | %7.2f  | %7.2f  | %7.2f\n', ...
        modes_to_check(im), kurtosis_table(im,1), kurtosis_table(im,2), kurtosis_table(im,3));
end

%% ═══════════════════════════════════════════════════════════════
%% 13. FIVE-PANEL DETECTION OVERVIEW
%% ═══════════════════════════════════════════════════════════════

figure('Name', 'Detection Analysis Overview', ...
    'Position', [50 50 1800 1000], 'Color', 'white');

% Panel 1: Circularity
ax1 = subplot(5, 1, 1);
plot(time_s, circularity_smooth, 'Color', [0.7 0.7 0.7], 'LineWidth', 1); hold on;
for i = 1:num_cycles
    idx = heatingCycles(i).onset:heatingCycles(i).offset;
    plot(time_s(idx), circularity_smooth(idx), '-', 'Color', col_heating_steady, 'LineWidth', 3);
end
for i = 1:num_shape_events
    idx = shape_zones(i, 1):shape_zones(i, 2);
    plot(time_s(idx), circularity_smooth(idx), 'o', 'Color', col_shape_change, ...
        'MarkerSize', 4, 'LineWidth', 0.5);
end
ylabel('Circularity', 'Interpreter', 'latex', 'FontSize', 20);
grid on; set(gca, 'FontSize', 16, 'TickLabelInterpreter', 'latex');

% Panel 2: Radius
ax2 = subplot(5, 1, 2);
plot(time_s, radius_midline_mean, 'Color', [0.7 0.7 0.7], 'LineWidth', 1); hold on;
for i = 1:num_cycles
    idx = heatingCycles(i).onset:heatingCycles(i).offset;
    plot(time_s(idx), radius_midline_mean(idx), '-', 'Color', col_heating_steady, 'LineWidth', 3);
end
for i = 1:num_shape_events
    idx = shape_zones(i, 1):shape_zones(i, 2);
    plot(time_s(idx), radius_midline_mean(idx), 'o', 'Color', col_shape_change, ...
        'MarkerSize', 4, 'LineWidth', 0.5);
end
ylabel('Radius (px)', 'Interpreter', 'latex', 'FontSize', 20);
grid on; set(gca, 'FontSize', 16, 'TickLabelInterpreter', 'latex');

% Panel 3: Drift
ax3 = subplot(5, 1, 3);
plot(time_s, drift_smooth, 'Color', [0.7 0.7 0.7], 'LineWidth', 1); hold on;
for i = 1:num_cycles
    idx = heatingCycles(i).onset:heatingCycles(i).offset;
    plot(time_s(idx), drift_smooth(idx), '-', 'Color', col_heating_steady, 'LineWidth', 3);
end
for i = 1:num_shape_events
    idx = shape_zones(i, 1):shape_zones(i, 2);
    plot(time_s(idx), drift_smooth(idx), 'o', 'Color', col_shape_change, ...
        'MarkerSize', 4, 'LineWidth', 0.5);
end
ylabel('Drift (px)', 'Interpreter', 'latex', 'FontSize', 20);
grid on; set(gca, 'FontSize', 16, 'TickLabelInterpreter', 'latex');

% Panel 4: Reduced Volume
ax4 = subplot(5, 1, 4);
plot(time_s, reduced_volume_smooth, 'Color', [0.7 0.7 0.7], 'LineWidth', 1); hold on;
yline(1, 'k:', 'LineWidth', 1);
for i = 1:num_cycles
    idx = heatingCycles(i).onset:heatingCycles(i).offset;
    plot(time_s(idx), reduced_volume_smooth(idx), '-', 'Color', col_heating_steady, 'LineWidth', 3);
end
for i = 1:num_shape_events
    idx = shape_zones(i, 1):shape_zones(i, 2);
    plot(time_s(idx), reduced_volume_smooth(idx), 'o', 'Color', col_shape_change, ...
        'MarkerSize', 4, 'LineWidth', 0.5);
end
ylabel('Reduced Volume $v$', 'Interpreter', 'latex', 'FontSize', 20);
grid on; set(gca, 'FontSize', 16, 'TickLabelInterpreter', 'latex');

% Panel 5: Roughness
ax5 = subplot(5, 1, 5);
plot(time_s, roughness_smooth, 'Color', [0.7 0.7 0.7], 'LineWidth', 1); hold on;
yline(roughness_threshold, 'r--', 'LineWidth', 1.5);
for i = 1:num_cycles
    idx = heatingCycles(i).onset:heatingCycles(i).offset;
    plot(time_s(idx), roughness_smooth(idx), '-', 'Color', col_heating_steady, 'LineWidth', 3);
end
for i = 1:num_shape_events
    idx = shape_zones(i, 1):shape_zones(i, 2);
    plot(time_s(idx), roughness_smooth(idx), 'o', 'Color', col_shape_change, ...
        'MarkerSize', 4, 'LineWidth', 0.5);
end
ylabel('Roughness', 'Interpreter', 'latex', 'FontSize', 20);
xlabel('Time (s)', 'Interpreter', 'latex', 'FontSize', 20);
grid on; set(gca, 'FontSize', 16, 'TickLabelInterpreter', 'latex');

legend(ax1, {'Baseline', 'Heating detected', 'Shape change detected'}, ...
    'Interpreter', 'latex', 'FontSize', 14, 'Location', 'northeast');
linkaxes([ax1, ax2, ax3, ax4, ax5], 'x');

%% ═══════════════════════════════════════════════════════════════
%% 14. SAVE ANALYSIS RESULTS
%% ═══════════════════════════════════════════════════════════════

fprintf('\n=== Saving Analysis Results ===\n');

% --- Representative frames ---
regime1_frames = find(mask_no_heating);
regime2_frames = find(mask_shape_change);
regime3_frames = find(mask_heating_steady);

% Regime 1: evenly spaced from baseline
nRep = 6;
if length(regime1_frames) >= nRep
    step = floor(length(regime1_frames) / nRep);
    regime1_representative = regime1_frames(1:step:end);
    regime1_representative = regime1_representative(1:min(nRep, length(regime1_representative)));
else
    regime1_representative = regime1_frames;
end

% Regime 2: peak roughness frames
if length(regime2_frames) >= nRep
    rough_r2 = roughness_smooth(regime2_frames);
    [~, peak_locs] = findpeaks(rough_r2, 'NPeaks', nRep, 'SortStr', 'descend');
    if length(peak_locs) >= nRep
        regime2_representative = regime2_frames(sort(peak_locs(1:nRep)));
    else
        step = floor(length(regime2_frames) / nRep);
        regime2_representative = regime2_frames(1:step:end);
        regime2_representative = regime2_representative(1:min(nRep, length(regime2_representative)));
    end
else
    regime2_representative = regime2_frames;
end

% Regime 3: evenly spaced from steady heating
if length(regime3_frames) >= nRep
    step = floor(length(regime3_frames) / nRep);
    regime3_representative = regime3_frames(1:step:end);
    regime3_representative = regime3_representative(1:min(nRep, length(regime3_representative)));
else
    regime3_representative = regime3_frames;
end

% --- Build results structure ---
analysisResults = struct();

% Parameters
analysisResults.params.fps              = fps;
analysisResults.params.exposure_time_ms = exposure_time_ms;
analysisResults.params.pixels_per_micron = pixels_per_micron;
analysisResults.params.pixel_size_um    = pixel_size_um;
analysisResults.params.T_kelvin         = T_kelvin;
analysisResults.params.kBT              = kBT;
analysisResults.params.R_mean_um        = R_mean_um;
analysisResults.params.smooth_window_s  = smooth_window_frames / fps;
analysisResults.params.optical_projection_factor = optical_projection_factor;

% Time vector
analysisResults.time_s = time_s;

% Regime masks
analysisResults.masks.no_heating     = mask_no_heating;
analysisResults.masks.shape_change   = mask_shape_change;
analysisResults.masks.heating_steady = mask_heating_steady;
analysisResults.regime = regime;

% Representative frames
analysisResults.representative_frames.regime1 = regime1_representative;
analysisResults.representative_frames.regime2 = regime2_representative;
analysisResults.representative_frames.regime3 = regime3_representative;

% Labels and colors
analysisResults.labels.regime1 = 'No Heating (Baseline)';
analysisResults.labels.regime2 = 'Shape Change (Deformation)';
analysisResults.labels.regime3 = 'Heating Steady State';
analysisResults.colors.regime1 = col_no_heating;
analysisResults.colors.regime2 = col_shape_change;
analysisResults.colors.regime3 = col_heating_steady;

% Time series
analysisResults.timeseries.circularity     = circularity_smooth;
analysisResults.timeseries.radius_px       = radius_midline_mean;
analysisResults.timeseries.drift_px        = drift_smooth;
analysisResults.timeseries.drift_rate      = drift_rate_sm;
analysisResults.timeseries.roughness       = roughness_smooth;
analysisResults.timeseries.reduced_volume  = reduced_volume_smooth;
analysisResults.timeseries.asymmetry       = asymmetry;
analysisResults.timeseries.eccentricity    = eccentricity;
analysisResults.timeseries.v_is_reliable   = v_is_reliable;

% Heating cycles
analysisResults.heatingCycles = heatingCycles;
analysisResults.heating_detection_method = detection_method;
analysisResults.heating_threshold = threshold_heating;

% Shape change events
analysisResults.shapeEvents.zones     = shape_zones;
analysisResults.shapeEvents.threshold = roughness_threshold;

% Fourier spectra (corrected)
analysisResults.fourier.physical_modes       = physical_modes;
analysisResults.fourier.spectrum_regime1     = spectrum_regime1;
analysisResults.fourier.spectrum_regime2     = spectrum_regime2;
analysisResults.fourier.spectrum_regime3     = spectrum_regime3;
analysisResults.fourier.spectrum_raw_regime1 = spectrum_raw_regime1;
analysisResults.fourier.noise_floor          = noise_floor;
analysisResults.fourier.integration_correction = integration_correction;

% Bending rigidity fits
analysisResults.fits.regime1.kappa_raw_kBT       = kappa_kBT_1;
analysisResults.fits.regime1.kappa_corrected_kBT = kappa_corrected_kBT_1;
analysisResults.fits.regime1.sigma_bar           = sigma_bar_1;
analysisResults.fits.regime1.sigma_Nm            = sigma_Nm_1;
analysisResults.fits.regime1.success             = fit_success_1;
analysisResults.fits.regime1.fit_mode_range      = [fit_mode_min, fit_mode_max];

if fit_success_3
    analysisResults.fits.regime3.kappa_raw_kBT       = kappa_kBT_3;
    analysisResults.fits.regime3.kappa_corrected_kBT = kappa_corrected_kBT_3;
    analysisResults.fits.regime3.sigma_bar           = sigma_bar_3;
    analysisResults.fits.regime3.sigma_Nm            = sigma_Nm_3;
    analysisResults.fits.regime3.success             = true;
end

% Non-Gaussian statistics
analysisResults.statistics.kurtosis_modes = modes_to_check;
analysisResults.statistics.kurtosis_table = kurtosis_table;

% Metadata
analysisResults.metadata.numFrames    = numFrames;
analysisResults.metadata.nAngles      = nAngles;
analysisResults.metadata.analysisDate = datetime('now');
analysisResults.metadata.version      = 'v2 (corrected)';
analysisResults.metadata.corrections  = { ...
    'Area centroid (not geometric mean)', ...
    'Fourier modes n=2..N (n=1 excluded)', ...
    'Integration time correction (Pecreaux 2004)', ...
    'White noise subtraction (Genova 2013)', ...
    'Optical projection factor (Rautu 2017)', ...
    'Helfrich spectrum fitting for kappa, sigma', ...
    'Reduced volume with L-R asymmetry flagging', ...
    'Adaptive GMM heating detection'};

save('analysisResults_v2.mat', 'analysisResults', '-v7.3');
fprintf('Results saved to: analysisResults_v2.mat\n');

%% ═══════════════════════════════════════════════════════════════
%% 15. SUMMARY PRINTOUT
%% ═══════════════════════════════════════════════════════════════

fprintf('\n');
fprintf('╔══════════════════════════════════════════════════════╗\n');
fprintf('║         ANALYSIS SUMMARY (v2 — Corrected)           ║\n');
fprintf('╠══════════════════════════════════════════════════════╣\n');
fprintf('║ Experiment                                          ║\n');
fprintf('║   Frames:          %5d (%.1f s at %d fps)         ║\n', numFrames, time_s(end), fps);
fprintf('║   Vesicle radius:  %.2f um (%.0f px)               ║\n', R_mean_um, mean(radius_midline_mean));
fprintf('║   Exposure time:   %d ms                           ║\n', exposure_time_ms);
fprintf('╠══════════════════════════════════════════════════════╣\n');
fprintf('║ Heating Detection (%s)                          ║\n', detection_method);
fprintf('║   Cycles found:    %d                               ║\n', num_cycles);
for i = 1:num_cycles
fprintf('║   Cycle %d: %.1f–%.1f s (%.1f s, drift %.0f px)  ║\n', ...
    i, time_s(heatingCycles(i).onset), time_s(heatingCycles(i).offset), ...
    heatingCycles(i).duration_s, heatingCycles(i).drift_total);
end
fprintf('╠══════════════════════════════════════════════════════╣\n');
fprintf('║ Shape Changes                                       ║\n');
fprintf('║   Events found:    %d                               ║\n', num_shape_events);
fprintf('║   Roughness base:  %.5f                          ║\n', roughness_baseline);
fprintf('║   Roughness peak:  %.5f                          ║\n', max(roughness_smooth));
fprintf('║   Peak/base ratio: %.1fx                            ║\n', max(roughness_smooth)/roughness_baseline);
fprintf('╠══════════════════════════════════════════════════════╣\n');
fprintf('║ Reduced Volume                                      ║\n');
fprintf('║   Baseline v0:     %.4f                          ║\n', reduced_volume(1));
fprintf('║   Minimum v:       %.4f                          ║\n', min(reduced_volume));
fprintf('║   Max volume loss:  %.1f%%                          ║\n', ...
    100*(1 - min(reduced_volume_smooth)/reduced_volume_smooth(1)));
fprintf('║   Unreliable frames: %d (%.1f%%)                    ║\n', n_unreliable, 100*n_unreliable/numFrames);
fprintf('╠══════════════════════════════════════════════════════╣\n');
fprintf('║ Bending Rigidity                                    ║\n');
if fit_success_1
fprintf('║   Regime 1 (raw):       %.1f kBT                   ║\n', kappa_kBT_1);
fprintf('║   Regime 1 (corrected): %.1f kBT                   ║\n', kappa_corrected_kBT_1);
fprintf('║   Tension sigma:        %.1e N/m                ║\n', sigma_Nm_1);
end
if fit_success_3
fprintf('║   Regime 3 (raw):       %.1f kBT                   ║\n', kappa_kBT_3);
fprintf('║   Regime 3 (corrected): %.1f kBT                   ║\n', kappa_corrected_kBT_3);
end
fprintf('║   Literature DOPC:      20-27 kBT                   ║\n');
fprintf('╠══════════════════════════════════════════════════════╣\n');
fprintf('║ Corrections Applied                                 ║\n');
fprintf('║   [x] Area centroid (not geometric mean)            ║\n');
fprintf('║   [x] Mode indexing n=2..N (Helfrich convention)    ║\n');
fprintf('║   [x] Integration time (Pecreaux 2004)             ║\n');
fprintf('║   [x] White noise subtraction (Genova 2013)        ║\n');
fprintf('║   [x] Optical projection x%.1f (Rautu 2017)        ║\n', optical_projection_factor);
fprintf('║   [x] Helfrich spectrum fitting                     ║\n');
fprintf('║   [x] L-R asymmetry flagging for reduced volume    ║\n');
fprintf('║   [x] Adaptive GMM heating detection                ║\n');
fprintf('║   [x] Non-Gaussian kurtosis check (Sciortino 2025) ║\n');
fprintf('╚══════════════════════════════════════════════════════╝\n');

fprintf('\n=== Analysis Complete ===\n');

%% ═══════════════════════════════════════════════════════════════
%% LOCAL FUNCTIONS
%% ═══════════════════════════════════════════════════════════════

function [result, success] = fit_helfrich_regime(spectrum_data, fit_idx, ...
    physical_modes, helfrich_model_hat, R_m, kBT, projection_factor)
% FIT_HELFRICH_REGIME  Fit Helfrich fluctuation spectrum to one regime.
%
%   [result, success] = fit_helfrich_regime(spectrum_data, fit_idx,
%       physical_modes, helfrich_model_hat, R_m, kBT, projection_factor)
%
%   INPUTS:
%     spectrum_data     - Column vector of <|u_n|^2> for each physical mode
%     fit_idx           - Logical mask of which modes to fit
%     physical_modes    - Vector of mode numbers (e.g. [2, 3, ..., N])
%     helfrich_model_hat - Function handle @(params, n) returning
%                         dimensionless spectrum with params = [kappa_hat, sigma_bar]
%     R_m               - Mean vesicle radius in meters
%     kBT               - Thermal energy in Joules
%     projection_factor - Optical projection correction factor (~1.4)
%
%   OUTPUTS:
%     result  - Struct with fields: kappa_kBT, kappa_corrected_kBT,
%               sigma_bar, sigma_Nm, residual_norm
%     success - Boolean flag

    result  = struct('kappa_kBT', NaN, 'kappa_corrected_kBT', NaN, ...
                     'sigma_bar', NaN, 'sigma_Nm', NaN, 'residual_norm', NaN);
    success = false;

    % Extract fitting data
    n_fit = physical_modes(fit_idx);
    s_fit = spectrum_data(fit_idx);

    % Remove zero or negative values (can occur after noise subtraction)
    valid = s_fit > 0 & isfinite(s_fit);
    n_fit = n_fit(valid);
    s_fit = s_fit(valid);

    if length(n_fit) < 3
        fprintf('  Fit skipped: only %d valid data points\n', length(n_fit));
        return;
    end

    % --- Initial guesses ---
    % kappa_hat ~ 20 (DOPC), sigma_bar ~ 10
    p0 = [20, 10];

    % --- Bounds (dimensionless, both O(1)-O(100)) ---
    lb = [1,   0.01];   % kappa_hat >= 1 kBT, sigma_bar >= 0.01
    ub = [200, 5000];   % kappa_hat <= 200 kBT, sigma_bar <= 5000

    % --- Optimizer settings ---
    opts = optimoptions('lsqcurvefit', ...
        'Display',          'off', ...
        'MaxFunctionEvaluations', 2000, ...
        'MaxIterations',    500, ...
        'FunctionTolerance', 1e-12, ...
        'StepTolerance',    1e-10, ...
        'TypicalX',         [20, 10]);

    % --- Fit in log-space for better conditioning ---
    log_model = @(params, n) log(helfrich_model_hat(params, n));
    log_data  = log(s_fit);

    try
        [p_opt, resnorm, ~, exitflag] = lsqcurvefit( ...
            log_model, p0, n_fit, log_data, lb, ub, opts);

        if exitflag <= 0
            % Try different initial conditions
            p0_alt = [10, 1;  40, 50;  5, 100;  30, 5];
            for k = 1:size(p0_alt, 1)
                [p_try, rn_try, ~, ef_try] = lsqcurvefit( ...
                    log_model, p0_alt(k,:), n_fit, log_data, lb, ub, opts);
                if ef_try > 0 && rn_try < resnorm
                    p_opt    = p_try;
                    resnorm  = rn_try;
                    exitflag = ef_try;
                end
            end
        end

        if exitflag <= 0
            fprintf('  Fit did not converge (exitflag = %d)\n', exitflag);
            return;
        end

        % --- Check if solution hit bounds ---
        at_bound = false;
        bound_msg = '';
        if abs(p_opt(1) - lb(1)) < 0.1 || abs(p_opt(1) - ub(1)) < 1
            at_bound = true;
            bound_msg = [bound_msg, sprintf('kappa_hat=%.1f ', p_opt(1))];
        end
        if abs(p_opt(2) - lb(2)) < 0.01 || abs(p_opt(2) - ub(2)) < 10
            at_bound = true;
            bound_msg = [bound_msg, sprintf('sigma_bar=%.1f ', p_opt(2))];
        end
        if at_bound
            fprintf('  WARNING: Fit hit bounds for: %s\n', bound_msg);
        end

        % --- Convert to physical units ---
        kappa_kBT     = p_opt(1);                              % dimensionless
        kappa_corr    = kappa_kBT * projection_factor;         % projection-corrected
        sigma_bar     = p_opt(2);                              % dimensionless
        sigma_Nm      = sigma_bar * kappa_kBT * kBT / R_m^2;  % sigma = sigma_bar * kappa / R^2

        % --- Populate result ---
        result.kappa_kBT           = kappa_kBT;
        result.kappa_corrected_kBT = kappa_corr;
        result.sigma_bar           = sigma_bar;
        result.sigma_Nm            = sigma_Nm;
        result.residual_norm       = resnorm;
        success = true;

    catch ME
        fprintf('  Fit failed: %s\n', ME.message);
    end
end
