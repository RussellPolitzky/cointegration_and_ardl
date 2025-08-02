# Load necessary libraries
suppressPackageStartupMessages({
  library(ARDL)
  library(signal)
  library(stringr)
})

#' Create a Transfer Function from an ARDL Model
#'
#' This function extracts the coefficients for a specified exogenous variable
#' from a fitted ARDL model and constructs a Z-domain transfer function
#' using the `signal` package.
#'
#' The resulting transfer function H(z) represents the relationship:
#' Y(z) = H(z) * X(z), where Y is the dependent variable and X is the
#' specified exogenous variable.
#'
#' @param ardl_model    A model object of class 'ardl'.
#' @param variable_name A string specifying the name of the exogenous variable
#'   for which to create the transfer function (e.g., "LRY").
#'
#' @return An object of class 'Arma' from the `signal` package.
#'
get_ardl_tf <- function(ardl_model, dep_var_name, exog_variable_name) {

  # 1. Extract all model coefficients
  all_coeffs <- coef(ardl_model)

  # 3. Extract the autoregressive coefficients for the denominator
  # These are the coefficients of the lagged dependent variable.
  ar_pattern    <- paste0("L\\(", dep_var_name)
  ar_coeffs_raw <- all_coeffs[grepl(ar_pattern, names(all_coeffs))]

  # The denominator polynomial is 1 - B_1*z^-1 - B_2*z^-2 ...
  # The 'a' vector for Arma() needs to be c(1, -B_1, -B_2, ...)
  denominator_coeffs <- c(1, -unname(ar_coeffs_raw))

  # 4. Extract the "moving average" coefficients for the numerator
  # These are the coefficients of the specified exogenous variable and its lags.
  ma_pattern    <- paste0(exog_variable_name, "|L\\(", exog_variable_name)
  ma_coeffs_raw <- all_coeffs[grepl(ma_pattern, names(all_coeffs))]

  # We need to sort them by lag order (0, 1, 2, ...)
  # The base variable (e.g., "LRY") is lag 0.
  lag_order <- str_extract(names(ma_coeffs_raw), "[0-9]+")
  lag_order[is.na(lag_order)] <- "0" # Lag 0 for the non-lagged variable
  
  # Sort the coefficients by lag
  numerator_coeffs <- unname(ma_coeffs_raw[order(as.integer(lag_order))])

  # 5. Create and return the transfer function object
  tf <- signal::Arma(b = numerator_coeffs, a = denominator_coeffs)
  return(tf)
}


get_impulse_response <- function(ardl_model, dep_var_name, exog_variable_name) {
  tf     <- get_ardl_tf(ardl_model, dep_var_name, exog_variable_name)
  imp    <- signal::impz(tf)
  imp$tf <- tf
  imp
}


get_step_response <- function(ardl_model, dep_var_name, exog_variable_name) {
  imp <- get_impulse_response(ardl_model, dep_var_name, exog_variable_name)
  imp$x <- cumsum(imp$x)
  imp
}

# --- Example Usage ---

# Load the data and fit the model from our experiment
data(denmark)
ardl_3132 <- ardl(LRM ~ LRY + IBO + IDE, data = denmark, order = c(3,1,3,2))

get_impulse_response(ardl_3132, "LRM", "LRY")
get_step_response   (ardl_3132, "LRM", "LRY")

get_step_response   (ardl_3132, "LRM", "IBO")
get_impulse_response(ardl_3132, "LRM", "IBO")

get_step_response   (ardl_3132, "LRM", "IDE")
get_impulse_response(ardl_3132, "LRM", "IDE")
