clearvars; clc; close all;

%% Load

S           = load('contourExtraction_hybrid_fixed.mat', 'allContours', 'angles');
allContours = S.allContours;
angles      = S.angles;
numFrames   = length(allContours);
frameNumbers = 1:numFrames;

%% Basic Metrics

circularity = zeros(numFrames,1);
area        = zeros(numFrames,1);
perimeter   = zeros(numFrames,1);

for iFrame = 1:numFrames
    x = [allContours(iFrame).x_midline; allContours(iFrame).x_midline(1)];
    y = [allContours(iFrame).y_midline; allContours(iFrame).y_midline(1)];
    dx = diff(x); dy = diff(y);
    area(iFrame)        = polyarea(x,y);
    perimeter(iFrame)   = sum(sqrt(dx.^2+dy.^2));
    circularity(iFrame) = 4*pi*area(iFrame)/perimeter(iFrame)^2;
end

xCM = zeros(numFrames,1); yCM = zeros(numFrames,1);
for iFrame = 1:numFrames
    xCM(iFrame) = mean(allContours(iFrame).x_midline);
    yCM(iFrame) = mean(allContours(iFrame).y_midline);
end
drift_x         = xCM - xCM(1);
drift_y         = yCM - yCM(1);
drift_magnitude = sqrt(drift_x.^2 + drift_y.^2);
total_drift     = drift_magnitude(end);

radius_inner_mean   = zeros(numFrames,1);
radius_midline_mean = zeros(numFrames,1);
radius_outer_mean   = zeros(numFrames,1);
roughness           = zeros(numFrames,1);

for iFrame = 1:numFrames
    r = allContours(iFrame).r_midline_smooth;
    radius_inner_mean(iFrame)   = mean(allContours(iFrame).r_inner_smooth);
    radius_midline_mean(iFrame) = mean(r);
    radius_outer_mean(iFrame)   = mean(allContours(iFrame).r_outer_smooth);
    roughness(iFrame)           = std(r)/mean(r);
end

delta_radius_inner    = radius_inner_mean    - radius_inner_mean(1);
delta_radius_midline  = radius_midline_mean  - radius_midline_mean(1);
delta_radius_outer    = radius_outer_mean    - radius_outer_mean(1);

%% Smoothing

sw = 50;
circularity_smooth  = smoothdata(circularity,         'gaussian', sw);
radius_smooth       = smoothdata(radius_midline_mean, 'gaussian', sw);
roughness_smooth    = smoothdata(roughness,           'gaussian', sw);
drift_smooth        = smoothdata(drift_magnitude,     'gaussian', 100);
drift_rate          = gradient(drift_smooth);
drift_rate_smooth   = smoothdata(drift_rate,          'gaussian', 30);
dCirc_dt            = gradient(circularity_smooth);

%% ── Drift Detection ──────────────────────────────────────────────────────────

fprintf('\n=== Drift Detection ===\n');

baseline_drift_rate = median(drift_rate);
noise_level         = std(drift_rate(1:min(100,numFrames)));
threshold_active    = max(baseline_drift_rate + 3*noise_level, 0.03);

fprintf('Drift rate baseline : %.4f px/frame\n', baseline_drift_rate);
fprintf('Noise level         : %.4f px/frame\n', noise_level);
fprintf('Heating threshold   : %.4f px/frame\n', threshold_active);

active_heating        = drift_rate > threshold_active;
active_heating_smooth = smoothdata(double(active_heating),'gaussian',20) > 0.5;

heat_starts = find(diff([0; active_heating_smooth]) ==  1);
heat_ends   = find(diff([active_heating_smooth; 0]) == -1);

min_duration      = 100;
min_total_drift   = 10;
durations         = heat_ends - heat_starts + 1;
total_drift_cyc   = drift_magnitude(heat_ends) - drift_magnitude(heat_starts);
ok                = (durations >= min_duration) & (total_drift_cyc >= min_total_drift);
zones_drift       = [heat_starts(ok), heat_ends(ok)];

if size(zones_drift,1) > 1
    merged = zones_drift(1,:);
    for k = 2:size(zones_drift,1)
        if zones_drift(k,1) - merged(end,2) < 300
            merged(end,2) = zones_drift(k,2);
        else
            merged = [merged; zones_drift(k,:)]; %#ok<AGROW>
        end
    end
    zones_drift = merged;
