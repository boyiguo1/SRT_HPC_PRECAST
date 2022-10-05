plot_PRECAST_cluster <- function(PRECASTObj, spe){
  seuInt <- IntegrateSpaData(PRECASTObj, species = "Human")
  browser()
  # Plot tsne etc.
  # p_sp1 <- SpaPlot(seuInt, item = "cluster", point_size = 3, combine = F)[[1]] + cowplot::theme_cowplot() +
  #   ggplot2::ggtitle(paste0("PRECAST: ARI="#, round(ari_precast, 2)
  #   )) + ggplot2::xlab("row") + ggplot2::ylab("col")
  # seuInt <- AddTSNE(seuInt, n_comp = 2)
  # p_tsne <- dimPlot(seuInt, item = "cluster")
  # p_tsne <- p_tsne + cowplot::theme_cowplot() + ggplot2::ggtitle("PRECAST")
  # 

  # Joining spe colData and Seurat meta data to retrieve batch and cluster info
  tmp_colData <- colData(spe) |> as.data.frame() |> 
    tibble::rownames_to_column(var = "spot_id") |> 
    left_join(seuInt@meta.data |> select(batch, cluster) |>
                tibble::rownames_to_column(var = "spot_id"))
  
  colData(spe)$batch <- tmp_colData$batch
  colData(spe)$cluster <- tmp_colData$cluster

  # library(RColorBrewer)
  nb.cols <- 18
  mycolors <- colorRampPalette(unname(palette.colors(36, "Polychrome 36")))(nb.cols)
  
  plotVisium(spe, fill = "cluster", palette = mycolors, alpha = 1)
}