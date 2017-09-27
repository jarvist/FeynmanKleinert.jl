module FeynmanKleinert

# Bring out the major leagues... https://www.youtube.com/watch?v=_E6DDktoPhg
using Optim
# Pkg.status("Optim.jl") --> Optim                         0.7.8              pinned.250b50ab.tmp
# I've pinned this to a weird old version... must update signature at some point to the new bindings

using QuadGK # For numerical integration

export K,Va2,Wtilde,verboseWtilde,W # export all the things.

"Integrand of (4) in Feynman and Kleinert"
K(xp,x,a2,V)=1/sqrt(2*π*a2)*exp(-(x-xp)^2/(2*a2))*V(xp)
"(4) in Feynman and Kleinert"
Va2(x,a2,V)=quadgk(xp->K(xp,x,a2,V), -Inf, +Inf) #, reltol=0, abstol=1e-5)

# (5) naively as written, in Feynman and Kleinert
#Wtilde(x0,a2,Ω,g,β)=(1/β) * log( sinh(β*Ω/2)/(β*Ω/2) ) - (Ω^2/2) * a2 + Va2(x0,a2,g)[1]
# Large β limit; by taking sinh(x)=e^x-e^-x , and then dropping e^-x
#Wtilde(x0,a2,Ω,g,β)=(1/β) * (β*Ω/2 - log(β*Ω/2)) - (Ω^2/2) * a2 + Va2(x0,a2,g)[1]

# Branch depending on β; for accuracy + lack of infinities
"""
    Wtilde(x0,a2,Ω,V,β)

(5) in Feynman and Kleinert. Switches depending on D=β*Ω/2 to use either an exponential approximation for sinh(x) (D>7.5) or an explicit evaluation and then take logarithms. Without doing this you get collapse to infinity for large β.
"""
function Wtilde(x0,a2,Ω,V,β)
    D=β*Ω/2
    if D>7.5
        F=(1/β) * (D - log(2*D)) # Large limit;  by taking sinh(x)=e^x-e^-x , and then dropping e^-x
    else
        F=(1/β)*( log(sinh(D)/D) ) # explicit evaluation, naively as written in (5)
    end
    V0=Va2(x0,a2,V())[1]
    mid=(Ω^2/2) * a2
    return F-mid+V0
end

"""
   verboseWtilde(x0,a2,Ω,g,β)

Expanded version of Wtilde, reporting the decomposition - this was used to explain what was going wrong
"""
function verboseWtilde(x0,a2,Ω,g,β)
    D=β*Ω/2
    println("D=β*Ω/2 = $D")
    F= (1/β)*( log(sinh(D)) - log(D) )
    #F= (1/β)*( (log(2D)+D^2/6+D^4/180) - log(D) ) # generalised Puiseux series
    # Large D limit, through sinh(D) --> e^D [through away e^-D part]
    F = (1/β) * (D - log(2*D))
    V=Va2(x0,a2,g)[1]
    mid=(Ω^2/2) * a2
    println("Wtilde(x0=$x0,a2=$a2,Ω=$Ω,g=$g,β=$β) \n\t= F - mid + V")
    println("\t= $F - $mid + $V = ",F-mid+V)
    return F-mid+V
end

"""
    W(x0,g,β)

    Implementing optimisation / minimisation described in Feynman-Kleinert (6)
    Calculates optimal W for x0, with given g and Beta
    Let's try and use (7) (a2 in terms of omega) to fix prior problems...
"""
function W(x0,g,β)
    #println("W(x0=$x0,g=$g,β=$β)")
    
    a2(Ω)=1/(β*Ω^2)*( (β*Ω)/2 * coth(β*Ω/2)-1 ) #(7)
    myf(x)=Wtilde(x0,a2(x[1]),x[1],g,β)
    
    lower=[0.0]
    upper=[5.0]
    initial=[1.0]

    res=optimize(OnceDifferentiable(myf), 
        initial, lower, upper, Fminbox(); 
        optimizer=GradientDescent, 
        optimizer_o=(Optim.Options(autodiff=true,allow_f_increases=true)) )
    minimum=Optim.minimum(res)
    Ω=Optim.minimizer(res)[1]
    mya2=a2(Ω)[1]
    #println("Optimised for W(x0=$x0,g=$g,β=$β). \n\tΩ=$Ω, a2=$mya2, minimum=$minimum.")
    #show(res)
    return minimum
end


end # module
