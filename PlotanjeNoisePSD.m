clear; clc; close all;

N = 1024;
fs = 1; 


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

    [PSD, f] = pwelch(noise, hamming(256), 128, 1024, fs);
    PSD = PSD / sum(PSD);  
    

    nexttile;
    plot(f, 10*log10(PSD), 'LineWidth', 1.4);
    grid on; axis tight;
    xlabel('Normalized frequency');
    ylabel('Power/Frequency [dB]');
    title(['PSD of ' noiseTypes{i} ' noise']);
end

nexttile;
axis off;

sgtitle('Power Spectral Densities of Colored Noises');
