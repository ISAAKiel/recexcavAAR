## Improvements for new submission 

  * solved solaris c++ problem to avoid ERRORs:
      * Installation failed.
  * reorganized dependencies to avoid NOTEs:  
      * Namespaces in Imports field not imported from:  
        ‘devtools’ ‘dplyr’ ‘magrittr’ ‘plyr’ ‘reshape2’  
        All declared Imports should be used.
  * replaced plotly with rgl in vignettes to avoid WARNINGs and NOTEs:  
      * Error: processing vignette ‘recexcavAAR-vignette-1.Rmd’ failed with diagnostics:  
        object ‘x’ not found  
        Execution halted  
      * installed size is 5.4Mb

## Test environments
* Manjaro Linux 64-bit, R 3.3.1
* win-builder (release+devel)
* Oracle Solaris 11.2 64-bit, R 3.3.0 (not vignettes)

### Travis CI matrix:

* os: linux  
  dist: precise  
  sudo: false  
* os: linux  
  dist: trusty  
  sudo: required  
  env: R_CODECOV=true  
  r_check_args: '--use-valgrind'  
* os: osx  
  osx_image: xcode8  
* os: osx  
  osx_image: beta-xcode6.1  
  disable_homebrew: true  

## R CMD check results in my test environments

There were no ERRORs or WARNINGs. I see one NOTE:

  * checking CRAN incoming feasibility ... NOTE  
    Maintainer: 'Clemens Schmid <clemens@nevrome.de>'  
    Possibly mis-spelled words in DESCRIPTION:  
    subunits (9:221)  
    toolset (9:16)  
    workflow (9:286)  