end

fprintf('Drift events detected: %d\n', size(zones_drift,1));
for k = 1:size(zones_drift,1)
    fprintf('  D%d: frames %d – %d\n', k, zones_drift(k,1), zones_drift(k,2));
end

% Build heating mask
heating_mask = false(numFrames,1);
for k = 1:size(zones_drift,1)
    heating_mask(zones_drift(k,1):zones_drift(k,2)) = true;
end

%% ── Roughness / Shape-Change Detection ──────────────────────────────────────

fprintf('\n=== Shape-Change Detection ===\n');

% Baseline from first 500 frames (pre-heating protocol)
initial_win  = min(500, numFrames);
initial_mean = mean(roughness_smooth(1:initial_win));
initial_std  = max(std(roughness_smooth(1:initial_win)), 0.001);
range_hi     = initial_mean + 3*initial_std;
range_lo     = initial_mean - 3*initial_std;

fprintf('Roughness baseline  : %.5f\n', initial_mean);
fprintf('Roughness range     : [%.5f, %.5f]\n', range_lo, range_hi);

% Detect excursions outside baseline band, excluding drift zones
outside        = (roughness_smooth < range_lo) | (roughness_smooth > range_hi);
outside_clean  = smoothdata(double(outside & ~heating_mask),'gaussian',20) > 0.5;

r_starts = find(diff([0; outside_clean]) ==  1);
r_ends   = find(diff([outside_clean; 0]) == -1);

zones_rough = [];
for k = 1:length(r_starts)
    if (r_ends(k) - r_starts(k) + 1) < 200, continue; end
    zones_rough = [zones_rough; r_starts(k), r_ends(k)]; %#ok<AGROW>
end

% Merge nearby roughness events
if size(zones_rough,1) > 1
    merged_r = zones_rough(1,:);
    for k = 2:size(zones_rough,1)
        if zones_rough(k,1) - merged_r(end,2) < 100
            merged_r(end,2) = zones_rough(k,2);
        else
            merged_r = [merged_r; zones_rough(k,:)]; %#ok<AGROW>
        end
    end
    zones_rough = merged_r;
end

num_shape_events = size(zones_rough,1);
fprintf('Shape-change events: %d\n', num_shape_events);
for k = 1:num_shape_events
    fprintf('  S%d: frames %d – %d  (duration: %d frames)\n', ...
        k, zones_rough(k,1), zones_rough(k,2), zones_rough(k,2)-zones_rough(k,1)+1);
end

% Build shape-change mask (excludes drift zones)
shape_change_mask = false(numFrames,1);
for k = 1:num_shape_events
    shape_change_mask(zones_rough(k,1):zones_rough(k,2)) = true;
end

%% ── Regime Classification ─────────────────────────────────────────────────

fprintf('\n=== Regime Classification ===\n');

% Regime 1: no heating, roughness within baseline band
% Regime 2: shape change (roughness outside band, not during drift)
% Regime 3: active heating / drift
regime = ones(numFrames,1);
regime(heating_mask)      = 3;
regime(shape_change_mask) = 2;   % overrides heating for shape-change frames

mask_no_heating     = (regime == 1);
mask_shape_change   = (regime == 2);
mask_heating_steady = (regime == 3);

fprintf('Regime 1 (No heating):      %d frames (%.1f%%)\n', ...
    sum(mask_no_heating),     100*sum(mask_no_heating)/numFrames);
fprintf('Regime 2 (Shape change):    %d frames (%.1f%%)\n', ...
    sum(mask_shape_change),   100*sum(mask_shape_change)/numFrames);
fprintf('Regime 3 (Heating/drift):   %d frames (%.1f%%)\n', ...
    sum(mask_heating_steady), 100*sum(mask_heating_steady)/numFrames);

%% ── Heating Cycles Struct ─────────────────────────────────────────────────

all_zones   = [zones_drift; zones_rough];
all_origins = [repmat({'drift'},    size(zones_drift,1),1); ...
               repmat({'roughness'},size(zones_rough, 1),1)];
[~,si]      = sort(all_zones(:,1));
all_zones   = all_zones(si,:);
all_origins = all_origins(si);
num_cycles  = size(all_zones,1);

