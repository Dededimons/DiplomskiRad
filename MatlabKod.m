% Generiranje šuma
N = 256; 
noise = noisecg(N, 0.8); 

% linear frequency modulation
sig = fmlin(128, 0, 0.5);

% Plot generiranog signala
figure;
plot(real(sig));
xlabel('Time');
ylabel('Amplitude');
title('Time-Domain Representation of linear frequency modulation ');
grid on;

% Fourierova transformacija
dsp = fftshift(abs(fft(sig)).^2);
f = (-length(sig)/2:length(sig)/2-1) / length(sig);

% Plot 
figure;
plot(f, dsp);
xlabel('Normalized Frequency');
ylabel('Power');
title('Frequency Spectrum (FFT) of the Chirp Signal');
grid on;

% Spektralna gustoća snage
[pxx, f] = pwelch(sig, [], [], [], 1);

% Plot SGS
figure;
plot(f, 10*log10(pxx));
xlabel('Frequency');
ylabel('Power/Frequency (dB/Hz)');
title('Power Spectral Density of the Chirp Signal');
grid on;


