% dualplls.m: estimation of carrier via dual loop structure
N=10000; M=10; Ts=.0001; time=Ts*N*M ; t=0:Ts:time-Ts;  % # symbols, oversampling factor
fc=1000; phoff=-2.0;       % carrier freq. and phase
rsc=pulsesig(M,N,Ts,fc,phoff) ; 
rsc2=rsc.^2 ; 
fl=100; ff=[0 .38 .39 .41 .42 1]; % BPF center frequency at .4
fa=[0 0 1 1 0 0];                 % which is twice f_0
h=firpm(fl,ff,fa);                % BPF design via firpm
rp=filter(h,1,rsc2);                 % filter gives preprocessed r
mu1=.01; mu2=.003;                  % algorithm stepsizes
f0=1001;                            % assumed freq at receiver
lent=length(t); th1=zeros(1,lent);  % initialize estimates
th2=zeros(1,lent); carest=zeros(1,lent);
for k=1:lent-1                      % combine top PLL th1
    th1(k+1)=th1(k)-mu1*rp(k)*sin(4*pi*f0*t(k)+2*th1(k));           
    th2(k+1)=th2(k)-mu2*rp(k)*sin(4*pi*f0*t(k)+2*th1(k)+2*th2(k));  
    % with bottom PLL th2 to form estimate of preprocessed signal
    carest(k)=cos(4*pi*f0*t(k)+2*th1(k)+2*th2(k));
end

figure(1), subplot(3,1,1), plot(t,th1)              % plot first theta
title('output of first PLL')
ylabel('\theta_1')
subplot(3,1,2), plot(t,th2)              % plot second theta
title('output of second PLL')
ylabel('\theta_2')
subplot(3,1,3), plot(rp-carest) % plot difference between estimate
% and preprocesssed carrier rp
title('error between preprocessed carrier and estimated carrier')
xlabel('time')
ylabel('f_0 - f')