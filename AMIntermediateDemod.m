
%% Parameters
time = 0.3;
Ts = 1/10000;               % sampling interval
t = Ts:Ts:time;             % time vector
lent = length(t);

fc = 2000;                  % carrier frequency (Hz)
fm = 20;                    % message frequency (Hz)

%% Message signal and modulation
w = 5/lent*(1:lent) + cos(2*pi*fm*t);  % create message
v = w .* cos(2*pi*fc*t);               % suppressed carrier AM

%% Step 1 : mix with cos(2*pi*3fc/4*t)
% 3fc/4 = 1500 Hz
c1 = cos(2*pi*(3*fc/4)*t);             % first demod carrier
x1 = v .* c1;                          % mix with received signal

% Bandpass filter around fc/4 = 500 Hz
% normalized : 500/5000 = 0.1
% passband : [480, 520] Hz = [0.096, 0.104] normalized
fbe1 = [0    0.09  0.096  0.104  0.11  1];
damps1 = [0  0     1      1      0     0];
fl = 200;                               % filter order
b1 = firpm(fl, fbe1, damps1);          % design bandpass filter
x1f = filter(b1, 1, x1);              % filter around fc/4

%% Step 2 : mix with cos(2*pi*fc/4*t)
% fc/4 = 500 Hz
c2 = cos(2*pi*(fc/4)*t);              % second demod carrier
x2 = x1f .* c2;                       % mix filtered signal

% Lowpass filter to recover message
% cutoff below fc/4 = 500 Hz
% normalized : 20/5000 = 0.004
fbe2 = [0   0.02  0.04  1];
damps2 = [1  1     0    0];
b2 = firpm(fl, fbe2, damps2);         % design lowpass filter
m = 4*filter(b2, 1, x2);             % filter and scale by 4

%% Plots
subplot(5,1,1)
plot(t, w)
title('(a) Original message w(t)')
ylabel('amplitude')

subplot(5,1,2)
plot(t, v)
title('(b) Modulated signal v(t) = w(t)cos(2*pi*fc*t)')
ylabel('amplitude')

subplot(5,1,3)
plot(t, x1f)
title('(c) After step 1 : mix with cos(2*pi*3fc/4*t) + bandpass filter')
ylabel('amplitude')

subplot(5,1,4)
plot(t, x2)
title('(d) After step 2 : mix with cos(2*pi*fc/4*t)')
ylabel('amplitude')

subplot(5,1,5)
plot(t, m)
title('(e) Recovered message after lowpass filter')
ylabel('amplitude')