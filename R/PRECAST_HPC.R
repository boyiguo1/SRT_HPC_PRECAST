library(dplyr)
library(purrr)
library(Seurat)
library(SpatialExperiment)
library(PRECAST)

load("~/GitHub/SRT_HPC_PRECAST/data/spe_QCfinal.Rdata")

colData(spe) |> as.data.frame() |> 
  select(brnum, sample_id) |> distinct() |> 
  arrange(brnum)

# Sample Subsetting -------------------------------------------------------

# Alternatively, I can just pull slide (the four slide) and array(index of capture area) infromation
slide_info <- colData(raw_spe) |> as.data.frame() |> 
  dplyr::select(sample_id, slide, array) |> 
  distinct()

# Subsetting slices from the same donner
spe_sub <- spe[, colData(spe)$brnum == "Br6423" ]
colData(spe_sub)$spot_id <- colData(spe_sub) |> rownames()



# SPE to SeuRat -----------------------------------------------------------
source("~/GitHub/SRT_HPC_PRECAST/R/spe_to_seurat.R")
seuList <- spe_sub |> spe_to_seuratList()


# PRECAST -----------------------------------------------------------------

preobj <- CreatePRECASTObject(seuList = seuList)
preobj@seulist


pbmc_raw <- read.table(
  file = system.file('extdata', 'pbmc_raw.txt', package = 'Seurat'),
  as.is = TRUE
)


PRECASTObj <- AddAdjList(preobj, platform = "Visium")
## Add a model setting in advance for a PRECASTObj object. verbose =TRUE helps outputing the
## information in the algorithm.
PRECASTObj <- AddParSetting(PRECASTObj, Sigma_equal = FALSE, coreNum = 1, maxIter = 30, verbose = TRUE)
PRECASTObj <- PRECAST(PRECASTObj, K = 15)
resList <- PRECASTObj@resList
PRECASTObj <- selectModel(PRECASTObj)
# What is ARI statistics?
# ari_precast <- mclust::adjustedRandIndex(PRECASTObj@resList$cluster[[1]], PRECASTObj@seulist[[1]]$layer_guess_reordered)

seuInt <- IntegrateSpaData(PRECASTObj, species = "Human")
seuInt

p_sp1 <- SpaPlot(seuInt, item = "cluster", point_size = 3, combine = F)[[1]] + cowplot::theme_cowplot() +
  ggplot2::ggtitle(paste0("PRECAST: ARI="#, round(ari_precast, 2)
  )) + ggplot2::xlab("row") + ggplot2::ylab("col")
seuInt <- AddTSNE(seuInt, n_comp = 2)
p_tsne <- dimPlot(seuInt, item = "cluster")
p_tsne <- p_tsne + cowplot::theme_cowplot() + ggplot2::ggtitle("PRECAST")


fnl_spe_sub <- spe_sub
tmp_colData <- colData(fnl_spe_sub) |> as.data.frame() |> 
  left_join(seuInt@meta.data |> select(batch, cluster)|> rownames_to_column(var = "spot_id"))

colData(fnl_spe_sub)$batch <- tmp_colData$batch
colData(fnl_spe_sub)$cluster <- tmp_colData$cluster

library(ggspavis)
library(RColorBrewer)
nb.cols <- 18
mycolors <- colorRampPalette(brewer.pal(8, "Set2"))(nb.cols)


plotVisium(fnl_spe_sub, fill = "cluster", palette = mycolors)
