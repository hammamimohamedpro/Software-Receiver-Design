% pllsd.m: phase tracking minimizing SD
N=10000; M=20; Ts=.0001;   % # symbols, oversampling factor
fc=1000; phoff=-1.0;       % carrier freq. and phase
rsc=pulsesig(M,N,Ts,fc,phoff) ; 
rsc2=rsc.^2 ; 
fl=500; ff=[0 .38 .39 .41 .42 1]; % BPF center frequency at .4
fa=[0 0 1 1 0 0];                 % which is twice f_0
h=firpm(fl,ff,fa);                % BPF design via firpm
rp=filter(h,1,rsc2);                 % filter gives preprocessed r
mu=.001;                               % algorithm stepsize
theta=zeros(1,length(t)); theta(1)=0;  % initialize estimates
fl=1; h=ones(1,fl)/fl;                % averaging coefficients
z=zeros(1,fl); f0=fc;                  % buffer for avg
for k=1:length(t)-1                    % run algorithm
    filtin=(rp(k)-cos(4*pi*f0*t(k)+2*theta(k)))*sin(4*pi*f0*t(k)+2*theta(k));
    z=[z(2:fl), filtin];                 % z contains past inputs
    theta(k+1)=theta(k)-mu*fliplr(h)*z'; % update = z convolve h
end

plot(t,theta)                             % plot estimated phase
title('Phase Tracking via SD cost')
xlabel('time'); ylabel('phase offset')
