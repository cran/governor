## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(governor)

## ----example------------------------------------------------------------------
library(governor)

# Limit loop to 30 frames-per-second i.e. 1/30th of a second per frame.
gov <- gov_init(1/30); 

# Running the loop 30 times at 30 frames-per-second should take ~1 second
# The actual work in this loop only takes 0.3seconds (30 * 0.01)
# So `gov_wait()` will pause every loop to maintain the interval
system.time({
  for (i in 1:30) {
    Sys.sleep(0.01)  # Work done in loop
    gov_wait(gov)    # Compensate to keep interval loop time
  }
})

## ----skip---------------------------------------------------------------------
library(governor)

# Run loop at 30fps if possible
# Set a high learning rate so it will converge quickly
gov <- gov_init(1/30); 

# Running the loop 30 times at 30 frames-per-second should take ~1 second
# The actual work should take a total of 0.1 * 30 = 3 seconds!
system.time({
  skip <- FALSE
  for (i in 1:30) {
    if (!skip) {
      Sys.sleep(0.1)  # Work done in loop
    }
    skip <- gov_wait(gov)    # Compensate to keep interval loop time
    cat(skip, "\n")
  }
})

## -----------------------------------------------------------------------------
long_timer  <- timer_init(1)
short_timer <- timer_init(0.1)
counter <- 0L
while(TRUE) {
  if (timer_check(long_timer)) {
    cat("\nLong  timer fired at count: ", counter, "\n")
    break;
  } 
  if (timer_check(short_timer)) {
    cat("Short timer fired at count: ", counter, "\n")
  } 
  counter <- counter + 1L
}

