This is a resubmission. 

---------------------------------

## Improvements for resubmission 

  * solved solaris c++ problem to avoid ERROR:
      * Installation failed.
  * reorganized dependencies to avoid NOTE:  
      * Namespaces in Imports field not imported from:  
        ‘devtools’ ‘dplyr’ ‘magrittr’ ‘plyr’ ‘reshape2’  
        All declared Imports should be used.   

## Test environments
* Manjaro Linux 64-bit, R 3.3.1
* win-builder (release)
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

* checking installed package size ... NOTE  
  installed size is  5.4Mb  
  sub-directories of 1Mb or more:  
    doc    3.6Mb  
    libs   1.6Mb  
     
  The vignettes are huge when they are rendered because they contain plotly 3D models. Nevertheless I would like to keep them - archaeologists are very visual scientists...