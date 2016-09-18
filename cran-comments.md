This is a resubmission. 

---------------------------------

## Test environments
* Manjaro Linux, R 3.3.1
* win-builder (devel and release)

## R CMD check results

There were no ERRORs or WARNINGs. I see two NOTEs:

* Found the following (possibly) invalid URLs:  
  URL: https://cran.r-project.org/package=recexcavAAR  
    From: README.md  
    Status: 404  
    Message: Not Found  
    
  This can't work yet. It's there for a Github badge.
  
* checking installed package size ... NOTE  
  installed size is  5.4Mb  
  sub-directories of 1Mb or more:  
    doc    3.6Mb  
    libs   1.6Mb  
     
  The vignettes are huge when they are rendered because they contain plotly 3D models. Nevertheless I would like to keep them - archaeologists are very visual scientists...
