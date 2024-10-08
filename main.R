# ----------------------- Helper Functions to Implement ------------------------

#' Evaluate whether the argument is less than 2
#'
#' Returns TRUE if the numeric argument x is a prime number, otherwise returns
#' FALSE
#'
#' @param x (numeric): the numeric value(s) to test
#'
#' @return logical value or vector indicating whether the numeric argument is less than 2
#' @export
#'
#' @examples
#' less_than_zero(-1)
#' [1] TRUE
#' less_than_zero(10)
#' [1] FALSE
#' less_than_zero(c(-1,0,1,2,3,4))
#' [1] TRUE FALSE FALSE FALSE FALSE FALSE
less_than_zero <- function(x) {
#when working with vectors/matrices, don't use if/else statements
  return(x < 0)
}

#' Evaluate whether the argument is between two numbers
#'
#' Returns TRUE if the numeric argument x is contained within the open interval
#' (a, b), otherwise return FALSE.
#'
#' @param x (numeric): the numeric value(s) to test
#' @param a (number): the lower bound
#' @param b (number): the upper bound
#'
#' @return logical value of same type as input (e.g. scalar, vector, or matrix)
#' @export
#'
#' @examples
#' is_between(3,1,5)
#' [1] TRUE
#' is_between(c(1,9,5,2), 1, 5)
#' [1] FALSE FALSE FALSE TRUE
#' is_between(matrix(1:9, nrow=3, byrow=TRUE), 1, 5)
#'       [,1]  [,2]  [,3]
#' [1,] FALSE  TRUE  TRUE
#' [2,]  TRUE FALSE FALSE
#' [3,] FALSE FALSE FALSE
is_between <- function(x, a, b) {
#simple check to see if x is in between a and b. should work for matrices + vectors (fingers crossed)
  return(a < x & x < b)
}

#' Return the values of the input vector that are not NA
#'
#' Returns the values of the input vector `x` that are not NA
#'
#' @param x (numeric): numeric vector to remove NA from 
#'
#' @return numeric vector `x` with all `NA` removed
#' @export
#'
#' @examples
#' x <- c(1,2,NA,3)
#' rm_na(x)
#' [1] 1 2 3
rm_na <- function(x) {
#remembered na omit
  return(as.vector(na.omit(x)))
}

#' Calculate the median of each row of a matrix
#'
#' Given the matrix x with n rows and m columns, return a numeric vector of
#' length n that contains the median value of each row of x
#'
#' @param x (numeric matrix): matrix to compute median along rows
#'
#' @return (numeric vector) vector containing median row values
#' @export
#'
#' @examples
#' m <- matrix(1:9, nrow=3, byrow=T)
#' row_medians(m)
#' [1] 1 4 7
#' 
row_medians <- function(x) {
#create new vector where length = num rows
#for loop for each row, order in terms of size - found out about median function in r lol
#take the median value once sorted and add to new vector
#return new vector
median_vector <- vector(length = nrow(x))
for (i in 1:nrow(x)) {
  row_sorted <- sort(x[i, ])
  median_vector[i] <- median(row_sorted)
  }
  return(median_vector)
}

#' Evaluate each row of a matrix with a provided function
#'
#' Given the matrix `x` with n rows and m columns, return a numeric vector of
#' length n that contains the returned values from the evaluation of the
#' function `fn` on each row. `fn` should be a function that accepts a vector as
#' input and returns a scalar value
#'
#' @param x (numeric matrix): matrix to evaluate the function along rows
#' @param fn (function) function that accepts a vector as input and returns a scalar
#' @param na.rm (logical) OPTIONAL: a logical evaluating to `TRUE` or `FALSE`
#'   indicating whether `NA` values should be stripped before computing summary
#'
#' @return (numeric vector) vector of the evaluation of `fn` on rows of `x`
#' @export
#'
#' @examples
#' m <- matrix(1:9, nrow=3, byrow=T)
#' summarize_rows(m, min)
#' [1] 1 4 7
#' summarize_rows(m, mean)
#' [1] 2 5 8
summarize_rows <- function(x, fn, na.rm=TRUE) {
  #remove nas from matrix
  #loop through each row, use fn on each row
  #return a vector! wahoo!
  summarize_vector <- vector(length = nrow(x))
  for (i in 1:nrow(x)) {
    if (na.rm) {
      summarize_vector[i] <- fn(x[i, ], na.rm = TRUE)
    } else {
      summarize_vector[i] <- fn(x[i, ])
    }
  }
  return(summarize_vector)
}

