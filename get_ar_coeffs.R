suppressPackageStartupMessages({
  library(ARDL)
})
data(denmark)
ardl_3132 <- ardl(LRM ~ LRY + IBO + IDE, data = denmark, order = c(3,1,3,2))
all_coeffs <- coef(ardl_3132)
ar_coeffs <- all_coeffs[grepl("L\\(LRM", names(all_coeffs))]
print(ar_coeffs)
