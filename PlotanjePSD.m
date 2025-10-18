clear; clc; close all;

N = 1024;             
SNR = -5;             
fs = 1;                

sig1 = fmlin(N);
sig1 = sig1 ./ max(abs(sig1));

whiteGen  = dsp.ColoredNoise('Color','white','SamplesPerFrame',N,'NumChannels',1);
pinkGen   = dsp.ColoredNoise('Color','pink','SamplesPerFrame',N,'NumChannels',1);
brownGen  = dsp.ColoredNoise('Color','brown','SamplesPerFrame',N,'NumChannels',1);
blueGen   = dsp.ColoredNoise('Color','blue','SamplesPerFrame',N,'NumChannels',1);
purpleGen = dsp.ColoredNoise('Color','purple','SamplesPerFrame',N,'NumChannels',1);

noiseTypes = {'white','pink','brown','blue','purple'};
noiseGenerators = {whiteGen, pinkGen, brownGen, blueGen, purpleGen};

figure('Units','normalized','Position',[0.05 0.05 0.9 0.8]);
tiledlayout(2,3,'Padding','compact','TileSpacing','compact');

for i = 1:length(noiseTypes)
    noise = noiseGenerators{i}();
    sig1n = sigmerge(sig1, noise, SNR);
    
    [PSD, f] = pwelch(sig1n, hamming(256), 128, 1024, fs);
    PSD = PSD / sum(PSD); 
    
    nexttile;
    plot(f, 10*log10(PSD), 'LineWidth', 1.3);
    grid on;
    axis tight;
    xlabel('Normalized frequency');
    ylabel('Power/Frequency [dB]');
    title(['PSD: fmlin + ' noiseTypes{i} ' noise (SNR=' num2str(SNR) ' dB)']);
end

nexttile;
[PSD_clean, f] = pwelch(sig1, hamming(256), 128, 1024, fs);
PSD_clean = PSD_clean / sum(PSD_clean);
plot(f, 10*log10(PSD_clean), 'LineWidth', 1.3);
grid on;
axis tight;
xlabel('Normalized frequency');
ylabel('Power/Frequency [dB]');
title('PSD: Clean fmlin signal');

sgtitle('Power Spectral Densities of fmlin Signal with Different Colored Noises');
