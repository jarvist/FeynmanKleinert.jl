# A work in progress - beware, dragons!
# Feynman-Kleinert-1986-PRA
#
# All codes lead to MAPI...
# Processing Feynman-Kleinert double-well method to apply to 
#     https://github.com/jarvist/Julia-SoftModeTISH-DeformationPotential

push!(LOAD_PATH,"../src/") # load module from local directory

using FeynmanKleinert

# Variables
# Potential energy g; either anharmonic strength or double-well setup
g=0.1976
# Thermodynamic Beta, natch
β=1000

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

#V=@doublewell(g)
#println("@doublewell test. g=$g β=$β ")
#println("V(0.0) = ",V(0.0))
#println("Va2(0.0,1.0) = ",Va2(0.0,1.0,V))
#println("Wtilde(0.0,4,4,V,β=$β) = ",Wtilde(0.0,1.0,4,V,β))

using Plots

### OK - let's go for the big one!
# Try and reproduce Fig 3; Double-well for varying g.

xrange=-2:0.05:2 # For the plots; this to agree with FeynmanKleinertPRA
#Ws=[ W(x,g,β) for x in xrange ]
#println(Ws)
#plot(Ws,xrange,label="W(x)")

# This is same data as Fig 3 in FeynmanKleinertPRA

plot(size=(1200,600),fmt=:png) # force aspect ratio; 
    # use PNG as changing size seems to break whatever the default is (SVG?)
for g in [.2, .3,.35,.4,.6] # range of g used in Fig 3. (look carefully at unbroken lines)
    plot!(x->W(x/sqrt(g),@doublewell(g),β), xrange, label="g=$g") 
        # Note scaling of x-range within fn. argument
    plot!(x->@doublewell(g)(x/sqrt(g)), xrange, label="", linestyle = :dash) 
        # Bare potential = infinite Temperature
end
plot!(ylim=(0,1.25)) # same as Fig 3 scale

savefig("MAPI.png")

g=.3 # detailed analysis + partition fn. calc on this g=
β=50


import QuadGK.quadgk

# This is horribly small as minimum in energy is offset ^^^ upwards.
Zq,Zerr=quadgk(x->exp(-β*W(x/sqrt(g),@doublewell(g),β))/sqrt(2*π*β), -2, 2)
println("Quantum Partition Function Z=$Zq")

Zqfudge,Zerr=quadgk(x->exp(-β*(W(x/sqrt(g),@doublewell(g),β)-0.7))/sqrt(2*π*β), -2, 2)
# Did I actually just do that?
println("Quantum Partition W-0.7 Function Z=$Zqfudge")


Zc,Zerr=quadgk(x->exp(-β*@doublewell(g)(x/sqrt(g)))/sqrt(2*π*β), -2, 2)
println("Classical Partition Function Z=$Zc")

# Effective classical potential, eval'd for x
U=x->W(x/sqrt(g),@doublewell(g),β)

classical=x->@doublewell(g)(x/sqrt(g))

plot(size=(1200,600),fmt=:png) # force aspect ratio;
plot!(x->W(x/sqrt(g),@doublewell(g),β), xrange,label="Effective Pot @ Beta=$β")
plot!(classical,xrange,label="Classical Pot")
plot!(ylim=(0,1.25)) # same as Fig 3 scale

savefig("MAPI-detailed.png")

xrange=-2:0.01:2 # For the plots; this to agree with FeynmanKleinertPRA
plot(size=(1200,600),fmt=:png) # force aspect ratio;
plot!(x->exp(-U(x)*β)/Zq,xrange,label="Quantum PDF")
plot!(x->exp(-classical(x)*β)/Zc,xrange,label="Classical PDF")


savefig("PDF.png")

