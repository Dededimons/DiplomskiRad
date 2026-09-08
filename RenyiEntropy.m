clear; clc; close all;

N = 1024;
startFrequency = 0; endFrequency = 0.5;
numSimulations = 100;
alphaRenyi = 3;
SNR = [15, 10, 5, 1, -5];

pinkGen   = dsp.ColoredNoise('Color','pink',  'SamplesPerFrame',N,'NumChannels',1);
brownGen  = dsp.ColoredNoise('Color','brown', 'SamplesPerFrame',N,'NumChannels',1);
blueGen   = dsp.ColoredNoise('Color','blue',  'SamplesPerFrame',N,'NumChannels',1);
purpleGen = dsp.ColoredNoise('Color','purple','SamplesPerFrame',N,'NumChannels',1);
whiteGen  = dsp.ColoredNoise('Color','white', 'SamplesPerFrame',N,'NumChannels',1);

noiseTypes  = {'white','pink','brown','blue','purple'};
signalTypes = {'fmlin','fmsin','fmpar','amgauss'};

resultsPSD      = zeros(length(SNR), length(signalTypes)*length(noiseTypes));
resultsSpecRenyi = zeros(length(SNR), length(signalTypes)*length(noiseTypes));

for sType = 1:length(signalTypes)
    for nType = 1:length(noiseTypes)
        for idx = 1:length(SNR)
            currentSNR = SNR(idx);
            renyiPSDvals  = zeros(numSimulations,1);
            renyiSPECvals = zeros(numSimulations,1);

            for sim = 1:numSimulations
                switch signalTypes{sType}
                    case 'fmlin'
                        signal = fmlin(N, startFrequency, endFrequency);
                    case 'fmsin'
                        signal = fmsin(N);
                    case 'fmpar'
                        p1 = [1, 0];
                        p2 = [N/2, 0.25];
                        p3 = [N, 0.4];
                        signal = fmpar(N, p1, p2, p3);
                    case 'amgauss'
                        signal = amgauss(N, N/2, 30);
                end

                switch noiseTypes{nType}
                    case 'white',  noise = whiteGen();
                    case 'pink',   noise = pinkGen();
                    case 'brown',  noise = brownGen();
                    case 'blue',   noise = blueGen();
                    case 'purple', noise = purpleGen();
                end

                x = sigmerge(signal, noise, currentSNR);

                [PSD, ~] = pwelch(x, hamming(256), 128, 1024, 1);
                PSD = PSD / (sum(PSD) + eps);
                renyiPSDvals(sim) = (1/(1-alphaRenyi)) * log(sum(PSD.^alphaRenyi));

                [tfr, t, f] = tfrsp(x, 1:N, N);
                renyiSPECvals(sim) = renyi(tfr, t, f, alphaRenyi);
            end

            colIdx = (sType-1)*length(noiseTypes) + nType;
            resultsPSD(idx, colIdx)      = mean(renyiPSDvals,  'omitnan');
            resultsSpecRenyi(idx, colIdx) = mean(renyiSPECvals, 'omitnan');
        end
    end
end

varNames = {};
for sType = 1:length(signalTypes)
    for nType = 1:length(noiseTypes)
        varNames{end+1} = [signalTypes{sType} '_' noiseTypes{nType}];
    end
end
rowNames = strcat("SNR_", string(SNR));

T           = array2table(resultsPSD,        'VariableNames', varNames, 'RowNames', rowNames);
T_specRenyi = array2table(resultsSpecRenyi,  'VariableNames', varNames, 'RowNames', rowNames);

disp('Rényi entropy on PSD:');
disp(T);
disp('Rényi entropy on spectrogram (TFTB renyi()):');
disp(T_specRenyi);