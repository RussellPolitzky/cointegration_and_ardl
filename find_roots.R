# The characteristic polynomial is z^3 - 0.32*z^2 - 0.53*z + 0.27 = 0
# The coefficients vector for polyroot is c(a_0, a_1, a_2, ..., a_n)
coeffs <- c(0.27, -0.53, -0.32, 1)

# Find the roots
roots <- polyroot(coeffs)

# Print the roots
print(roots)

# Also print the magnitudes (modulus) of the roots to check for stability
# For stability, all roots must be inside the unit circle (|root| < 1)
cat("\nMagnitudes of the roots:\n")
print(abs(roots))