heatingCycles = struct('id',{},'onset',{},'offset',{},'duration',{}, ...
    'origin',{},'drift_total',{},'rough_change',{},'circ_change',{}, ...
    'rad_change',{},'v_pre',{},'v_post',{},'v_change',{});

fprintf('\nFinal events:\n');
colors_cycle = [0.9 0.3 0.3; 0.3 0.3 0.9; 0.3 0.8 0.3; 0.8 0.3 0.8];

for i = 1:num_cycles
    onset  = all_zones(i,1); offset = all_zones(i,2);
    pre    = max(1,onset-50):onset-1;
    post   = offset+1:min(numFrames,offset+50);

    heatingCycles(i).id          = i;
    heatingCycles(i).onset       = onset;
    heatingCycles(i).offset      = offset;
    heatingCycles(i).duration    = offset-onset+1;
    heatingCycles(i).origin      = all_origins{i};
    heatingCycles(i).drift_total = drift_magnitude(offset)-drift_magnitude(onset);
    heatingCycles(i).rough_change= nanmean(roughness_smooth(post)) - nanmean(roughness_smooth(pre));
    heatingCycles(i).circ_change = nanmean(circularity_smooth(post)) - nanmean(circularity_smooth(pre));
    heatingCycles(i).rad_change  = nanmean(radius_smooth(post)) - nanmean(radius_smooth(pre));

    fprintf('  Ev%d: %d-%d  [%s]  drift=%+.1fpx  drough=%+.5f\n', ...
        i, onset, offset, all_origins{i}, ...
        heatingCycles(i).drift_total, heatingCycles(i).rough_change);
end

ev_labels = arrayfun(@(i) sprintf('Ev%d (%s)', i, heatingCycles(i).origin), ...
    1:num_cycles, 'UniformOutput', false);

%% ── Figure 1: Overview (4 panels) ────────────────────────────────────────

col_no_heating     = [0.6 0.6 0.6];
col_shape_change   = [0.9 0.3 0.3];
col_heating_steady = [1.0 0.6 0.2];

fig1 = figure('Units','centimeters','Position',[3 3 24 28],'Color','w');
tl1  = tiledlayout(fig1, 4, 1,'TileSpacing','compact','Padding','compact');

% Circularity
[~,ax] = quickPlot('Parent',nexttile(tl1),'Grid','on');
plot(ax,frameNumbers,circularity_smooth,'Color',col_no_heating,'LineWidth',1.5);
for i = 1:num_cycles
    idx = heatingCycles(i).onset:heatingCycles(i).offset;
    plot(ax,idx,circularity_smooth(idx),'Color',colors_cycle(mod(i-1,4)+1,:),'LineWidth',3);
end
ylabel(ax,'Circularity');
legend(ax,[{'Baseline'}, ev_labels],'Interpreter','none','Box','off','FontSize',9,'Location','best');

% Drift magnitude
[~,ax] = quickPlot('Parent',nexttile(tl1),'Grid','on');
plot(ax,frameNumbers,drift_magnitude,'Color',[0.85 0.85 0.85],'LineWidth',1);
plot(ax,frameNumbers,drift_smooth,'Color',col_no_heating,'LineWidth',2);
for i = 1:num_cycles
    idx = heatingCycles(i).onset:heatingCycles(i).offset;
    plot(ax,idx,drift_smooth(idx),'Color',colors_cycle(mod(i-1,4)+1,:),'LineWidth',3);
end
ylabel(ax,'Drift (px)');

% Drift rate
[~,ax] = quickPlot('Parent',nexttile(tl1),'Grid','on');
plot(ax,frameNumbers,drift_rate_smooth,'Color',col_no_heating,'LineWidth',1.5);
for i = 1:num_cycles
    idx = heatingCycles(i).onset:heatingCycles(i).offset;
    plot(ax,idx,drift_rate_smooth(idx),'Color',colors_cycle(mod(i-1,4)+1,:),'LineWidth',3);
end
yline(threshold_active,'r--','LineWidth',1.5,'Label',sprintf('thr=%.3f',threshold_active));
yline(0,'k:','LineWidth',1);
ylabel(ax,'Drift Rate (px/fr)');

