# FeynmanKleinert

[![Build Status](https://travis-ci.org/jarvist/FeynmanKleinert.jl.svg?branch=master)](https://travis-ci.org/jarvist/FeynmanKleinert.jl)

[![Coverage Status](https://coveralls.io/repos/jarvist/FeynmanKleinert.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/jarvist/FeynmanKleinert.jl?branch=master)

[![codecov.io](http://codecov.io/github/jarvist/FeynmanKleinert.jl/coverage.svg?branch=master)](http://codecov.io/github/jarvist/FeynmanKleinert.jl?branch=master)


## A work in progress - beware, dragons!

Workbook to reimplement Feynman and Klenert's 1986 PRA "Effective classical partition function"

https://doi.org/10.1103/PhysRevA.34.5080

Effective classical partition functions.
R. P. Feynman and H. Kleinert. 
Phys. Rev. A 34, 5080 â Published 1 December 1986

### Errata 

The form for the double well potential (page 34, RHS, third paragraph starting 'Another example is the double-well...'), should read

`V(x)=-\frac{1}{2} x^2 + \frac{1}{4} g x^4 + \frac{1}{4g}`.

Strangely this is correct in the captions of figure 2 and 3!
