# Frequency & Phase Tracking

MATLAB scripts illustrating carrier phase and frequency recovery in a software
receiver, based on the companion code for *Software Receiver Design* (Johnson,
Sethares, Treichler). All scripts operate on a small-suppressed-carrier AM
signal built from a random 4-level PAM message and use adaptive
(gradient-descent) loops to track the unknown carrier phase and/or frequency.

## Signal model

`pulsesig.m` generates the test signal used by every script in this folder:

```
m   = pam(N,4,5)        % random 4-level PAM symbols, length N
mup = oversample(m, M)  % zero-stuffed by factor M
s   = filter(hamming(M), 1, mup)   % pulse-shape with a Hamming blip
c   = cos(2*pi*fc*t + phoff)       % carrier, frequency fc, phase phoff
rsc = s .* c                       % small-carrier AM signal (carrier suppressed)
```

Because the message `s` can be positive or negative, `rsc` has **no** discrete
spectral line at `fc` — a plain PLL cannot lock onto it directly. Most scripts
therefore square the signal first (`rsc.^2`), which produces a component at
`2*fc`, isolate it with a bandpass FIR filter (`firpm`) centered at the
normalized frequency 0.4 (i.e. `2*fc*Ts`), and run the tracking loop on that
squared/filtered signal `rp`.

## Files

| File | Description |
|---|---|
| `pulsesig.m` | Generates the PAM-modulated, small-carrier test signal `rsc` used as input by the other scripts. |
| `pam.m` | Generates a random `M`-level PAM sequence with a given variance. |
| `pllconverge.m` | Basic (single) Costas-type PLL: squares/filters the input, then uses one gradient-descent loop with an LPF-based update to track carrier phase. Plots the phase estimate vs. time. |
| `pllsd.m` | Phase tracking loop derived from minimizing a squared-difference (SD) cost between the preprocessed signal and its estimate. Single-loop, single-stepsize algorithm. |
| `plldd.m` | **Decision-directed** phase tracking: demodulates with in-phase/quadrature mixers, lowpass filters, downsamples to the symbol rate, quantizes to the PAM alphabet, and updates the phase estimate from the decision error. |
| `dualplls.m` | **Dual-loop** structure: a fast loop (`th1`) tracks/absorbs frequency offset while a slower loop (`th2`) refines the residual phase. Plots `th1`, `th2`, and the error between the preprocessed carrier and its reconstruction. |
