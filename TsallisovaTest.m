clear; clc; close all;

% --- Parametri ---
N = 1024;                        % dužina signala
pocetnaFrekvencija = 0;          % početna frekvencija (normalized)
krajnjaFrekvencija = 0.5;        % krajnja frekvencija (normalized)
brojSimulacija = 100;            % broj Monte Carlo simulacija
alphaRenyi = 3;                  % red Renyi entropije
SNR = [10, 5, 1];                % SNR razine [dB]

% --- Memorija za rezultate ---
prosjecnaRenyi = zeros(length(SNR), 1);

% --- Glavna petlja preko SNR razina ---
for indeks = 1:length(SNR)
    razinaSNR = SNR(indeks);
    vrijednostiRenyi = zeros(brojSimulacija, 1);
    
    for simulacija = 1:brojSimulacija
        % 1. Generiranje linearnog FM signala
        signal = fmlin(N, pocetnaFrekvencija, krajnjaFrekvencija);
        
        % 2. Generiranje šuma i miješanje sa signalom (sigmerge održava SNR)
        sum = noisecg(N);
        noisySignal = sigmerge(signal, sum, razinaSNR);
        
        % 3. Procjena PSD-a (Power Spectral Density)
        [PSD, f] = pwelch(noisySignal, hamming(256), 128, 1024, 1);
        
        % 4. Normalizacija PSD-a u distribuciju vjerojatnosti
        PSD = PSD / sum(PSD);
        
        % 5. Računanje Renyi entropije
        p = PSD(PSD > 0); % izbjegavanje log(0)
        renyiVal = (1/(1 - alphaRenyi)) * log(sum(p.^alphaRenyi));
        
        % 6. Spremanje rezultata za ovu simulaciju
        vrijednostiRenyi(simulacija) = renyiVal;
    end
    
    % 7. Prosjek entropije za ovu SNR razinu
    prosjecnaRenyi(indeks) = mean(vrijednostiRenyi);
end

% --- Prikaz rezultata ---
disp('Prosječne Renyi entropije za različite SNR:');
disp(table(SNR.', prosjecnaRenyi, 'VariableNames', {'SNR_dB','RenyiEntropy'}));

figure;
bar(SNR, prosjecnaRenyi);
xlabel('SNR [dB]');
ylabel(['Renyi entropija (\alpha = ' num2str(alphaRenyi) ')']);
title('Prosječna Renyi entropija PSD-a za različite SNR razine');
grid on;