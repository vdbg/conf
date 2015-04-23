
# Set CRAN mirror to a default location
options(repos = "http://cran.cs.wwu.edu")

# R interactive prompt
options(prompt="R> ")

# sets work directory back to original
dev <- function() {
  if (file.exists("f:/git")) {
    setwd("f:/git")
  } else if (file.exists("~/Git")) {
    setwd("~/Git")
  } else {
    stop("Unable to figure out dev dir.")
  }  
}

# Otherwise rpubs publish fails
options(rpubs.upload.method = "internal")
