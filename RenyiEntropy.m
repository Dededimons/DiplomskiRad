clear; clc; close all;

N = 1024;
pocetnaFrekvencija = 0; krajnjaFrekvencija = 0.5; 
brojSimulacija = 100;  
alphaRenyi = 3;  
SNR = [10, 5, 1]; 

pinkGen   = dsp.ColoredNoise('Color','pink','SamplesPerFrame',N,'NumChannels',1);
brownGen  = dsp.ColoredNoise('Color','brown','SamplesPerFrame',N,'NumChannels',1);
blueGen   = dsp.ColoredNoise('Color','blue','SamplesPerFrame',N,'NumChannels',1);
purpleGen = dsp.ColoredNoise('Color','purple','SamplesPerFrame',N,'NumChannels',1);

noiseTypes = {'white','pink','brown','blue','purple'};
signalTypes = {'fmlin','fmsin','fmpar'};

results = zeros(length(SNR), length(signalTypes)*length(noiseTypes));

for sType = 1:length(signalTypes)
    for nType = 1:length(noiseTypes)
        for indeks = 1:length(SNR)
            razinaSNR = SNR(indeks);
            vrijednostiRenyi = zeros(brojSimulacija,1);
            
            for simulacija = 1:brojSimulacija
                switch signalTypes{sType}
                    case 'fmlin'
                        signal = fmlin(N, pocetnaFrekvencija, krajnjaFrekvencija);
                    case 'fmsin'
                        signal = fmsin(N);
                    case 'fmpar'
                        p1 = [1, 0];  
                        p2 = [N/2, 0.25]; 
                        p3 = [N, 0.4]; 
                        [signal,~] = fmpar(N, p1, p2, p3);
                end
                
                switch noiseTypes{nType}
                    case 'white'
                        noise = noisecg(N);
                    case 'pink'
                        noise = pinkGen();
                    case 'brown'
                        noise = brownGen();
                    case 'blue'
                        noise = blueGen();
                    case 'purple'
                        noise = purpleGen();
                end
                
                noisySignal = sigmerge(signal, noise, razinaSNR);
                [PSD,~] = pwelch(noisySignal, hamming(256), 128, 1024, 1);
                PSD = PSD / sum(PSD);
                renyiVal = (1/(1-alphaRenyi)) * log(sum(PSD.^alphaRenyi));
                vrijednostiRenyi(simulacija) = renyiVal;
            end
            colIdx = (sType-1)*length(noiseTypes) + nType;
            results(indeks,colIdx) = mean(vrijednostiRenyi);
        end
    end
end

varNames = {};
for sType = 1:length(signalTypes)
    for nType = 1:length(noiseTypes)
        varNames{end+1} = [signalTypes{sType} '_' noiseTypes{nType}];
    end
end

T = array2table(results, 'VariableNames', varNames, 'RowNames', strcat("SNR_", string(SNR)));
disp(T);
