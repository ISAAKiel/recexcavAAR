## Resubmission
This is a resubmission. In this version I have:

* added a init.c file to register the c++-functions

## Improvements for new submission 

  * new functions (coordinate transformation and 3D drawing)
  * improved vignettes

## Test environments
* Manjaro Linux 64-bit, R 3.3.2
* win-builder (release+devel)
* Rhub: 
  Debian Linux, R-devel, GCC ASAN/UBSAN
  Ubuntu Linux 16.04 LTS, R-release, GCC  
  Fedora Linux, R-devel, clang, gfortran

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

There were no ERRORs or WARNINGs. I see two NOTEs:

  * Possibly mis-spelled words in DESCRIPTION:  
    subunits (9:221)  
    toolset (9:16)  
    workflow (9:286)  
  * Examples with CPU or elapsed time > 5s  
             user system elapsed  
    posdeclist 13.968  0.028  14.028  
    
I think both NOTEs are negligible, because they don't interfere with the 	functionality of the package in any way. 