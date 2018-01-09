# A work in progress - beware, dragons!
# Feynman-Kleinert-1986-PRA
#
# Workbook to reimplement Feynman and Klenert's 1986 PRA "Effective classical partition function"

push!(LOAD_PATH,"../src/") # load module from local directory

using FeynmanKleinert

# https://doi.org/10.1103/PhysRevA.34.5080
#
# Effective classical partition functions. R. P. Feynman and H. Kleinert. Phys. Rev. A 34, 5080 â Published 1 December 1986
#
# Errata
#
# The form for the double well potential (page 34, RHS, third paragraph starting 'Another example is the double-well...'), should read
#
# $V(x)=-\frac{1}{2} x^2 + \frac{1}{4} g x^4 + \frac{1}{4g}$.
#
# Strangely this is correct in the captions of figure 2 and 3!

# Nb: Forked from Workbook by Jarv 2017-09-27

# Variables
# Potential energy g; either anharmonic strength or double-well setup
g=0.1976
# Thermodynamic Beta, natch
β=10

# Potential energy curves - V(x) functions
# Double well potential as given in figure 2 + 3 captions
# Hold my beer - I'm going to try metaprogramming
macro doublewell(g)
    return :(x -> -0.5*x^2 + 0.25*g*x^4 + 0.25/g)
end

# Anharmonic potential, following Kleinhert's book (p. 471); Also Figure 1 Feynman-Kleinert
macro anharmonicwell(g)
    return :(x^2/2+x^4*g/4)
end

# Harmonic oscillator - simple soln
macro harmonicwell(g)
    return :(0.5*x^2)
end

V=@doublewell(g)
println("@doublewell test. g=$g β=$β ")
println("V(0.0) = ",V(0.0))
println("Va2(0.0,1.0) = ",Va2(0.0,1.0,V))
println("Wtilde(0.0,4,4,V,β=$β) = ",Wtilde(0.0,1.0,4,V,β))

using Plots

# OK, let's have a look our actors:
# V, the bare potential
# Va2, the Gaussian-smoothed potential
# Wtilde, the Auxillary potential, including partition function magic / failure
#
xrange=-3:0.1:3
#
plot(x->V(x),xrange,label="V") # bare [potential]
#
for a2 in 0.5 #:0.1:0.5 # Gaussian smearing widths to apply
    plot!(x->Va2(x,a2,V)[1],xrange,label="Va2, a2=$a2")
    plot!(x->Wtilde(x,a2,5,V,β),xrange,label="Wtilde, a2=$a2") # bare [potential]
end

#plot!(ylim=(0,1)) # force display
plot!()

#### Print out a table of values for omega and A2 values ####
g=0.4
β=10

@printf("Wtilde(x0,a2,Ω,g=%f,β=%f)\n",g,β)

@printf("a2\\Ω")
for Ω in 0.1:0.2:2.0
    @printf(" %.3f",Ω)
end

for a2 in 0.1:0.1:2.0
    @printf("\n a2=%.3f",a2)
    for Ω in 0.1:0.2:2.0
        @printf(" %.3f",Wtilde(0.0,a2,Ω,V,β))
    end
end

# Replot fits from Feynman-Kleinert Table II
# - basically checking whether the Wtilde equation is reporting correctly, 
# and whether (as described in the caption) only Wtilde for g=0.1976 has double well structure 
@printf("\n\nFeynman-Kleinert Table II reads:\n g      E0=Wtilde\n 0.1976 0.650 \n 0.4    0.549 \n 4.0    0.598 \n 40.0   1.409\n")
β=3000
# Much higher than this, and results collapse to Inf. But essentially agrees with Table II now!

@printf("\nI calculate, β=%g: ",β)
# Wtilde(x0,a2,Ω)
xrange=-4:0.1:4
# These values, from Feynman and Kleinhert, table II
g=0.1976
@printf("\n%f %f",g,Wtilde(1.943,0.397,1.255,@doublewell(g),β))
plot(x->Wtilde(x,0.397,1.255,@doublewell(g),β),xrange,label="g=0.1976") 

g=0.4
@printf("\n%f %f",g,Wtilde(0.0,1.030,0.486,@doublewell(g),β))
plot!(x->Wtilde(x,1.030,0.486,@doublewell(g),β),xrange,label="g=0.4") 

g=4.0
@printf("\n%f %f",g,Wtilde(0.0,0.3059,1.634,@doublewell(g),β))
plot!(x->Wtilde(x,0.3059,1.634,@doublewell(g),β),xrange,label="g=4.0")

g=40.0
@printf("\n%f %f",g,Wtilde(0.0,0.1306,3.829,V,β))
plot!(x->Wtilde(x,0.1306,3.829,@doublewell(g),β),xrange,label="g=40.0")

plot!(ylim=(-2,10)) # force plot in notebook
@printf("\n")

### OK - let's go for the big one!
# Try and reproduce Fig 3; Double-well for varying g.

g=0.1976
β=1000

xrange=-2:0.05:2
#Ws=[ W(x,g,β) for x in xrange ]
#println(Ws)
#plot(Ws,xrange,label="W(x)")

plot(size=(400,500),fmt=:png) # force aspect ratio; 
    # use PNG as changing size seems to break whatever the default is (SVG?)
for g in [.2, .3,.35,.4,.6] # range of g used in Fig 3. (look carefully at unbroken lines)
    plot!(x->W(x/sqrt(g),@doublewell(g),β), xrange, label="g=$g") 
        # Note scaling of x-range within fn. argument
    plot!(x->@doublewell(g)(x/sqrt(g)), xrange, label="", linestyle = :dash) 
        # Bare potential = infinite Temperature
end
plot!(ylim=(0,1.25)) # same as Fig 3 scale

savefig("figure3.png")
