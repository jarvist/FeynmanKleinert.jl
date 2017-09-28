# FeynmanKleinert

[![Build Status](https://travis-ci.org/jarvist/FeynmanKleinert.jl.svg?branch=master)](https://travis-ci.org/jarvist/FeynmanKleinert.jl)

[![Coverage Status](https://coveralls.io/repos/jarvist/FeynmanKleinert.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/jarvist/FeynmanKleinert.jl?branch=master)

[![codecov.io](http://codecov.io/github/jarvist/FeynmanKleinert.jl/coverage.svg?branch=master)](http://codecov.io/github/jarvist/FeynmanKleinert.jl?branch=master)


## A work in progress - beware, dragons!

These codes implement Feynman and Klenert's 1986 PRA "Effective classical
partition function" methods. In Gribbin's biography (see
[http://users.physik.fu-berlin.de/~kleinert/kleinert/?p=feynman]), it's
mentioned that they used a Sinclair ZX Spectrum to run the codes on. This is
the same computer I learnt to program with. I fear I'm rather using
a sledgehammer to crack a walnut, turning the power of Julia and automatic
differentiation against the poor thing!

Motivation is:
 - because it's cool
 - this might be useful
   - initially for calculating tunnelling and delocalisation of the nuclear
     wavefunction in double wells (dynamic stabilisation of soft modes in
     perovskites)
   - the idea of smearing out the potential, is exactly what I've been doing
     for semi-classical models of recombination
   - maybe it could be extended to n-dimensional problems, such as a full set
     of anharmonic phonons

### Literature

Central paper is [https://doi.org/10.1103/PhysRevA.34.5080 ]
Effective classical partition functions.
R. P. Feynman and H. Kleinert. 
Phys. Rev. A 34, 5080.  Published 1 December 1986

Kleinert followed this up in:

H. Kleinert
Improving the Variational Approach to Path Integrals
Phys. Lett. B 280, 251 (1992)

and

H. Kleinert
Systematic Corrections to Variational Calculation of Effective Classical
Potential
Phys. Lett. A 173, 332 (1993)

### Errata 

The form for the double well potential (page 34, RHS, third paragraph starting 'Another example is the double-well...'), should read

`V(x)=-\frac{1}{2} x^2 + \frac{1}{4} g x^4 + \frac{1}{4g}`.

Strangely this is correct in the captions of figure 2 and 3!