% Roughness
[~,ax] = quickPlot('Parent',nexttile(tl1),'Grid','on');
plot(ax,frameNumbers,roughness_smooth,'Color',col_no_heating,'LineWidth',1.5);
for i = 1:num_cycles
    idx = heatingCycles(i).onset:heatingCycles(i).offset;
    plot(ax,idx,roughness_smooth(idx),'Color',colors_cycle(mod(i-1,4)+1,:),'LineWidth',3);
end
yline(range_hi,'r--','LineWidth',1.5,'Label',sprintf('hi=%.4f',range_hi));
yline(range_lo,'b--','LineWidth',1.5,'Label',sprintf('lo=%.4f',range_lo));
yline(initial_mean,'k:','LineWidth',1);
ylabel(ax,'Roughness'); xlabel(ax,'Frame');

savefigures_new(fig1,'fig1_overview');

%% ── Reduced Volume + Fourier ──────────────────────────────────────────────

pixels_per_micron = 11.5;
pixel_size_um     = 1/pixels_per_micron;

reduced_volume = zeros(numFrames,1);
eccentricity   = zeros(numFrames,1);
volume_um3     = zeros(numFrames,1);
area_um2       = zeros(numFrames,1);
R0_values      = zeros(numFrames,1);
nFourierModes  = 30;
amp_sq_mid     = zeros(numFrames,nFourierModes);

for iFrame = 1:numFrames
    x_px = allContours(iFrame).x_midline;
    y_px = allContours(iFrame).y_midline;
    x_c  = x_px*pixel_size_um - mean(x_px*pixel_size_um);
    y_c  = y_px*pixel_size_um - mean(y_px*pixel_size_um);

    [coeff,~,latent]     = pca([x_c(:), y_c(:)]);
    eccentricity(iFrame) = 1 - sqrt(latent(2)/latent(1));
    th    = atan2(coeff(2,1),coeff(1,1));
    x_rot = x_c*cos(-th) - y_c*sin(-th);
    y_rot = x_c*sin(-th) + y_c*cos(-th);

    % Right-half profile for axisymmetric volume
    ir = x_rot >= 0;
    [yp,si] = sort(y_rot(ir)); rp = x_rot(ir); rp = rp(si);
    [yu,~,ic] = uniquetol(yp,1e-6);
    ru = zeros(size(yu));
    for k = 1:length(yu), ru(k) = max(rp(ic==k)); end
    dy = diff(yu); rm = (ru(1:end-1)+ru(2:end))/2;
    V  = sum(pi*rm.^2.*dy);
    dr = diff(ru); ds = sqrt(dr.^2+dy.^2);
    A  = sum(2*pi*rm.*ds);
    R0 = sqrt(A/(4*pi));
    rv = V/((4/3)*pi*R0^3);
    if rv > 1 || rv <= 0, rv = NaN; end
    volume_um3(iFrame)     = V;
    area_um2(iFrame)       = A;
    R0_values(iFrame)      = R0;
    reduced_volume(iFrame) = rv;

    % Fourier (factor of 2 for two-sided spectrum)
    r       = allContours(iFrame).r_midline_smooth(:);
    r_fluct = r - mean(r);
    N       = length(r_fluct);
    u_n     = fft(r_fluct)/N;
    amp_sq_mid(iFrame,:) = 2*abs(u_n(2:nFourierModes+1)).^2 * pixel_size_um^2;
end

rv_smooth = smoothdata(reduced_volume,'gaussian',sw,'omitnan');

% Update heatingCycles with reduced volume
for i = 1:num_cycles
    pre  = max(1,heatingCycles(i).onset-50):heatingCycles(i).onset-1;
    post = heatingCycles(i).offset+1:min(numFrames,heatingCycles(i).offset+50);
    heatingCycles(i).v_pre    = nanmean(rv_smooth(pre));
    heatingCycles(i).v_post   = nanmean(rv_smooth(post));
    heatingCycles(i).v_change = heatingCycles(i).v_post - heatingCycles(i).v_pre;
end

%% ── Fourier spectra by regime ─────────────────────────────────────────────
% Regime 1 (No heating) = pre-heating baseline + any post-event recovery
% Regime 2 (Shape change) = roughness outside band, not during drift
% Regime 3 (Heating/drift) = active drift frames

modes = (1:nFourierModes)';

