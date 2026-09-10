clear; clc; close all;

N = 1024;
startFrequency = 0; endFrequency = 0.5;
numSimulations = 100;
SNR = [15, 10, 5, 1, -5];

pinkGen   = dsp.ColoredNoise('Color','pink',  'SamplesPerFrame',N,'NumChannels',1);
brownGen  = dsp.ColoredNoise('Color','brown', 'SamplesPerFrame',N,'NumChannels',1);
blueGen   = dsp.ColoredNoise('Color','blue',  'SamplesPerFrame',N,'NumChannels',1);
purpleGen = dsp.ColoredNoise('Color','purple','SamplesPerFrame',N,'NumChannels',1);
whiteGen  = dsp.ColoredNoise('Color','white', 'SamplesPerFrame',N,'NumChannels',1);

noiseTypes  = {'white','pink','brown','blue','purple'};
signalTypes = {'fmlin','fmsin','fmpar','amgauss'};

resultsPSD  = zeros(length(SNR), length(signalTypes)*length(noiseTypes));
resultsSpec = zeros(length(SNR), length(signalTypes)*length(noiseTypes));

for sType = 1:length(signalTypes)
    for nType = 1:length(noiseTypes)
        for idx = 1:length(SNR)
            currentSNR = SNR(idx);
            lzPSDvals  = zeros(numSimulations,1);
            lzSPECvals = zeros(numSimulations,1);

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

                PSD = pwelch(x, hamming(256), 128, 1024, 1);
                PSD = PSD / (sum(PSD) + eps);
                binaryPSD = double(PSD > median(PSD));
                lzPSDvals(sim) = kolmogorov(binaryPSD);

                [tfr, ~, ~] = tfrsp(x, 1:N, N);
                tfr_pos = abs(tfr(1:N/2+1, :));

                colIndices = round(linspace(1, N, 20));
                lzcols = zeros(length(colIndices), 1);
                for ci = 1:length(colIndices)
                    slice = tfr_pos(:, colIndices(ci));
                    slice = slice / (sum(slice) + eps);
                    binarySlice = double(slice > median(slice));
                    lzcols(ci) = kolmogorov(binarySlice);
                end
                lzSPECvals(sim) = mean(lzcols, 'omitnan');
            end

            colIdx = (sType-1)*length(noiseTypes) + nType;
            resultsPSD(idx, colIdx)  = mean(lzPSDvals,  'omitnan');
            resultsSpec(idx, colIdx) = mean(lzSPECvals, 'omitnan');
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

T_PSD  = array2table(resultsPSD,  'VariableNames', varNames, 'RowNames', rowNames);
T_spec = array2table(resultsSpec, 'VariableNames', varNames, 'RowNames', rowNames);

disp('Kolmogorov (Lempel-Ziv) complexity on PSD:');
disp(T_PSD);
disp('Kolmogorov (Lempel-Ziv) complexity on spectrogram:');
disp(T_spec);