% pllconverge.m simulate Phase Locked Loop

N=10000; M=20; Ts=.0001;   % # symbols, oversampling factor
fc=1000; phoff=-1.0;       % carrier freq. and phase
rsc=pulsesig(M,N,Ts,fc,phoff) ; 
rsc2=rsc.^2 ; 
fl=500; ff=[0 .38 .39 .41 .42 1]; % BPF center frequency at .4
fa=[0 0 1 1 0 0];                 % which is twice f_0
h=firpm(fl,ff,fa);                % BPF design via firpm
rp=filter(h,1,rsc2);                 % filter gives preprocessed r
fl=100; ff=[0 .01 .02 1]; fa=[1 1 0 0];
h=firpm(fl,ff,fa);                    % LPF design
mu=.003;                              % algorithm stepsize
f0=1000;                              % freq at receiver
theta=zeros(1,length(t)); theta(1)=0; % initialize estimates
z=zeros(1,fl+1);                      % initialize LPF
for k=1:length(t)-1                   % z contains past inputs
    z=[z(2:fl+1), rp(k)*sin(4*pi*f0*t(k)+2*theta(k))];
    update= z(end) ;         % new output of LPF
    theta(k+1)=theta(k)-mu*update;      % algorithm update
end
plot(t,theta)
title('Phase Tracking via the Phase Locked Loop')
xlabel('time'); ylabel('phase offset')