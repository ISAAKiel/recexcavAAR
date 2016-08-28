[![Travis-CI Build Status](https://travis-ci.org/ISAAKiel/recexcavAAR.svg?branch=master)](https://travis-ci.org/ISAAKiel/recexcavAAR) [![Coverage Status](https://img.shields.io/codecov/c/github/ISAAKiel/recexcavAAR/master.svg)](https://codecov.io/github/ISAAKiel/recexcavAAR?branch=master) [![GitHub release](https://img.shields.io/github/release/ISAAKiel/recexcavAAR.svg?maxAge=2592000)]() [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/recexcavAAR)](http://cran.r-project.org/package=recexcavAAR) [![license](https://img.shields.io/badge/license-GPL%202-B50B82.svg)](http://www.r-project.org/Licenses/GPL-2)

recexcavAAR
-----------

R Library for 3D reconstruction and analysis of excavation states. The following **vignettes** explains the implemented functions:

* [**Ifri el Baroud** for v0.1](https://isaakiel.github.io/recexcavAAR-vignette-1.html)
* [**Kakcus-Turján** for v0.2](https://isaakiel.github.io/recexcavAAR-vignette-2.html) 

:collision: Vignettes do not work with Firefox browser

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