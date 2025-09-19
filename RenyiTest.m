clear; clc; close all;

%Linearna modulacija
N = 1024;
pocetnaFrekvencija = 0; krajnjaFrekvencija = 0.5; 
brojSimulacija = 100;  
alphaRenyi = 3;  
SNR = [10, 5, 1]; 

prosjecnaRenyi = zeros(length(SNR), 1);

for indeks = 1:length(SNR)
    razinaSNR = SNR(indeks);
    vrijednostiRenyi = zeros(brojSimulacija, 1); 
    
    
    for simulacija = 1:brojSimulacija
        signal = fmlin(N, pocetnaFrekvencija, krajnjaFrekvencija);
        
        sum = noisecg(N);
        
        noisySignal = sigmerge(signal, sum, razinaSNR);
        
        [wvd_tf, vrijeme, frekvencija] = tfrwv(noisySignal);
        
        vrijednostRenyi = renyi(wvd_tf, vrijeme, frekvencija, alphaRenyi);
        vrijednostiRenyi(simulacija) = vrijednostRenyi;
    end
    
    prosjecnaRenyi(indeks) = mean(vrijednostiRenyi);
    fprintf('Prosjecna Renyi entropija za SNR %d: %.4f\n', razinaSNR, prosjecnaRenyi(indeks));
end

tablicaRezultata = table(SNR', prosjecnaRenyi, ...
                      'Var', {'SNR', 'Prosjecna_Renyiova_Entropija_Linearna(alpha3)'});

disp('Tablica rezultata:');
disp(tablicaRezultata);

%% 

% Sin modulacija
prosjecnaRenyi_sinus = zeros(length(SNR), 1);
for indeks = 1:length(SNR)
    razinaSNR = SNR(indeks);
    vrijednostiRenyi = zeros(brojSimulacija, 1); 
    for simulacija = 1:brojSimulacija
        signal = fmsin(N);
        sum = noisecg(N);
        noisySignal = sigmerge(signal, sum, razinaSNR);
        [wvd_tf, vrijeme, frekvencija] = tfrwv(noisySignal);
        vrijednostRenyi = renyi(wvd_tf, vrijeme, frekvencija, alphaRenyi);
        vrijednostiRenyi(simulacija) = vrijednostRenyi;
    end
    prosjecnaRenyi_sinus(indeks) = mean(vrijednostiRenyi);
    fprintf('Prosjecna Renyi entropija za sinusoidalni SNR %d: %.4f\n', razinaSNR, prosjecnaRenyi_sinus(indeks));
end
tablicaSinus = table(SNR', prosjecnaRenyi_sinus, ...
                    'VariableNames', {'SNR', 'Prosjecna_Renyiova_Entropija_Sinusoidalna(alpha3)'});
disp('Tablica rezultata za sinusoidalnu modulaciju:');
disp(tablicaSinus);


% Parabolična modulacija
prosjecnaRenyi_parab = zeros(length(SNR), 1);
for indeks = 1:length(SNR)
    razinaSNR = SNR(indeks);
    vrijednostiRenyi = zeros(brojSimulacija, 1); 
    for simulacija = 1:brojSimulacija
        p1 = [1, 0];  
        p2 = [N/2, 0.25]; 
        p3 = [N, 0.4]; 
        [signal, ~] = fmpar(N, p1, p2, p3); 
        sum = noisecg(N);
        noisySignal = sigmerge(signal, sum, razinaSNR);
        [wvd_tf, vrijeme, frekvencija] = tfrwv(noisySignal);
        vrijednostRenyi = renyi(wvd_tf, vrijeme, frekvencija, alphaRenyi);
        vrijednostiRenyi(simulacija) = vrijednostRenyi;
    end
    prosjecnaRenyi_parab(indeks) = mean(vrijednostiRenyi);
    fprintf('Prosjecna Renyi entropija za parabolični SNR %d: %.4f\n', razinaSNR, prosjecnaRenyi_parab(indeks));
end
tablicaParab = table(SNR', prosjecnaRenyi_parab, ...
                    'VariableNames', {'SNR', 'Prosjecna_Renyiova_Entropija_Parabolična(alpha3)'});
disp('Tablica rezultata za paraboličnu modulaciju:');
disp(tablicaParab);