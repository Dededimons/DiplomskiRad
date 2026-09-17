clear; clc; close all;

rng(42);
N = 1024;

sig_fmlin   = fmlin(N, 0, 0.5);
sig_fmsin   = fmsin(N);
sig_fmpar   = fmpar(N, [1,0], [N/2,0.25], [N,0.4]);
sig_amgauss = amgauss(N, N/2, 30);

signals = {sig_fmlin, sig_fmsin, sig_fmpar, sig_amgauss};
names   = {'fmlin - Linearna modulacija', ...
           'fmsin - Sinusoidna modulacija', ...
           'fmpar - Parabolična modulacija', ...
           'amgauss - Gaussova amplitudna modulacija'};

figure('Units','normalized','Position',[0.05 0.05 0.9 0.85]);
tiledlayout(2, 2, 'Padding','compact', 'TileSpacing','compact');

for i = 1:4
    nexttile;
    plot(real(signals{i}), 'LineWidth', 1);
    axis tight;
    title(names{i});
    xlabel('Vrijeme [uzorci]');
    ylabel('Amplituda');
end

sgtitle('Generirani signali');

%% 


clear; clc; close all;

N = 1024;
h = tftb_window(61, 'hanning');

sig_fmlin   = fmlin(N, 0, 0.5);
sig_fmsin   = fmsin(N);
sig_fmpar   = fmpar(N, [1,0], [N/2,0.25], [N,0.4]);
sig_amgauss = amgauss(N, N/2, 30);

signals = {sig_fmlin, sig_fmsin, sig_fmpar, sig_amgauss};
names   = {'fmlin - Linearna modulacija', ...
           'fmsin - Sinusoidna modulacija', ...
           'fmpar - Parabolična modulacija', ...
           'amgauss - Gaussova amplitudna modulacija'};

f = linspace(0, 0.5, N/2 + 1);

figure('Units','normalized','Position',[0.05 0.05 0.9 0.85]);
tiledlayout(2, 2, 'Padding','compact', 'TileSpacing','compact');

for i = 1:4
    [tfr, ~, ~] = tfrsp(signals{i}, 1:N, N, h);
    tfr_pos = abs(tfr(1:N/2+1, :));
    tfr_pos = tfr_pos ./ max(tfr_pos(:));

    nexttile;
    contourf(1:N, f, tfr_pos, 40, 'LineColor', 'none');
    colormap(jet);
    axis tight;
    title(names{i});
    xlabel('Vrijeme [uzorci]');
    ylabel('Normalizirana frekvencija');
end

sgtitle('Vremensko-frekvencijski prikaz generiranih signala');

%% 
clear; clc; close all;

N  = 1024;
fs = 1;

whiteGen  = dsp.ColoredNoise('Color','white', 'SamplesPerFrame',N,'NumChannels',1);
pinkGen   = dsp.ColoredNoise('Color','pink',  'SamplesPerFrame',N,'NumChannels',1);
brownGen  = dsp.ColoredNoise('Color','brown', 'SamplesPerFrame',N,'NumChannels',1);
blueGen   = dsp.ColoredNoise('Color','blue',  'SamplesPerFrame',N,'NumChannels',1);
purpleGen = dsp.ColoredNoise('Color','purple','SamplesPerFrame',N,'NumChannels',1);

noiseTypes      = {'bijeli','ruzicasti','smedi','plavi','ljubicasti'};
noiseGenerators = {whiteGen, pinkGen, brownGen, blueGen, purpleGen};

% common y-axis limits so the slopes are comparable across figures
allPSD = cell(1,5);
for i = 1:5
    noise = noiseGenerators{i}();
    [PSD, f] = pwelch(noise, hamming(256), 128, 1024, fs);
    allPSD{i} = PSD / sum(PSD);
end
yAll = cellfun(@(p) 10*log10(p), allPSD, 'UniformOutput', false);
yMin = min(cellfun(@(y) min(y), yAll));
yMax = max(cellfun(@(y) max(y), yAll));

[~, f] = pwelch(noiseGenerators{1}(), hamming(256), 128, 1024, fs);

for i = 1:5
    figure('Units','normalized','Position',[0.2 0.2 0.5 0.45]);
    plot(f, 10*log10(allPSD{i}), 'LineWidth', 1.4);
    grid on;
    xlim([min(f) max(f)]);
    ylim([yMin-2 yMax+2]);
    xlabel('Normalizirana frekvencija');
    ylabel('Snaga/frekvencija [dB]');
    title(['Gustoca spektra snage - ' noiseTypes{i} ' sum']);
end

%% 
clear; clc; close all;

N = 1024;
whiteGen = dsp.ColoredNoise('Color','white', 'SamplesPerFrame',N,'NumChannels',1);

figure;
tiledlayout(5,1,'Padding','compact','TileSpacing','compact');

for i = 1:5
    noise = whiteGen();
    nexttile;
    plot(noise);
    title(['Realizacija ' num2str(i)]);
    xlabel('Uzorak');
    ylabel('Amplituda');
end