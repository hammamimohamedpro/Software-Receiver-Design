% AM.m suppressed carrier AM with freq and phase offset
time=0.3; Ts=1/10000;               % sampling interval & time
t=Ts:Ts:time; lent=length(t);       % define a time vector
fm1=20; fm2=30 ;  fc=1000; c=cos(2*pi*fc*t);   % cos carrier at freq fc
s=sin(2*pi*fc*t) ;                  % sin carrier at freq fc
w1=5/lent*(1:lent)+cos(2*pi*fm*t);   % create "message m1"
w2=5/lent*(1:lent)+square(2*pi*fm2*t); % create "message m2" 
v1=c.*w1; v2=s.*w2 ;                 % modulate with carrier
v=v1+v2  ;                           % sum before transmission
gamc = 0; phic=0; gams=0 ; phis=0;      % freq & phase offset
c1=cos(2*pi*(fc+gamc)*t+phic);        % create cosine for demod
s1=sin(2*pi*(fc+gams)*t+phis) ;     %create sine for demod
x1=v.*c1; x2=v.*s1 ;                             % demod received signal
fbe=[0 0.1 0.2 1]; damps=[1 1 0 0]; % LPF design
fl=100; b=firpm(fl,fbe,damps);      % impulse response of LPF
m1=2*filter(b,1,x1);                % LPF the demodulated signal
m2=2*filter(b,1,x2);

% used to plot figure
subplot(5,1,1), plot(t,w1)
axis([0,0.1, -1,3])
ylabel('amplitude'); title('(a) message signal 1');
subplot(5,1,2), plot(t,w2)
axis([0,0.1, -2.5,2.5])
ylabel('amplitude'); title('(b) message signal 2');
subplot(5,1,3), plot(t,v)
axis([0,0.1, -1,3])
ylabel('amplitude');
title('(c) message after modulation');
subplot(5,1,4), plot(t,m1)
axis([0,0.1, -1,3])
ylabel('amplitude'); title('(d) demodulated signal m1');
subplot(5,1,5), plot(t,m2)
axis([0,0.1, -1,3])
ylabel('amplitude'); title('(e) demodulated signal m2');
