prep_PRECASTobj <- function(spe) {
  seuList <- spe |> spe_to_seuratList()
  
  # PRECAST -----------------------------------------------------------------
  preobj <- CreatePRECASTObject(seuList = seuList)
  # preobj@seulist
  
  PRECASTObj <- AddAdjList(preobj, platform = "Visium")
  ## Add a model setting in advance for a PRECASTObj object. verbose =TRUE helps outputing the
  ## information in the algorithm.
  PRECASTObj <- AddParSetting(PRECASTObj, Sigma_equal = FALSE, coreNum = 1, maxIter = 30, verbose = TRUE)
  
  return(PRECASTObj)
}