% linear frequency modulation
N = 128
sig = fmlin(N, 0, 0.5);
figure;
plot(real(sig));
xlabel('Time');
ylabel('Amplitude');
axis([1 N -1 1]);
title('Time-Domain Representation of Linear Frequency Modulation');
grid on;


% Generating noise using Time-Frequency Toolbox
noise = noisecg(N, 0.8); 

% Plot the noise in time domain
figure;
plot(real(noise));
xlabel('Time');
ylabel('Amplitude');
axis([1 N -1 1]);
title('Colored Gaussian Noise in Time Domain');
grid on;

% Fourier Transform and Power Spectral Density (PSD) of the noise
dsp = fftshift(abs(fft(noise)).^2); % Power spectrum
f_noise = (-N/2:N/2-1) / N; % Frequency axis

% Log-Log Plot of the noise power spectrum
figure;
loglog(f_noise(f_noise > 0), dsp(f_noise > 0));
xlabel('Frequency');
ylabel('Power');
title('Log-Log Power Spectral Density of the Noise');
grid on;



