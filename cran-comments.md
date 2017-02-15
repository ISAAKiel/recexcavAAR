## Improvements for new submission 

  * new functions (coordinate transformation and 3D drawing)
  * improved vignettes

## Test environments
* Manjaro Linux 64-bit, R 3.3.2
* win-builder (release+devel)

### Travis CI matrix:

* os: linux
    * dist: precise
    * sudo: false
* os: linux
    * dist: trusty
    * sudo: required
    * env: R_CODECOV=true
    * r_check_args: '--use-valgrind'
* os: osx
    * osx_image: xcode8.2
* os: osx
    * osx_image: xcode7.3

## R CMD check results in my test environments

There were no ERRORs or WARNINGs. I see one NOTE:

  * checking CRAN incoming feasibility ... NOTE  
    Maintainer: 'Clemens Schmid <clemens@nevrome.de>'  
    Possibly mis-spelled words in DESCRIPTION:  
    subunits (9:221)  
    toolset (9:16)  
    workflow (9:286)  