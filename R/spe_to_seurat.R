# One sample
spe_to_seurat <- function(spe){
  
  # Get the log normalization
  
  # browser()
  # Find assay
  
  ret <- CreateSeuratObject(
    counts=assays(spe)$counts,
    meta.data=data.frame(
      row=spatialCoords(spe)[,1],
      col=spatialCoords(spe)[,2]),
      spot_id = colData(spe_sub)$spot_id
  )
  
  # sce <- SingleCellExperiment(list(counts=assays(spe)$counts,
  #                                  logcounts = assays(spe)$logcounts),
  #                             colData=DataFrame(row=colData(spe)$array_row,
  #                                               col=colData(spe)$array_col)
  #                             )
  # 
  # assays(spe) <- assays(spe)$counts
  # 
  #   ret <- as.Seurat(sce, project ="SingleCellExperiment") # Need to change to log normalization
  # 
  #   
  #   counts <- matrix(rpois(100, lambda = 10), ncol=10, nrow=10)
  #   sce <- SingleCellExperiment(list(counts=counts))
  #   tmp <- as.Seurat(sce, data = NULL, project ="SingleCellExperiment") 
  
  
  
  # # Force the spatial coordinates to names
  # if(!all(c("row", "col") %in% colnames(tmp@meta.data))
  # ret@meta.data <- ret@meta.data |> select( nFeature_RNA = nFeature_originalexp,
  #                                          row = array_row, col = array_col)
  
  return(ret)
  
  # #Why Seurat doesn't readin log transformed data
  # 
  # 
  
  #    
  
  
  
  
  
}


# Multiple sample
spe_to_seuratList <- function(spe){
  uniq_sample_id <- colData(spe)$sample_id |> unique()
  
  # Create a seurate object for each unique sample_id
  map(uniq_sample_id,
      .f = function(smp_id, spe){
        # browser()
        ret_spe <- spe[, colData(spe)$sample_id == smp_id]
        ret_seurat <- spe_to_seurat(ret_spe)
        
        return(ret_seurat)
      },
      spe = spe)
  
  
  
}