spectrum_regime1 = mean(amp_sq_mid(mask_no_heating,     :), 1)';
spectrum_regime2 = mean(amp_sq_mid(mask_shape_change,   :), 1)';
spectrum_regime3 = mean(amp_sq_mid(mask_heating_steady, :), 1)';

% Suppress spectra with too few frames
if sum(mask_no_heating)     < 5, spectrum_regime1 = NaN(nFourierModes,1); end
if sum(mask_shape_change)   < 5, spectrum_regime2 = NaN(nFourierModes,1); end
if sum(mask_heating_steady) < 5, spectrum_regime3 = NaN(nFourierModes,1); end

fprintf('\nFourier frame counts:\n');
fprintf('  Regime 1 (No heating)   : %d frames\n', sum(mask_no_heating));
fprintf('  Regime 2 (Shape change) : %d frames\n', sum(mask_shape_change));
fprintf('  Regime 3 (Heating)      : %d frames\n', sum(mask_heating_steady));

%% ── Figure 2: Fourier Spectra ────────────────────────────────────────────

fig2 = figure('Units','centimeters','Position',[3 3 16 14],'Color','w');
tl2  = tiledlayout(fig2,1,1,'TileSpacing','compact','Padding','compact');

[~,ax] = quickPlot('Parent',nexttile(tl2),'Grid','off');
set(ax,'XScale','log','YScale','log');

h = gobjects(0); leg_labels = {};

if ~all(isnan(spectrum_regime1))
    h(end+1) = loglog(ax,modes,spectrum_regime1,'o-','Color',col_no_heating, ...
        'MarkerFaceColor',col_no_heating,'LineWidth',2,'MarkerSize',6);
    leg_labels{end+1} = 'No heating';
end
if ~all(isnan(spectrum_regime2))
    h(end+1) = loglog(ax,modes,spectrum_regime2,'s-','Color',col_shape_change, ...
        'MarkerFaceColor',col_shape_change,'LineWidth',2,'MarkerSize',6);
    leg_labels{end+1} = 'Shape change';
end
if ~all(isnan(spectrum_regime3))
    h(end+1) = loglog(ax,modes,spectrum_regime3,'d-','Color',col_heating_steady, ...
        'MarkerFaceColor',col_heating_steady,'LineWidth',2,'MarkerSize',6);
    leg_labels{end+1} = 'Heating';
end

% Power-law references anchored to regime 1 (or first valid spectrum)
ref_spec = spectrum_regime1;
if all(isnan(ref_spec)), ref_spec = spectrum_regime2; end
if ~all(isnan(ref_spec))
    n0 = 10; S0 = ref_spec(n0); rn = [2; nFourierModes];
    h4 = loglog(ax,rn,S0*(rn/n0).^(-4),'k-', 'LineWidth',1.5);
    h3 = loglog(ax,rn,S0*(rn/n0).^(-3),'k:', 'LineWidth',1.5);
    h2 = loglog(ax,rn,S0*(rn/n0).^(-2),'k--','LineWidth',1.5);
    h = [h, h4, h3, h2];
    leg_labels = [leg_labels, {'$n^{-4}$ (bending)','$n^{-3}$ (mixed)','$n^{-2}$ (tension)'}];
end

xlabel(ax,'Mode $n$'); ylabel(ax,'$\langle|u_n|^2\rangle$ ($\mu$m$^2$)');
xlim(ax,[1 nFourierModes]);
legend(ax,h,leg_labels,'Interpreter','latex','Box','off','FontSize',10,'Location','southwest');

savefigures_new(fig2,'fig2_fourier');

%% ── Figure 3: Full 5-panel Detection Overview ────────────────────────────

fig3 = figure('Units','centimeters','Position',[3 3 30 28],'Color','w');
tl3  = tiledlayout(fig3,5,1,'TileSpacing','compact','Padding','compact');

panel_data = { ...
    circularity_smooth,  'Circularity'; ...
    radius_midline_mean, 'Radius (px)'; ...
    drift_smooth,        'Drift (px)'; ...
    drift_rate_smooth,   'Drift Rate (px/fr)'; ...
    roughness_smooth,    'Roughness'};

