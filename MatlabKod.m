% linear frequency modulation
N = 128
sig = fmlin(N, 0, 0.5);
figure;
plot(real(sig));
xlabel('Time');
ylabel('Amplitude');
title('Time-Domain Representation of Linear Frequency Modulation');
grid on;


noise = noisecg(N, 1); 

% Plot the noise in time domain
figure;
plot(real(noise));
xlabel('Time');
ylabel('Amplitude');
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

% Fit a line to the log-log PSD
logF = log(f_noise(f_noise > 0)); % Log of positive frequencies
logPxx = log(dsp(f_noise > 0)); % Log of power spectrum

% Fit a line to the log-log plot
coefficients = polyfit(logF, logPxx, 1);
slope = coefficients(1);

% Display the slope
fprintf('The slope of the log-log PSD is: %.2f\n', slope);

% Determine the color of the noise based on the slope
if slope >= -0.5 && slope <= 0.5
    disp('The signal is White Noise');
elseif slope > -1.5 && slope < -0.5
    disp('The signal is Pink Noise');
elseif slope < -1.5
    disp('The signal is Brown Noise');
else
    disp('Unknown noise characteristic');
end