#' Summarize matrix rows into data frame
#'
#' Summarizes the rows of matrix `x`. Returns a data frame with the following
#' columns in order and the corresponding value for each row:
#' 
#'   * mean - arithmetic mean
#'   * stdev - standard deviation
#'   * median - median
#'   * min - minimum value
#'   * max - maximum value
#'   * num_lt_0 - the number of values less than 0
#'   * num_btw_1_and_5 - the number of values between 1 and 5
#'   * num_na - the number of missing (NA) values (ignoring value of na.rm)
#'
#' @param x (numeric matrix): matrix to evaluate the function along rows
#' @param na.rm (logical) OPTIONAL: a logical evaluating to `TRUE` or `FALSE`
#'   indicating whether `NA` values should be stripped before computing summary
#'
#' @return (data frame) data frame containing summarized values for each row of `x`
#' @export
#'
#' @examples
#' m <- matrix(1:9, nrow=3, byrow=T)
#' summarize_matrix(m)
#'   mean stdev median min max num_lt_0 num_btw_1_and_5 num_na
#' 1    2     1      2   1   3        0               3      0
#' 2    5     1      5   4   6        0               1      0
#' 3    8     1      8   7   9        0               0      0
#'
#' m <- matrix(rnorm(1000), nrow=4, byrow=T)
#' summarize_matrix(m)
#'          mean    stdev      median       min      max num_lt_0 num_btw_1_and_5 num_na
#' 1 -0.02220010 1.006901  0.02804177 -3.485147 3.221089      120              61      0
#' 2 -0.01574033 1.026951 -0.04725656 -2.967057 2.571608      112              70      0
#' 3 -0.09040182 1.027559 -0.02774705 -3.026888 2.353087      130              54      0
#' 4  0.09518138 1.030461  0.11294781 -3.409049 2.544992       90              72      0
summarize_matrix <- function(x, na.rm=FALSE) {
  #create list to store multiple types
  #make all necessary functions: mean stdev median min max num_lt_0 num_btw_1_and_5 num_na
  #perform all functions for each row
  #add all results into list
  summary_list <- list(nrow(x))
  for (i in 1:nrow(x)) {
    this_row <- x[i, ]
    
    #remove nas
    num_na <- sum(is.na(this_row))
    rm_na(this_row)
    
    find_mean <- mean(this_row)
    find_sd <- sd(this_row)
    find_median <- median(this_row)
    find_min <- min(this_row)
    find_max <- max(this_row)
    num_lt_0 <- sum(this_row < 0)
    num_btw_1_and_5 <- sum(is_between(this_row, 1, 5))
    
    # Add the results for this row into the list
    summary_list[[i]] <- data.frame(
      mean = find_mean,
      stdev = find_sd,
      median = find_median,
      min = find_min,
      max = find_max,
      num_lt_0 = num_lt_0,
      num_btw_1_and_5 = num_btw_1_and_5,
      num_na = num_na
    )
  }
  summary_dataframe <- do.call(rbind, summary_list)
  
  return(summary_dataframe)
}

# ------------ Helper Functions Used By Assignment, You May Ignore ------------
sample_normal <- function(n, mean=0, sd=1) {
  set.seed(1337)
  samples <- rnorm(n, mean=mean, sd=sd)
  return(samples)
}

sample_normal_w_missing <- function(n, mean=0, sd=1, missing_frac=0.1) {
  set.seed(1337)
  samples <- rnorm(n, mean=mean, sd=sd)
  missing <- rbinom(length(samples), 1, missing_frac)==1
  samples[missing] <- NA
  return(samples)
}

simulate_gene_expression <- function(num_samples, num_genes) {
  set.seed(1337)
  gene_exp <- matrix(
    rnbinom(num_samples*num_genes, rlnorm(num_genes,meanlog = 3), prob=runif(num_genes)),
    nrow=num_genes
  )
  return(gene_exp)
}

simulate_gene_expression_w_missing <- function(num_samples, num_genes, missing_frac=0.1) {
  gene_exp <- simulate_gene_expression(num_samples, num_genes)
  missing <- matrix(
    rbinom(num_samples*num_genes, 1, missing_frac)==1,
    nrow=num_genes
  )
  gene_exp[missing] <- NA
  return(gene_exp)
}