for p = 1:5
    [~,ax] = quickPlot('Parent',nexttile(tl3),'Grid','on');
    sig = panel_data{p,1};

    % Colour each regime
    plot(ax,frameNumbers,sig,'Color',col_no_heating,'LineWidth',1.5);
    for i = 1:num_shape_events
        idx = zones_rough(i,1):zones_rough(i,2);
        plot(ax,idx,sig(idx),'-','Color',col_shape_change,'LineWidth',3);
    end
    for k = 1:size(zones_drift,1)
        idx = zones_drift(k,1):zones_drift(k,2);
        plot(ax,idx,sig(idx),'-','Color',col_heating_steady,'LineWidth',3);
    end

    ylabel(ax,panel_data{p,2});

    if p == 4
        yline(threshold_active,'r--','LineWidth',1.5, ...
            'Label',sprintf('thr=%.3f',threshold_active));
        yline(0,'k:','LineWidth',1);
    end
    if p == 5
        yline(range_hi,'r--','LineWidth',1.5,'Label',sprintf('hi=%.4f',range_hi));
        yline(range_lo,'b--','LineWidth',1.5,'Label',sprintf('lo=%.4f',range_lo));
        yline(initial_mean,'k:','LineWidth',1);
        xlabel(ax,'Frame');
    end
end

% Legend on first panel
nexttile(tl3,1);
legend({'No heating','Shape change','Heating / drift'}, ...
    'Interpreter','none','Box','off','FontSize',10,'Location','best');

savefigures_new(fig3,'fig3_detection');

%% ── Save ──────────────────────────────────────────────────────────────────

% Representative frames per regime
regime1_frames = find(mask_no_heating);
regime2_frames = find(mask_shape_change);
regime3_frames = find(mask_heating_steady);

pick_rep = @(fr,n) fr(round(linspace(1,length(fr),min(n,length(fr)))));
regime1_rep = pick_rep(regime1_frames,6);
regime2_rep = pick_rep(regime2_frames,6);
regime3_rep = pick_rep(regime3_frames,6);

analysisResults = struct();

% Regime masks
analysisResults.masks.no_heating     = mask_no_heating;
analysisResults.masks.shape_change   = mask_shape_change;
analysisResults.masks.heating_steady = mask_heating_steady;

% Representative frames
analysisResults.representative_frames.regime1 = regime1_rep;
analysisResults.representative_frames.regime2 = regime2_rep;
analysisResults.representative_frames.regime3 = regime3_rep;

% Labels & colors
analysisResults.labels.regime1 = 'No Heating';
analysisResults.labels.regime2 = 'Shape Change';
analysisResults.labels.regime3 = 'Heating / Drift';
analysisResults.colors.regime1 = col_no_heating;
analysisResults.colors.regime2 = col_shape_change;
analysisResults.colors.regime3 = col_heating_steady;

% Time series
analysisResults.timeseries.circ           = circularity_smooth;
analysisResults.timeseries.radius         = radius_midline_mean;
analysisResults.timeseries.drift          = drift_smooth;
analysisResults.timeseries.roughness      = roughness_smooth;
analysisResults.timeseries.reduced_volume = rv_smooth;

% Events
analysisResults.heatingCycles          = heatingCycles;
analysisResults.shapeEvents.zones      = zones_rough;
analysisResults.shapeEvents.range_hi   = range_hi;
analysisResults.shapeEvents.range_lo   = range_lo;
analysisResults.shapeEvents.baseline   = initial_mean;
analysisResults.detection.thresh_drift = threshold_active;

% Fourier
analysisResults.fourier.modes          = modes;
analysisResults.fourier.spectrum_no_heating     = spectrum_regime1;
analysisResults.fourier.spectrum_shape_change   = spectrum_regime2;
analysisResults.fourier.spectrum_heating        = spectrum_regime3;

% Metadata
analysisResults.metadata.numFrames          = numFrames;
analysisResults.metadata.pixels_per_micron  = pixels_per_micron;
analysisResults.metadata.angles             = angles;
analysisResults.metadata.date               = datetime('now');

save('analysisResults.mat','analysisResults','-v7.3');

fprintf('\nSummary:\n');
fprintf('  Regime 1 representative frames: %d\n', length(regime1_rep));
fprintf('  Regime 2 representative frames: %d\n', length(regime2_rep));
fprintf('  Regime 3 representative frames: %d\n', length(regime3_rep));
fprintf('Done.\n');