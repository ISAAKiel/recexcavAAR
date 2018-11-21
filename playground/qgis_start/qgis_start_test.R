library(raster)

rasta <- raster::raster("playground/qgis_start/exraster.png")
plot(rasta)

qgis_georeference <- function(
  raster,
  path = "~/tmp-reference/", file_name = "ref_raster.tif"
  ) {

  if(Sys.which("qgis") == ""){
    stop("QGIS is not available on this System. Path variable?")
  }

  system(paste0("mkdir ", path))

  try(raster::writeRaster(raster, paste0(path, file_name), format = "GTiff", overwrite = TRUE))

  system("qgis --nologo --code playground/qgis_start/startup.py", ignore.stderr = TRUE)

  mod_file_name <- readline(
    prompt = "Enter the name of the referenced image. Default: 'ref_raster_modified.tif'"
  )
  if (mod_file_name == "" | !file.exists(paste0(path, mod_file_name))) {
    mod_file_name <- "ref_raster_modified.tif"
    if (!file.exists(paste0(path, mod_file_name))){
      stop("can't find referenced picture")
    }
  }

  try(rasta_mod <- raster::raster(paste0(path, mod_file_name)))

  #system("rmdir ~/tmp-reference")

  return(rasta_mod)
}

rasta_mod <- qgis_georeference(rasta)
plot(rasta_mod)
