# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline # nolint

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) # Load other packages as needed. # nolint

# Set target options:
tar_option_set(
  packages = c(
    "SpatialExperiment", "STexampleData",     # Spatial Data
    "Seurat", "PRECAST",
    "scater", "ggspavis",
    "tidyverse"                # data manipulations
  ), # packages that your targets need to run
  format = "rds" # default storage format
  # Set other options as needed.
)

# tar_make_clustermq() configuration (okay to leave alone):
options(clustermq.scheduler = "multicore")

# tar_make_future() configuration (okay to leave alone):
# Install packages {{future}}, {{future.callr}}, and {{future.batchtools}} to allow use_targets() to configure tar_make_future() options.

# Run the R scripts in the R/ folder with your custom functions:
# tar_source()
source("R/spe_to_seurat.R")
source("R/prep_PRECASTobj.R")
source("R/plot_PRECAST_cluster.R")
# source("other_functions.R") # Source other scripts as needed. # nolint

# Replace the target list below with your own:
list(
  tar_target(
    name = raw_spe,
    command = readRDS("data/raw_spe.rds")
  ),

  tar_target(
    slide_info,
    colData(raw_spe) |> as.data.frame() |>
      dplyr::select(brnum, sample_id, slide, array) |>
      distinct() |> 
      tibble::remove_rownames() |> 
      arrange(brnum)
  ),
  
  #  Br3942 -----------------------------------------------------------------  
  tar_target(
    spe_Br3942,
    raw_spe[, colData(raw_spe)$brnum == "Br3942" ]
  ),
  
  tar_target(
    pre_PRECASTObj_Br3942,
    spe_Br3942 |> prep_PRECASTobj()
  ),
  
  tar_target(
    PRECASTObj_Br3942,
    PRECAST(pre_PRECASTObj_Br3942, K = 15)
  ),
  
  tar_target(
    best_PRECASTObj_Br3942,
    selectModel(PRECASTObj_Br3942)
  ),
  
  tar_target(
    PRECAST_clusters_Br3942,
    plot_PRECAST_cluster(best_PRECASTObj_Br3942, spe_Br3942)
  ),
  
  tar_target(
    plot_PRECAST_Br3942,
    ggsave(filename = "plots/Br3942_PRECAST_Clustering.png",
           PRECAST_clusters_Br3942,
           width = 2437,
           height = 2158,
           units = "px")
  ),
  
  #  Br8325 -----------------------------------------------------------------  
  tar_target(
    spe_Br8325,
    raw_spe[, colData(raw_spe)$brnum == "Br8325" ]
  ),
  
  tar_target(
    pre_PRECASTObj_Br8325,
    spe_Br8325 |> prep_PRECASTobj()
  ),
  
  tar_target(
    PRECASTObj_Br8325,
    PRECAST(pre_PRECASTObj_Br8325, K = 15)
  ),
  
  tar_target(
    best_PRECASTObj_Br8325,
    selectModel(PRECASTObj_Br8325)
  ),
  
  tar_target(
    PRECAST_clusters_Br8325,
    plot_PRECAST_cluster(best_PRECASTObj_Br8325, spe_Br8325)
  ),
  
  tar_target(
    plot_PRECAST_Br8325,
    ggsave(filename = "plots/Br8325_PRECAST_Clustering.png",
           PRECAST_clusters_Br8325,
           width = 2437,
           height = 2158,
           units = "px")
  )
  
  # 
  # tar_target(
  #   name = seuList,
  #   command =  spe |> spe_to_seuratList()
  # )
)
