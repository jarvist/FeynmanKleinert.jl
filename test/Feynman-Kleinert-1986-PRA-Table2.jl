# Feynman-Kleinert-1986-PRA
# Replot fits from Feynman-Kleinert Table II
# - basically checking whether the Wtilde equation is reporting correctly, 
# and whether (as described in the caption) only Wtilde for g=0.1976 has double well structure 

macro doublewell(g)
    return :(x -> -0.5*x^2 + 0.25*g*x^4 + 0.25/g)
end

@printf("\n\nFeynman-Kleinert Table II reads:\n g      E0=Wtilde\n 0.1976 0.650 \n 0.4    0.549 \n 4.0    0.598 \n 40.0   1.409\n")
β=3000
# Much higher than this, and results collapse to Inf. But essentially agrees with Table II now!

@printf("\nI calculate, β=%g: \n",β)
# Wtilde(x0,a2,Ω)
xrange=-4:0.1:4
# These values, from Feynman and Kleinhert, table II
g=0.1976
myW=Wtilde(1.943,0.397,1.255,@doublewell(g),β)
@printf("%f %f\n",g,myW)
@test myW ≈ 0.650 atol=0.02

g=0.4
myW=Wtilde(0.0,1.030,0.486,@doublewell(g),β)
@printf("%f %f\n",g,myW)
@test  myW ≈ 0.549 atol=0.01

g=4.0
myW=Wtilde(0.0,0.3059,1.634,@doublewell(g),β)
@printf("%f %f\n",g,myW)
@test myW ≈ 0.598 atol=0.01

g=40.0
myW=Wtilde(0.0,0.1306,3.829,@doublewell(g),β)
@printf("%f %f\n",g,myW)
@test myW ≈ 1.409 atol=0.01

