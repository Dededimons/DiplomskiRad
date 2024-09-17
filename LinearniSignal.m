% Parameters
N = 128;  % Length of the signal
SNR = 0;  % Signal-to-Noise Ratio (in dB)
alpha = 2;  % Parameter for Rényi entropy
q = 2;  % Parameter for Tsallis entropy
num_simulations = 100;

% Initialize result storage
renyi_vals = zeros(num_simulations, 1);
kolmogorov_vals = zeros(num_simulations, 1);
tsallis_vals = zeros(num_simulations, 1);

% Perform 100 simulations
for sim = 1:num_simulations
    % Step 1: Generate the signal (Linear Frequency Modulation signal)
    sig1 = real(fmlin(N, 0.1, 0.250));  % Ensure real part

    % Step 2: Generate noise using noisecg
    noise = real(noisecg(N, 0.8));  % Ensure real part

    % Step 3: Adjust noise to match the desired SNR (SNR = 0 dB)
    signal_power = mean(abs(sig1).^2);
    noise_power = mean(abs(noise).^2);

    % Ensure that the noise power is non-zero to avoid division by zero
    if noise_power == 0
        noise_power = eps;  % Use a very small value if noise power is zero
    end
    
    % Calculate the scaling factor for the noise
    scale_factor = sqrt(signal_power / noise_power);  % Scale noise to match SNR
    noisy_sig1 = sig1 + scale_factor * noise;  % Add noise to the signal

    % Step 4: Compute complexity and entropy measures

    % Rényi entropy
    renyi_vals(sim) = renyi_entropy(real(noisy_sig1), alpha);

    % Kolmogorov complexity (compression length as a proxy)
    kolmogorov_vals(sim) = kolmogorov_complexity_estimate(real(noisy_sig1));  % Use real signal

    % Tsallis entropy
    tsallis_vals(sim) = tsallis_entropy(real(noisy_sig1), q);
end

% Step 5: Average the results over 100 simulations
avg_renyi = mean(renyi_vals);
avg_kolmogorov = mean(kolmogorov_vals);
avg_tsallis = mean(tsallis_vals);

% Display the results
fprintf('Average Rényi Entropy: %.4f\n', avg_renyi);
fprintf('Average Kolmogorov Complexity (compression length): %.4f\n', avg_kolmogorov);
fprintf('Average Tsallis Entropy: %.4f\n', avg_tsallis);

% Plot the signal (without noise)
figure;
plot(real(sig1));  % Plot the real part of the signal
title('sig1 Linear Frequency Modulation');
axis([1 N -1 1]);
xlabel('Time'); ylabel('Amplitude');
grid on;

% Supporting Functions

% Rényi entropy function
function renyi_entropy = renyi_entropy(signal, alpha)
    % Calculate probability distribution of signal
    p = abs(signal).^2 / sum(abs(signal).^2);  % Normalize
    p = p(p > 0);  % Avoid log of zero
    renyi_entropy = 1/(1-alpha) * log(sum(p.^alpha));  % Rényi entropy formula
end

% Tsallis entropy function
function tsallis_entropy = tsallis_entropy(signal, q)
    % Calculate probability distribution of signal
    p = abs(signal).^2 / sum(abs(signal).^2);  % Normalize
    p = p(p > 0);  % Avoid log of zero
    tsallis_entropy = 1/(q-1) * (1 - sum(p.^q));  % Tsallis entropy formula
end

% Kolmogorov complexity estimate (using gzip compression length as a proxy)
function kolmogorov_complexity = kolmogorov_complexity_estimate(signal)
    % Convert signal to string
    signal_str = mat2str(signal);  % Convert signal to string format
    fileID = fopen('signal.txt','w');  % Write to file
    fprintf(fileID, signal_str);
    fclose(fileID);

    % Use gzip compression
    gzip('signal.txt');  % Compress the file using gzip
    file_info = dir('signal.txt.gz');  % Get compressed file info

    % Get the compressed file size (proxy for Kolmogorov complexity)
    kolmogorov_complexity = file_info.bytes;

    % Clean up: remove the temporary files
    delete('signal.txt');
    delete('signal.txt.gz');
end
