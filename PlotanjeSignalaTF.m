clear; clc; close all;

N = 1024;             
SNR = -5;              
h = tftb_window(61, 'hanning');

sig1 = fmlin(N);
sig1 = sig1 ./ max(abs(sig1));

whiteGen  = dsp.ColoredNoise('Color','white','SamplesPerFrame',N,'NumChannels',1);
pinkGen   = dsp.ColoredNoise('Color','pink','SamplesPerFrame',N,'NumChannels',1);
brownGen  = dsp.ColoredNoise('Color','brown','SamplesPerFrame',N,'NumChannels',1);
blueGen   = dsp.ColoredNoise('Color','blue','SamplesPerFrame',N,'NumChannels',1);
purpleGen = dsp.ColoredNoise('Color','purple','SamplesPerFrame',N,'NumChannels',1);

noiseTypes = {'white','pink','brown','blue','purple'};
noiseGenerators = {whiteGen, pinkGen, brownGen, blueGen, purpleGen};

figure('Units','normalized','Position',[0.05 0.05 0.9 0.85]);
tiledlayout(2,3,'Padding','compact','TileSpacing','compact');

for i = 1:length(noiseTypes)
    noise = noiseGenerators{i}();
    sig1n = sigmerge(sig1, noise, SNR);
    
    [tfr, ~, ~] = tfrsp(sig1n, 1:N, N, h);
    tfr = abs(tfr);
    tfr = tfr ./ max(tfr(:));

    f = linspace(0, 0.5, N/2 + 1);
    tfr_pos = tfr(1:N/2+1, :);
    
    nexttile;
    contour(1:N, f, tfr_pos, 40, 'LineWidth', 1);
    colormap(jet);
    axis tight;
    title(['amgauss + ' noiseTypes{i} ' noise (SNR=' num2str(SNR) ' dB)']);
    xlabel('Time [samples]');
    ylabel('Normalized frequency');
end

nexttile;
[tfr_clean, ~, ~] = tfrsp(sig1, 1:N, N, h);
tfr_clean = abs(tfr_clean) ./ max(abs(tfr_clean(:)));
f = linspace(0, 0.5, N/2 + 1);
tfr_pos = tfr_clean(1:N/2+1, :);
contour(1:N, f, tfr_pos, 40, 'LineWidth', 1);
colormap(jet);
axis tight;
title('Clean amgauss signal');
xlabel('Time [samples]');
ylabel('Normalized frequency');

sgtitle('Spectrograms of amgauss Signal with Different Colored Noises');
