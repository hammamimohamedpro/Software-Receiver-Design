% demod2step.m two-step demodulation of suppressed carrier AM
time=0.3; Ts=1/10000;                    % sampling interval & time
t=Ts:Ts:time; lent=length(t);           % define a time vector
fm=20; fc=2000;                          % message and carrier freq
w=5/lent*(1:lent)+cos(2*pi*fm*t);       % create "message"
v=w.*cos(2*pi*fc*t);                    % modulate with carrier

c1=cos(2*pi*(3*fc/4)*t);               % first demod carrier 3fc/4
x1=v.*c1;                               % mix with modulated signal
fbe1=[0 0.09 0.096 0.104 0.11 1];      % BPF around fc/4
damps1=[0 0 1 1 0 0];
fl=200; b1=firpm(fl,fbe1,damps1);      % design bandpass filter
x1f=filter(b1,1,x1);                   % filter around fc/4=500Hz

c2=cos(2*pi*(fc/4)*t);                 % second demod carrier fc/4
x2=x1f.*c2;                            % mix filtered signal
fbe2=[0 0.02 0.04 1]; damps2=[1 1 0 0]; % LPF design
b2=firpm(fl,fbe2,damps2);              % impulse response of LPF
m=4*filter(b2,1,x2);                   % LPF and scale by 4

subplot(5,1,1), plot(t,w)
ylabel('amplitude'); title('(a) message signal')
subplot(5,1,2), plot(t,v)
ylabel('amplitude'); title('(b) message after modulation')
subplot(5,1,3), plot(t,x1f)
ylabel('amplitude'); title('(c) after step 1 mix and bandpass filter')
subplot(5,1,4), plot(t,x2)
ylabel('amplitude'); title('(d) after step 2 mix')
subplot(5,1,5), plot(t,m)
ylabel('amplitude'); title('(e) recovered message after LPF')
