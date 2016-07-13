[![Travis-CI Build Status](https://travis-ci.org/ISAAKiel/recexcavAAR.svg?branch=master)](https://travis-ci.org/ISAAKiel/recexcavAAR) [![Coverage Status](https://img.shields.io/codecov/c/github/ISAAKiel/recexcavAAR/master.svg)](https://codecov.io/github/ISAAKiel/recexcavAAR?branch=master)

recexcavAAR
--------

R Library for 3D reconstruction and analysis of excavation states — 

#### Released version

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/recexcavAAR)](http://cran.r-project.org/package=recexcavAAR)

`recexcavAAR` is a collection of functions useful for archaeologists.

Just started...

Licence
-------

`recexcavAAR` is released under the [GNU General Public Licence, version 2](http://www.r-project.org/Licenses/GPL-2). Comments and feedback are welcome, as are code contributions.

Installation
------------

`recexcavAAR` is currently not on [CRAN](http://cran.r-project.org/), but you can use [devtools](http://cran.r-project.org/web/packages/devtools/index.html) to install the development version. To do so:

    if(!require('devtools')) install.packages('devtools')
    library(devtools)
    install_github('ISAAKiel/recexcavAAR')
    
To install with vignettes:

    install_github('ISAAKiel/recexcavAAR', build_vignettes = TRUE, force = TRUE)
    
History
-------

The development of recexcavAAR began in [quantaar](https://github.com/ISAAKiel/quantaar) and was later moved.