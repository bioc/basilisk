#' Configure client environments
#'
#' Configure the \pkg{basilisk} environments in the \code{configure} file of client packages.
#'
#' @param src String containing path to a R source file that defines one or more \linkS4class{BasiliskEnvironment} objects.
#'
#' @return One or more \pkg{basilisk} environments are created 
#' corresponding to the \linkS4class{BasiliskEnvironment} objects in \code{src}.
#' A \code{NULL} is invisibly returned.
#'
#' @author Aaron Lun
#'
#' @details 
#' This function is designed to be called in the \code{configure} file of client packages,
#' triggering the construction of \pkg{basilisk} environments during package installation.
#' It will only run if the \code{BASILISK_USE_SYSTEM_DIR} environment variable is set to \code{"1"}.
#'
#' We take a source file as input to avoid duplicated definitions of the \linkS4class{BasiliskEnvironment}s.
#' These objects are used in \code{\link{basiliskStart}} in the body of the package, so they naturally belong in \code{R/}; 
#' we then ask \code{configure} to pull out that file (named \code{"basilisk.R"} by convention) 
#' to create these objects during installation.
#'
#' The source file in \code{src} should be executable on its own, 
#' i.e., you can \code{\link{source}} it without loading any other packages (beside \pkg{basilisk}, obviously).
#' Non-\linkS4class{BasiliskEnvironment} objects can be created but are simply ignored in this function.
#'
#' @examples
#' \dontrun{
#' configureBasiliskEnv()
#' }
#' 
#' @seealso
#' \code{\link{setupBasiliskEnv}}, which does the heavy lifting of setting up the environments.
#'
#' @export
#' @importFrom methods is
#' @importFrom basilisk.utils useSystemDir getEnvironmentDir
configureBasiliskEnv <- function(src="R/basilisk.R") {
    if (!useSystemDir()) {
        return(invisible(NULL))
    }

    envir <- new.env()
    eval(parse(file=src), envir=envir)

    for (nm in ls(envir)) {
        current <- get(nm, envir=envir, inherits=FALSE)
        if (is(current, "BasiliskEnvironment")) {
            envdir <- getEnvironmentDir(.getPkgName(current), assume.installed=FALSE)
            setupBasiliskEnv(
                envpath=file.path(envdir, .getEnvName(current)),
                packages=.getPackages(current),
                conda=.useConda(current)
            )
        }
    }

    invisible(NULL)
}