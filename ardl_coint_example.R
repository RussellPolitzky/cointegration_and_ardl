library(ARDL)
data(denmark)
library(zoo) # for cbind.zoo()


## Estimate the Cointegrating Equation of an ARDL(3,1,3,2) model -------
# From an ARDL model (under case 2, restricted constant)
ardl_3132 <- ardl(LRM ~ LRY + IBO + IDE, data = denmark, order = c(3,1,3,2))
ce2_ardl  <- coint_eq(ardl_3132, case = 2)

coint_vector <- multipliers(ardl_3132)

 L(LRM, 1)    L(LRM, 2)    L(LRM, 3)
1           2          3
0.3192077   0.5326063  -0.2686663

LRY   L(LRY, 1) 
0          1
0.6727993  -0.2574193

       IBO   L(IBO, 1)   L(IBO, 2)   L(IBO, 3)
         0           1           2          3
-1.0785180  -0.1061973   0.2876689  -0.9946781

      IDE   L(IDE, 1)   L(IDE, 2) 
        0           1           2
0.1254643  -0.3279847   1.4078575


coefficients(ardl_3132)

           1           2          3
0          1
0          1           2          3
0          1           2

m1 <- c(                1,           2,          3)
m2 <- c(    0,          1)
m3 <- c(    0,          1,           2,          3)
m4 <- c(    0,          1,           2)

coeffs <- coefficients(ardl_3132)[ -1 ]

var_vctr <- stringr::str_match(names(coeffs), "[A-Z]{3}")[,1] 

uvars <- unique(vars)






c <- -1

sum(c^x * coeffs)









