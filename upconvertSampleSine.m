% upconvertSampleSine.m: simulated sampling of the 50 Hz sine wave
f=50; time=0.05; Ts=1/15000; t=Ts:Ts:time;   % freq and time vectors
w=sin(2*pi*f*t);                              % create sine wave w(t)
ss=15;                                        % take 1 in ss samples ( the ratio between the computer sampling frequency 
                                              % and the desired sampling
                                              % frequency ) 
wk=w(1:ss:end);                               % the "sampled" sequence
ws=zeros(size(w)); ws(1:ss:end)=wk;           % sampled waveform ws(t)
fbe = [0  4000/7500  4500/7500  5500/7500  6000/7500  1]; %BPF at 5000Hz
damps = [0   0           1          1          0      0];
fl= 300 ; b=firpm(fl,fbe,damps) ; 
wf=filter(b,1,ws) ; 



figure (1) , plotspec(w,Ts)                                     % plot the waveforms
figure(2) , plotspec(ws,Ts)
figure(3) , plotspec(wf,Ts)