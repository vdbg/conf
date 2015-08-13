
# Set CRAN mirror to a default location
options(repos = "http://cran.fhcrc.org")

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

testScaleRNumber <- function(nb, install = TRUE) {
    if (is.na(nb) || 
            ! is.vector(nb) || 
            length(nb) != 1 || 
            is.na(nb[1]) ||
            ! is.numeric(nb) ) {
        stop("expected nb to be a scalar character")
    }
    if (nb == 1)
        myRoot <- "f:\\svn\\bigAnalytics\\trunk"
    else
        myRoot <- paste0("f:\\svn\\bigAnalytics",nb,"\\trunk")
    testScaleRPath (myRoot, install)
}

testScaleRPath <- function(myRoot = Sys.getenv("RXSVNROOT"), install = TRUE, scaleR = "RevoScaleR_7.4.1.zip") {
    if (is.na(myRoot) || 
        ! is.vector(myRoot) || 
        length(myRoot) != 1 || 
        is.na(myRoot[1]) ||
        ! is.character(myRoot) ) {
        stop("expected myRoot to be a scalar character")
    }
    packagePath <- file.path(myRoot, scaleR)
    if (! file.exists(packagePath)) {
        stop("Cannot find ", packagePath)
    }
    Sys.setenv(RXSVNROOT = myRoot)
    if (install) install.packages(file.path(myRoot, scaleR), repos = NULL)
    library(RevoScaleR)
    library(RevoDevTools)
    rxRunit()
}


#getOption("defaultPackages")
## TODO figure out how to remove revoscaleR
# options(defaultPackages=c("datasets" ,     "utils" ,        "grDevices" ,    "graphics"     ,
#  "stats"    ,     "methods"    ,   "rpart"    ,     "lattice"   ,  "RevoMods"      "RevoUtils"     "RevoUtilsMath"))
  
  