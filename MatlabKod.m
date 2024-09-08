% linear frequency modulation
sig = fmlin(128, 0, 0.5);
% linear frequency modulation
sig = fmlin(128, 0, 0.5);

figure;
plot(real(sig));
xlabel('Time');
ylabel('Amplitude');
title('Time-Domain Representation of linear frequency modulation ');
grid on;

